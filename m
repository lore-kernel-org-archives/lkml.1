Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYGAG0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYGAG0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYGAG0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:26:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYGAG0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:26:22 -0400
Date: Tue, 1 Jul 2008 08:26:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Raistlin <raistlin@linux.it>
Cc: Michael Trimarchi <trimarchimichael@yahoo.it>,
       PeterZijlstra <peterz@infradead.org>, "Daniel K." <dk@uw.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: divide error trying to set rt_period to zero
Message-ID: <20080701062604.GB16642@elte.hu>
References: <1214432249.5464.22.camel@Palanthas.Krynn> <20080626133924.GA20188@elte.hu> <1214499251.10344.7.camel@Palanthas.Krynn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214499251.10344.7.camel@Palanthas.Krynn>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Raistlin <raistlin@linux.it> wrote:

> Ops! :-O
> 
> My fault, moving the 'if' back and forth from one function to another 
> I finally sent the wrong (and broken!) version of the patch... Very 
> sorry about it!
> 
> I know, I would have noticed just looking at the code... But I missed 
> it. :-(

hey, no problem.

> Anyway, if still interested in, the following one build and work... 
> I've just tried it and I'm quite sure this time. :-P

applied to tip/sched/urgent - thanks Dario. We are interested in it of 
course, you fixed a real bug in the scheduler :-)

small sidenote:

> +++ b/kernel/sched.c
> @@ -8501,6 +8501,9 @@ int sched_group_set_rt_period(struct task_group
> *tg, long rt_period_us)
>         rt_period = (u64)rt_period_us * NSEC_PER_USEC;
>         rt_runtime = tg->rt_bandwidth.rt_runtime;
>  
> +       if (rt_period == 0)
> +               return -EINVAL;
> +
>         return tg_set_bandwidth(tg, rt_period, rt_runtime);
>  }

that patch was whitespace damaged (lines wrapped and tabs converted to 
spaces). I fixed it up by hand - you can avoid such problems with future 
patches by sending patches a'la Documentation/email-clients.txt.

	Ingo
