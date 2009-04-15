Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZDOLmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZDOLmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZDOLmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:42:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:53183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbZDOLmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:42:07 -0400
Subject: Re: [PATCH] sched: fix off-by-one bug in balance_tasks()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49E54B2A.9060100@cn.fujitsu.com>
References: <49E54B2A.9060100@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 13:41:59 +0200
Message-Id: <1239795719.22720.2231.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 10:49 +0800, Miao Xie wrote:
> If the load that need be moved equals the half weight of a task, I think
> it is unnecessary to move this task. Or this task will be moved back and
> forth.

That's actually desirable. Consider the 3 tasks on 2 cpus statically
infeasible scenario. There you'd want the tasks to bounce around a bit
in order to provide fairness.

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 5724508..44926c8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3085,7 +3085,7 @@ next:
>  	if (!p || loops++ > sysctl_sched_nr_migrate)
>  		goto out;
>  
> -	if ((p->se.load.weight >> 1) > rem_load_move ||
> +	if ((p->se.load.weight >> 1) >= rem_load_move ||
>  	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
>  		p = iterator->next(iterator->arg);
>  		goto next;

