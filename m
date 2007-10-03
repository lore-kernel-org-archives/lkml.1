Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXJCEEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXJCEEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbXJCEEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:04:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56985 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXJCEEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:04:32 -0400
Date: Wed, 3 Oct 2007 09:45:10 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20071003041510.GJ5724@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1191354556.5664.7.camel@earth> <1191355144.5664.16.camel@earth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191355144.5664.16.camel@earth>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 09:59:04PM +0200, Dmitry Adamushko wrote:
> The following patch (sched: disable sleeper_fairness on SCHED_BATCH)
> seems to break GROUP_SCHED. Although, it may be
> 'oops'-less due to the possibility of 'p' being always a valid
> address.

Thanks for catching it!  Patch below looks good to me. 

Acked-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> ---
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 8727d17..a379456 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -473,9 +473,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  		vruntime += sched_vslice_add(cfs_rq, se);
> 
>  	if (!initial) {
> -		struct task_struct *p = container_of(se, struct task_struct, se);
> -
> -		if (sched_feat(NEW_FAIR_SLEEPERS) && p->policy != SCHED_BATCH)
> +		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se) &&
> +				task_of(se)->policy != SCHED_BATCH)
>  			vruntime -= sysctl_sched_latency;
> 
>  		vruntime = max_t(s64, vruntime, se->vruntime);
> 
> ---
> 

-- 
Regards,
vatsa
