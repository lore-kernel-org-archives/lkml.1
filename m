Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZCOFdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZCOFdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCOFdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 01:33:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCOFdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 01:33:35 -0400
Date: Sun, 15 Mar 2009 06:33:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090315053301.GC20949@elte.hu>
References: <20090312183603.GC3352@redhat.com> <20090314025701.GC22526@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314025701.GC22526@Krystal>
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


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> * Jason Baron (jbaron@redhat.com) wrote:
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
> 
> The softirq tracepoints are a good idea indeed (I have similar 
> ones in the LTTng tree). My main concern is about the fact 
> that you output the softirq name in plain text to the trace 
> buffers. I would rather prefer to save only the softirq 
> (h-vec) into the trace and dump the mapping (h-vec) to name 
> only once, so we can save precious trace bytes.

The right solution is to change this tracepoint to TRACE_EVENT() 
format. Jason, do you have time to do that?

	Ingo
