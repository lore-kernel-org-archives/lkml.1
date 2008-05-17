Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYEQRZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYEQRZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 13:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYEQRZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 13:25:32 -0400
Received: from testure.choralone.org ([194.9.77.134]:42952 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYEQRZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 13:25:30 -0400
Date: Sat, 17 May 2008 13:26:12 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: stsp@users.sourceforge.net
Subject: pcspkr lockdep trace.
Message-ID: <20080517172612.GA3522@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	stsp@users.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-0.13.rc2.git5.fc10.x86_64 #1
-------------------------------------------------------
ksoftirqd/0/4 is trying to acquire lock:
 (&pcsp_chip.substream_lock){++..}, at: [<ffffffffa0265333>] pcsp_do_timer+0x5a/0x2b3 [snd_pcsp]

but task is already holding lock:
 (&cpu_base->lock){++..}, at: [<ffffffff8104e0a8>] hrtimer_interrupt+0x79/0x14f

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&cpu_base->lock){++..}:
       [<ffffffff81058334>] __lock_acquire+0xbcf/0xd5f
       [<ffffffff81058522>] lock_acquire+0x5e/0x78
       [<ffffffff812b1e5d>] _spin_lock_irqsave+0x36/0x69
       [<ffffffff8104da9a>] lock_hrtimer_base+0x25/0x4b
       [<ffffffff8104dc76>] hrtimer_start+0x24/0x15e
       [<ffffffff8102dccc>] enqueue_rt_entity+0x212/0x23d
       [<ffffffff8102dfcd>] enqueue_task_rt+0x60/0x89
       [<ffffffff81027844>] enqueue_task+0x4d/0x58
       [<ffffffff81027871>] activate_task+0x22/0x2a
       [<ffffffff8102ceab>] try_to_wake_up+0x186/0x1dd
       [<ffffffff8102cf2e>] wake_up_process+0x10/0x12
       [<ffffffff812ac90c>] migration_call+0xdf/0x4d3
       [<ffffffff815164e7>] migration_init+0x46/0x57
       [<ffffffff815035ce>] kernel_init+0x5f/0x344
       [<ffffffff8100cec8>] child_rip+0xa/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #3 (&rt_b->rt_runtime_lock){+...}:
       [<ffffffff81058334>] __lock_acquire+0xbcf/0xd5f
       [<ffffffff81058522>] lock_acquire+0x5e/0x78
       [<ffffffff812b1d47>] _spin_lock+0x26/0x53
       [<ffffffff8102dc99>] enqueue_rt_entity+0x1df/0x23d
       [<ffffffff8102dfcd>] enqueue_task_rt+0x60/0x89
       [<ffffffff81027844>] enqueue_task+0x4d/0x58
       [<ffffffff81027871>] activate_task+0x22/0x2a
       [<ffffffff8102ceab>] try_to_wake_up+0x186/0x1dd
       [<ffffffff8102cf2e>] wake_up_process+0x10/0x12
       [<ffffffff812ac90c>] migration_call+0xdf/0x4d3
       [<ffffffff815164e7>] migration_init+0x46/0x57
       [<ffffffff815035ce>] kernel_init+0x5f/0x344
       [<ffffffff8100cec8>] child_rip+0xa/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&rq->rq_lock_key){++..}:
       [<ffffffff81058334>] __lock_acquire+0xbcf/0xd5f
       [<ffffffff81058522>] lock_acquire+0x5e/0x78
       [<ffffffff812b1d47>] _spin_lock+0x26/0x53
       [<ffffffff8102c5a4>] task_rq_lock+0x42/0x78
       [<ffffffff8102cd59>] try_to_wake_up+0x34/0x1dd
       [<ffffffff8102cf2e>] wake_up_process+0x10/0x12
       [<ffffffff8103c1b8>] __tasklet_schedule+0x86/0xa6
       [<ffffffffa02651d1>] snd_pcsp_trigger+0xac/0xbe [snd_pcsp]
       [<ffffffffa0146b97>] snd_pcm_do_start+0x27/0x29 [snd_pcm]
       [<ffffffffa0146ad5>] snd_pcm_action_single+0x2d/0x5b [snd_pcm]
       [<ffffffffa0148779>] snd_pcm_action_lock_irq+0x86/0xac [snd_pcm]
       [<ffffffffa014aebe>] snd_pcm_common_ioctl1+0x4c0/0xcee [snd_pcm]
       [<ffffffffa014bbe3>] snd_pcm_playback_ioctl1+0x252/0x26f [snd_pcm]
       [<ffffffffa014c49e>] snd_pcm_playback_ioctl+0x2e/0x36 [snd_pcm]
       [<ffffffff810bdf9a>] vfs_ioctl+0x2a/0x78
       [<ffffffff810be239>] do_vfs_ioctl+0x251/0x26b
       [<ffffffff810be2a8>] sys_ioctl+0x55/0x79
       [<ffffffff8100c120>] tracesys+0xd5/0xda
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&substream->self_group.lock){.+..}:
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&pcsp_chip.substream_lock){++..}:
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by ksoftirqd/0/4:
 #0:  (&cpu_base->lock){++..}, at: [<ffffffff8104e0a8>] hrtimer_interrupt+0x79/0x14f

