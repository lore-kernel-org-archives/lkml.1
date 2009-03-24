Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZCXRh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZCXRh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZCXRhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:37:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55014 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455AbZCXRhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:37:09 -0400
Date: Tue, 24 Mar 2009 13:33:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
Message-ID: <20090324173354.GC3129@redhat.com>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.080628193@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:56:27AM -0400, Mathieu Desnoyers wrote:
> Instrumentation of IRQ related events : irq_entry, irq_exit and
> irq_next_handler.
> 
> It allows tracers to perform latency analysis on those various types of
> interrupts and to detect interrupts with max/min/avg duration. It helps
> detecting driver or hardware problems which cause an ISR to take ages to
> execute. It has been shown to be the case with bogus hardware causing an mmio
> read to take a few milliseconds.
> 
> Those tracepoints are used by LTTng.
> 
> About the performance impact of tracepoints (which is comparable to markers),
> even without immediate values optimizations, tests done by Hideo Aoki on ia64
> show no regression. His test case was using hackbench on a kernel where
> scheduler instrumentation (about 5 events in code scheduler code) was added.
> See the "Tracepoints" patch header for performance result detail.
> 
> irq_entry and irq_exit not declared static because they appear in x86 arch code.
> 
> The idea behind logging irq/softirq/tasklet/(and eventually syscall) entry and
> exit events is to be able to recreate the kernel execution state at a given
> point in time. Knowing which execution context is responsible for a given trace
> event is _very_ valuable in trace data analysis.
> 
> The IRQ instrumentation instruments the IRQ handler entry and exit. Jason
> instrumented the irq notifier chain calls (irq_handler_entry/exit). His approach
> provides information about which handler is being called, but does not map
> correctly to the fact that _multiple_ handlers are being called from within the
> same interrupt handler. From an interrupt latency analysis POV, this is
> incorrect.
> 

Since we are passing back the irq number, and we can not be interrupted
by the same irq, I think it should be pretty clear we are in the same
handler. That said, the extra entry/exit tracepoints could make the
sequence of events simpler to decipher, which is important. The code
looks good, and provides at least as much information as the patch that
I proposed. So i'll be happy either way :)

thanks,

-Jason

