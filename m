Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXEaJx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXEaJx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXEaJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:53:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271AbXEaJxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:53:51 -0400
Date: Thu, 31 May 2007 11:53:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Yu <raise.sail@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070531095337.GA8104@elte.hu>
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465E992C.4020601@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Yu <raise.sail@gmail.com> wrote:

> static void distribute_fair_add(struct rq *rq, s64 delta)
> {
>    struct task_struct *curr = rq->curr;
>    s64 delta_fair = 0;
> 
>    if (!(sysctl_sched_load_smoothing & 32))
>        return;
> 
>    if (rq->nr_running) {
>        delta_fair = div64_s(delta, rq->nr_running);
>        /*
>         * The currently running task's next wait_runtime value does
>         * not depend on the fair_clock, so fix it up explicitly:
>         */
>        add_wait_runtime(rq, curr, -delta_fair);
>        rq->fair_clock -= delta_fair;
>    }
> }
> 
> See this line:
> 
>        delta_fair = div64_s(delta, rq->nr_running);
> 
> Ingo, should we be replace "rq->nr_running" with "rq->raw_load_weight" 
> here?

that would break the code. The handling of sleep periods is basically 
heuristics and using nr_running here appears to be 'good enough' in 
practice.

	Ingo
