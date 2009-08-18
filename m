Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbZHRQ2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbZHRQ2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbZHRQ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:28:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbZHRQ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:28:47 -0400
Date: Tue, 18 Aug 2009 12:28:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing, sched: mark preempt_schedule() notrace
In-Reply-To: <20090818103853.GB5231@nowhere>
Message-ID: <alpine.DEB.2.00.0908181220280.7852@gandalf.stny.rr.com>
References: <4A8A5FF5.8080609@cn.fujitsu.com> <20090818103853.GB5231@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Aug 2009, Frederic Weisbecker wrote:

> On Tue, Aug 18, 2009 at 04:01:57PM +0800, Lai Jiangshan wrote:
> > 
> > Current preempt_schedule() is not marked notrace. It may be
> > infinite recursion in __trace_graph_return().
> > 
> > preempt_schedule()
> >   __trace_graph_return()
> >     ftrace_preempt_disable() (!!return false!!)
> >     ftrace_preempt_enable()
> >       preempt_enable_notrace()
> >          preempt_schedule() (need_resched() may be true again)
> 
> 
> 
> It would happen in __trace_graph_return() , when preempt_schedule()
> has finished its job. It's very unlikely the TIF_NEED_RESCHED is
> set just after (because it has just been cleared).
> But why not. In that case, preempt_schedule() is called again but it's
> not a real tracing recursion.
> 
> That seems like a normal behaviour actually.

In fact, this is actually something to be traced. I would not add a 
notrace to it. This is not saving anything, the trace_graph_return does 
not need to worry about stack overflow, since the return code already 
freed the stack.

-- Steve
