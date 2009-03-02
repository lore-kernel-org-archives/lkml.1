Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbZCBGNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbZCBGNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZCBGNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:13:41 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:64816 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCBGNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:13:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KIHrmrEGesg4EmeJshmvT0kLXiQoTDaz7QkPuKTzfsLBptThif2AsbD8+2FJpt5Ult
         KboFFi/jWTRfMF/Go2n18KNLY+Zc9RF1Q5wiHtZAJJBYMP5xDyb4n/MRfs6yyQBUfWOB
         5OyMBNaSQmcTlAAWF3f1y40LE8gyd/yP2ptCs=
Date: Mon, 2 Mar 2009 14:13:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: kill unused parameter of pick_next_task()
Message-ID: <20090302061350.GE1771@hack.private>
References: <49AB74CE.2000200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AB74CE.2000200@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 01:55:26PM +0800, Wang Chen wrote:
>based on tip/sched/cleanups
>
>impact: no change in functionality
>
>Parameter "prev" seems like an unusable thing.
>
>Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
>---
> kernel/sched.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/kernel/sched.c b/kernel/sched.c
>index 410eec4..57f8b12 100644
>--- a/kernel/sched.c
>+++ b/kernel/sched.c
>@@ -4512,7 +4512,7 @@ static inline void schedule_debug(struct task_struct *prev)
>  * Pick up the highest-prio task:
>  */
> static inline struct task_struct *
>-pick_next_task(struct rq *rq, struct task_struct *prev)
>+pick_next_task(struct rq *rq)
> {
> 	const struct sched_class *class;
> 	struct task_struct *p;
>@@ -4587,7 +4587,7 @@ need_resched_nonpreemptible:
> 		idle_balance(cpu, rq);
> 
> 	prev->sched_class->put_prev_task(rq, prev);
        ^^^^^

How about this? :)

>-	next = pick_next_task(rq, prev);
>+	next = pick_next_task(rq);
> 
> 	if (likely(prev != next)) {
                   ^^^^

also here.

> 		sched_info_switch(prev, next);
>@@ -6423,7 +6423,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
> 		if (!rq->nr_running)
> 			break;
> 		update_rq_clock(rq);
>-		next = pick_next_task(rq, rq->curr);
>+		next = pick_next_task(rq);
> 		if (!next)
> 			break;
> 		next->sched_class->put_prev_task(rq, next);


I think you should check the latest linus-git, where you can safely
just remove the parameter 'prev'.


-- 
Do what you love, f**k the rest! F**k the regulations!
 
