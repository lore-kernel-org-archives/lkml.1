Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYFLRuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYFLRuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYFLRuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:50:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYFLRub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:50:31 -0400
Date: Thu, 12 Jun 2008 13:48:34 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080612174834.GB22454@redhat.com>
References: <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com> <20080612164318.GB17814@redhat.com> <48515770.4020002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48515770.4020002@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jun 12, 2008 at 01:05:52PM -0400, Masami Hiramatsu wrote:
> [...]
> >> "sched_switch(struct task_struct * next, struct task_struct * prev)":"next %p prev %p"
> >> out of tree. Thus, you can use the printf-style format parser.
> > 
> > That's an interesting idea, but errors in this table would themselves
> > only be caught at C compilation time.

> Hmm, why would you think so?  I think if we can't find corresponding
> entry from the lookup table, it becomes an error.

Sure, but if the entry exists but is wrong, we'd emit C code that
won't compile.


> [...] Even if you use trace_mark() markers, you have to post a
> kernel patch which passes the prev->pid to the marking point and to
> discuss it.  for example,
> DEFINE_TRACE(sched_switch, (int prev_pid, int next_pid), prev_pid, next_pid)

(If it were up to me, I would add the task pointers too, which
debuginfo-less systemtap could ignore but other tracers may use.)


> But it might not so general, we have to discuss what parameters are
> enough good for each marking point.

That's exactly what the "lttng instrumentation markers" threads from
the recent past had started.


- FChE
