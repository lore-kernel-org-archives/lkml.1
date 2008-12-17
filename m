Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752155AbYLQSqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbYLQSqo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYLQSqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:46:22 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:53745 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYLQSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:46:21 -0500
Date: Wed, 17 Dec 2008 23:39:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH v6 2/7] sched: favour lower logical cpu number for
	sched_mc balance
Message-ID: <20081217180932.GB26572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
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
	Pavel Machek <pavel@suse.cz>
References: <20081217172309.534.28847.stgit@drishya.in.ibm.com> <20081217172642.534.10983.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081217172642.534.10983.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-17 22:56:42]:

> Just in case two groups have identical load, prefer to move load to lower
> logical cpu number rather than the present logic of moving to higher logical
> number.
> 
> find_busiest_group() tries to look for a group_leader that has spare capacity
> to take more tasks and freeup an appropriate least loaded group.  Just in case
> there is a tie and the load is equal, then the group with higher logical number
> is favoured.  This conflicts with user space irqbalance daemon that will move
> interrupts to lower logical number if the system utilisation is very low.
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 16897ab..0b9bbbd 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3264,7 +3264,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
>  		 */
>  		if ((sum_nr_running < min_nr_running) ||
>  		    (sum_nr_running == min_nr_running &&
> -		     first_cpu(group->cpumask) <
> +		     first_cpu(group->cpumask) >
>  		     first_cpu(group_min->cpumask))) {
>  			group_min = group;
>  			min_nr_running = sum_nr_running;
> @@ -3280,7 +3280,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
>  		if (sum_nr_running <= group_capacity - 1) {
>  			if (sum_nr_running > leader_nr_running ||
>  			    (sum_nr_running == leader_nr_running &&
> -			     first_cpu(group->cpumask) >
> +			     first_cpu(group->cpumask) <
>  			      first_cpu(group_leader->cpumask))) {
>  				group_leader = group;
>  				leader_nr_running = sum_nr_running;
> 
>

OK, so group_min is pushed to higher cpu numbers and group_leader is pulled to
lower cpu numbers

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Balbir
