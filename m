Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYJDMcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYJDMcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 08:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYJDMcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 08:32:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbYJDMcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 08:32:36 -0400
Date: Sat, 4 Oct 2008 14:32:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dario Faggioli <raistlin@linux.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_rt.c: resch needed in rt_rq_enqueue() for the
	root rt_rq
Message-ID: <20081004123226.GC3728@elte.hu>
References: <1223048447.6714.46.camel@Palanthas> <1223119065.28938.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223119065.28938.22.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2008-10-03 at 17:40 +0200, Dario Faggioli wrote:
> > Hi all,
> > 
> > While working on the new version of the code for SCHED_SPORADIC I
> > noticed something strange in the present throttling mechanism. More
> > specifically in the throttling timer handler in sched_rt.c
> > (do_sched_rt_period_timer()) and in rt_rq_enqueue().
> > 
> > The problem is that, when unthrottling a runqueue, rt_rq_enqueue() only
> > asks for rescheduling if the runqueue has a sched_entity associated to
> > it (i.e., rt_rq->rt_se != NULL).
> > Now, if the runqueue is the root rq (which has a rt_se = NULL)
> > rescheduling does not take place, and it is delayed to some undefined
> > instant in the future.
> > 
> > This imply some random bandwidth usage by the RT tasks under throttling.
> > For instance, setting rt_runtime_us/rt_period_us = 950ms/1000ms an RT
> > task will get less than 95%. In our tests we got something varying
> > between 70% to 95%.
> > Using smaller time values, e.g., 95ms/100ms, things are even worse, and
> > I can see values also going down to 20-25%!!
> > 
> > The tests we performed are simply running 'yes' as a SCHED_FIFO task,
> > and checking the CPU usage with top, but we can investigate thoroughly
> > if you think it is needed.
> > 
> > Things go much better, for us, with the attached patch... Don't know if
> > it is the best approach, but it solved the issue for us.
> 
> Its consistent with John Blackwood's change to the !group case
> (f3ade837), and looks good.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Ingo, please pickup (might be 27.1 material as well).

applied to tip/sched/devel, thanks! I've also added a Cc: 
stable@kernel.org tag to the commit.

	Ingo
