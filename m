Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYIOKoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYIOKoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 06:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYIOKoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 06:44:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:50669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752476AbYIOKoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 06:44:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/izGMGeZziGKQYReC62vAtmrbmbCzpipMb7Yicy9
	wDqD3ynNfZZS8H
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1221421907.4597.24.camel@marge.simson.net>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik>  <48CAE7A0.8000004@linux-foundation.org>
	 <1221306287.5213.111.camel@marge.simson.net>
	 <48CD1D25.9080301@linux-foundation.org>
	 <1221421907.4597.24.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 12:44:00 +0200
Message-Id: <1221475440.4784.39.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-14 at 21:51 +0200, Mike Galbraith wrote:
> On Sun, 2008-09-14 at 09:18 -0500, Christoph Lameter wrote:
> > Mike Galbraith wrote:
> > > Numbers from my Q6600 Aldi supermarket box (hm, your box is from different shelf)
> > >   
> > My box is an 8p with recent quad core processors. 8G, 32bit Linux.
> 
> Don't hold your breath, but after putting my network config of a very
> severe diet, I'm starting to see something resembling sensible results.

Turns off all netfilter options except tables, etc.

Since 2.6.22.19-cfs-v24.1 and 2.6.23.17-cfs-v24.1 schedulers are
identical, and these are essentially identical with 2.6.24.7, what I
read from numbers below is that cfs in 2.6.23 was somewhat less than
wonderful for either netperf or tbench,  Something happened somewhere
other than the scheduler at 23->24 which cost us some performance, and
another something happened at 26->27.  I'll likely go looking again..
and likely regret it again ;-)

Math ain't free is part of it, though apparently not much.  For me,
tbench regression 22->27 is ~10%, and netperf regression is ~16%.

Data:

2.6.22.19

Throughput 1250.73 MB/sec 4 procs                  1.00

16384  87380  1        1       60.01    111272.55  1.00
16384  87380  1        1       60.00    104689.58
16384  87380  1        1       60.00    110733.05
16384  87380  1        1       60.00    110748.88

2.6.22.19-cfs-v24.1

Throughput 1204.14 MB/sec 4 procs                  .962

16384  87380  1        1       60.01    101799.85  .929
16384  87380  1        1       60.01    101659.41
16384  87380  1        1       60.01    101628.78
16384  87380  1        1       60.01    101700.53

wakeup granularity = 0 (make scheduler as preempt happy as 2.6.22 is)

Throughput 1213.21 MB/sec 4 procs                  .970

16384  87380  1        1       60.01    108569.27  .992
16384  87380  1        1       60.01    108541.04
16384  87380  1        1       60.00    108579.63
16384  87380  1        1       60.01    108519.09

2.6.23.17

Throughput 1192.49 MB/sec 4 procs                  .953

16384  87380  1        1       60.00    91124.67   .866
16384  87380  1        1       60.00    93124.38
16384  87380  1        1       60.01    92249.69
16384  87380  1        1       60.01    91103.12

wakeup granularity = 0

Throughput 1200.46 MB/sec 4 procs                  .959

16384  87380  1        1       60.01    95987.66   .866
16384  87380  1        1       60.01    92819.98
16384  87380  1        1       60.01    95454.00
16384  87380  1        1       60.01    94834.84

2.6.23.17-cfs-v24.1

Throughput 1242.47 MB/sec 4 procs                  .993

16384  87380  1        1       60.00    101728.34  .931
16384  87380  1        1       60.00    101930.23
16384  87380  1        1       60.00    101803.15
16384  87380  1        1       60.00    101908.29

wakeup granularity = 0

Throughput 1238.68 MB/sec 4 procs                  .990

16384  87380  1        1       60.01    105871.52  .969
16384  87380  1        1       60.01    105813.11
16384  87380  1        1       60.01    106106.31
16384  87380  1        1       60.01    106310.20

2.6.24.7

Throughput 1202.49 MB/sec 4 procs                  .961

16384  87380  1        1       60.00    94643.23   .868
16384  87380  1        1       60.00    94754.37
16384  87380  1        1       60.00    94909.77
16384  87380  1        1       60.00    95457.41

wakeup granularity = 0

Throughput 1204 MB/sec 4 procs                     .962

16384  87380  1        1       60.00    99599.27   .910
16384  87380  1        1       60.00    99439.95
16384  87380  1        1       60.00    99556.38
16384  87380  1        1       60.00    99500.45

2.6.25.17

Throughput 1220.47 MB/sec 4 procs                  .975

16384  87380  1        1       60.00    94641.06   .867
16384  87380  1        1       60.00    94864.87
16384  87380  1        1       60.01    95033.81
16384  87380  1        1       60.00    94863.49

wakeup granularity = 0

Throughput 1223.16 MB/sec 4 procs                  .977
16384  87380  1        1       60.00    101768.95  .930
16384  87380  1        1       60.00    101888.46
16384  87380  1        1       60.01    101608.21
16384  87380  1        1       60.01    101833.05

2.6.26.5

Throughput 1182.24 MB/sec 4 procs                  .945

16384  87380  1        1       60.00    93814.75   .854
16384  87380  1        1       60.00    94173.41
16384  87380  1        1       60.00    92925.24
16384  87380  1        1       60.00    93002.51

wakeup granularity = 0

Throughput 1183.47 MB/sec 4 procs                  .945

16384  87380  1        1       60.00    100837.12  .922
16384  87380  1        1       60.00    101230.12
16384  87380  1        1       60.00    100868.45
16384  87380  1        1       60.00    100491.41

2.6.27

Throughput 1088.17 MB/sec 4 procs                  .870

16384  87380  1        1       60.00    84225.59   .766
16384  87380  1        1       60.00    83362.65
16384  87380  1        1       60.00    84060.73
16384  87380  1        1       60.00    83462.72

wakeup granularity = 0

Throughput 1116.22 MB/sec 4 procs                  .892

16384  87380  1        1       60.00    92502.44   .841
16384  87380  1        1       60.01    92213.72
16384  87380  1        1       60.00    91445.86
16384  87380  1        1       60.00    91832.84

revert sched weight/asym changes, gran = 0

Throughput 1149.16 MB/sec 4 proc                   .918

16384  87380  1        1       60.00    94824.92   .868
16384  87380  1        1       60.01    94579.45
16384  87380  1        1       60.01    95284.94
16384  87380  1        1       60.01    95228.22

Weight/asym changes cost ~3%.  Mysql+oltp agrees.  Preempt happy loads
lose a bit, preempt haters gain a bit.  Performance shift.



