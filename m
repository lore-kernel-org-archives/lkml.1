Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbZDNRcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbZDNRcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZDNRcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:32:05 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:52342 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZDNRcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:32:04 -0400
Message-ID: <49E4C898.9080003@oracle.com>
Date: Tue, 14 Apr 2009 10:32:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gautham R Shenoy <ego@in.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 2 1/2] sched: Nominate idle load balancer from a semi-idle
 package.
References: <20090414045356.7645.33369.stgit@sofia.in.ibm.com> <20090414045530.7645.12175.stgit@sofia.in.ibm.com>
In-Reply-To: <20090414045530.7645.12175.stgit@sofia.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49E4C87B.000E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
>  kernel/sched.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 118 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6cc1fd5..d702be7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
>  
> +/**
> + * is_semi_idle_group - Checks if the given sched_group is semi-idle.
> + * @ilb_group:	group to be checked for semi-idleness
> + *
> + * Returns:	1 if the group is semi-idle. 0 otherwise.
> + *
> + * We define a sched_group to be semi idle if it has atleast one idle-CPU
> + * and atleast one non-idle CPU. This helper function checks if the given

"at least" (2x)

> + * sched_group is semi-idle or not.
> + */
> +static inline int is_semi_idle_group(struct sched_group *ilb_group)
> +{
> +	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
> +					sched_group_cpus(ilb_group));
> +
> +	/*
> +	 * A sched_group is semi-idle when it has atleast one busy cpu
> +	 * and atleast one idle cpu.

"at least" (2x)

> +	 */
> +	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
> +		return 0;
> +
> +	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
> +		return 0;
> +
> +	return 1;
> +}


-- 
~Randy
