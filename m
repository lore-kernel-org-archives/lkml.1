Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZCJAwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZCJAwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 20:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZCJAwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 20:52:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZCJAwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 20:52:05 -0400
Date: Mon, 9 Mar 2009 20:52:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing
 infrastructure
In-Reply-To: <20090309204748.GD5010@nowhere>
Message-ID: <alpine.DEB.2.00.0903092050580.2203@gandalf.stny.rr.com>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <20090307074917.GA5749@nowhere> <alpine.DEB.2.00.0903090947450.2203@gandalf.stny.rr.com> <20090309204748.GD5010@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Mar 2009, Frederic Weisbecker wrote:

> On Mon, Mar 09, 2009 at 09:52:20AM -0400, Steven Rostedt wrote:
> > 
> > On Sat, 7 Mar 2009, Frederic Weisbecker wrote:
> > > +
> > > +
> > > +static atomic_t refcount;
> > > +
> > > +enum print_line_t
> > > +print_syscall_enter(struct trace_iterator *iter, int flags)
> > > +{
> > > +	struct trace_seq *s = &iter->seq;
> > > +	struct trace_entry *ent = iter->ent;
> > > +	struct syscall_trace_enter *trace;
> > > +	enum syscall_trace_nr syscall;
> > > +	const struct syscall_trace_entry *entry;
> > > +	char *str = NULL;
> > > +	int i, ret;
> > > +
> > > +	trace_assign_type(trace, ent);
> > > +
> > > +	syscall = trace->nr;
> > > +
> > > +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> > 
> > You still need to print a "\n" otherwise the output of the next line
> > will start on the current line.
> 
> Are you sure?
> This entry will be ignored. And the previous one did print a newline.
> So the next one should not have any problem.

Does this take over the printline? Otherwise we could be printing a 
header, (comm, timestamp, cpu, etc).

-- Steve
