Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZHYKnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZHYKnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZHYKnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:43:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZHYKnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:43:15 -0400
Date: Tue, 25 Aug 2009 12:43:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory (f6f6e1a4), by kmemleak's scan_block()
Message-ID: <20090825104311.GA10642@elte.hu>
References: <1251189914.7261.11.camel@penberg-laptop> <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop> <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com> <1251191507.26351.0.camel@penberg-laptop> <1251192069.15678.21.camel@pc1117.cambridge.arm.com> <1251192415.26351.5.camel@penberg-laptop> <1251192534.15678.29.camel@pc1117.cambridge.arm.com> <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com> <20090825093423.GA12935@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825093423.GA12935@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Tue, Aug 25, 2009 at 12:28 PM, Catalin
> > Marinas<catalin.marinas@arm.com> wrote:
> > >> Does this look OK to you?
> > >
> > > For the kmemleak.c part:
> > >
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > Vegard? Ingo? The patch is based on tip/out-of-tree so it probably 
> > should go to the kmemleak tree?
> 
> I'm testing it currently - but yeah, i'd agree that it should go 
> into the kmemleak tree, with a .32 merge date or so.

btw., i re-tested the original tree, and got the lockup/crash below.

	Ingo

--------------->
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
BUG: soft lockup - CPU#0 stuck for 61s! [kmemleak:3080]
irq event stamp: 6938907
hardirqs last  enabled at (6938906): [<c1e68535>] _write_unlock_irqrestore+0x55/0x70
hardirqs last disabled at (6938907): [<c102434f>] apic_timer_interrupt+0x2f/0x3c
softirqs last  enabled at (1776166): [<c106ba9c>] __do_softirq+0x1cc/0x200
softirqs last disabled at (1776357): [<c106bb2d>] do_softirq+0x5d/0x70

Pid: 3080, comm: kmemleak Not tainted (2.6.31-rc7-tip #1528) P4DC6
EIP: 0060:[<c1e68537>] EFLAGS: 00000282 CPU: 0
EIP is at _write_unlock_irqrestore+0x57/0x70
EAX: 0069e11a EBX: c2420d48 ECX: 00000002 EDX: 00000001
ESI: 00000282 EDI: c3526af8 EBP: f0c13df4 ESP: f0c13dec
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: f7840000 CR3: 1ffd3000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
Call Trace:
 [<c1103ade>] __delete_object+0x3e/0x90
 [<c1103b46>] delete_object_full+0x16/0x30
 [<c110491f>] kmemleak_free+0x5f/0x70
 [<c10fc2e3>] ? kmem_cache_free+0x43/0x160
 [<c10fc3b7>] kmem_cache_free+0x117/0x160
 [<c111c33b>] ? __d_free+0x2b/0x40
 [<c111c33b>] __d_free+0x2b/0x40
 [<c111cd1b>] d_callback+0xb/0x10
 [<c10b22ef>] rcu_process_callbacks+0x4f/0x70
 [<c106b9bf>] __do_softirq+0xef/0x200
 [<c108dd99>] ? tick_program_event+0x39/0x50
 [<c106bb2d>] do_softirq+0x5d/0x70
 [<c106c35d>] irq_exit+0x8d/0xa0
 [<c103bb86>] smp_apic_timer_interrupt+0x56/0x90
 [<c1424538>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c1024356>] apic_timer_interrupt+0x36/0x3c
 [<c109007b>] ? lockdep_free_key_range+0x12b/0x1c0
 [<c1e685f7>] ? _read_unlock_irqrestore+0x57/0x70
 [<c1103a1f>] find_and_get_object+0x5f/0xa0
 [<c1103f62>] scan_block+0x42/0x120
 [<c1104b70>] ? kmemleak_scan_thread+0x0/0xc0
 [<c11041fa>] kmemleak_scan+0xda/0x4f0
 [<c1104b70>] ? kmemleak_scan_thread+0x0/0xc0
 [<c1e66ea5>] ? mutex_lock_nested+0x35/0x40
 [<c1104b70>] ? kmemleak_scan_thread+0x0/0xc0
 [<c1104bc0>] kmemleak_scan_thread+0x50/0xc0
 [<c1080514>] kthread+0x74/0x80
 [<c10804a0>] ? kthread+0x0/0x80
 [<c102453b>] kernel_thread_helper+0x7/0x3c
Kernel panic - not syncing: softlockup: hung tasks
Pid: 3080, comm: kmemleak Not tainted 2.6.31-rc7-tip #1528
Call Trace:
 [<c1e654be>] ? printk+0x18/0x1a
 [<c1e653ee>] panic+0x4d/0x105
 [<c10acc16>] softlockup_tick+0x156/0x180
 [<c10717a7>] run_local_timers+0x17/0x20
 [<c10717df>] update_process_times+0x2f/0x70
 [<c108e1ed>] tick_nohz_handler+0x7d/0xf0
 [<c103bb81>] smp_apic_timer_interrupt+0x51/0x90
 [<c1424538>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c1024356>] apic_timer_interrupt+0x36/0x3c
 [<c109007b>] ? lockdep_free_key_range+0x12b/0x1c0
 [<c1e68537>] ? _write_unlock_irqrestore+0x57/0x70
 [<c1103ade>] __delete_object+0x3e/0x90
 [<c1103b46>] delete_object_full+0x16/0x30
 [<c110491f>] kmemleak_free+0x5f/0x70
 [<c10fc2e3>] ? kmem_cache_free+0x43/0x160
 [<c10fc3b7>] kmem_cache_free+0x117/0x160
 [<c111c33b>] ? __d_free+0x2b/0x40
 [<c111c33b>] __d_free+0x2b/0x40
 [<c111cd1b>] d_callback+0xb/0x10
 [<c10b22ef>] rcu_process_callbacks+0x4f/0x70
 [<c106b9bf>] __do_softirq+0xef/0x200
 [<c108dd99>] ? tick_program_event+0x39/0x50
 [<c106bb2d>] do_softirq+0x5d/0x70
 [<c106c35d>] irq_exit+0x8d/0xa0
 [<c103bb86>] smp_apic_timer_interrupt+0x56/0x90
 [<c1424538>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c1024356>] apic_timer_interrupt+0x36/0x3c
 [<c109007b>] ? lockdep_free_key_range+0x12b/0x1c0
 [<c1e685f7>] ? _read_unlock_irqrestore+0x57/0x70
 [<c1103a1f>] find_and_get_object+0x5f/0xa0
 [<c1103f62>] scan_block+0x42/0x120
 [<c1104b70>] ? kmemleak_scan_thread+0x0/0xc0
 [<c11041fa>] kmemleak_scan+0xda/0x4f0
 [<c1104b70>] ? kmemleak_scan_thread+0x0/0xc0
 [<c1e66ea5>] ? mutex_lock_nested+0x35/0x40
 [<c1104b70>] ? kmemleak_scan_thread+0x0/0xc0
 [<c1104bc0>] kmemleak_scan_thread+0x50/0xc0
 [<c1080514>] kthread+0x74/0x80
 [<c10804a0>] ? kthread+0x0/0x80
 [<c102453b>] kernel_thread_helper+0x7/0x3c
Rebooting in 1 seconds..Initializing cgroup subsys cpuset
