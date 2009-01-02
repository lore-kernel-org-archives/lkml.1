Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbZABWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbZABWQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZABWQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:16:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbZABWQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:16:40 -0500
Date: Fri, 2 Jan 2009 23:16:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090102221630.GF17240@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu> <20081230180722.GA29060@dirshya.in.ibm.com> <20090102072600.GA13412@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102072600.GA13412@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-30 23:37:22]:
> 
> > * Ingo Molnar <mingo@elte.hu> [2008-12-30 07:21:39]:
> > 
> > > 
> > > * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > > > KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> > > > > > package system
> > > > > >
> > > > > > SchedMC Run Time     Package Idle    Energy  Power
> > > > > > 0       81.68        52.83% 54.71%  1.00x J 1.00y W
> > > > > > 1       80.70        36.62% 70.11%  0.95x J 0.96y W
> > > > > > 2       74.95        19.53% 85.92%  0.90x J 0.98y W
> > > 
> > > > > Your result is very interesting.
> > > > > level 2 is more fast and efficient of power.
> > > > > 
> > > > > What's major contributor to use less time in level 2?
> > > > > I think it's cache bounce is less time than old.
> > > > > Is right ?
> > > > 
> > > > Yes, correct
> > > 
> > > yes, i too noticed that runtime improved so dramatically: +7.5% on 
> > > kernbench is a _very_ big deal.
> > > 
> > > So i wanted to ask you to re-test whether this speedup is reproducible, 
> > > and if yes, please check a few other workloads (for example sysbench on 
> > > postgresql / mysqld) and send a patch that changes the 
> > > sched_mc_power_savings default to POWERSAVINGS_BALANCE_WAKEUP (2).
> > 
> > The speedup for kernbench is reproducible.  I will post a more
> > detailed test report on kernbench soon.  The power-performance benefit
> > is for an under-utilised system (nr_cpus/2) run of kernbench which is
> > very ideal to demonstrate the power savings feature.  I will also try
> > sysbench and update results little later.  As Balbir mentioned, I am
> > on vacation and traveling.  I will post more benchmark results as soon
> > as possible.
> 
> Hi Ingo,
> 
> I ran my kernbench test setup over multiple iterations with several
> thread counts.  The performance will almost max out at 8-10 threads of
> kernbench since the system has total of 8 logical CPUs.
> 
> The power saving benefits is expected to be maximum around 30-50%
> system utilisation (3-5 threads).
> 
> I have posted the normalised results in various tables below.
> Apparently the sched_mc=2 settings is helping at 8 threads case also
> due to better cache line sharing.  I will work with Balbir to see if
> we can prove this assertion using performance counters.  I will start
> looking at sysbench and try to get benchmark results and power/energy
> data in similar configurations.
> 
> --Vaidy
> 
> All these tests were done on sched-tip at 
> commit: fe235c6b2a4b9eb11909fe40249abcce67f7d45d 
> uname -a is 2.6.28-rc8-tip-sv-05664-gfe235c6-dirty
> 
> Kernbench was run on source 2.6.28 while the previous tests used
> 2.6.25 kernel which had far less stuff to compile in defconfig :)
> 
> System configuration is x86 quad core dual socket system 
> with 8 logical CPUs
> 
> Each result is an average of 5 iterations.
> 
> Kernbench threads = 2
> 
> SchedMC Run Time     Package Idle(%)    Energy(J)  Power(W)
> 0	217.37	     73.30 76.93	1.00	   1.00
> 1	204.68	     50.86 99.91	0.95	   1.01
> 2	204.49	     50.69 99.93	0.95	   1.01
> 
> Kernbench threads = 4
> 
> SchedMC Run Time     Package Idle(%)    Energy(J)  Power(W)
> 0	109.11	     51.99 54.91	1.00	   1.00
> 1	109.71	     35.86 71.88	0.96	   0.96
> 2	102.95	     25.02 82.47	0.92	   0.97
> 
> Kernbench threads = 6
> 
> SchedMC Run Time     Package Idle(%)    Energy(J)  Power(W)
> 0	74.77	     35.29 36.37	1.00	   1.00
> 1	74.54	     28.83 40.90	0.99	   0.99
> 2	73.38	     21.09 47.29	0.98	   1.00
> 
> Kernbench threads = 8
> 
> SchedMC Run Time     Package Idle(%)    Energy(J)  Power(W)
> 0	63.18	     26.23 28.67	1.00	   1.00
> 1	56.89	     19.85 22.38 	0.93	   1.02
> 2	55.27	     17.65 19.84	0.91	   1.03

looks very promising.

> Relative measures for sched_mc=1 compared to baseline sched_mc=0
> 
> Threads=>	2	4	6	8	10	12
> KernbenchTime	0.94	1.01	1.00	0.90	0.93	0.95
> Energy		0.95	0.96	0.99	0.93	0.95	0.97
> Power		1.01	0.96	0.99	1.02	1.02	1.01
> 
> Relative measures for sched_mc=2 compared to baseline sched_mc=0
> 
> Threads=>	2	4	6	8	10	12
> KernbenchTime	0.94	0.94	0.98	0.87	0.92	0.94
> Energy		0.95	0.92	0.98	0.91	0.94	0.96
> Power		1.01	0.97	1.00	1.03	1.02	1.02

That's icing on the cake.

Mike, would you be interesting in having a look at sched_mc=2 as a 
kernel-wide default - and give it your blessing if you find it to be a net 
improvement for the various performance and interactivity tests you do?

	Ingo
