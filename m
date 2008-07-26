Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYGZMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYGZMlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYGZMla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:41:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56042 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYGZMl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:41:29 -0400
Date: Sat, 26 Jul 2008 14:40:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
Message-ID: <20080726124058.GD20713@elte.hu>
References: <20080725220040.911370182@goodmis.org> <20080725220334.781928198@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725220334.781928198@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The current ftrace clock uses the sched_clock.c code. This code tries 
> to handle cases where the TSC is out of sync between different CPUs. 
> Unfortunately, even with insync TSCs, due to drifts between the CPU 
> clock and the GTOD clock, we might get some inaccuracy in a single CPU 
> trace.
> 
> Some tracers (irqsoff, preemptoff, preempirqsoff) only care about a 
> trace on a single CPU. This patch changes the ftrace_now (the clock 
> reader) from a function call to a function variable. On initialization 
> of a tracer, the tracer will be allowed to choose which type of clock 
> to use.
> 
> Now the irqsoff, preemptoff and preemptirqs off tracers can have 
> accurate traces with the local CPU clock without affecting the tracers 
> that want the modified clock that tries to keep the different CPU 
> clock reads in sync.

this is not a good idea. We want to fix cpu_clock(), not work around any 
deficiencies it might have.

	Ingo
