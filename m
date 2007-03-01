Return-Path: <linux-kernel-owner+w=401wt.eu-S965402AbXCARRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402AbXCARRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXCARRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:17:54 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:65452 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965402AbXCARRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:17:52 -0500
Date: Thu, 1 Mar 2007 08:56:28 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070301105928.GA15709@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.63.0703010822560.23701@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> 
 <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> 
 <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> 
 <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> 
 <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> 
 <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the ab numbers below do not seem that impressive to me, especially for such 
stripped down server processes.

here are some numbers from a set of test boxes I've got in my lab. I've been 
useing them to test firewalls, and I've been getting throughput similar to what 
is listed below when going through a proxy that does a full fork for each 
connection, and then makes a new connection to the webserver on the other side! 
the first few sets of numbers are going directly from test client to test 
server, the final set is going though the proxy.

client and server are dual opteron 252 with 8G of ram, running debian in 64 bit 
mode

this is with apache2 MPM as the destination (relativly untuned except for 
tinkering with the child count settings). this should be about as bad as you can 
get for a server

loadtest2:/proc/sys# ab -c 8000 -n 80000 http://208.2.188.5:80/4k
This is ApacheBench, Version 2.0.41-dev <$Revision: 1.141 $> apache-2.0
Copyright (c) 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright (c) 1998-2002 The Apache Software Foundation, http://www.apache.org/

Benchmarking 208.2.188.5 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        Apache/1.3.33
Server Hostname:        208.2.188.5
Server Port:            80

Document Path:          /4k
Document Length:        4352 bytes

