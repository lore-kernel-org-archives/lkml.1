Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZCFTCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZCFTCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZCFTCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:02:31 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:60114 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbZCFTCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:02:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAKP7sElMQW1W/2dsb2JhbACBTtUWhAgG
Date: Fri, 6 Mar 2009 14:02:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20090306190224.GF14236@Krystal>
References: <20090305224728.947235917@polymtl.ca> <20090306101142.GA26659@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090306101142.GA26659@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:27:04 up 6 days, 14:53,  1 user,  load average: 0.87, 1.03,
	0.82
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > I spent the last 4-5 months working with the Fujitsu team at 
> > implementing the tracer elements identified as goals at Kernel 
> > Summit 2008 and at the following Plumber Conference. My idea 
> > was to incremententally adapt the LTTng tracer, currently used 
> > in the industry and well tested, to those requirements.
> > 
> > I spent the last days rearranging/folding/inspecting the LTTng 
> > patchset to prepare it for an LKML post. The version 0.105 in 
> > the LTTng git tree corresponds to the patchset I am posting 
> > here. The said patchset will only include the core features of 
> > LTTng, excluding the timestamping infrastructure (trace clock) 
> > and excluding the instrumentation.
> 
> I'd like to merge the good bits into the tracing tree. Looking 
> at the patches you submitted there's a lot of avoidable overlap 
> with existing tracing features either present upstream already 
> or queued up for v2.6.30 - and we need to work more on 
> eliminating that overlap.
> 
> I dont think there's much fundamental disagreement just 
> different implementations - so we should evaluate each of those 
> details one by one, iteratively.
> 
> The first step would be to split the patches up into three 
> logical buckets:
> 
>  - Unique features not present in the tracing infracture, in the 
>    event tracer or other tracing plugins - those should be 
>    structured as feature additions.
> 
>  - Features that you consider superior to existing tracing
>    features of the kernel. For those, please iterate the
>    existing code with your enhancements - instead of a parallel 
>    implementation.
> 
>  - Items which offer nothing new and are not superior to 
>    existing features, those should be dropped probably. This too 
>    is a case by case thing.
> 
> Would you be interested in working with us on that? I know that 
> both Steve and me would be very much interested in that. If you 
> have time/interest to work on that then we can go through each 
> patch one by one and categorize them and map out the way to go.
> 

Hi Ingo,

Yes, I think an incremental inclusion is the way to go in the current
context. If we do it correctly, the resulting discussion will end up
putting the best features of both tracers in the resulting one. The only
problem is that I have less time at the moment (I should be writing my
Ph.D. thesis full time), but I think it's very important at this stage
to interact with the kernel community so everyone can benefit of the
work done in the past years.

I guess that identifying the good parts in each tracer will be a first
step towards integration. If you want, I could start by replying to my
own patchset post and do a ftrace-lttng comparison on each important
item.

I don't know how much time I'll be able to put into refactoring all this
though : I just spent 4 years developing LTTng and making sure every
nuts and bolts fits together fine. Hopefully we'll be able to keep the
modifications as lightweight and as iterative as possible.

> Let me give you a few examples of existing areas of overlap:
> 
> > The corresponding git tree contains also the trace clock 
> > patches and the lttng instrumentation. The trace clock is 
> > required to use the tracer, but it can be used without the 
> > instrumentation : there is already a kprobes and userspace 
> > event support included in this patchset.
> 
> The latest tracing tree includes kernel/tracing/trace_clock.c 
> which offers three trace clock variants, with different 
> performance/precision tradeoffs:
> 
>  trace_clock_local()   [ for pure CPU-local tracers with no idle 
>                          events. This is the fastest but least 
>                          coherent tracing clock. ]
> 
>  trace_clock()         [ intermediate, scalable clock with
>                          usable but imprecise global coherency. ]
> 
>  trace_clock_global()  [ globally serialized, coherent clock. 
>                          It is the slowest but most accurate variant. ]
> 
> Tracing plugins can pick their choice. (This is relatively new 
> code but you get the idea.)
> 

Hehe this reminds me of the trace clock thread I started a few months
ago on LKML. So you guys took over that work ? Nice :) Is it based on
the trace-clock patches I proposed back then ? Ah, no. Well I guess
we'll have to discuss this too. I agree on the
trace_clock_local/trace_clock/trace_clock_global interface, it looks
nice. The underlying implementation will have to be discussed though.


> > This tracer exports binary data through buffers using 
> > splice(). The resulting binary files can be parsed from 
> > userspace because the format string metadata is exported in 
> > the files. The event set can be enhanced by adding tracepoints 
> > to the kernel code and by creating probe modules, which 
> > connects callbacks to the tracepoints and contain the format 
> > string metainformation. Those callbacks are responsible for 
> > writing the data in the trace buffers. This separation between 
> > the trace buffer format string and the tracepoints is done on 
> > purpose so the core kernel instrumentation (tracepoints) is 
> > not exported to userspace, which will make maintainance much 
> > easier.
> 
> A tracepoint format specification mechanism plus working (and 
> fast!) zero-copy splice() support of the ring-buffer exists in 
> the latest tracing tree already - as you are probably aware of 
> because you commented on those patches a few days ago.

Yep, I know. :)

> 
> There are 3 good ways to go from here regarding the trace 
> buffering and splice code:
> 
>   1- we end up switching to the lttng version in essence
>   2- we end up keeping the tracing tree version
>   3- we end up somewhere inbetween
> 
> Which point in the above spectrum we will settle down on depends 
> on the technical details.
> 
> Note, whichever path we choose a gradual, iterative workflow is 
> still needed, so that we improve the existing upstream code with
> lttng enhancements gradually.
> 
> This approach works for all your other patches as well. A 
> direct, constructive comparison and active work on unifying them 
> is required.
> 

Yes, let's try to do it. Maybe it's better to start a new thread with
less CCs for this type of work ?

Mathieu

> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
