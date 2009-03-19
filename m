Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZCSQhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZCSQhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZCSQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:37:41 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51032 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZCSQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:37:40 -0400
Date: Thu, 19 Mar 2009 22:08:53 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 3 3/6] sched: Add Comments at the beginning of
	find_busiest_group.
Message-ID: <20090319163853.GL2990@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com> <20090318092233.24787.39132.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318092233.24787.39132.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:33]:

> Currently there are no comments pertaining to power-savings balance in
> the function find_busiest_group. Add appropriate comments.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  kernel/sched.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 407ee03..864c6ca 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3090,6 +3090,23 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
>   * find_busiest_group finds and returns the busiest CPU group within the
>   * domain. It calculates and returns the amount of weighted load which
>   * should be moved to restore balance via the imbalance parameter.
> + *
> + * Power-savings-balance: Through the sysfs tunables sched_mc/smt_power_savings
> + * he user can opt for aggressive task consolidation as a means to save power.
      ^ the  
> + * When this is activated, we would have the SD_POWERSAVINGS_BALANCE flag
           ^^^^ When sched_{mc,smt}_powersavings is activated, then
           SD_POWERSAVINGS_BALANCE...
> + * set for appropriate sched_domains,
> + *
> + * Within such sched_domains, find_busiest_group would try to identify
> + * a sched_group which can be freed-up and whose tasks can be migrated to
> + * a sibling group which has the capacity to accomodate the former's tasks.
                                        ^^^ remaining capacity
> + * If such a "can-go-idle" sched_group does exist, then the sibling group
                                                                ^^^^^^^^
                                                this group is returned
                                                as busiest_group                                                                        
> + * which can accomodate it's tasks is returned as the busiest group.
                                ^^^^^^^^^^^^^^^^ This is the
                                group_leader and busiest_group is
                                returned if the current cpu is
                                a member of group leader.
> + *
> + * Furthermore, if the user opts for more aggressive power-aware load
> + * balancing through sched_smt/mc_power_savings = 2, i.e when the
> + * active_power_savings_level greater or equal to POWERSAVINGS_BALANCE_WAKEUP,
> + * find_busiest_group will also nominate the preferred CPU, on which the tasks
> + * should hence forth be woken up on, instead of bothering an idle-cpu.
>   */
>  static struct sched_group *
>  find_busiest_group(struct sched_domain *sd, int this_cpu,


Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
