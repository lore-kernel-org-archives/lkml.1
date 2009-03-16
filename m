Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbZCPNfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbZCPNfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbZCPNfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:35:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZCPNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:35:01 -0400
Date: Mon, 16 Mar 2009 09:34:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
In-Reply-To: <20090314025701.GC22526@Krystal>
Message-ID: <alpine.DEB.2.00.0903160934010.26431@gandalf.stny.rr.com>
References: <20090312183603.GC3352@redhat.com> <20090314025701.GC22526@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Mar 2009, Mathieu Desnoyers wrote:

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
> The softirq tracepoints are a good idea indeed (I have similar ones in
> the LTTng tree). My main concern is about the fact that you output the
> softirq name in plain text to the trace buffers. I would rather prefer
> to save only the softirq (h-vec) into the trace and dump the mapping
> (h-vec) to name only once, so we can save precious trace bytes.

The TP_FMT is only used by those tracers that want to use it. Any tracer 
can still hook directly to the trace point and do what every they want.

-- Steve
