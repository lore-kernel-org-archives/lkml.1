Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZLCUCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZLCUCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZLCUCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:02:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:37139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZLCUCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:02:01 -0500
Subject: Re: Inconsistent lock state - finish_task_switch/sched.c
From: Peter Zijlstra <peterz@infradead.org>
To: michal.simek@petalogix.com
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, matthew@wil.cx,
       Arnd Bergmann <arnd@arndb.de>,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4B17E6AF.90700@petalogix.com>
References: <4B17E6AF.90700@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 21:02:01 +0100
Message-ID: <1259870521.3977.1373.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 17:26 +0100, Michal Simek wrote:

> =================================
> [ INFO: inconsistent lock state ]
> 2.6.32-00043-g62a59b0 #12
> ---------------------------------
> inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> swapper/1 [HC0[0]:SC0[0]:HE0:SE1] takes:
>   (&rq->lock){?.-...}, at: [<c000f148>] finish_task_switch+0x0/0x178
> {IN-HARDIRQ-W} state was registered at:
>    [<c0016478>] release_console_sem+0x50/0x2d8
>    [<c0046214>] mark_lock+0x2f4/0x6ac
>    [<c00492f8>] __lock_acquire+0x908/0xbb8
>    [<c001707c>] vprintk+0x2a4/0x550
>    [<c0048cfc>] __lock_acquire+0x30c/0xbb8
>    [<c00495f8>] lock_acquire+0x50/0x80
>    [<c0024374>] do_timer+0x40/0x68
>    [<c0048bfc>] __lock_acquire+0x20c/0xbb8
>    [<c0280d3c>] _spin_lock+0x38/0x64
>    [<c00120f0>] scheduler_tick+0x2c/0x13c
>    [<c00120e8>] scheduler_tick+0x24/0x13c
>    [<c00243b8>] run_local_timers+0x1c/0x44
>    [<c00120f0>] scheduler_tick+0x2c/0x13c
>    [<c0024438>] update_process_times+0x58/0x88
>    [<c002442c>] update_process_times+0x4c/0x88
>    [<c0042d30>] tick_periodic+0x30/0x110
>    [<c0042dec>] tick_periodic+0xec/0x110
>    [<c0042dc4>] tick_periodic+0xc4/0x110
>    [<c0042e3c>] tick_handle_periodic+0x2c/0x150
>    [<c00495f8>] lock_acquire+0x50/0x80
>    [<c0280af4>] _spin_unlock_irqrestore+0x2c/0x90
>    [<c0005ff4>] timer_interrupt+0x30/0x50
>    [<c0050f58>] handle_IRQ_event+0x58/0x1e8
>    [<c0280b88>] _spin_unlock+0x30/0x50
>    [<c00540d8>] handle_level_irq+0xa4/0x16c
>    [<c00540c8>] handle_level_irq+0x94/0x16c
>    [<c0001b2c>] do_IRQ+0x7c/0x108
>    [<c0001ae0>] do_IRQ+0x30/0x108
>    [<c0008b20>] irq_call+0x0/0x8
>    [<c0280e90>] _spin_lock_irqsave+0x30/0x8c
>    [<c0280b1c>] _spin_unlock_irqrestore+0x54/0x90
>    [<c0042628>] clockevents_register_device+0xf8/0x194
>    [<c00425a8>] clockevents_register_device+0x78/0x194
>    [<c0042630>] clockevents_register_device+0x100/0x194
>    [<c0339a6c>] start_kernel+0x2d4/0x4e4
>    [<c0339a74>] start_kernel+0x2dc/0x4e4
>    [<c0339a7c>] start_kernel+0x2e4/0x4e4
>    [<c00065b0>] machine_halt+0x0/0x24
>    [<c001667c>] release_console_sem+0x254/0x2d8
> irq event stamp: 0
> hardirqs last  enabled at (0): [<(null)>] (null)
> hardirqs last disabled at (0): [<c001358c>] copy_process+0x33c/0x1200
> softirqs last  enabled at (0): [<c001358c>] copy_process+0x33c/0x1200
> softirqs last disabled at (0): [<(null)>] (null)
> 
> other info that might help us debug this:
> no locks held by swapper/1.
> 
> stack backtrace:
> 
> Stack:
>    cf833de8 00000000 cf833e00 c028ee58 cf833e08 cf833e00 c0046594 c028e584
>    c02b7568 c001667c 00000000 00000002 00000000 00000000 00000000 00000001
>    cf833e3c 00000000 00000000 00000002 cf8313b4 c00490c4 cf83111c cf831210
> Call Trace:
> 
> [<c0046594>] mark_lock+0x674/0x6ac
> [<c001667c>] release_console_sem+0x254/0x2d8
> [<c00490c4>] __lock_acquire+0x6d4/0xbb8
> [<c001a24c>] do_exit+0xcc/0x7a4
> [<c0280d1c>] _spin_lock+0x18/0x64
> [<c001a2b0>] do_exit+0x130/0x7a4
> [<c00495f8>] lock_acquire+0x50/0x80
> [<c000f1a8>] finish_task_switch+0x60/0x178
> [<c000f148>] finish_task_switch+0x0/0x178
> [<c0010aa4>] schedule_tail+0x18/0x88
> [<c0018620>] exit_mm+0x248/0x268
> [<c000f148>] finish_task_switch+0x0/0x178
> [<c0007e94>] ret_from_fork+0x4/0x20
> [<c0007f88>] full_exception_trap+0x28/0x210
> [<c03391c0>] kernel_init+0x0/0x194
> [<c0002628>] kernel_thread_helper+0x0/0x28

So we schedule while holding rq->lock (for obvious reasons), but since
lockdep tracks held locks per tasks, we need to transfer the held state
from the prev to the next task. We do this by explicity calling
spin_release(&rq->lock) in context_switch() right before switch_to(),
and calling spin_acquire(&rq->lock) in
finish_task_switch()->finish_lock_switch().

Now, for some reason lockdep thinks that interrupts got enabled over the
context switch (git grep __ARCH_WANTS_INTERRUPTS_ON_CTSW arch/microblaze
doesn't seem to turn up anything).

Clearly trying to acquire the rq->lock with interrupts enabled is a bad
idea and lockdep warns you about this.



