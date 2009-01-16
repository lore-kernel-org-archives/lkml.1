Return-Path: <linux-kernel-owner+w=401wt.eu-S932867AbZAPLNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbZAPLNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbZAPLNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:13:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbZAPLNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:13:00 -0500
Date: Fri, 16 Jan 2009 12:12:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/6] ftrace: move function tracer functions out of
	trace.c
Message-ID: <20090116111243.GA20082@elte.hu>
References: <20090116045342.748642160@goodmis.org> <20090116045417.632296101@goodmis.org> <20090115224925.6b0e6c24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115224925.6b0e6c24.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 Jan 2009 23:53:43 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  static void
> > +function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
> > +{
> > +	struct trace_array *tr = func_trace;
> > +	struct trace_array_cpu *data;
> > +	unsigned long flags;
> > +	long disabled;
> > +	int cpu, resched;
> > +	int pc;
> > +
> > +	if (unlikely(!ftrace_function_enabled))
> > +		return;
> 
> We're optimizing for the tracing-is-enabled case.  What's the thinking 
> here?

There's two levels here: first the patched in callsites. Those are NOPs in 
the usual case - there's no overhead for the default 'function tracing is 
built in but not enabled' case.

There's a second level: a /debug/tracing/tracing_enabled lightweight 
dynamic flag to flip tracing on/off while the tracer is enabled. _That_ 
one, if it ever matters to a codepath, is default-enabled.

I.e. the above code sequence is correct.

Thanks,

	Ingo