Concurrency Level:      8000
Time taken for tests:   10.992838 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      386192835 bytes
HTML transferred:       362612992 bytes
Requests per second:    7277.47 [#/sec] (mean)
Time per request:       1099.284 [ms] (mean)
Time per request:       0.137 [ms] (mean, across all concurrent requests)
Transfer rate:          34307.88 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:        8  497 1398.3     71    9072
Processing:    17  236 346.9    103    2995
Waiting:        8   91 131.6     65    1692
Total:         26  734 1435.5    187    9786

Percentage of the requests served within a certain time (ms)
   50%    187
   66%    288
   75%    564
   80%    754
   90%   3085
   95%   3163
   98%   4316
   99%   9186
  100%   9786 (longest request)
loadtest2:/proc/sys# ab -c 8000 -n 80000 http://208.2.188.5:80/8k
This is ApacheBench, Version 2.0.41-dev <$Revision: 1.141 $> apache-2.0
Copyright (c) 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright (c) 1998-2002 The Apache Software Foundation, http://www.apache.org/

Benchmarking 208.2.188.5 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        Apache/1.3.33
Server Hostname:        208.2.188.5
Server Port:            80

Document Path:          /8k
Document Length:        8704 bytes

Concurrency Level:      8000
Time taken for tests:   11.355031 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      736949141 bytes
HTML transferred:       713733802 bytes
Requests per second:    7045.34 [#/sec] (mean)
Time per request:       1135.503 [ms] (mean)
Time per request:       0.142 [ms] (mean, across all concurrent requests)
Transfer rate:          63379.48 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:       36  495 1297.1     76    9056
Processing:    81  317 529.5    161    3448
Waiting:       25   89  75.1     76    1610
Total:        124  812 1401.5    250   11011

Percentage of the requests served within a certain time (ms)
   50%    250
   66%    304
   75%    497
   80%    705
   90%   3171
   95%   3251
   98%   3455
   99%   9160
  100%  11011 (longest request)

for both of these tests the server had it's cpu maxed out (<5% idle)

switching to thttpd instead of apache and I get

loadtest2:/proc/sys# ab -c 8000 -n 80000 http://208.2.188.5:81/4k
This is ApacheBench, Version 2.0.41-dev <$Revision: 1.141 $> apache-2.0
Copyright (c) 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright (c) 1998-2002 The Apache Software Foundation, http://www.apache.org/

Benchmarking 208.2.188.5 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        thttpd/2.23beta1
Server Hostname:        208.2.188.5
Server Port:            81

Document Path:          /4k
Document Length:        4352 bytes

Concurrency Level:      8000
Time taken for tests:   9.944605 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      372748950 bytes
HTML transferred:       352729600 bytes
Requests per second:    8044.56 [#/sec] (mean)
Time per request:       994.461 [ms] (mean)
Time per request:       0.124 [ms] (mean, across all concurrent requests)
Transfer rate:          36603.97 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:       50  324 1274.4     70    9124
Processing:    68   98  33.3     90     781
Waiting:       22   69  26.9     63     729
Total:        125  423 1291.9    161    9324

Percentage of the requests served within a certain time (ms)
   50%    161
   66%    175
   75%    188
   80%    203
   90%    246
   95%    307
   98%   3243
   99%   9272
  100%   9324 (longest request)
loadtest2:/proc/sys# ab -c 8000 -n 80000 http://208.2.188.5:81/8k
This is ApacheBench, Version 2.0.41-dev <$Revision: 1.141 $> apache-2.0
Copyright (c) 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright (c) 1998-2002 The Apache Software Foundation, http://www.apache.org/

Benchmarking 208.2.188.5 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        thttpd/2.23beta1
Server Hostname:        208.2.188.5
Server Port:            81

Document Path:          /8k
Document Length:        8704 bytes

Concurrency Level:      8000
Time taken for tests:   13.502031 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      729161888 bytes
HTML transferred:       709030153 bytes
Requests per second:    5925.03 [#/sec] (mean)
Time per request:       1350.203 [ms] (mean)
Time per request:       0.169 [ms] (mean, across all concurrent requests)
Transfer rate:          52738.14 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:       46  338 1189.7    106    9145
Processing:    79  197  52.8    195     670
Waiting:       39   92  28.4     94     577
Total:        140  536 1208.3    293    9424

Percentage of the requests served within a certain time (ms)
   50%    293
   66%    350
   75%    355
   80%    369
   90%    388
   95%   3293
   98%   3388
   99%   9392
  100%   9424 (longest request)

for these the CPU is ~45% idle on the server box.

now if I go through a box in the middle running a proxy that forks for every 
request (so you have two seperate TCP connections, plus a fork for each 
request plus two writes to syslog) the proxy box is a dual opteron 252 with 4G 
or ram running debian 32 bit

loadtest2:/proc/sys# ab -c 8000 -n 80000 http://192.168.254.2:8080/8k
This is ApacheBench, Version 2.0.41-dev <$Revision: 1.141 $> apache-2.0
Copyright (c) 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright (c) 1998-2002 The Apache Software Foundation, http://www.apache.org/

Benchmarking 192.168.254.2 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        Apache/1.3.33
Server Hostname:        192.168.254.2
Server Port:            8080

Document Path:          /8k
Document Length:        8704 bytes

Concurrency Level:      8000
Time taken for tests:   21.101321 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      721092650 bytes
HTML transferred:       698383315 bytes
Requests per second:    3791.23 [#/sec] (mean)
Time per request:       2110.132 [ms] (mean)
Time per request:       0.264 [ms] (mean, across all concurrent requests)
Transfer rate:          33371.94 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:        9  621 1652.3     20    9036
Processing:    28   81 195.5     50    6652
Waiting:        9   51 195.5     19    6620
Total:         38  703 1683.2     70   12291

Percentage of the requests served within a certain time (ms)
   50%     70
   66%     80
   75%     83
   80%    101
   90%   3075
   95%   3088
   98%   9073
   99%   9087
  100%  12291 (longest request)

David Lang





On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:

> On Thu, Mar 01, 2007 at 10:54:02AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
>>
>> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>>
>>> I posted kevent/epoll benchmarks and related design issues too many
>>> times both with handmade applications (which might be broken as hell)
>>> and popular open-source servers to repeat them again.
>>
>> numbers are crutial here - and given the epoll bugs in the evserver code
>> that we found, do you have updated evserver benchmark results that
>> compare epoll to kevent? I'm wondering why epoll has half the speed of
>> kevent in those measurements - i suspect some possible benchmarking bug.
>> The queueing model of epoll and kevent is roughly comparable, both do
>> only a constant number of steps to serve one particular request,
>> regardless of how many pending connections/requests there are. What is
>> the CPU utilization of the server system during an epoll test, and what
>> is the CPU utilization during a kevent test? 100% utilized in both
>> cases?
>
> Yes, it is about 98-100% in both cases.
> I've just re-run tests on my amd64 test machine without debug options:
>
> epoll		4794.23
> kevent		6468.95
>
> here are full client 'ab' outputs for epoll and kevent servers (epoll
> does not contain EPOLLET as you requested, but it does not look like
> it change performance in my case).
>
> epoll ab aoutput:
> # ab -c8000 -n80000 http://192.168.0.48/
> This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
> Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
> Copyright 2006 The Apache Software Foundation, http://www.apache.org/
>
> Benchmarking 192.168.0.48 (be patient)
> Completed 8000 requests
> Completed 16000 requests
> Completed 24000 requests
> Completed 32000 requests
> Completed 40000 requests
> Completed 48000 requests
> Completed 56000 requests
> Completed 64000 requests
> Completed 72000 requests
> Finished 80000 requests
>
>
> Server Software:        Apache/1.3.27
> Server Hostname:        192.168.0.48
> Server Port:            80
>
> Document Path:          /
> Document Length:        3521 bytes
>
> Concurrency Level:      8000
> Time taken for tests:   16.686737 seconds
> Complete requests:      80000
> Failed requests:        0
> Write errors:           0
> Total transferred:      309760000 bytes
> HTML transferred:       281680000 bytes
> Requests per second:    4794.23 [#/sec] (mean)
> Time per request:       1668.674 [ms] (mean)
> Time per request:       0.209 [ms] (mean, across all concurrent
> requests)
> Transfer rate:          18128.17 [Kbytes/sec] received
>
> Connection Times (ms)
>              min  mean[+/-sd] median   max
> Connect:      159  779 110.1    799     921
> Processing:   468  866  77.4    869     988
> Waiting:       63  426 212.3    425     921
> Total:       1145 1646 115.6   1660    1873
>
> Percentage of the requests served within a certain time (ms)
> 50%   1660
> 66%   1661
> 75%   1662
> 80%   1663
> 90%   1806
> 95%   1830
> 98%   1833
> 99%   1834
> 100%   1873 (longest request)
>
> kevent ab output:
> # ab -c8000 -n80000 http://192.168.0.48/
> This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
> Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
> Copyright 2006 The Apache Software Foundation, http://www.apache.org/
>
> Benchmarking 192.168.0.48 (be patient)
> Completed 8000 requests
> Completed 16000 requests
> Completed 24000 requests
> Completed 32000 requests
> Completed 40000 requests
> Completed 48000 requests
> Completed 56000 requests
> Completed 64000 requests
> Completed 72000 requests
> Finished 80000 requests
>
>
> Server Software:        Apache/1.3.27
> Server Hostname:        192.168.0.48
> Server Port:            80
>
> Document Path:          /
> Document Length:        3521 bytes
>
> Concurrency Level:      8000
> Time taken for tests:   12.366775 seconds
> Complete requests:      80000
> Failed requests:        0
> Write errors:           0
> Total transferred:      317047104 bytes
> HTML transferred:       288306522 bytes
> Requests per second:    6468.95 [#/sec] (mean)
> Time per request:       1236.677 [ms] (mean)
> Time per request:       0.155 [ms] (mean, across all concurrent
> requests)
> Transfer rate:          25036.12 [Kbytes/sec] received
>
> Connection Times (ms)
>              min  mean[+/-sd] median   max
> Connect:      130  364 871.1    275    9347
> Processing:   178  298  42.5    296     580
> Waiting:       31  202  65.8    210     369
> Total:        411  663 887.0    572    9722
>
> Percentage of the requests served within a certain time (ms)
> 50%    572
> 66%    573
> 75%    618
> 80%    640
> 90%    684
> 95%    709
> 98%    721
> 99%   3455
> 100%   9722 (longest request)
>
> Notice how percentage of the requests served within a certain time
> differs for kevent and epoll. And this server does not include
> ready-on-submission kevent optimization.
>
>> 	Ingo
>
>
