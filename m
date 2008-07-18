Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYGRKys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYGRKys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYGRKyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:54:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbYGRKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:54:39 -0400
Date: Fri, 18 Jul 2008 12:54:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eric miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
Message-ID: <20080718105424.GA22268@elte.hu>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com> <20080718102446.GV6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718102446.GV6875@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4446,7 +4446,8 @@ need_resched_nonpreemptible:
>  		rq->nr_switches++;
>  		rq->curr = next;
>  		++*switch_count;
> -
> +		if (rq->curr != rq->idle)
> +			tick_nohz_restart_sched_tick();
>  		context_switch(rq, prev, next); /* unlocks the rq */

hm, one problem i can see is lock dependencies. This code is executed 
with the rq lock while tick_nohz_restart_sched_tick() takes hr locks => 
not good. So i havent applied this just yet - this needs to be solved 
differently.

	Ingo
