Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbZBXWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbZBXWKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759163AbZBXWKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:10:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139AbZBXWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:10:15 -0500
Date: Tue, 24 Feb 2009 17:10:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1235504556.4645.2252.camel@laptop>
Message-ID: <alpine.DEB.2.00.0902241706260.12697@gandalf.stny.rr.com>
References: <20090224193344.638329210@goodmis.org> <1235504556.4645.2252.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Feb 2009, Peter Zijlstra wrote:

> On Tue, 2009-02-24 at 14:33 -0500, Steven Rostedt wrote:
> 
> >  DECLARE_TRACE_FMT(sched_kthread_stop,
> >         TPPROTO(struct task_struct *t),
> >                   TPARGS(t),
> >                    "task %s:%d", TPARGS(t->comm, t->pid));
> 
> Consistency would require something like:
> 
> DECLARE_TRACE_FMT(sched_kthread_stop,
> 		  TPPROTO(struct task_struct *t),
> 		  TPARGS(t),
> 		  TPFMT("task %s:%d", t->comm, t->pid));
> 
> I seem to remember Jason proposing something like this in the past.

Hmm, I'll have to look at that. (althought I was going to use a different 
TPARGS for the format args.)

I have, for now:

	event_printk("(%s)" fmt "\n", #call, fmtargs);

I guess I can redefine the TPFMT too.

#undef TPFMT
#define TPFMT(fmt, args...) \
	"(%s)" fmt "\n", #call, ##args

and then I could do

	event_printk(fmt);

-- Steve

