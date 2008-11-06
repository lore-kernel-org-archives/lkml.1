Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYKFHpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYKFHpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYKFHpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:45:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYKFHpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:45:04 -0500
Date: Thu, 6 Nov 2008 08:44:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Huber <andreas.huber@keymile.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: Scheduler RR, first time slice wrong?
Message-ID: <20081106074449.GC8459@elte.hu>
References: <1225956167.4472.27.camel@chber1-10446x.ch.keymile.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225956167.4472.27.camel@chber1-10446x.ch.keymile.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(added Cc:s)

* Andreas Huber <andreas.huber@keymile.com> wrote:

> Hi,
> 
> when starting a real-time process with the round-robin scheduler, the
> first time slice is set to HZ (1 second).
> When starting two such processes at the same time of the same static
> priority, the second one started is first executed after 1 second.
> (supposing the first process is heavy on cpu load).
> After both have exhausted this first time slice, it is set to
> DEF_TIMESLICE (which is 100ms).
> 
> Is this behavior as it is supposed to be?
> 
> Please add me in CC.
> 
> Regards,
> Andreas
> 
> 
> Relevant parts in the code:
> include/linux/init_task.h
> #define INIT_TASK(tsk) \
> 	.rt	= { \
> 		.time_slice = HZ,
> 
> kernel/sched.c
> #define DEF_TIMESLICE   (100 * HZ / 1000)
> 
> kernel/sched_rt.c
> static void task_tick_rt(struct rq *rq, struct task_struct *p, int
> queued)
>   if (--p->rt.time_slice)
>     return;
> 
>   p->rt.time_slice = DEF_TIMESLICE;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
