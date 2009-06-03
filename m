Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZFCWSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZFCWSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZFCWSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:18:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZFCWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:18:06 -0400
Date: Wed, 3 Jun 2009 18:18:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: add trace_stack interface
In-Reply-To: <20090603214814.GA5193@nowhere>
Message-ID: <alpine.DEB.2.00.0906031814010.14994@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905192043090.7816@gandalf.stny.rr.com> <alpine.DEB.2.00.0905192108560.7816@gandalf.stny.rr.com> <20090603214814.GA5193@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Jun 2009, Frederic Weisbecker wrote:
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
> 

It looks like it hasn't :-(

Luckily, I do not do "git gc" on my relay repo. Otherwise I would have 
totally lost this. (it's no longer in my working repo.) I'll make a branch 
from it now.

I wish merges were OK, because then I would be know if anything is 
missing. When we rebase changes, things can easily get lost.

-- Steve

