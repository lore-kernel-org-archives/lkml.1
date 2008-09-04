Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYIDKxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYIDKxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYIDKxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:53:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:65335 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYIDKxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:53:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="612656155"
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo <mingo@elte.hu>
In-Reply-To: <1220519034.8609.206.camel@twins>
References: <1220518266.9590.22.camel@minggr>
	 <1220519034.8609.206.camel@twins>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 18:52:59 +0800
Message-Id: <1220525579.12161.8.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-09-04 at 11:03 +0200, Peter Zijlstra wrote:
> On Thu, 2008-09-04 at 16:51 +0800, Lin Ming wrote:
> > Comparing with 2.6.27-rc4, oltp has ~10% regression with 2.6.27-rc5 on
> > 8-core stoakley machine.
> > 
> > Run oltp with 8 threads 120 seconds, vmstat shows much more idle time, about ~30%
> > 
> > procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> > 10  0      0 7822824  42240 123740    0    0   312    47  442 1613  3  2 88  6  0
> >  9  0      0 7822312  42240 123764    0    0     0    16 26691 232566 56 14 30  0  0
> > 13  0      0 7821940  42240 123764    0    0     0    16 26661 228689 54 14 32  0  0
> >  8  0      0 7821320  42240 123764    0    0     0    16 31508 263765 61 17 23  0  0
> > 12  0      0 7820948  42240 123764    0    0    16    16 28666 242402 57 15 28  0  0
> >  9  0      0 7820584  42240 123780    0    0     0    16 27107 230804 56 14 30  0  0
> > 10  0      0 7819964  42240 123796    0    0    16   612 27599 244037 55 16 29  0  0
> > 11  0      0 7819356  42240 123796    0    0     0    64 23540 209713 51 13 36  0  0
> > 10  0      0 7819212  42240 123796    0    0     0    32 25674 224205 54 13 32  0  0
> > 10  0      0 7818716  42240 123796    0    0     0    20 30106 257161 59 16 25  0  0
> >  7  0      0 7818468  42240 123796    0    0     0    16 28356 241551 57 14 29  0  0
> > 10  0      0 7818096  42240 123796    0    0     0    16 39174 273656 64 16 20  0  0
> > 12  0      0 7817724  42240 123796    0    0     0    20 39688 276936 63 16 20  0  0
> > 11  0      0 7817352  42240 123796    0    0     0    16 42543 285192 66 16 18  0  0
> >  9  0      0 7817352  42240 123796    0    0     0    16 37083 259830 62 14 24  0  0
> >  8  0      0 7817104  42240 123796    0    0     0    16 37450 259160 61 15 23  0  0
> > 10  0      0 7816516  42240 123796    0    0     0    64 37425 261870 61 16 23  0  0
> > 11  0      0 7815896  42240 123812    0    0    16    16 41558 279320 66 16 18  0  0
> >  9  0      0 7815648  42240 123812    0    0     0    16 34017 235741 59 14 28  0  0
> > 10  0      0 7815152  42240 123812    0    0     0    16 35642 248888 60 14 26  0  0
> >  9  0      0 7814532  42240 123812    0    0     0    16 38517 263220 63 15 22  0  0
> >  9  0      0 7814160  42240 123812    0    0     0    20 35965 246487 61 14 25  0  0
> > 10  0      0 7814036  42240 123812    0    0     0    16 33852 236313 59 13 28  0  0
> > 11  0      0 7813664  42240 123812    0    0     0    16 34958 244819 59 14 27  0  0
> > 10  0      0 7813416  42240 123812    0    0     0    16 26106 202062 53 10 37  0  0
> > 10  0      0 7812672  42240 123812    0    0     0    16 31174 222714 56 12 32  0  0
> >  9  0      0 7812300  42240 123812    0    0     0   276 25089 196813 52 11 38  0  0
> >  9  0      0 7812060  42240 123812    0    0     0    16 31877 228004 57 12 31  0  0
> > 
> > 
> > 
> > Bisect located below patch, 
> > after reverted this patch the regression disappear.
> > 
> > commit 354879bb977e06695993435745f06a0f6d39ce2b
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Mon Aug 25 17:15:34 2008 +0200
> > 
> >     sched_clock: fix cpu_clock()
> > 
> >     This patch fixes 3 issues:
> > 
> >     a) it removes the dependency on jiffies, because jiffies are
> > incremented
> >        by a single CPU, and the tick is not synchronized between CPUs.
> > Therefore
> >        relying on it to calculate a window to clip whacky TSC values
> > doesn't work
> >        as it can drift around.
> > 
> >        So instead use [GTOD, GTOD+TICK_NSEC) as the window.
> > 
> >     b) __update_sched_clock() did (roughly speaking):
> > 
> >        delta = sched_clock() - scd->tick_raw;
> >        clock += delta;
> > 
> >        Which gives exponential growth, instead of linear.
> > 
> >     c) allows the sched_clock_cpu() value to warp the u64 without
> > breaking.
> > 
> >     the results are more reliable sched_clock() deltas:
> 
> Thats bizarre... that just indicates the better clock, which should give
> better (read fairer) scheduling hurts your workload.
> 
> Is there anything I can run to see if we can fix the scheduler perhaps?

I observed schedstats of sysbench, there's more
"nr_failed_migrations_hot"

2.6.27-rc4: se.nr_failed_migrations_hot 11
2.6.27-rc5: se.nr_failed_migrations_hot 95

task migration failed because of task_hot, the system is un-balanced?

