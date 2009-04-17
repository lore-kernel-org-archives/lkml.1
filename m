Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbZDQRwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbZDQRwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbZDQRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:52:24 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:35023 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761913AbZDQRwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:52:23 -0400
Date: Fri, 17 Apr 2009 13:45:05 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <20090417164918.GK8253@elte.hu>
Message-ID: <alpine.DEB.1.10.0904171335490.28603@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop> <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop> <alpine.DEB.1.10.0904171021360.20239@qirst.com> <1239979901.23397.4638.camel@laptop>
 <alpine.DEB.1.10.0904171100510.21575@qirst.com> <20090417153520.GA29968@elte.hu> <alpine.DEB.1.10.0904171142050.13734@qirst.com> <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I made some changes to the latencytest program (gentwo.org/ll). I hope
you can tell me what exactly you would consider meaningful numbers.

Here is a sample execution with a granularity of 1usec and a bucket size
of 1usec and the mininum set to zero (2.6.29 HZ=1000):

latencytest -d -m0 -b1000

CPUs: Freq=3.16Ghz Processors=8 Cores=4 cacheline_size=64 Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz
522 involuntary context switches
207231729 (100.00000000%) variances in 10.00 seconds: minimum 0.04us
maximum 109.58us average 0.05us
usecs percent samples
-------------------------
 0.0   100.0 207221180
 2.0     0.0       35
 3.0     0.0     3691
 4.0     0.0     4637
 5.0     0.0      891
 6.0     0.0      464
 7.0     0.0       90
 8.0     0.0       83
 9.0     0.0       44
10.0     0.0       42
11.0     0.0       42
12.0     0.0      171
13.0     0.0      150
14.0     0.0       44
15.0     0.0       19
16.0     0.0       23
17.0     0.0       16
18.0     0.0        9
19.0     0.0       15
20.0     0.0        2
21.0     0.0        6
22.0     0.0        4
23.0     0.0        4
24.0     0.0       13
25.0     0.0        2
27.0     0.0        2
29.0     0.0        2
30.0     0.0        3
31.0     0.0        1
32.0     0.0        3
33.0     0.0        2
34.0     0.0        1
36.0     0.0        2
37.0     0.0        1
38.0     0.0        1
39.0     0.0        7
40.0     0.0        7
41.0     0.0        9
42.0     0.0        3
43.0     0.0        1
44.0     0.0        1
46.0     0.0        1
49.0     0.0        1
50.0     0.0        1
57.0     0.0        1
61.0     0.0        1
109.0     0.0        1

Setting the mininum to 1usec yields:

christoph@JTCHITW00139:~/lldiag-0.2$ ./latencytest -d -m1000 -b1000
CPUs: Freq=3.16Ghz Processors=8 Cores=4 cacheline_size=64 Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz
247597652 samples below 1000 nsec
28 involuntary context switches
10011 (0.00404309%) variances in 10.00 seconds: minimum 3.20us maximum 336.82us average 5.35us
usecs percent samples
-------------------------
 3.0     6.4      645
 4.0    28.6     2866
 5.0    57.7     5781
 6.0     4.5      448
 7.0     1.1      113
 8.0     0.4       39
 9.0     0.6       59
10.0     0.2       19
11.0     0.0        1
12.0     0.0        2
13.0     0.0        4
14.0     0.0        1
15.0     0.0        1
16.0     0.0        2
20.0     0.0        3
26.0     0.0        1
28.0     0.0        1
30.0     0.0        1
37.0     0.0        1
38.0     0.0        1
43.0     0.0        1
45.0     0.0        3
46.0     0.0        1
47.0     0.0        2
48.0     0.0        1
53.0     0.0        1
55.0     0.0        1
56.0     0.0        4
57.0     0.0        4
61.0     0.0        1
76.0     0.0        1
93.0     0.0        1
336.0     0.0        1

More fine grained resolution (100ns do not count measurements below 100ns):

latencytest -d -m100 -b100

CPUs: Freq=3.16Ghz Processors=8 Cores=4 cacheline_size=64 Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz
266619352 samples below 100 nsec
19 involuntary context switches
13254 (0.00497088%) variances in 10.00 seconds: minimum 0.10us maximum
143.63us average 3.63us
usecs percent samples
-------------------------
 0.1    23.7     3141
 0.2     0.7       87
 0.3     0.1       12
 0.5     0.0        1
 0.6     0.0        1
 1.9     0.1       17
 2.0     0.4       47
 2.1     1.0      127
 2.2     2.3      309
 2.3     0.3       35
 2.4     0.2       25
 2.5     0.2       22
 2.6     0.2       23
 2.7     2.0      267
 2.8     4.2      559
 2.9     0.4       52
 3.0     1.1      143
 3.1     1.5      198
 3.2     1.1      149
 3.3     0.7       97
 3.4     0.6       78
 3.5     0.6       83
 3.6     0.9      121
 3.7     0.8      112
 3.8     4.1      547
 3.9     1.5      194
 4.0     0.3       42
 4.1     0.1       15
 4.2     0.2       23
 4.3     0.8      108
 4.4     0.5       63
 4.5     0.2       20
 4.6     0.2       25
 4.7     0.2       28
 4.8     0.3       44
 4.9     0.2       24
 5.0     1.0      126
 5.1     3.1      414
 5.2    18.0     2385
 5.3     6.5      857
 5.4     4.9      656
 5.5     2.5      335
 5.6     3.4      448
 5.7     3.4      445
 5.8     2.0      268
 5.9     0.9      116
 6.0     0.4       54
 6.1     0.2       22
 6.2     0.3       36
 6.3     0.1       17
 6.4     0.1       10
 6.5     0.1       11
 6.6     0.1        9
 6.7     0.1        9
 6.8     0.1        8
 6.9     0.0        4
 7.0     0.1        8
 7.1     0.0        6
 7.2     0.1        7
 7.3     0.1       14
 7.4     0.1        7
 7.5     0.0        4
 7.6     0.0        3
 7.7     0.0        6
 7.8     0.1        7
 7.9     0.0        6
 8.0     0.0        5
 8.1     0.0        4
 8.2     0.0        3
 8.3     0.0        2
 8.4     0.0        2

The group around 5usec is likely the timer interrupt.
