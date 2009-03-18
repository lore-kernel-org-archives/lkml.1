Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZCRJA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZCRJA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZCRJAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:00:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZCRJAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:00:15 -0400
Date: Wed, 18 Mar 2009 09:59:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: stop {irqs,preempt}soff tracers when
	tracing is stopped
Message-ID: <20090318085957.GB15416@elte.hu>
References: <1237325938-5240-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com> <20090317214926.GA5137@nowhere> <alpine.DEB.2.00.0903171757320.9036@gandalf.stny.rr.com> <20090317225454.GA5143@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317225454.GA5143@nowhere>
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

> On Tue, Mar 17, 2009 at 05:59:22PM -0400, Steven Rostedt wrote:
> > 
> > On Tue, 17 Mar 2009, Frederic Weisbecker wrote:
> > > > > +	/*
> > > > > +	 * Stop the tracer to avoid a warning subsequent
> > > > > +	 * to buffer flipping failure because tracing_stop()
> > > > > +	 * disables the tr and max buffers, making flipping impossible
> > > > > +	 * in case of parallels max preempt off latencies.
> > > > > +	 */
> > > > > +	trace->stop(tr);
> > > > >  	/* stop the tracing. */
> > > > >  	tracing_stop();
> > > > 
> > > > I'm actually thinking that tracing_stop() should call the current tracer
> > > > "stop" function.
> > > > 
> > > > -- Steve
> > > 
> > > 
> > > Indeed, it could be better.
> > > But I think of a combination of stop() callback call plus
> > > ring buffer disabled because I'm not sure all tracers implement
> > > the stop callback.
> > 
> > Yes, that's what I meant. The tracing_stop should do a few things, and one
> > of them is to call the stop function if it exists.
> > 
> > > 
> > > Should I send a v2 based on the above?
> > 
> > Sure.
> > 
> > -- Steve
> 
> 
> Ingo,
> 
> I tested the call to the start/stop callbacks from tracing_start() 
> and tracing_stop() but it's not possible for now: the sched_switch 
> tracer register/unregister his tracepoints from these callbacks, 
> thus allocate some memory. But tracing_start/stop can be called 
> from atomic.
> 
> I discussed about that with Steven on irc, and for now the v1 
> should be applied as a temporary solution. We plan to simplify 
> later the start/stop callbacks from each tracers that need it.

ok. Steve, could you please pick v1 up?

	Ingo
