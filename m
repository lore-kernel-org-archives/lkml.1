Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZCDRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZCDRUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZCDRUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:20:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:42431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZCDRUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:20:04 -0500
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
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
In-Reply-To: <20090304170015.GB1150@Krystal>
References: <20090304024921.153061228@goodmis.org>
	 <20090304170015.GB1150@Krystal>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 18:19:15 +0100
Message-Id: <1236187155.5330.8229.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 12:00 -0500, Mathieu Desnoyers wrote:

> > TRACE_EVENT_FORMAT(sched_switch,
> > 	TPPROTO(struct rq *rq, struct task_struct *prev,
> > 		struct task_struct *next),
> > 	TPARGS(rq, prev, next),
> > 	TPFMT("task %s:%d ==> %s:%d",
> > 	      prev->comm, prev->pid, next->comm, next->pid),
> > 	TRACE_STRUCT(
> > 		TRACE_FIELD(pid_t, prev_pid, prev->pid)
> > 		TRACE_FIELD(int, prev_prio, prev->prio)
> > 		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
> > 				    next_comm,
> > 				    TPCMD(memcpy(TRACE_ENTRY->next_comm,
> > 						 next->comm,
> > 						 TASK_COMM_LEN)))
> > 		TRACE_FIELD(pid_t, next_pid, next->pid)
> > 		TRACE_FIELD(int, next_prio, next->prio)
> > 	),
> > 	TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
> > 	);
> > 
> 
> I fear that putting these user-visible format strings in tracepoint
> header files will create a big maintainability issue.
> 
> I'll post the LTTng patchset in a jiffy, where the format string
> awareness is done in a tracer-specific module. I don't understand why
> Peter Z. is not yelling against your tracepoints modifications : they
> are actually presenting to userspace an interface that is meant to
> eventually change.
> 
> I used a separate layer for format string presentation for this very
> purpose : I don't want to tie the kernel code instrumentation
> (tracepoints) to any kind of user-visible API.

Not only that, its butt-ugly to boot.

I'm just not sure what to say anymore.. people seem insistent on doing
this, look at the recent google trace and this zedtrace thing.

What I can live with is if we tie it 1:1 to our code structure by means
of code generation, in that case we can simply argue its a direct
representation of our code, and we don't have any API rules on that.

Arnaldo proposed using sparse and tree rewriting to accomplish this.

The above however creates these artificial things that can arguably be
kept static, therefore one could defend that expectation.

What's worse, it doesn't even come with version information :-)

