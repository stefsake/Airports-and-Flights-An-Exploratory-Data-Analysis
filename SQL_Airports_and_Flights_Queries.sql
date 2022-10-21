use FlightCancellations
go


-- 1) Find per airline, what is the average departure delay and arrival delay

select b.Name, avg(DepartureDelay) as Average_Deparure_delay, avg(ArrivalDelay) as Average_Arrival_Delay
from FactFlights a
join DimAirlines b
on a.AirlineID = b.AirlineID
group by b.Name
order by avg(DepartureDelay) desc


-- 2) Find the per airline, the summary of distance per year

select b.Name, sum(Distance) as Total_Distance
from FactFlights a
join DimAirlines b
on a.AirlineID = b.AirlineID
group by b.Name, a.Year
order by sum(Distance) desc


-- 3) Find the airline with the most cancellations

select top 1 b.Name, sum(Canceled) as Number_of_Cancellations
from FactFlights a
join DimAirlines b
on a.AirlineID = b.AirlineID
group by b.Name
order by sum(Canceled) desc


-- 4) Find the airline with the most cancelations for reason "Weather"

select top 1 Name, sum(Canceled) as Weather_Cancellations
from FactFlights a
join DimAirlines b
on a.AirlineID = b.AirlineID
where CancelationID = 2
group by b.Name
order by sum(Canceled) desc


-- 5) Find for each flight if the previous one had a departure delay

	select b.Name,FlightNumber, case
        when Lag(DepartureDelay) over(partition by Date order by ScheduledDeparture) > 0 then 'YES'
		else 'NO'
    end as Previous_Flight_Delayed_Departure
    from FactFlights a
	join DimAirlines b
	on a.AirlineID = b.AirlineID


-- 6) Find for each flight, if the previous one had an arrival delay

	select b.Name,FlightNumber, case
        when Lag(ArrivalDelay) over(partition by Date order by ScheduledArrival) > 15 then 'YES'
		else 'NO'
    end as Previous_Flight_Delayed_Arrival
    from FactFlights a
	join DimAirlines b
	on a.AirlineID = b.AirlineID


-- 7) What is the day of the week with the most departure delays?

select DayofWeek, count(DepartureDelay) Number_of_Departure_Delays
from FactFlights
group by DayofWeek
order by count(DepartureDelay) desc 


-- 8) Find the airline that has the most cancellations for reason Security

select Name, sum(Canceled) as Security_Cancellations
from FactFlights a
join DimAirlines b
on a.AirlineID = b.AirlineID
where CancelationID = 4
group by b.Name
order by sum(Canceled) desc


-- 9) Find the total number of unique routes per airline (meaning for unique set of combination of origin and destination airports)

select b.Name, count(distinct(FlightNumber)) as Total_Unique_Flights
from FactFlights a
join DimAirlines b 
on a.AirlineDelay = b.AirlineID
group by b.Name
order by Total_Unique_flights desc


-- 10) Find which month has the least flights per airline 

SELECT top 1 with ties 
b.Name, Month, count(ID) Number_of_Flights
from FactFlights a
join DimAirlines b
on a.AirlineID = b.AirlineID
group by b.Name, Month
order by ROW_NUMBER() OVER (PARTITION BY b.Name ORDER BY count(ID)) 


-- 11) Find which month has the least flights per airport  

SELECT top 1 with ties 
b.Name, Month, count(ID) Number_of_Flights
from FactFlights a
join DimAirports b
on a.OriginAirportID = b.AirportID
group by b.Name, Month
order by ROW_NUMBER() OVER (PARTITION BY b.Name ORDER BY count(ID)) 
