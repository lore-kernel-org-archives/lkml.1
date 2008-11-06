Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYKFWPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYKFWPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYKFWO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:14:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKFWO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:14:57 -0500
Date: Thu, 6 Nov 2008 17:14:27 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106221426.GD20928@redhat.com>
References: <20081106060624.58a0f967@infradead.org> <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins> <20081106070157.065b2dcc@infradead.org> <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com> <20081106094558.50d94bcc@infradead.org> <y0mej1ofvyz.fsf@ton.toronto.redhat.com> <1226003343.31966.43.camel@lappy.programming.kicks-ass.net> <20081106215310.GA15163@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106215310.GA15163@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Nov 06, 2008 at 04:53:11PM -0500, Mathieu Desnoyers wrote:
> [...]
> > Something like
> > 
> > DEFINE_TRACE_FMT(sched_switch,
> > 	TPPROTO(struct rq *rq, struct task_struct *prev,
> > 		 struct task_struct *next),
> > 	TPARGS(rq, prev, next),
> > 	TPFMT("%d to %d\n", prev->pid, next->pid));
> > 
> > Which would be similar to attaching a trace_mark() to the trace point
> > and can in these cases save a lot of lines of code.
> > 
> > Both lttng and the ftrace event tracer can use these default text
> > strings.
> 
> Argh. No, please. Doing this would end up exposing the inner kernel API
> (the tracepoints) directly to userspace. [...]


Arjan asked for something to send formatted strings to tracing buffers
that are consumed by user space.  Whether internally that is done by
markers, or by tracepoints converted to markers, or by tracepoints
with custom ftrace_printf-y code, is indistinguishable to the user.

Can you be specific in what way any of that is exposing an "API
directly to userspace"?

- FChE
