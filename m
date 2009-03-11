Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZCKSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZCKSeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCKSeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:34:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36292 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZCKSeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:34:07 -0400
Date: Wed, 11 Mar 2009 19:32:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [RFC patch 00/41] LTTng 0.105 core for Linux 2.6.27-rc9
Message-ID: <20090311183231.GA24106@elte.hu>
References: <20090305224728.947235917@polymtl.ca> <20090306101142.GA26659@elte.hu> <20090306190224.GF14236@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306190224.GF14236@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > Let me give you a few examples of existing areas of overlap:
> > 
> > > The corresponding git tree contains also the trace clock 
> > > patches and the lttng instrumentation. The trace clock is 
> > > required to use the tracer, but it can be used without the 
> > > instrumentation : there is already a kprobes and userspace 
> > > event support included in this patchset.
> > 
> > The latest tracing tree includes 
> > kernel/tracing/trace_clock.c which offers three trace clock 
> > variants, with different performance/precision tradeoffs:
> > 
> >  trace_clock_local()   [ for pure CPU-local tracers with no idle 
> >                          events. This is the fastest but least 
> >                          coherent tracing clock. ]
> > 
> >  trace_clock()         [ intermediate, scalable clock with
> >                          usable but imprecise global coherency. ]
> > 
> >  trace_clock_global()  [ globally serialized, coherent clock. 
> >                          It is the slowest but most accurate variant. ]
> > 
> > Tracing plugins can pick their choice. (This is relatively new 
> > code but you get the idea.)
> > 
> 
> Hehe this reminds me of the trace clock thread I started a few 
> months ago on LKML. So you guys took over that work ? Nice :) 
> Is it based on the trace-clock patches I proposed back then ? 
> Ah, no. Well I guess we'll have to discuss this too. I agree 
> on the trace_clock_local/trace_clock/trace_clock_global 
> interface, it looks nice. The underlying implementation will 
> have to be discussed though.

Beware: i found the assembly trace_clock() stuff you did back 
then rather ugly ;-) I dont think there's any easy solutions 
here, so i went for this palette of clocks.

> > This approach works for all your other patches as well. A 
> > direct, constructive comparison and active work on unifying 
> > them is required.
> 
> Yes, let's try to do it. Maybe it's better to start a new 
> thread with less CCs for this type of work ?

Yeah. More finegrained steps are really needed.

The least controversial bits would be the many tracepoints you 
identified in LTTng as interesting. Mind sending them separately 
so that we can make some progress?

In the latest tracing code all tracepoints will show up 
automatically under /debug/tracing/events/ and can be used by 
user-space tools.

	Ingo
