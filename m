Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYLNUF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYLNUF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYLNUFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:05:47 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60881 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYLNUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:05:45 -0500
Date: Mon, 15 Dec 2008 01:38:43 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 0/7] Tunable sched_mc_power_savings=n
Message-ID: <20081214200843.GO5457@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com> <19700101001343.GA1440@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <19700101001343.GA1440@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@suse.cz> [1970-01-01 01:13:43]:

> 
> > Results:
> > --------
> > 
> > Basic functionality of the code has not changed and the power vs
> > performance benefits for kernbench are similar to the ones posted
> > earlier.
> > 
> > KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> > package system
> > 
> > SchedMC Run Time     Package Idle    Energy  Power
> > 0	81.28	     52.43% 53.53%  1.00x J 1.00y W
> > 1	80.71	     37.35% 68.91%  0.96x J 0.97y W
> > 2	76.05	     23.81% 82.65%  0.92x J 0.98y W
> > 
> > *** This is RFC code and not for inclusion ***
> 
> Hmm, so it makes it compile faster _and_ it saves power? Why to keep
> it tunable at all if it is win-win? Or are there other benchmarks?

Hi Pavel,

The performance and power gain depends on the nature of the
application.  If the processor cache is large enough, then
consolidation improves cache sharing and makes the system finish the
job faster.  I would expect applications with larger cache foot print
and no data sharing may experience degradation in performance.

I am open to suggestion on any interesting workload that should be
tested.  I have tested ebizzy and SPECjbb for power savings.  I am
also looking forward to test reports from others having different
system topology and processor power saving features.

The idea behind the tunable is to have power saving as higher priority
in scheduling relative to performance.  At higher sched_mc(2) settings
(aggressive power save mode), we should save power even if there is
a slight degradation in application performance.  If we save power and
improve performance, then it is a best case scenario.  However I would
expect certain workloads to sacrifice performance for the power
consumption.

At sched_mc = 0 the scheduler would not optimise for power savings
and provide maximum performance for any application.

Kernel compile is a representative workload where my additional
optimisations for sched_mc=2 improves over the default sched_mc=1
implementation in the kernel.

--Vaidy
