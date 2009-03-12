Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZCLXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZCLXt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbZCLXtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:49:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZCLXtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:49:39 -0400
Date: Fri, 13 Mar 2009 00:49:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fche@redhat.com,
       peterz@infradead.org, compudj@krystal.dyndns.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090312234912.GA3381@elte.hu>
References: <20090312183603.GC3352@redhat.com> <20090312190243.GC11045@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312190243.GC11045@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Mar 12, 2009 at 02:36:03PM -0400, Jason Baron wrote:
> > 
> > introduce softirq entry/exit tracepoints. These are useful for
> > augmenting existing tracers, and to figure out softirq frequencies and
> > timings.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> > 
> >  include/trace/irq_event_types.h |   12 ++++++++++++
> >  kernel/softirq.c                |    7 ++++++-
> >  2 files changed, 18 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
> > index 214bb92..38b4bdd 100644
> > --- a/include/trace/irq_event_types.h
> > +++ b/include/trace/irq_event_types.h
> > @@ -40,4 +40,16 @@ TRACE_EVENT(irq_handler_exit,
> >  		  __entry->irq, __entry->ret ? "handled" : "unhandled")
> >  );
> >  
> > +TRACE_FORMAT(irq_softirq_entry,
> > +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> > +	TP_ARGS(h, vec),
> > +	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
> > +	);
> > +
> > +TRACE_FORMAT(irq_softirq_exit,
> > +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> > +	TP_ARGS(h, vec),
> > +	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
> > +	);
> > +
> >  #undef TRACE_SYSTEM
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index ba1511f..c378d53 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/ftrace.h>
> >  #include <linux/smp.h>
> >  #include <linux/tick.h>
> > +#include <trace/irq.h>
> >  
> >  #include <asm/irq.h>
> >  /*
> > @@ -186,6 +187,9 @@ EXPORT_SYMBOL(local_bh_enable_ip);
> >   */
> >  #define MAX_SOFTIRQ_RESTART 10
> >  
> > +DEFINE_TRACE(irq_softirq_entry);
> > +DEFINE_TRACE(irq_softirq_exit);
> 
> 
> Just one nit here. The "irq_" prefix seems to me too much.
> On the trace we have:
> 
> /* irq_softirq_entry: softirq=nb action=nb_to_logical_name */
> 
> It's even too much words that says the same things.
> Moreover, we have the logical name, the number seems not very useful
> because we have its logical translation just after.
> 
> I would suggest to have just:
> 
> /* softirq_entry: nb_to_logical_name */
> 
> ie:
> 
> /* softirq_entry: SCHED_SOFTIRQ */
> 
> Don't you think it's more clear and obvious?

yeah.

> Other than that, I think these tracepoints are a good idea.

agreed.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
