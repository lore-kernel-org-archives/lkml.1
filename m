Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808Ab0AEPO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0AEPO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730Ab0AEPOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:14:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab0AEPOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:14:53 -0500
Date: Tue, 5 Jan 2010 10:14:13 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
Message-ID: <20100105151413.GA2662@redhat.com>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com> <20091222153955.GD3308@redhat.com> <20091222161353.GB20225@jolsa.lab.eng.brq.redhat.com> <20091228092402.GD24690@elte.hu> <20091230225011.GJ6322@nowhere> <1262223857.28171.9.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262223857.28171.9.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 08:44:17PM -0500, Steven Rostedt wrote:
> 
> > That said, I sometimes dream about one event per printk.
> > 
> > Having, say:
> > 
> > /debug/tracing/events/printk/
> >          |
> >          ---- kernel/
> >          |      |
> >          |      ------- time/
> >          |      |        |
> >          |      |        ---- clocksource.c
> >          |      |                 |
> >          |      |                 --- clocksource_unstable:218/
> >          |      |                 |            |
> >          |      |                 |            ---- format
> >          |      |                 |            |
> >          |      |                 |            ---- filter
> >          |      |                 |            |
> >          |      |                 |            ---- enable
> >          |      |                 --- [...]
> >          |      ------- [...]
> >          |
> >          ---- drivers/
> >          |       |
> >          |       ---- [...]
> >          |
> >          ---- [...]
> > 
> > 
> > That would give a total control over every printk, trace_printk, etc...
> > 
> > Too bad that would bloat the memory.
> > Well, that could be wrapped in a single, wildly implemented (understand:
> > not using TRACE_EVENT macro) trace event, something able to walk through
> > every calls of printk, trace_printk, early_printk, etc... and imitate
> > a per printk event granularity.
> > 
> > But still it needs to be useful...
> 
> 
> I think we can do the above without bloating memory. Yes we would not
> need the TRACE_EVENT macro for this. The TRACE_EVENT macro is just for
> generic tracing, but we could easily come up with something specific for
> the printk's that will not bloat the kernel as much.
> 
> When I get some time, I may try to play with this idea.
> 
> -- Steve
> 

I agree with this direction...in terms of the implementation I was
thinking it could be very similar to the tracepoint optimization i've
been working on. Where we basically end up with just a 'nop' in place of
the printk and then when we enable it we patch the 'nop' with a jump to
the proper printk location...

-Jason
