Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbYLHOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbYLHOER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYLHOEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:04:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYLHOD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:03:59 -0500
Date: Mon, 8 Dec 2008 15:03:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts
	entry/exit points on outpout
Message-ID: <20081208140351.GE29965@elte.hu>
References: <493C7058.4060709@gmail.com> <20081208122221.GA16560@elte.hu> <c62985530812080547t67a84d0cy146265c767df99b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812080547t67a84d0cy146265c767df99b4@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/12/8 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> +/* Used during output to find the interrupts entry/exit points */
> >> +const char *ftrace_graph_irq_entries[] = {
> >> +     "smp_call_function_single_interrupt",
> >> +     "xen_call_function_single_interrupt",
> >> +     "wrapper_smp_local_timer_interrupt",
> >> +     "smp_irq_move_cleanup_interrupt",
> >> +     "smp_call_function_interrupt",
> >> +     "xen_call_function_interrupt",
> >> +     "smp_apic_timer_interrupt",
> >> +     "uv_bau_message_interrupt",
> >> +     "mce_threshold_interrupt",
> >> +     "smp_spurious_interrupt",
> >> +     "smp_thermal_interrupt",
> >> +     "smp_error_interrupt",
> >> +     "do_IRQ",
> >> +     NULL
> >
> > hm, couldnt we move these symbols to a separate section, and then only
> > check for [section.start ... section.end] instead of this ugly and slow
> > array?
> >
> > Missing a few annotations initially is no big deal - we wont have
> > pretty-print. do_IRQ() and smp_apic_timer_interrupt is what matters most
> > in practice. "__irqentry" section annotation or so, which puts them into
> > .text.irqentry or so - and then irqentry_start/end are extracted via
> > appropriate glue in the arch/x86/kernel/vmlinux* linker script.
> 
> 
> I found it a bit ugly too while I wrote it :-( I like this idea of a 
> section, I will just have to verify if it is between the start and the 
> end of it to check if its an irq entry. But I think that even if the 
> others than do_IRQ and smp_apic_timer_interrupt are more rare, they 
> should be annotated for this new section (and it seems there are new 
> coming interrupts like smp_perf_counter_interrupt() in perf 
> counter....)... Perhaps someone would profile them...
> 
> Hm?

not annotating an IRQ entry is not a big problem in practice: people will 
notice them in traces that they are not annotated, will send a feature 
request, we annotate them. If they are not noticed, it means they are 
rare in one way or another, and dont matter in practice. So this is a 
self-maintaining concept.

	Ingo
