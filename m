Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZFDLxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZFDLxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbZFDLxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:53:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZFDLxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:53:40 -0400
Date: Thu, 4 Jun 2009 13:53:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: add trace_stack interface
Message-ID: <20090604115334.GA26925@elte.hu>
References: <alpine.DEB.2.00.0905192043090.7816@gandalf.stny.rr.com> <alpine.DEB.2.00.0905192108560.7816@gandalf.stny.rr.com> <20090603214814.GA5193@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603214814.GA5193@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, May 19, 2009 at 09:09:40PM -0400, Steven Rostedt wrote:
> > 
> > Ingo,
> > 
> > I rebased because I forgot to add EXPORT_SYMBOL_GPL.
> > 
> > -- Steve
> > 
> > Please pull the latest tip/tracing/ftrace tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/ftrace
> > 
> > 
> > Steven Rostedt (1):
> >       tracing: add trace_stack interface
> > 
> > ----
> >  include/linux/kernel.h |    2 ++
> >  kernel/trace/trace.c   |   16 ++++++++++++++++
> >  2 files changed, 18 insertions(+), 0 deletions(-)
> > ---------------------------
> > commit 9f6b28655254b91c48f684b367ac14bfec0e180a
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Tue May 19 18:54:16 2009 -0400
> > 
> >     tracing: add trace_stack interface
> >     
> >     This patch adds the global function
> >     
> >       void trace_stack(void)
> >     
> >     This allows a developer to find where a function is called. For example,
> >     if you want to know who calls __netif_reschedule, you can add
> >     
> >      static inline void __netif_reschedule(struct Qdisc *q)
> >      {
> >      	struct softnet_data *sd;
> >      	unsigned long flags;
> >     
> >     +	trace_stack();
> >      	local_irq_save(flags);
> >      	sd = &__get_cpu_var(softnet_data);
> >      	q->next_sched = sd->output_queue;
> >     
> >     And see the following in the trace output:
> >     
> >      <= __ftrace_trace_stack
> >      <= trace_stack
> >      <= __netif_schedule
> >      <= dev_watchdog
> >      <= run_timer_softirq
> >      <= __do_softirq
> >      <= call_softirq
> >      <= do_softirq
> >      <= irq_exit
> >     
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> 
> I wanted to use it to get the recursive locking points in reiserfs
> but I can't find it.
> 
> Has it been merged in -tip ?

hm, Steve has not sent it along AFAICS. There were no objections 
from me.

	Ingo
