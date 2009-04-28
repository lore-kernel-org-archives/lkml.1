Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZD1Lxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZD1Lxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZD1Lxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:53:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZD1Lxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:53:37 -0400
Subject: Re: [PATCH] sched: make sure sched_child_runs_first WORK
From: Peter Zijlstra <peterz@infradead.org>
To: marywangran <marywangran@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <e82940b20904280426j53ff8be7h3caeed84a02bbfe9@mail.gmail.com>
References: <e82940b20904280421p171343a8h9072215028948b57@mail.gmail.com>
	 <e82940b20904280426j53ff8be7h3caeed84a02bbfe9@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 13:53:32 +0200
Message-Id: <1240919612.7620.155.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 19:26 +0800, marywangran wrote:


> Signed-off-by: Ya Zhao <marywangran@gmail.com>
> ---
> --- linux-2.6.28.1/kernel/sched_fair.c.orig     2009-04-28
> 22:26:00.000000000 +0800
> +++ linux-2.6.28.1/kernel/sched_fair.c  2009-04-28 22:34:49.000000000 +0800
> @@ -1628,12 +1628,13 @@ static void task_new_fair(struct rq *rq,
> 
>        /* 'curr' will be NULL if the child belongs to a different group */
>        if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
> -                       curr && curr->vruntime < se->vruntime) {
> +                      curr){
>                /*
>                 * Upon rescheduling, sched_class::put_prev_task() will place
>                 * 'current' within the tree based on its new key value.
>                 */
> -               swap(curr->vruntime, se->vruntime);
> +               if( curr->vruntime < se->vruntime )
> +                       swap(curr->vruntime, se->vruntime);
>                resched_task(rq->curr);
>        }

Aside from the style issue the patch seems sensible enough.

Thing is, do we really care about child runs first? 
