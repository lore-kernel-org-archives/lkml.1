Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbZAPNNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbZAPNNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760743AbZAPNNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:13:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbZAPNNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:13:41 -0500
Date: Fri, 16 Jan 2009 08:13:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/6] ftrace: move function tracer functions out of
 trace.c
In-Reply-To: <20090115224925.6b0e6c24.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901160811180.22303@gandalf.stny.rr.com>
References: <20090116045342.748642160@goodmis.org> <20090116045417.632296101@goodmis.org> <20090115224925.6b0e6c24.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Jan 2009, Andrew Morton wrote:

> On Thu, 15 Jan 2009 23:53:43 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  static void
> > +function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
> > +{
> > +	struct trace_array *tr = func_trace;
> > +	struct trace_array_cpu *data;
> > +	unsigned long flags;
> > +	long disabled;
> > +	int cpu, resched;
> > +	int pc;
> > +
> > +	if (unlikely(!ftrace_function_enabled))
> > +		return;
> 
> We're optimizing for the tracing-is-enabled case.  What's the thinking
> here?

This is called only when tracing _is_ enabled :-) Either it was enabled by 
the dynamic ftrace system, or there's another variable tested before 
jumping to the functions. This function must be register, and when it is, 
tracing is expected to run.

The reason for the "ftrace_function_enabled" variable is to prevent 
tracing to start before the stop_machine finishes. It is local to this one 
tracer. Without it, you get a lot of garbage on the start up of the 
tracer.

-- Steve

