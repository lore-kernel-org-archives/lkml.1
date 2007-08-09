Return-Path: <linux-kernel-owner+w=401wt.eu-S939073AbXHII10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939073AbXHII10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXHII1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:27:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939015AbXHII1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:27:03 -0400
Date: Thu, 9 Aug 2007 10:26:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Mitchell Erblich <erblichs@earthlink.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq, struct
	task_struct *p) : decreases overhead when rq->nr_running == 1
Message-ID: <20070809082656.GA21973@elte.hu>
References: <000501c7d945$f30af1a0$6501a8c0@earthlink.net> <20070808123418.GA30248@elte.hu> <b647ffbd0708090111r50d29dbp779e014db1a63296@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0708090111r50d29dbp779e014db1a63296@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> I guess, the following thing would do a better job:
> 
> - we do need reschedule() _only_ if there are other task on the _same_ 
> queue (for this prio level) :

ah, indeed.

> --- kernel/sched_rt-prev.c      2007-08-09 09:55:10.000000000 +0200
> +++ kernel/sched_rt.c   2007-08-09 09:58:53.000000000 +0200
> @@ -207,6 +207,11 @@ static void task_tick_rt(struct rq *rq,
>                 return;
> 
>         p->time_slice = static_prio_timeslice(p->static_prio);
> +
> +       /* We are the only element on the queue. */
> +       if (p->run_list.prev == p->run_list.next)
> +               return;
> +

i've applied your patch - could you please send a SOB line?

	Ingo
