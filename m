Return-Path: <linux-kernel-owner+w=401wt.eu-S935401AbXGQTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401AbXGQTG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935538AbXGQTF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:05:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935528AbXGQTF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:05:56 -0400
Date: Tue, 17 Jul 2007 21:05:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Q: a bogus task_running() check in try_to_wake_up() ?
Message-ID: <20070717190548.GB26283@elte.hu>
References: <20070715153914.GA441@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715153914.GA441@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> try_to_wake_up:
> 	
> 	if (p->se.on_rq)
> 		goto out_running;
> 
> 	...
> 
> 	if (unlikely(task_running(rq, p)))
> 		goto out_activate;
> 
> How it possible that rq->curr has on_rq == 0 ?
> 
> AFAICS, this can only happen if this task is rq->idle. But idle 
> threads should not sleep, we have a special "scheduling from the idle 
> thread!" check in schedule().

it's also possible if an arch uses __ARCH_WANT_INTERRUPTS_ON_CTXSW, 
right?

[ btw., we dont have a special "scheduling from the idle thread" check
  in schedule() anymore, it's now in kernel/sched_idletask.c :-) ]

	Ingo
