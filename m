Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbXFMGJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbXFMGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXFMGJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:09:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:4166 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbXFMGJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:09:50 -0400
Message-Id: <200706130609.l5D69lC7063716@www262.sakura.ne.jp>
Subject: How to diagnose this error?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jun 2007 15:09:47 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Something is wrong with my guest Linux on VMware.

Host: CentOS5 (2.6.18-8.1.4.el5) on x86_64 (ThinkPad X60)
Guest: CentOS5 (2.6.18-8.1.4.el5) on x86_64 on VMware Workstation 5.5.4 using 2 CPUs

BUG messages appear frequently (several times per a minute) on the guest, while they never appear on the host.

--- dmesg start ---

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>
BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff8804ec84>] :ext3:ext3_get_block+0x0/0xe3
 [<ffffffff8804ec84>] :ext3:ext3_get_block+0x0/0xe3
 [<ffffffff8001b82e>] __block_write_full_page+0x0/0x2eb
 [<ffffffff8805042b>] :ext3:ext3_ordered_writepage+0xf1/0x198
 [<ffffffff8001c53f>] mpage_writepages+0x1ab/0x34c
 [<ffffffff8805033a>] :ext3:ext3_ordered_writepage+0x0/0x198
 [<ffffffff800d10bd>] do_readv_writev+0x272/0x295
 [<ffffffff80059080>] do_writepages+0x29/0x2f
 [<ffffffff8004d5b4>] __filemap_fdatawrite_range+0x51/0x5b
 [<ffffffff8004de7c>] do_fsync+0x2f/0xa3
 [<ffffffff800d155c>] __do_fsync+0x23/0x36
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>
BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
mptscsih: ioc0: attempting task abort! (sc=ffff81000da886c0)
sd 0:0:0:0:
        command: Write(10): 2a 00 00 2c 80 67 00 00 e8 00
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

mptbase: ioc0: IOCStatus(0x004b): SCSI IOC Terminated
mptscsih: ioc0: task abort: SUCCESS (sc=ffff81000da886c0)
BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb7>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80068ae6>] default_idle+0x0/0x50
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80068b0f>] default_idle+0x29/0x50
 [<ffffffff80046fb7>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff8005f996>] copy_user_generic+0x92/0x126
 [<ffffffff800173e0>] copy_strings+0x1af/0x204
 [<ffffffff800173e0>] copy_strings+0x1af/0x204
 [<ffffffff8003e327>] do_execve+0x161/0x243
 [<ffffffff80052a45>] sys_execve+0x36/0x4c
 [<ffffffff8005b507>] stub_execve+0x67/0xb0

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2ca3>] softlockup_tick+0xdb/0xed
 [<ffffffff80093424>] update_process_times+0x42/0x68
 [<ffffffff80073d99>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8007445b>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 [<ffffffff8021f49e>] dst_rcu_free+0x0/0x3a
 [<ffffffff8003cca7>] rt_run_flush+0x61/0xb8
 [<ffffffff80220ca4>] rt_secret_rebuild+0x0/0x26
 [<ffffffff80220cb3>] rt_secret_rebuild+0xf/0x26
 [<ffffffff80092c4a>] run_timer_softirq+0x133/0x1b0
 [<ffffffff80011c19>] __do_softirq+0x5e/0xd5
 [<ffffffff8005c330>] call_softirq+0x1c/0x28
 [<ffffffff8006a312>] do_softirq+0x2c/0x85
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80008e1a>] __handle_mm_fault+0x832/0xdf2
 [<ffffffff80008cd5>] __handle_mm_fault+0x6ed/0xdf2
 [<ffffffff800645a7>] do_page_fault+0x4b8/0x81d
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff8005be1d>] error_exit+0x0/0x84

--- dmesg end ---

Finally I got kernel panic (but I couldn't get the dmesg after panic).
Any way to diagnose?

Regards.
