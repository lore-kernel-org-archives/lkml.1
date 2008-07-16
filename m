Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYGPEN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYGPEN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYGPENs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:13:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYGPENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:13:48 -0400
Date: Wed, 16 Jul 2008 00:13:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: 4d3702b6 (post-v2.6.26): WARNING: at kernel/lockdep.c:2731
 check_flags (ftrace)
In-Reply-To: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0807160010490.25043@gandalf.stny.rr.com>
References: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Vegard Nossum wrote:

>
> Hi,
>
> When booting 4d3702b6, I got this huge thing:
>
> Testing tracer wakeup: <4>------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2731 check_flags+0x123/0x160()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-crashing-02127-g4d3702b6 #30
>  [<c015c349>] warn_on_slowpath+0x59/0xb0
>  [<c01276c6>] ? ftrace_call+0x5/0x8
>  [<c012d800>] ? native_read_tsc+0x0/0x20
>  [<c0158de2>] ? sub_preempt_count+0x12/0xf0
>  [<c01814eb>] ? trace_hardirqs_off+0xb/0x10
>  [<c0182fbc>] ? __lock_acquire+0x2cc/0x1120
>  [<c01814eb>] ? trace_hardirqs_off+0xb/0x10
>  [<c01276af>] ? mcount_call+0x5/0xa
>  [<c017ff53>] check_flags+0x123/0x160
>  [<c0183e61>] lock_acquire+0x51/0xd0
>  [<c01276c6>] ? ftrace_call+0x5/0x8
>  [<c0613d4f>] _spin_lock_irqsave+0x5f/0xa0
>  [<c01a8d45>] ? ftrace_record_ip+0xf5/0x220
>  [<c02d5413>] ? debug_locks_off+0x3/0x50
>  [<c01a8d45>] ftrace_record_ip+0xf5/0x220
>  [<c01276af>] mcount_call+0x5/0xa
>  [<c02d5418>] ? debug_locks_off+0x8/0x50
>  [<c017ff27>] check_flags+0xf7/0x160
>  [<c0183e61>] lock_acquire+0x51/0xd0
>  [<c01276c6>] ? ftrace_call+0x5/0x8
>  [<c0613d4f>] _spin_lock_irqsave+0x5f/0xa0
>  [<c01affcd>] ? wakeup_tracer_call+0x6d/0xf0
>  [<c01625e2>] ? _local_bh_enable+0x62/0xb0
>  [<c0158ddd>] ? sub_preempt_count+0xd/0xf0
>  [<c01affcd>] wakeup_tracer_call+0x6d/0xf0
>  [<c0162724>] ? __do_softirq+0xf4/0x110
>  [<c01afff1>] ? wakeup_tracer_call+0x91/0xf0
>  [<c01276c6>] ftrace_call+0x5/0x8
>  [<c0162724>] ? __do_softirq+0xf4/0x110
>  [<c0158de2>] ? sub_preempt_count+0x12/0xf0
>  [<c01625e2>] _local_bh_enable+0x62/0xb0
>  [<c0162724>] __do_softirq+0xf4/0x110
>  [<c01627ed>] do_softirq+0xad/0xb0
>  [<c0162a15>] irq_exit+0xa5/0xb0
>  [<c013a506>] smp_apic_timer_interrupt+0x66/0xa0
>  [<c02d3fac>] ? trace_hardirqs_off_thunk+0xc/0x10
>  [<c0127449>] apic_timer_interrupt+0x2d/0x34
>  [<c018007b>] ? find_usage_backwards+0xb/0xf0
>  [<c0613a09>] ? _spin_unlock_irqrestore+0x69/0x80
>  [<c014ef32>] tg_shares_up+0x132/0x1d0
>  [<c014d2a2>] walk_tg_tree+0x62/0xa0
>  [<c014ee00>] ? tg_shares_up+0x0/0x1d0
>  [<c014a860>] ? tg_nop+0x0/0x10
>  [<c015499d>] update_shares+0x5d/0x80
>  [<c0154a2f>] try_to_wake_up+0x6f/0x280
>  [<c01a8b90>] ? __ftrace_modify_code+0x0/0xc0
>  [<c01a8b90>] ? __ftrace_modify_code+0x0/0xc0
>  [<c0154c94>] wake_up_process+0x14/0x20
>  [<c01725f6>] kthread_create+0x66/0xb0
>  [<c0195400>] ? do_stop+0x0/0x200
>  [<c0195320>] ? __stop_machine_run+0x30/0xb0
>  [<c0195340>] __stop_machine_run+0x50/0xb0
>  [<c0195400>] ? do_stop+0x0/0x200
>  [<c01a8b90>] ? __ftrace_modify_code+0x0/0xc0
>  [<c061242d>] ? mutex_unlock+0xd/0x10
>  [<c01953cc>] stop_machine_run+0x2c/0x60
>  [<c01a94d3>] unregister_ftrace_function+0x103/0x180
>  [<c01b0517>] stop_wakeup_tracer+0x17/0x60
>  [<c01b056f>] wakeup_tracer_ctrl_update+0xf/0x30
>  [<c01ab8d5>] trace_selftest_startup_wakeup+0xb5/0x130
>  [<c01ab950>] ? trace_wakeup_test_thread+0x0/0x70
>  [<c01aadf5>] register_tracer+0x135/0x1b0
>  [<c0877d02>] init_wakeup_tracer+0xd/0xf
>  [<c085d437>] kernel_init+0x1a9/0x2ce
>  [<c061397b>] ? _spin_unlock_irq+0x3b/0x60
>  [<c02d3f9c>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c0877cf5>] ? init_wakeup_tracer+0x0/0xf
>  [<c0182646>] ? trace_hardirqs_on_caller+0x126/0x180
>  [<c02d3f9c>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c01269c8>] ? restore_nocheck_notrace+0x0/0xe
>  [<c085d28e>] ? kernel_init+0x0/0x2ce
>  [<c085d28e>] ? kernel_init+0x0/0x2ce
>  [<c01275fb>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace a7919e7f17c0a725 ]---
> irq event stamp: 579530
> hardirqs last  enabled at (579528): [<c01826ab>] trace_hardirqs_on+0xb/0x10
> hardirqs last disabled at (579529): [<c01814eb>] trace_hardirqs_off+0xb/0x10
> softirqs last  enabled at (579530): [<c0162724>] __do_softirq+0xf4/0x110
> softirqs last disabled at (579517): [<c01627ed>] do_softirq+0xad/0xb0
> irq event stamp: 579530
> hardirqs last  enabled at (579528): [<c01826ab>] trace_hardirqs_on+0xb/0x10
> hardirqs last disabled at (579529): [<c01814eb>] trace_hardirqs_off+0xb/0x10
> softirqs last  enabled at (579530): [<c0162724>] __do_softirq+0xf4/0x110
> softirqs last disabled at (579517): [<c01627ed>] do_softirq+0xad/0xb0
> PASSED
>
> Incidentally, the kernel also hung while I was typing in this report.
>
> (I thought I'd already reported this in -next before the merge window
> opened... weird.)

