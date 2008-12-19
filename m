Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYLSNba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYLSNba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYLSNbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:31:22 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:44235 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYLSNbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:31:21 -0500
Date: Fri, 19 Dec 2008 19:04:24 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081219133424.GG22463@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218201938.GB12376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081218201938.GB12376@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-18 21:19:38]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > The existing power saving loadbalancer CONFIG_SCHED_MC attempts to run 
> > the workload in the system on minimum number of CPU packages and tries 
> > to keep rest of the CPU packages idle for longer duration. Thus 
> > consolidating workloads to fewer packages help other packages to be in 
> > idle state and save power.  The current implementation is very 
> > conservative and does not work effectively across different workloads. 
> > Initial idea of tunable sched_mc_power_savings=n was proposed to enable 
> > tuning of the power saving load balancer based on the system 
> > configuration, workload characteristics and end user requirements.
> > 
> > The power savings and performance of the given workload in an under 
> > utilised system can be controlled by setting values of 0, 1 or 2 to 
> > /sys/devices/system/cpu/sched_mc_power_savings with 0 being highest 
> > performance and least power savings and level 2 indicating maximum power 
> > savings even at the cost of slight performance degradation.
> > 
> > Please refer to the following discussions and article for details.
> > 
> > [1]Making power policy just work
> > http://lwn.net/Articles/287924/ 
> > 
> > [2][RFC v1] Tunable sched_mc_power_savings=n
> > http://lwn.net/Articles/287882/
> >                                                                                                                
> > v2: http://lwn.net/Articles/297306/
> > v3: http://lkml.org/lkml/2008/11/10/260
> > v4: http://lkml.org/lkml/2008/11/21/47
> > v5: http://lkml.org/lkml/2008/12/11/178
> > v6: http://lwn.net/Articles/311830/
> > 
> > The following series of patch demonstrates the basic framework for
> > tunable sched_mc_power_savings.
> > 
> > This version of the patch incorporates comments and feedback received
> > on the previous post from Andrew Morton.
> > 
> > Changes form v6:
> > ----------------
> > * Convert BALANCE_FOR_xx_POWER and related macros to inline functions
> >   based on comments from Andrew and Ingo.
> > * Ran basic kernelbench test and did not see any performance variation
> >   due to the changes.
> > 
> > Changes form v5:
> > ---------------
> > * Fixed the sscanf bug and checking for (p->flags & PF_KTHREAD)
> > * Dropped the RFC prefix to indicate that the patch is ready for
> >   testing and inclusion  
> > * Patch series against 2.6.28-rc8 kernel
> 
> thanks, applied - and i started testing them. It needed some help here and 
> there to resolve conflicts with pending cpumask changes. Could you please 
> double-check the merged up end result in the latest scheduler devel tree:
> 
>   http://people.redhat.com/mingo/tip.git/README

Hi Ingo,

I reviewed and tested the tip tree.  The merge looks good.  I did not
find any other cpumask API warnings after the one you have fixed in commit
220e7f617826e0527bbc523ba859f6a4bae0bfe1

Results in tip at: 2.6.28-rc8-tip-sv-01393-gc79978a

SchedMC Run Time     Package Idle    Energy  Power
0       80.50        51.47% 54.00%  1.00x J 1.00y W
1       78.89        43.37% 62.86%  0.95x J 0.97y W
2       75.37        30.28% 76.00%  0.91x J 0.98y W
		
Thanks,
Vaidy
