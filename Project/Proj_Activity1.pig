-- Load Data from HDFS
inputDialouges = LOAD 'hdfs:///user/root/input' USING PigStorage('\t') As (name:chararray, line:chararray);

-- Fileter out the first 2 lines
ranked = RANK inputDialouges;
onlyDialouges = FILTER ranked BY (rank_inputDialouges > 2);

-- Group by name
groupByName = GROUP onlyDialouges BY name;

-- Count the number of lines by each character
names = FOREACH groupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

-- Remove the output folder 
rmf hdfs:///user/zakir/outputs

-- Store result in HDFS
STORE namesOrdered INTO 'hdfs:///user/zakir/outputs' USING PigStorage('\t');
