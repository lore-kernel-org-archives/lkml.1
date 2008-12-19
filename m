Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYLSI2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYLSI2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYLSI2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:28:44 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58505 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYLSI2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:28:43 -0500
Date: Fri, 19 Dec 2008 13:59:09 +0530
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
Message-ID: <20081219082909.GE22463@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218201938.GB12376@elte.hu> <20081218203140.GA18757@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081218203140.GA18757@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-18 21:31:40]:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > thanks, applied - and i started testing them. [...]
> 
> the sched.h bits needed the small fix below. (struct sched_domain is not 
> defined on UP)

Thanks Ingo. I will watch out for such errors next time.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

--Vaidy

> 
> 	Ingo
> 
> ------------->
> From edb4c71953409c1deac1a80528ac0aa768762b33 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 18 Dec 2008 21:30:23 +0100
> Subject: [PATCH] sched: move test_sd_parent() to an SMP section of sched.h
> 
> Impact: build fix
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/sched.h |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5a933d9..e5f928a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -920,6 +920,15 @@ extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
>  				    struct sched_domain_attr *dattr_new);
>  extern int arch_reinit_sched_domains(void);
> 
> +/* Test a flag in parent sched domain */
> +static inline int test_sd_parent(struct sched_domain *sd, int flag)
> +{
> +	if (sd->parent && (sd->parent->flags & flag))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  #else /* CONFIG_SMP */
> 
>  struct sched_domain_attr;
> @@ -1431,15 +1440,6 @@ struct task_struct {
>  #endif
>  };
> 
> -/* Test a flag in parent sched domain */
> -static inline int test_sd_parent(struct sched_domain *sd, int flag)
> -{
> -	if (sd->parent && (sd->parent->flags & flag))
> -		return 1;
> -
> -	return 0;
> -}
> -
>  /*
>   * Priority of a process goes from 0..MAX_PRIO-1, valid RT
>   * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
