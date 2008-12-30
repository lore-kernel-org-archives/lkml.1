Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbYL3GWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbYL3GWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYL3GVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:21:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYL3GVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:21:50 -0500
Date: Tue, 30 Dec 2008 07:21:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081230062139.GA30038@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230024819.GA23301@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > > KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> > > package system
> > >
> > > SchedMC Run Time     Package Idle    Energy  Power
> > > 0       81.68        52.83% 54.71%  1.00x J 1.00y W
> > > 1       80.70        36.62% 70.11%  0.95x J 0.96y W
> > > 2       74.95        19.53% 85.92%  0.90x J 0.98y W

> > Your result is very interesting.
> > level 2 is more fast and efficient of power.
> > 
> > What's major contributor to use less time in level 2?
> > I think it's cache bounce is less time than old.
> > Is right ?
> 
> Yes, correct

yes, i too noticed that runtime improved so dramatically: +7.5% on 
kernbench is a _very_ big deal.

So i wanted to ask you to re-test whether this speedup is reproducible, 
and if yes, please check a few other workloads (for example sysbench on 
postgresql / mysqld) and send a patch that changes the 
sched_mc_power_savings default to POWERSAVINGS_BALANCE_WAKEUP (2).

Sidenote, _please_ fix your mail client to not mess up the Cc: list via:

Mail-Followup-To: MinChan Kim <minchan.kim@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>

	Ingo