Maybe.

Things get weird between lockdep and ftrace because ftrace can be called
within lockdep internal code (via the mcount pointer) and lockdep can be
called with ftrace (via spin_locks).

Can you try this patch out and see if it fixes your problem. I only
compiled tested it.

Note: I'll be traveling for the next couple of weeks, so I will be on and
off with email.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: linux-compile.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_sched_wakeup.c	2008-07-15 23:56:50.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_sched_wakeup.c	2008-07-16 00:10:05.000000000 -0400
@@ -26,7 +26,8 @@ static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
 static unsigned			wakeup_prio = -1;

-static DEFINE_SPINLOCK(wakeup_lock);
+static raw_spinlock_t wakeup_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;

 static void __wakeup_reset(struct trace_array *tr);

@@ -56,7 +57,8 @@ wakeup_tracer_call(unsigned long ip, uns
 	if (unlikely(disabled != 1))
 		goto out;

-	spin_lock_irqsave(&wakeup_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&wakeup_lock);

 	if (unlikely(!wakeup_task))
 		goto unlock;
@@ -71,7 +73,8 @@ wakeup_tracer_call(unsigned long ip, uns
 	trace_function(tr, data, ip, parent_ip, flags);

  unlock:
-	spin_unlock_irqrestore(&wakeup_lock, flags);
+	__raw_spin_unlock(&wakeup_lock);
+	local_irq_restore(flags);

  out:
 	atomic_dec(&data->disabled);
@@ -145,7 +148,8 @@ wakeup_sched_switch(void *private, void
 	if (likely(disabled != 1))
 		goto out;

-	spin_lock_irqsave(&wakeup_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&wakeup_lock);

 	/* We could race with grabbing wakeup_lock */
 	if (unlikely(!tracer_enabled || next != wakeup_task))
@@ -174,7 +178,8 @@ wakeup_sched_switch(void *private, void

 out_unlock:
 	__wakeup_reset(tr);
-	spin_unlock_irqrestore(&wakeup_lock, flags);
+	__raw_spin_unlock(&wakeup_lock);
+	local_irq_restore(flags);
 out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
@@ -209,8 +214,6 @@ static void __wakeup_reset(struct trace_
 	struct trace_array_cpu *data;
 	int cpu;

-	assert_spin_locked(&wakeup_lock);
-
 	for_each_possible_cpu(cpu) {
 		data = tr->data[cpu];
 		tracing_reset(data);
@@ -229,9 +232,11 @@ static void wakeup_reset(struct trace_ar
 {
 	unsigned long flags;

-	spin_lock_irqsave(&wakeup_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&wakeup_lock);
 	__wakeup_reset(tr);
-	spin_unlock_irqrestore(&wakeup_lock, flags);
+	__raw_spin_unlock(&wakeup_lock);
+	local_irq_restore(flags);
 }

 static void
@@ -252,7 +257,7 @@ wakeup_check_start(struct trace_array *t
 		goto out;

 	/* interrupts should be off from try_to_wake_up */
-	spin_lock(&wakeup_lock);
+	__raw_spin_lock(&wakeup_lock);

 	/* check for races. */
 	if (!tracer_enabled || p->prio >= wakeup_prio)
@@ -274,7 +279,7 @@ wakeup_check_start(struct trace_array *t
 		       CALLER_ADDR1, CALLER_ADDR2, flags);

 out_locked:
-	spin_unlock(&wakeup_lock);
+	__raw_spin_unlock(&wakeup_lock);
 out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
