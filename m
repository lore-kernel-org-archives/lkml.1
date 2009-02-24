Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbZBXTkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbZBXTkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbZBXTkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:40:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49589 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbZBXTkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:40:20 -0500
Date: Tue, 24 Feb 2009 20:39:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
Message-ID: <20090224193952.GB27491@elte.hu>
References: <20090224193344.638329210@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224193344.638329210@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This is still RFC, do not pull.
> 
> This patch set gives the ability to add a format string and 
> args to a trace point declaration. Then it gives a tracer an 
> opportunity to override the header macro and use the default 
> trace format to trace the object.
> 
> For example (and used in this patch series), the sched 
> tracepoint declarations are moved from include/trace/sched.h 
> to include/trace/sched_event_types.h, and instead of using the 
> macro DECLARE_TRACE we use DECLARE_TRACE_FMT. The first three 
> arguments are the same, but it adds 2 more arguments. A printf 
> format and arguments.
> 
> The new trace/sched.h file contains:
> 
>   #include <linux/sched.h>
>   #include <linux/tracepoint.h>
> 
>   #include <trace/sched_event_types.h>
> 
> The sched_event_types.h file has:
> 
>  DECLARE_TRACE_FMT(sched_kthread_stop,
>         TPPROTO(struct task_struct *t),
>                   TPARGS(t),
>                    "task %s:%d", TPARGS(t->comm, t->pid));
> 
> The tracepoint.h defines DECLARE_TRACE_FMT as:
> 
>  #define DECLARE_TRACE_FMT(name, proto, args, fmt, fmt_args) \
>         DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> 
> 
> But in kernel/trace/events.c we have:
> 
>  /* trace/<type>.h here */
>  #include <trace/sched.h>
> 
>  #include "trace_events.h"
> 
>  /* trace/<type>_event_types.h here */
>  #include <trace/sched_event_types.h>
> 
> The trace_events.h redefines the DECLARE_TRACE_FMT and makes a 
> hook for to automate adding event points.
> 
> To add event points, convert to the DECLARE_TRACE_FMT, add 
> your default printf format, and then add to events.c, the 
> <type>.h and <type>_event_types.h as described. Then your 
> trace points will appear in the event tracer.
> 
> Next I'll convert the rest of the tracepoints that are already 
> defined to this format.

Looks very good - especially the VFS enumeration of all present 
tracepoints. Let me know when it gets into pullable state.

	Ingo
