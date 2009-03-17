Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZCQV7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZCQV7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZCQV7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:59:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZCQV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:59:24 -0400
Date: Tue, 17 Mar 2009 17:59:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: stop {irqs,preempt}soff tracers when
 tracing is stopped
In-Reply-To: <20090317214926.GA5137@nowhere>
Message-ID: <alpine.DEB.2.00.0903171757320.9036@gandalf.stny.rr.com>
References: <1237325938-5240-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com> <20090317214926.GA5137@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Frederic Weisbecker wrote:
> > > +	/*
> > > +	 * Stop the tracer to avoid a warning subsequent
> > > +	 * to buffer flipping failure because tracing_stop()
> > > +	 * disables the tr and max buffers, making flipping impossible
> > > +	 * in case of parallels max preempt off latencies.
> > > +	 */
> > > +	trace->stop(tr);
> > >  	/* stop the tracing. */
> > >  	tracing_stop();
> > 
> > I'm actually thinking that tracing_stop() should call the current tracer
> > "stop" function.
> > 
> > -- Steve
> 
> 
> Indeed, it could be better.
> But I think of a combination of stop() callback call plus
> ring buffer disabled because I'm not sure all tracers implement
> the stop callback.

Yes, that's what I meant. The tracing_stop should do a few things, and one
of them is to call the stop function if it exists.

> 
> Should I send a v2 based on the above?

Sure.

-- Steve
