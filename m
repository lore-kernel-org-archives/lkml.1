Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZFDN1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZFDN1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZFDN1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:27:46 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:54945 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbZFDN1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:27:45 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 09:27:44 EDT
Message-ID: <4A27C7F8.3010207@itwm.fraunhofer.de>
Date: Thu, 04 Jun 2009 15:11:20 +0200
From: Martin Vogt <vogt@itwm.fraunhofer.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NUMA regression(?) on 32core shanghai
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050608020602060508070707"
X-ITWM-CharSet: 
X-ITWM-CharSet: ISO-8859-1
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050608020602060508070707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Hello,

I have strange/unexpected benchmark results for my numa machine
a 32 cores shanghai system with 512GB RAM.


My benchmark shows varying runtimes up to factor 12(!) for identical
tests and I think this is a bug somewhere.

I have tested the following kernels:

-2.6.30-rc8,2.6.29.4 and SLES10-SP1 kernel

All have the same problems for 16/32 threads in the first run.
(but not always!)
For example 2.6.30-rc8:

16-1:           33.403038s      28.906326s <<-- strange values
16-2:           5.444921s       5.072422s
16-3:           6.266797s       6.152743s


This is why I think this is a bug:
----------------------------------

My understanding of the NUMA memory bandwitdh test is:

- if I attach 8 threads to one numa node
- and allocate for each thread 512MB local memory

THEN:
- the runtime should be near constant over all nodes for all runs
  (for example: every thread runs 3 seconds)


If I now double the threads (16 threads, 2 on each numa node)
then:
- the the runtime should double too.
  (for example: 6 seconds instead of three)

and so on, for 32 threads 12 seconds etc...

The machine behaves sometimes as expected, but for the
16/32 threads case it usually has these strange runtimes in the first run.
(But this can happen for the 8 thread test too)

What is wrong with this?
(a factor of 12 slower for old kernels, and factor ~4 for newer)

There must be something wrong with this.
How can I debug it?


regards,

Martin

PS: on a smaller opteron numa system 4 nodes a 2 cores with
8GB on each node the test program works as expected.

PPS: the "bug" does not happens always, but very often with 16/32 threads
and: the behaviour is the same if I replace numa_alloc_onnode with malloc

Benchmark:
- cron is off/HZ is 100/libc 2.4-31.43.7 from SLES10
- Format example:
  08-1:           3.405676        3.023264
  8 threads, first run, read took 3.4 seconds and write 3.0 secs.


2.6.30-rc8
=====================
04-1:           3.591044        3.295444
04-2:           3.588437        3.280143
04-3:           3.448116        2.995627

08-1:           4.122432        3.566830
08-2:           4.119241        3.548015
08-3:           3.819517        3.349197

16-1:           33.403038       28.906326 <<-- strange values
16-2:           5.444921        5.072422
16-3:           6.266797        6.152743

32-1:           49.885150       76.500259 <<-- strange values
32-2:           19.114738       12.170802
32-3:           14.807441       11.064564


2.6.29.4
==================
04-1:           3.375012        3.057332
04-2:           3.401835        3.039497
04-3:           3.359395        2.980974

08-1:           3.405676        3.023264
08-2:           3.257743        3.000751
08-3:           3.129684        2.886261

16-1:           22.417126       11.807065 <<-- strange values
16-2:           6.031583        5.098305
16-3:           5.088144        5.457238

32-1:           45.829553       24.225427 <<-- strange values
32-2:           13.165044       12.290732
32-3:           8.908012        11.622502

2.6.16 (SuSE SLES10-SP1)+perfctr
================================
(Seconds:  it was take the slowest thread)


#Thread-run     read in secs    write in secs
04-1:           3.375012        3.057332
04-2:           3.401835        3.039497
04-3:           3.359395        2.980974

08-1:           3.405676        3.023264
08-2:           3.257743        3.000751
08-3:           3.129684        2.886261

16-1:           74.399871       12.747340 <<-- strange values
16-2:           7.449596        4.401576
16-3:           6.123250        5.518968

32-1:           150.927981      55.032012 <<-- strange values
32-2:           12.119996       12.203303
32-3:           11.601377       12.485716



--------------050608020602060508070707
Content-Type: application/x-gzip;
 name="mbind2.cpp.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mbind2.cpp.gz"

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
--------------050608020602060508070707--
