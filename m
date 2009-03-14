Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZCNQ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZCNQ7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZCNQ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:59:41 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:39459 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbZCNQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:59:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoEAM95u0lMQW1W/2dsb2JhbACBTs4Ng38G
Date: Sat, 14 Mar 2009 12:59:36 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mrubin@google.com, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       "H. Peter Anvin" <hpa@zytor.com>, md@google.com,
       Tom Zanussi <tzanussi@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, ltt-dev@lists.casi.polymtl.ca,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [RFC patch 00/41] LTTng 0.105 core for Linux
	2.6.27-rc9
Message-ID: <20090314165936.GA11928@Krystal>
References: <20090305224728.947235917@polymtl.ca> <20090306101142.GA26659@elte.hu> <20090306190224.GF14236@Krystal> <20090311183231.GA24106@elte.hu> <20090313161838.GA2925@Krystal> <20090314164358.GB31930@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090314164358.GB31930@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:54:28 up 14 days, 13:20,  1 user,  load average: 0.23, 0.31,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > > Let me give you a few examples of existing areas of overlap:
> > > > > 
> > > > > > The corresponding git tree contains also the trace clock 
> > > > > > patches and the lttng instrumentation. The trace clock is 
> > > > > > required to use the tracer, but it can be used without the 
> > > > > > instrumentation : there is already a kprobes and userspace 
> > > > > > event support included in this patchset.
> > > > > 
> > > > > The latest tracing tree includes 
> > > > > kernel/tracing/trace_clock.c which offers three trace clock 
> > > > > variants, with different performance/precision tradeoffs:
> > > > > 
> > > > >  trace_clock_local()   [ for pure CPU-local tracers with no idle 
> > > > >                          events. This is the fastest but least 
> > > > >                          coherent tracing clock. ]
> > > > > 
> > > > >  trace_clock()         [ intermediate, scalable clock with
> > > > >                          usable but imprecise global coherency. ]
> > > > > 
> > > > >  trace_clock_global()  [ globally serialized, coherent clock. 
> > > > >                          It is the slowest but most accurate variant. ]
> > > > > 
> > > > > Tracing plugins can pick their choice. (This is relatively new 
> > > > > code but you get the idea.)
> > > > > 
> > > > 
> > > > Hehe this reminds me of the trace clock thread I started a few 
> > > > months ago on LKML. So you guys took over that work ? Nice :) 
> > > > Is it based on the trace-clock patches I proposed back then ? 
> > > > Ah, no. Well I guess we'll have to discuss this too. I agree 
> > > > on the trace_clock_local/trace_clock/trace_clock_global 
> > > > interface, it looks nice. The underlying implementation will 
> > > > have to be discussed though.
> > > 
> > > Beware: i found the assembly trace_clock() stuff you did back 
> > > then rather ugly ;-) I dont think there's any easy solutions 
> > > here, so i went for this palette of clocks.
> > > 
> > 
> > Hi Ingo,
> > 
> > I agree for the palette of clocks to fit all needs. I wonder 
> > what exactly you found ugly in the approach I took with my 
> > trace_clock() implementation ? Maybe you could refresh my 
> > memory, I do not recall writing any part of it in assembly.. ? 
> > But this is a whole different topic. We can discuss this 
> > later.
> 
> hm, it was months ago. Ok, it must have been this one:
> 
>  http://lkml.org/lkml/2008/11/7/21
>  http://lkml.org/lkml/2008/11/7/23
> 
> indeed no assembly but almost ;-) What i found rather ugly were 
> the cnt32_to_63() complications.
> 

The fact that I put a patch touching cnt32_to_63 back then was just a
way to point out how the current cnt32_to_63 implementation is broken
for SMP and should stay in UP-only architecture-specific code (that was
an answer to Peter Zijlstra's reuse concerns). Once I got agreement that
tracers should not be expected to use cnt32_to_63, I dropped any patch
touching this piece of infrastructure and stayed with my
trace-clock-32-to-64.c implementation, which is SMP-safe, scalable and
basically extends atomically (through a rcu-like algorithm) a N bit
clock to a full 64-bits clock. This is very, very useful for lots of
architectures. Is it that code you find ugly ?

Mathieu

> 	Ingo
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
