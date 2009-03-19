Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZCSQk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZCSQk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZCSQkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:40:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58026 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZCSQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:40:18 -0400
Date: Thu, 19 Mar 2009 22:11:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 3 4/6] sched: Rename the variable
	sched_mc_preferred_wakeup_cpu
Message-ID: <20090319164131.GM2990@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com> <20090318092238.24787.6657.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318092238.24787.6657.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:38]:

> sched_mc_ preferred_wakeup_cpu is currently used when the user seeks
> power savings through aggressive task consolidation.
> 
> This is applicable for both sched_mc_power_savings as well as
> sched_smt_power_savings. So rename sched_mc_preferred_wakeup_cpu to
> preferred_wakeup_cpu.
> 
> Also fix the comment for preferred_wakeup_cpu.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
> 
>  kernel/sched.c      |   12 +++++++-----
>  kernel/sched_fair.c |    2 +-
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 864c6ca..16d7655 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -515,11 +515,13 @@ struct root_domain {
>  #endif
>  #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
>  	/*
> -	 * Preferred wake up cpu nominated by sched_mc balance that will be
> -	 * used when most cpus are idle in the system indicating overall very
> -	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
> +	 * Preferred wake up cpu which is nominated by load balancer,
> +	 * is the CPU on which the tasks would be woken up, which
> +	 * otherwise would have woken up on an idle CPU even on a system
> +	 * with low-cpu-utilization.
> +	 * This is triggered at POWERSAVINGS_BALANCE_WAKEUP(2).
>  	 */
> -	unsigned int sched_mc_preferred_wakeup_cpu;
> +	unsigned int preferred_wakeup_cpu;
                Good short name :)
>  #endif
>  };
> 
> @@ -3416,7 +3418,7 @@ out_balanced:
>  	if (this == group_leader && group_leader != group_min) {
>  		*imbalance = min_load_per_task;
>  		if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
> -			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
> +			cpu_rq(this_cpu)->rd->preferred_wakeup_cpu =
>  				cpumask_first(sched_group_cpus(group_leader));
>  		}
>  		return group_min;
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index a3583c6..03b1e3c 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1052,7 +1052,7 @@ static int wake_idle(int cpu, struct task_struct *p)
> 
>  	this_cpu = smp_processor_id();
>  	chosen_wakeup_cpu =
> -		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
> +		cpu_rq(this_cpu)->rd->preferred_wakeup_cpu;
> 
>  	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP &&
>  		idle_cpu(cpu) && idle_cpu(this_cpu) &&


Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
