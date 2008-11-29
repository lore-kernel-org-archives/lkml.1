Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYK2K7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYK2K7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYK2K7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:59:35 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:14766 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYK2K7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:59:35 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the
 trace informations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530811281940w4542546t5a1235ad8e5a24bf@mail.gmail.com>
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu>
	 <20081128092553.GA7040@elte.hu> <20081128192249.GA22263@elte.hu>
	 <c62985530811281940w4542546t5a1235ad8e5a24bf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Nov 2008 11:59:29 +0100
Message-Id: <1227956369.7505.1572.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-29 at 04:40 +0100, Frédéric Weisbecker wrote:
> 2008/11/28 Ingo Molnar <mingo@elte.hu>:

> I tried to figure out a way to signal a hardirq in a trace, I like
> this arrow but It
> breaks the indentation.
> I would suggest:
> 
>   0)               |              skb_dequeue() {
>   0)      0.365 us |                _spin_lock_irqsave();
>   0)      0.422 us |                _spin_unlock_irqrestore();
>   0)      1.912 us |              }
>   0)               |              memcpy_toiovec() {
>   0)               |                copy_to_user() {
>              =====>
>   0)               |               smp_apic_timer_interrupt() {
>   0)      0.450 us |                    native_apic_mem_write();
>   0)               |                    irq_enter() {
>   0)      0.410 us |                      idle_cpu();
>   0)      1.167 us |                    }
>   0)               |                    hrtimer_interrupt() {
> 
> Your idea solves a part of one of the features I wanted to add: why
> not using a single character column to print
> the current context: workqueue, syscall, kernel thread, tasklet, hardirq .....

That was my initial suggestion too, like the latency tracer has.

Then again, most of that would be obvious from the comm/pid column, that
will show preemption and all those things.

But showing Hard,Soft irq disabled and perhaps the preempt count would
be handy.

