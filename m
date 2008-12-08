Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYLHNsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYLHNsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYLHNrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:47:52 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:21410 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYLHNrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uiBkEXmOA4XzdrXYxJspljLJccq+C42OHa9xOiYVrfHG00Wrt5J3XzO2pqoDOYnSSb
         5PqgTsfHoCq9iw7EDL9qu8RJDIRLgEM8kVw0rYEqPRtFk0bDXvgM1/f/kkSIfTF3L+P9
         3dR0m1RNCPE3+gqzbiImIxU1Drry9JcbmWSQA=
Message-ID: <c62985530812080547t67a84d0cy146265c767df99b4@mail.gmail.com>
Date: Mon, 8 Dec 2008 14:47:49 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts entry/exit points on outpout
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081208122221.GA16560@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493C7058.4060709@gmail.com> <20081208122221.GA16560@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/8 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> +/* Used during output to find the interrupts entry/exit points */
>> +const char *ftrace_graph_irq_entries[] = {
>> +     "smp_call_function_single_interrupt",
>> +     "xen_call_function_single_interrupt",
>> +     "wrapper_smp_local_timer_interrupt",
>> +     "smp_irq_move_cleanup_interrupt",
>> +     "smp_call_function_interrupt",
>> +     "xen_call_function_interrupt",
>> +     "smp_apic_timer_interrupt",
>> +     "uv_bau_message_interrupt",
>> +     "mce_threshold_interrupt",
>> +     "smp_spurious_interrupt",
>> +     "smp_thermal_interrupt",
>> +     "smp_error_interrupt",
>> +     "do_IRQ",
>> +     NULL
>
> hm, couldnt we move these symbols to a separate section, and then only
> check for [section.start ... section.end] instead of this ugly and slow
> array?
>
> Missing a few annotations initially is no big deal - we wont have
> pretty-print. do_IRQ() and smp_apic_timer_interrupt is what matters most
> in practice. "__irqentry" section annotation or so, which puts them into
> .text.irqentry or so - and then irqentry_start/end are extracted via
> appropriate glue in the arch/x86/kernel/vmlinux* linker script.


I found it a bit ugly too while I wrote it :-(
I like this idea of a section, I will just have to verify if it is
between the start and the end of
it to check if its an irq entry.
But I think that even if the others than do_IRQ and
smp_apic_timer_interrupt are more rare,
they should be annotated for this new section (and it seems there are
new coming interrupts
like smp_perf_counter_interrupt() in perf counter....)... Perhaps
someone would profile them...

Hm?
