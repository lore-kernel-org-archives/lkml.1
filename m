Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXFLCab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXFLCab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXFLCaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:30:23 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:44345 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXFLCaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:30:22 -0400
Message-ID: <466E0502.7000906@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2007 07:59:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       efault@gmx.de, kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
Subject: Re: [RFC][PATCH 3/6] core changes in CFS
References: <20070611154724.GA32435@in.ibm.com> <20070611155345.GC2109@in.ibm.com>
In-Reply-To: <20070611155345.GC2109@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> +#define entity_is_task(se)	1

Could you add some comments as to what this means? Should be it boolean instead
(true)


>  /*
> - * Enqueue a task into the rb-tree:
> + * Enqueue a entity into the rb-tree:

Enqueue an entity

> -static void limit_wait_runtime(struct rq *rq, struct task_struct *p)
> +static void limit_wait_runtime(struct lrq *lrq, struct sched_entity *p)

p is a general convention for tasks in the code, could we use something
different -- may be "e"?

> 
>  static s64 div64_s(s64 divident, unsigned long divisor)
> @@ -183,49 +219,51 @@
>   * Update the current task's runtime statistics. Skip current tasks that
>   * are not in our scheduling class.
>   */
> -static inline void update_curr(struct rq *rq, u64 now)
> +static inline void update_curr(struct lrq *lrq, u64 now)
>  {
> -	unsigned long load = rq->lrq.raw_weighted_load;
> +	unsigned long load = lrq->raw_weighted_load;
>  	u64 delta_exec, delta_fair, delta_mine;
> -	struct task_struct *curr = rq->curr;
> +	struct sched_entity *curr = lrq_curr(lrq);

How about curr_entity?

> +	struct rq *rq = lrq_rq(lrq);
> +	struct task_struct *curtask = rq->curr;
> 
> -	if (curr->sched_class != &fair_sched_class || curr == rq->idle || !load)
> +	if (!curr || curtask == rq->idle || !load)

Can !curr ever be true? shoudn't we look into the sched_class of the task
that the entity belongs to?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
