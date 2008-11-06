Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYKFWam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYKFWam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYKFWad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:30:33 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:57375 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYKFWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:30:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEACf4EklMQWxa/2dsb2JhbACBdspqg1Y
Date: Thu, 6 Nov 2008 17:25:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106222529.GA17528@Krystal>
References: <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins> <20081106070157.065b2dcc@infradead.org> <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com> <20081106094558.50d94bcc@infradead.org> <y0mej1ofvyz.fsf@ton.toronto.redhat.com> <1226003343.31966.43.camel@lappy.programming.kicks-ass.net> <20081106215310.GA15163@Krystal> <20081106221426.GD20928@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081106221426.GD20928@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:22:35 up 155 days,  3:03,  6 users,  load average: 0.47, 1.16,
	1.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Thu, Nov 06, 2008 at 04:53:11PM -0500, Mathieu Desnoyers wrote:
> > [...]
> > > Something like
> > > 
> > > DEFINE_TRACE_FMT(sched_switch,
> > > 	TPPROTO(struct rq *rq, struct task_struct *prev,
> > > 		 struct task_struct *next),
> > > 	TPARGS(rq, prev, next),
> > > 	TPFMT("%d to %d\n", prev->pid, next->pid));
> > > 
> > > Which would be similar to attaching a trace_mark() to the trace point
> > > and can in these cases save a lot of lines of code.
> > > 
> > > Both lttng and the ftrace event tracer can use these default text
> > > strings.
> > 
> > Argh. No, please. Doing this would end up exposing the inner kernel API
> > (the tracepoints) directly to userspace. [...]
> 
> 
> Arjan asked for something to send formatted strings to tracing buffers
> that are consumed by user space.  Whether internally that is done by
> markers, or by tracepoints converted to markers, or by tracepoints
> with custom ftrace_printf-y code, is indistinguishable to the user.
> 
> Can you be specific in what way any of that is exposing an "API
> directly to userspace"?
> 
> - FChE

The tracepoint declaration is linked to the kernel code that is meant to
be traced. Given this code will change over time, it will be more
difficult to perform those changes if it is in any way coupled with
format strings exported to userspace via traced.

This is where using the markers as an indirection layer plays its role.

I also have a patch with "redux" markers, where I separate the marker
"declaration" from the marker "call". By doing this, I remove the need
for cascading function calls, which is more efficient.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
