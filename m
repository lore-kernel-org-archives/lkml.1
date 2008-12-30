Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYL3R21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYL3R21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYL3R2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:28:17 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33969 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYL3R2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:28:16 -0500
Date: Tue, 30 Dec 2008 23:01:10 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: MinChan Kim <minchan.kim@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081230173110.GA5159@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081230024819.GA23301@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-12-30 08:18:19]:

> * MinChan Kim <minchan.kim@gmail.com> [2008-12-30 08:43:58]:
> 
> > Hi, Vaidyanathan.
> > It's very late reponse. :(
> > 
> > > Results:
> > > --------
> > >
> > > Basic functionality of the code has not changed and the power vs
> > > performance benefits for kernbench are similar to the ones posted
> > > earlier.
> > >
> > > KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> > > package system
> > >
> > > SchedMC Run Time     Package Idle    Energy  Power
> > > 0       81.68        52.83% 54.71%  1.00x J 1.00y W
> > > 1       80.70        36.62% 70.11%  0.95x J 0.96y W
> > > 2       74.95        19.53% 85.92%  0.90x J 0.98y W
> > >
> > > The results are marginally better than the previous version of the
> > > patch series which could be within the test variation.
> > >
> > > Please feel free to test, and let me know your comments and feedback.
> > > I will post more experimental results with various benchmarks.
> > 
> > Your result is very interesting.
> > level 2 is more fast and efficient of power.
> > 
> > What's major contributor to use less time in level 2?
> > I think it's cache bounce is less time than old.
> > Is right ?
> >
> 
> Yes, correct
> 
> > I want to test SCHED_MC but I don't know what you use to benchmark about power.
> > How do I get the data about 'Package, Idle, Energy, Power'?
> > 
> 
> Note, it is Package Idle (for both packages), it is a x86-64 8 core,
> dual socket, quad core box. It is not Package, Idle.
> 
> For Energy and Power you need a means of measuring power like a meter.
> 

Hi MinChan,

Thank you for your interest in sched_mc power saving feature.  As
Balbir has mentioned, you will need a power measurement infrastructure
like an external power meter.

Laptops have battery discharge rate measurement that is a good
approximation for power consumption.  But that is not helpful to test
sched_mc since we would need a multi-socket multi core system to get
power saving benefit from the enhancements.

The 'package idle' information comes from /proc/stat by adding up the
idle times from various logical CPUs belonging to a single physical
package.  All logical CPUs belonging to a single physical package can
be identified from /proc/cpuinfo or
/sys/devices/system/cpu/cpu<n>/topology/physical_package_id

--Vaidy
