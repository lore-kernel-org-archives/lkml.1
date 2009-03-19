Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZCSPQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZCSPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZCSPQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:16:19 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40069 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZCSPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:16:18 -0400
Date: Thu, 19 Mar 2009 20:47:30 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH v3 0/6] sched: Extend sched_mc/smt_framework
Message-ID: <20090319151730.GI2990@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318092054.24787.18730.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:17]:

> Hi,
> 
> I am reposting the iteration 3 of the patch series that extends the existing
> sched_smt_/mc_power_savings framework to work on platforms
> that have on-chip memory controllers making each of the cpu-package
> a 'node'. I have rebased this patch series against 2.6.29-rc8.
> 
> Changes from V2: (Found here:  --> http://lkml.org/lkml/2009/3/3/109)
> - Patches have been split up in an incremental manner for easy review.
> - Fixed comments for some variables.
> - Renamed some variables to better reflect their usage.
> 
> Changes from V1: (Found here: --> http://lkml.org/lkml/2009/2/16/221)
> - Added comments to explain power-saving part in find_busiest_group()
> - Added comments for the different sched_domain levels.
> 
> Background
> ------------------------------------------------------------------
> On machines with on-chip memory controller, each physical CPU
> package forms a NUMA node and the CPU level sched_domain will have
> only one group.  This prevents any form of power saving balance across
> these nodes.  Enabling the sched_mc_power_savings tunable to work as
> designed on these new single CPU NUMA node machines will help task
> consolidation and save power as we did in other multi core multi
> socket platforms.
> 
> Consolidation across NODES have implications of cross-node memory
> access and other NUMA locality issues.  Even under such constraints
> there could be scope for power savings vs performance tradeoffs and
> hence making the sched_mc_powersavings work as expected on these
> platform is justified.

If the workload threads share lots of data from cache, then
consolidating them will improve cache sharing at the last level cache
in the package.  If most of the working set fits the on chip cache,
then the cross-node reference latencies will be effectively hidden.
 
> sched_mc/smt_power_savings is still a tunable and power savings benefits
> and performance would vary depending on the workload and the system
> topology and hardware features.

In your results we can see significant performance degradation for
marginal power savings when sibling threads are used to run workloads.
Kernbench is perhaps cpu intensive and did not leave many stall cycles
in the processor for the sibling thread to benefit.  

Some other workloads that experience stalls due to memory references
may not see such degradation when run on sibling threads.

--Vaidy