stack backtrace:
Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.26-0.13.rc2.git5.fc10.x86_64 #1

Call Trace:
 <IRQ>  [<ffffffff810574ca>] print_circular_bug_tail+0x70/0x7b
 [<ffffffff810572e2>] ? print_circular_bug_entry+0x48/0x4f
 [<ffffffff81058237>] __lock_acquire+0xad2/0xd5f
 [<ffffffff81011dc7>] ? native_sched_clock+0x50/0x6d
 [<ffffffff81011dc7>] ? native_sched_clock+0x50/0x6d
 [<ffffffff8104dffe>] ? ktime_get+0x11/0x42
 [<ffffffff81058522>] lock_acquire+0x5e/0x78
 [<ffffffffa0265333>] ? :snd_pcsp:pcsp_do_timer+0x5a/0x2b3
 [<ffffffff812b1e5d>] _spin_lock_irqsave+0x36/0x69
 [<ffffffff812b1bf1>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffffa02652d9>] ? :snd_pcsp:pcsp_do_timer+0x0/0x2b3
 [<ffffffffa0265333>] :snd_pcsp:pcsp_do_timer+0x5a/0x2b3
 [<ffffffff8104e128>] ? hrtimer_interrupt+0xf9/0x14f
 [<ffffffffa02652d9>] ? :snd_pcsp:pcsp_do_timer+0x0/0x2b3
 [<ffffffff8104d4bc>] __run_hrtimer+0x79/0xa7
 [<ffffffff8104e113>] hrtimer_interrupt+0xe4/0x14f
 [<ffffffff8101aa65>] smp_apic_timer_interrupt+0x85/0xa3
 [<ffffffff8100cceb>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff812b1c38>] ? _spin_unlock_irqrestore+0x42/0x47
 [<ffffffff8104db82>] ? hrtimer_try_to_cancel+0x85/0x92
 [<ffffffff8104dba3>] ? hrtimer_cancel+0x14/0x20
 [<ffffffff812aeef6>] ? schedule+0x135/0x825
 [<ffffffff8100e4d8>] ? do_softirq+0x84/0x8a
 [<ffffffff8103c28d>] ? ksoftirqd+0x34/0xcf
 [<ffffffff8103c259>] ? ksoftirqd+0x0/0xcf
 [<ffffffff8104a9e7>] ? kthread+0x49/0x76
 [<ffffffff8100cec8>] ? child_rip+0xa/0x12
 [<ffffffff8100c5df>] ? restore_args+0x0/0x30
 [<ffffffff8104a99e>] ? kthread+0x0/0x76
 [<ffffffff8100cebe>] ? child_rip+0x0/0x12


-- 
http://www.codemonkey.org.uk
