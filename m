Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZD1OBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZD1OBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZD1OBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:01:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbZD1OBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:01:23 -0400
Subject: Re: [PATCH] sched: make sure sched_child_runs_first WORK
From: Peter Zijlstra <peterz@infradead.org>
To: marywangran <marywangran@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <e82940b20904280655j6b7208f6jff8bbdef290d9872@mail.gmail.com>
References: <e82940b20904280421p171343a8h9072215028948b57@mail.gmail.com>
	 <e82940b20904280426j53ff8be7h3caeed84a02bbfe9@mail.gmail.com>
	 <1240919612.7620.155.camel@twins>
	 <e82940b20904280655j6b7208f6jff8bbdef290d9872@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 16:01:18 +0200
Message-Id: <1240927278.7620.159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 21:55 +0800, marywangran wrote:
> 
> 
> 2009/4/28 Peter Zijlstra <peterz@infradead.org>
>         On Tue, 2009-04-28 at 19:26 +0800, marywangran wrote:
>         
>         
>         > Signed-off-by: Ya Zhao <marywangran@gmail.com>
>         > ---
>         > --- linux-2.6.28.1/kernel/sched_fair.c.orig     2009-04-28
>         > 22:26:00.000000000 +0800
>         > +++ linux-2.6.28.1/kernel/sched_fair.c  2009-04-28 22:34:49.000000000 +0800
>         > @@ -1628,12 +1628,13 @@ static void task_new_fair(struct rq *rq,
>         >
>         >        /* 'curr' will be NULL if the child belongs to a different group */
>         >        if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
>         > -                       curr && curr->vruntime < se->vruntime) {
>         > +                      curr){
>         >                /*
>         >                 * Upon rescheduling, sched_class::put_prev_task() will place
>         >                 * 'current' within the tree based on its new key value.
>         >                 */
>         > -               swap(curr->vruntime, se->vruntime);
>         > +               if( curr->vruntime < se->vruntime )
>         > +                       swap(curr->vruntime, se->vruntime);
>         >                resched_task(rq->curr);
>         >        }
>         
>         
>         Aside from the style issue the patch seems sensible enough.
>         
>         Thing is, do we really care about child runs first?
> 
> but if the child runs last,there maybe more copy-on-write.User can
> disable child-runs-first if he can confirm the child would not do exec
> or so . now that the kernel provide the policy,why we implement it
> halfway?

Sure, I just wanted to raise the issue, child-runs-first doesn't really
work reliably on SMP, and since even embedded is moving to SMP the value
of keeping it around seems to be less each day.

But as long as we do have it, I agree that your patch is wanted.
