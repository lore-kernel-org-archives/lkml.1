Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZENX7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZENX7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZENX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:58:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:30929 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZENX6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kCvPF84hqMf2rfQAoB3oJII2ODMSdavljescHO73U1KdwEiSEh8VX2g/FLCttubgXr
         NTzHpZHYPESmBCFpBMDQal4esosUhIgUC5De/v4exfJVPrr0Kv16ULS2u3kL7JdjXrZ2
         tGFru0QWUszgNeJiFQPKX5a++Mk7wXlEdPP3A=
Date: Fri, 15 May 2009 01:58:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
Message-ID: <20090514235846.GA8051@nowhere>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com> <20090514203351.GA5969@nowhere> <alpine.DEB.2.00.0905141916000.30591@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905141916000.30591@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 07:18:23PM -0400, Steven Rostedt wrote:
> > > +
> > >  #undef TRACE_EVENT
> > >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> > >  enum print_line_t							\
> > > @@ -127,6 +132,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> > >  	struct trace_seq *s = &iter->seq;				\
> > >  	struct ftrace_raw_##call *field;				\
> > >  	struct trace_entry *entry;					\
> > > +	struct trace_seq *p;						\
> > >  	int ret;							\
> > >  									\
> > >  	entry = iter->ent;						\
> > > @@ -138,7 +144,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> > >  									\
> > >  	field = (typeof(field))entry;					\
> > >  									\
> > > +	p = &get_cpu_var(ftrace_event_seq);				\
> > >  	ret = trace_seq_printf(s, #call ": " print);			\
> > > +	put_cpu();							\
> > 
> > 
> > 
> > I don't understand the role of this per-cpu trace_seq variable.
> > It doesn't seem to be used.
> 
> See it now? ;-)


Still not :-)

I don't understand, it doesn't seem to be used. May be I'm too
much sleepy to understand...


> -- Steve

