Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbYLHMWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbYLHMWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYLHMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:22:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60605 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYLHMW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:22:27 -0500
Date: Mon, 8 Dec 2008 13:22:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts
	entry/exit points on outpout
Message-ID: <20081208122221.GA16560@elte.hu>
References: <493C7058.4060709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493C7058.4060709@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +/* Used during output to find the interrupts entry/exit points */
> +const char *ftrace_graph_irq_entries[] = {
> +	"smp_call_function_single_interrupt",
> +	"xen_call_function_single_interrupt",
> +	"wrapper_smp_local_timer_interrupt",
> +	"smp_irq_move_cleanup_interrupt",
> +	"smp_call_function_interrupt",
> +	"xen_call_function_interrupt",
> +	"smp_apic_timer_interrupt",
> +	"uv_bau_message_interrupt",
> +	"mce_threshold_interrupt",
> +	"smp_spurious_interrupt",
> +	"smp_thermal_interrupt",
> +	"smp_error_interrupt",
> +	"do_IRQ",
> +	NULL

hm, couldnt we move these symbols to a separate section, and then only 
check for [section.start ... section.end] instead of this ugly and slow 
array?

Missing a few annotations initially is no big deal - we wont have 
pretty-print. do_IRQ() and smp_apic_timer_interrupt is what matters most 
in practice. "__irqentry" section annotation or so, which puts them into 
.text.irqentry or so - and then irqentry_start/end are extracted via 
appropriate glue in the arch/x86/kernel/vmlinux* linker script.

	Ingo
