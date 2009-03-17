Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZCQWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZCQWzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZCQWzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:55:03 -0400
Received: from mail-ew0-f168.google.com ([209.85.219.168]:46528 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbZCQWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MwqJTtjk2zxFsLlayj1aS+YXznynrwm+MO+o2WWoXAdkSOdrJ1G9Fk0M64g/mxDqC4
         huOgCbwU1tuFu3ZEbx2NkzjpXAh7zMkW3g+m9UgANrBBGhba4O7caf31o8cDlVhjVKaj
         d4qqrib5wm/52Y8/IJTX4oERJaao4PfzinDAg=
Date: Tue, 17 Mar 2009 23:54:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: stop {irqs,preempt}soff tracers when
	tracing is stopped
Message-ID: <20090317225454.GA5143@nowhere>
References: <1237325938-5240-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com> <20090317214926.GA5137@nowhere> <alpine.DEB.2.00.0903171757320.9036@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903171757320.9036@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 05:59:22PM -0400, Steven Rostedt wrote:
> 
> On Tue, 17 Mar 2009, Frederic Weisbecker wrote:
> > > > +	/*
> > > > +	 * Stop the tracer to avoid a warning subsequent
> > > > +	 * to buffer flipping failure because tracing_stop()
> > > > +	 * disables the tr and max buffers, making flipping impossible
> > > > +	 * in case of parallels max preempt off latencies.
> > > > +	 */
> > > > +	trace->stop(tr);
> > > >  	/* stop the tracing. */
> > > >  	tracing_stop();
> > > 
> > > I'm actually thinking that tracing_stop() should call the current tracer
> > > "stop" function.
> > > 
> > > -- Steve
> > 
> > 
> > Indeed, it could be better.
> > But I think of a combination of stop() callback call plus
> > ring buffer disabled because I'm not sure all tracers implement
> > the stop callback.
> 
> Yes, that's what I meant. The tracing_stop should do a few things, and one
> of them is to call the stop function if it exists.
> 
> > 
> > Should I send a v2 based on the above?
> 
> Sure.
> 
> -- Steve


Ingo,

I tested the call to the start/stop callbacks from tracing_start() and tracing_stop()
but it's not possible for now: the sched_switch tracer register/unregister his
tracepoints from these callbacks, thus allocate some memory. But tracing_start/stop
can be called from atomic.

I discussed about that with Steven on irc, and for now the v1 should be applied
as a temporary solution. We plan to simplify later the start/stop callbacks from
each tracers that need it.

Thanks.

