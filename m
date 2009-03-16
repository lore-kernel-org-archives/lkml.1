Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbZCPShy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbZCPShy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZCPShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:37:45 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:57010 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbZCPSho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:37:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsEAO84vklMQW1W/2dsb2JhbACBTtREg38G
Date: Mon, 16 Mar 2009 14:37:39 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090316183739.GA10292@Krystal>
References: <20090312183603.GC3352@redhat.com> <20090314025701.GC22526@Krystal> <alpine.DEB.2.00.0903160934010.26431@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903160934010.26431@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:34:37 up 16 days, 15:00,  2 users,  load average: 0.41, 0.70,
	0.75
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 13 Mar 2009, Mathieu Desnoyers wrote:
> 
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > 
> > > introduce softirq entry/exit tracepoints. These are useful for
> > > augmenting existing tracers, and to figure out softirq frequencies and
> > > timings.
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > > 
> > >  include/trace/irq_event_types.h |   12 ++++++++++++
> > >  kernel/softirq.c                |    7 ++++++-
> > >  2 files changed, 18 insertions(+), 1 deletions(-)
> > > 
> > > 
> > > diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
> > > index 214bb92..38b4bdd 100644
> > > --- a/include/trace/irq_event_types.h
> > > +++ b/include/trace/irq_event_types.h
> > > @@ -40,4 +40,16 @@ TRACE_EVENT(irq_handler_exit,
> > >  		  __entry->irq, __entry->ret ? "handled" : "unhandled")
> > >  );
> > >  
> > > +TRACE_FORMAT(irq_softirq_entry,
> > > +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> > > +	TP_ARGS(h, vec),
> > > +	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
> > > +	);
> > > +
> > > +TRACE_FORMAT(irq_softirq_exit,
> > > +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> > > +	TP_ARGS(h, vec),
> > > +	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
> > 
> > The softirq tracepoints are a good idea indeed (I have similar ones in
> > the LTTng tree). My main concern is about the fact that you output the
> > softirq name in plain text to the trace buffers. I would rather prefer
> > to save only the softirq (h-vec) into the trace and dump the mapping
> > (h-vec) to name only once, so we can save precious trace bytes.
> 
> The TP_FMT is only used by those tracers that want to use it. Any tracer 
> can still hook directly to the trace point and do what every they want.
> 
> -- Steve
> 

By doing so, you are removing the ability to use the TP_FMT information
to perform high-speed system-wide tracing. I thought the goal was to
create a unified buffering, but sadly I don't see the high-speed
requirements being part of that plan.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
