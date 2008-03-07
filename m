Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYCGFAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYCGFAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYCGFAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:00:21 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49349 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703AbYCGFAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:00:19 -0500
Date: Fri, 7 Mar 2008 10:28:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: Re: [patch 1/2] sched: cleanup cpuacct variable names
Message-ID: <20080307045830.GA11805@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	vatsa@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu,
	linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
References: <20080229043242.110741439@linux.vnet.ibm.com> <20080229043751.492446073@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080229043751.492446073@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dhaval Giani <dhaval@linux.vnet.ibm.com> [2008-02-29 10:02:43]:

> Change the variable names to the common convention for the cpuacct
> subsystem.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> ---
>  kernel/sched.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c	2008-02-27 16:21:15.000000000 +0530
> +++ linux-2.6/kernel/sched.c	2008-02-28 20:05:27.000000000 +0530
> @@ -8180,9 +8180,9 @@ struct cpuacct {
>  struct cgroup_subsys cpuacct_subsys;
> 
>  /* return cpu accounting group corresponding to this container */
> -static inline struct cpuacct *cgroup_ca(struct cgroup *cont)
> +static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
>  {
> -	return container_of(cgroup_subsys_state(cont, cpuacct_subsys_id),
> +	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
>  			    struct cpuacct, css);
>  }
> 
> @@ -8195,7 +8195,7 @@ static inline struct cpuacct *task_ca(st
> 
>  /* create a new cpu accounting group */
>  static struct cgroup_subsys_state *cpuacct_create(
> -	struct cgroup_subsys *ss, struct cgroup *cont)
> +	struct cgroup_subsys *ss, struct cgroup *cgrp)
>  {
>  	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
> 
> @@ -8213,18 +8213,18 @@ static struct cgroup_subsys_state *cpuac
> 
>  /* destroy an existing cpu accounting group */
>  static void
> -cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
> +cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
>  {
> -	struct cpuacct *ca = cgroup_ca(cont);
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> 
>  	free_percpu(ca->cpuusage);
>  	kfree(ca);
>  }
> 
>  /* return total cpu usage (in nanoseconds) of a group */
> -static u64 cpuusage_read(struct cgroup *cont, struct cftype *cft)
> +static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
>  {
> -	struct cpuacct *ca = cgroup_ca(cont);
> +	struct cpuacct *ca = cgroup_ca(cgrp);
>  	u64 totalcpuusage = 0;
>  	int i;
> 
> @@ -8250,9 +8250,9 @@ static struct cftype files[] = {
>  	},
>  };
> 
> -static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cont)
> +static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
>  {
> -	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
> +	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
>  }
> 
>  /*
> 
>

Looks good

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

