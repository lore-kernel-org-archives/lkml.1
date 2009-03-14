Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZCNQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZCNQpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZCNQp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:45:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZCNQp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:45:26 -0400
Date: Sat, 14 Mar 2009 17:43:58 +0100
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
Message-ID: <20090314164358.GB31930@elte.hu>
References: <20090305224728.947235917@polymtl.ca> <20090306101142.GA26659@elte.hu> <20090306190224.GF14236@Krystal> <20090311183231.GA24106@elte.hu> <20090313161838.GA2925@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313161838.GA2925@Krystal>
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

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > > Let me give you a few examples of existing areas of overlap:
> > > > 
> > > > > The corresponding git tree contains also the trace clock 
> > > > > patches and the lttng instrumentation. The trace clock is 
> > > > > required to use the tracer, but it can be used without the 
> > > > > instrumentation : there is already a kprobes and userspace 
> > > > > event support included in this patchset.
> > > > 
> > > > The latest tracing tree includes 
> > > > kernel/tracing/trace_clock.c which offers three trace clock 
> > > > variants, with different performance/precision tradeoffs:
> > > > 
> > > >  trace_clock_local()   [ for pure CPU-local tracers with no idle 
> > > >                          events. This is the fastest but least 
> > > >                          coherent tracing clock. ]
> > > > 
> > > >  trace_clock()         [ intermediate, scalable clock with
> > > >                          usable but imprecise global coherency. ]
> > > > 
> > > >  trace_clock_global()  [ globally serialized, coherent clock. 
> > > >                          It is the slowest but most accurate variant. ]
> > > > 
> > > > Tracing plugins can pick their choice. (This is relatively new 
> > > > code but you get the idea.)
> > > > 
> > > 
> > > Hehe this reminds me of the trace clock thread I started a few 
> > > months ago on LKML. So you guys took over that work ? Nice :) 
> > > Is it based on the trace-clock patches I proposed back then ? 
> > > Ah, no. Well I guess we'll have to discuss this too. I agree 
> > > on the trace_clock_local/trace_clock/trace_clock_global 
> > > interface, it looks nice. The underlying implementation will 
> > > have to be discussed though.
> > 
> > Beware: i found the assembly trace_clock() stuff you did back 
> > then rather ugly ;-) I dont think there's any easy solutions 
> > here, so i went for this palette of clocks.
> > 
> 
> Hi Ingo,
> 
> I agree for the palette of clocks to fit all needs. I wonder 
> what exactly you found ugly in the approach I took with my 
> trace_clock() implementation ? Maybe you could refresh my 
> memory, I do not recall writing any part of it in assembly.. ? 
> But this is a whole different topic. We can discuss this 
> later.

hm, it was months ago. Ok, it must have been this one:

 http://lkml.org/lkml/2008/11/7/21
 http://lkml.org/lkml/2008/11/7/23

indeed no assembly but almost ;-) What i found rather ugly were 
the cnt32_to_63() complications.

	Ingo
