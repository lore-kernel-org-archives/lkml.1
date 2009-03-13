Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZCMQTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZCMQTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZCMQS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:18:57 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:63964 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZCMQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:18:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugFAPAiuklMQW1W/2dsb2JhbACBTs83g34G
Date: Fri, 13 Mar 2009 12:18:38 -0400
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
Message-ID: <20090313161838.GA2925@Krystal>
References: <20090305224728.947235917@polymtl.ca> <20090306101142.GA26659@elte.hu> <20090306190224.GF14236@Krystal> <20090311183231.GA24106@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090311183231.GA24106@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:59:28 up 13 days, 12:25,  2 users,  load average: 0.25, 0.32,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > Let me give you a few examples of existing areas of overlap:
> > > 
> > > > The corresponding git tree contains also the trace clock 
> > > > patches and the lttng instrumentation. The trace clock is 
> > > > required to use the tracer, but it can be used without the 
> > > > instrumentation : there is already a kprobes and userspace 
> > > > event support included in this patchset.
> > > 
> > > The latest tracing tree includes 
> > > kernel/tracing/trace_clock.c which offers three trace clock 
> > > variants, with different performance/precision tradeoffs:
> > > 
> > >  trace_clock_local()   [ for pure CPU-local tracers with no idle 
> > >                          events. This is the fastest but least 
> > >                          coherent tracing clock. ]
> > > 
> > >  trace_clock()         [ intermediate, scalable clock with
> > >                          usable but imprecise global coherency. ]
> > > 
> > >  trace_clock_global()  [ globally serialized, coherent clock. 
> > >                          It is the slowest but most accurate variant. ]
> > > 
> > > Tracing plugins can pick their choice. (This is relatively new 
> > > code but you get the idea.)
> > > 
> > 
> > Hehe this reminds me of the trace clock thread I started a few 
> > months ago on LKML. So you guys took over that work ? Nice :) 
> > Is it based on the trace-clock patches I proposed back then ? 
> > Ah, no. Well I guess we'll have to discuss this too. I agree 
> > on the trace_clock_local/trace_clock/trace_clock_global 
> > interface, it looks nice. The underlying implementation will 
> > have to be discussed though.
> 
> Beware: i found the assembly trace_clock() stuff you did back 
> then rather ugly ;-) I dont think there's any easy solutions 
> here, so i went for this palette of clocks.
> 

Hi Ingo,

I agree for the palette of clocks to fit all needs. I wonder what
exactly you found ugly in the approach I took with my trace_clock()
implementation ? Maybe you could refresh my memory, I do not recall
writing any part of it in assembly.. ? But this is a whole different
topic. We can discuss this later.


> > > This approach works for all your other patches as well. A 
> > > direct, constructive comparison and active work on unifying 
> > > them is required.
> > 
> > Yes, let's try to do it. Maybe it's better to start a new 
> > thread with less CCs for this type of work ?
> 
> Yeah. More finegrained steps are really needed.
> 
> The least controversial bits would be the many tracepoints you 
> identified in LTTng as interesting. Mind sending them separately 
> so that we can make some progress?
> 

OK, I'll work on it. Note however that I flipped my patchset around in
the past months : thinking that the tracer acceptance would be easier
than tracepoints. And now we are back at square one. Is it just me or I
have the funny feeling of acting like a dog running in circles after his
tail ? :)


> In the latest tracing code all tracepoints will show up 
> automatically under /debug/tracing/events/ and can be used by 
> user-space tools.
> 

Hrm, the thing is : I strongly disagree with showing tracepoints to
userspace and with the fact that you embed the data serialization
"pseudo-callbacks" into the tracepoint headers. Here is why. Peter
Zijlstra convinced me that putting format strings directly in tracepoint
headers was a bad idea. First off, you end up requiring all tracers
which connect on the tracepoints to choose your event format description
if they ever want to benefit from it. It's a "all included" formula :
either the tracers use them or they cannot output "standard" trace
information.

Second point : the tracepoints are meant to be tied to the kernel
source. Putting those event descriptions in global headers seems like
the people responsible for writing the kernel code surrounding the
tracepoints will end up being responsible for updating those tracepoint
event format descriptions. I think this is an unacceptable maintainance
burden for the whole community. Only tracer-specific modules should
refuse to build whenever it does not match the inner kernel structures
anymore.

Third point : it's plainly ugly. If we look at your tracepoint example :


/*
 * Tracepoint for task switches, performed by the scheduler:
 *
 * (NOTE: the 'rq' argument is not used by generic trace events,
 *        but used by the latency tracer plugin. )
 */
TRACE_EVENT(sched_switch,

        TP_PROTO(struct rq *rq, struct task_struct *prev,
                 struct task_struct *next),

        TP_ARGS(rq, prev, next),

        TP_STRUCT__entry(
                __array(        char,   prev_comm,      TASK_COMM_LEN   )
                __field(        pid_t,  prev_pid                        )
                __field(        int,    prev_prio                       )
                __array(        char,   next_comm,      TASK_COMM_LEN   )
                __field(        pid_t,  next_pid                        )
                __field(        int,    next_prio                       )
        ),

        TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
                __entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
                __entry->next_comm, __entry->next_pid, __entry->next_prio),

        TP_fast_assign(
                memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
                __entry->prev_pid       = prev->pid;
                __entry->prev_prio      = prev->prio;
                memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
                __entry->next_pid       = next->pid;
                __entry->next_prio      = next->prio;
        )
);


I notice that you actually embed the "function" that converts between
the format string into a header macro declaration. Why don't we write
this in plain C ?

in include/trace/sched.h :

DECLARE_TRACE(sched_switch,
        TPPROTO(struct rq *rq, struct task_struct *prev,
                struct task_struct *next),
                TPARGS(rq, prev, next));

in ltt/probes/kernel-trace.c :


void probe_sched_switch(struct rq *rq, struct task_struct *prev,
                struct task_struct *next);

DEFINE_MARKER_TP(kernel, sched_schedule, sched_switch, probe_sched_switch,
        "prev_pid %d next_pid %d prev_state #2d%ld");

notrace void probe_sched_switch(struct rq *rq, struct task_struct *prev,
                struct task_struct *next)
{
        struct marker *marker;
        struct serialize_int_int_short data;

        data.f1 = prev->pid;
        data.f2 = next->pid;
        data.f3 = prev->state;

        marker = &GET_MARKER(kernel, sched_schedule);
        ltt_specialized_trace(marker, marker->single.probe_private,
                &data, serialize_sizeof(data), sizeof(int));
}

This way, if the content of task_struct ever changes, only the tracer
module will break, not code touching a global header.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
