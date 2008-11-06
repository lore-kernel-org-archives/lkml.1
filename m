Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYKFU7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYKFU7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYKFU6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:58:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbYKFU6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:58:12 -0500
Date: Thu, 6 Nov 2008 15:57:49 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106205749.GA20928@redhat.com>
References: <1225976138.7803.4485.camel@twins> <20081106060624.58a0f967@infradead.org> <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins> <20081106070157.065b2dcc@infradead.org> <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com> <20081106094558.50d94bcc@infradead.org> <y0mej1ofvyz.fsf@ton.toronto.redhat.com> <1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Nov 06, 2008 at 09:29:03PM +0100, Peter Zijlstra wrote:
> [...]
> I prefer we keep using trace points but do what jason has been proposing
> for a while, which is add a format and arg list to the trace point
> definition.
> 
> Something like
> 
> DEFINE_TRACE_FMT(sched_switch,
> 	TPPROTO(struct rq *rq, struct task_struct *prev,
> 		 struct task_struct *next),
> 	TPARGS(rq, prev, next),
> 	TPFMT("%d to %d\n", prev->pid, next->pid));
> 
> Which would be similar to attaching a trace_mark() to the trace point
> and can in these cases save a lot of lines of code.

Can you explain how this would save any lines of code at all compared
to the trace_mark() example?  Both cases still need a bit of
~identical additional code to couple the markers (specified whichever
way) to a trace buffer.  Your version has the tracepoint machinery
too, which is strictly additional.  Where's the savings?


- FChE
