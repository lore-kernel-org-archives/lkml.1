Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZEOABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZEOABa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZEOABV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:01:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZEOABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:01:21 -0400
Date: Thu, 14 May 2009 20:01:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
In-Reply-To: <20090514235846.GA8051@nowhere>
Message-ID: <alpine.DEB.2.00.0905142000540.30591@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com> <20090514203351.GA5969@nowhere> <alpine.DEB.2.00.0905141916000.30591@gandalf.stny.rr.com> <20090514235846.GA8051@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 15 May 2009, Frederic Weisbecker wrote:

> On Thu, May 14, 2009 at 07:18:23PM -0400, Steven Rostedt wrote:
> > > > +
> > > >  #undef TRACE_EVENT
> > > >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> > > >  enum print_line_t							\
> > > > @@ -127,6 +132,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> > > >  	struct trace_seq *s = &iter->seq;				\
> > > >  	struct ftrace_raw_##call *field;				\
> > > >  	struct trace_entry *entry;					\
> > > > +	struct trace_seq *p;						\
> > > >  	int ret;							\
> > > >  									\
> > > >  	entry = iter->ent;						\
> > > > @@ -138,7 +144,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> > > >  									\
> > > >  	field = (typeof(field))entry;					\
> > > >  									\
> > > > +	p = &get_cpu_var(ftrace_event_seq);				\
> > > >  	ret = trace_seq_printf(s, #call ": " print);			\
> > > > +	put_cpu();							\
> > > 
> > > 
> > > 
> > > I don't understand the role of this per-cpu trace_seq variable.
> > > It doesn't seem to be used.
> > 
> > See it now? ;-)
> 
> 
> Still not :-)
> 
> I don't understand, it doesn't seem to be used. May be I'm too
> much sleepy to understand...

That's because you cut out an important detail ;-)

> > +#define __print_flags(flag, x...) ftrace_print_flags_seq(p, flag, x)


-- Steve

