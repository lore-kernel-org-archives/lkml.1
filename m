Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYKSPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYKSPOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYKSPON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:14:13 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:26717 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYKSPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Ui90CubqCp6wr/JtTsCLWn/dgIFbAdZwmnbg3gM9hER5qnwBMvIjzEemWMW+FPochx
         zKlBLbl0l/ti8WVKbMr4RllyBjHK0UxGbsvbvZqwWqhW30dJpsXELrbBI7UQou49R8d4
         TMJnqa4zHv4IMyVi0UpolT2zL7PzCvYckg9eU=
Message-ID: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com>
Date: Wed, 19 Nov 2008 18:14:09 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: next-20081119: general protection fault: get_next_timer_interrupt()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It is 4way X86_64
The kernel does not boot.

...
scsi0 : LSI SAS based MegaRAID driver
Driver 'sd' needs updating - please use bus_type methods
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HE160HJ  0-24 PQ: 0 ANSI: 5
general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file:
CPU 3
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc5-next-20081119 #6
RIP: 0010:[<ffffffff80240061>]  [<ffffffff80240061>]
get_next_timer_interrupt+0x11b/0x1f0
RSP: 0018:ffff88007dfe3e98  EFLAGS: 00010016
RAX: 6b6b6b6b6b6b6b6b RBX: ffff88007dfd0000 RCX: 000000000000003e
RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000000037 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff88007dfe3ef8 R08: ffff88007dfe3ea8 R09: 0000000000fffeb7
R10: 0000000000000001 R11: ffff88007dfd1430 R12: 000000013ffeb69c
R13: 00000000fffeb69c R14: ffff88007dfd1050 R15: 0000000000000040
FS:  0000000000000000(0000) GS:ffff88007f402a28(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007dfd6000, task ffff88007dfa4bc0)
Stack:
ffff88008486d000 ffff8800051390c0 ffff88007dfd1050 ffff88007dfd1450
ffff88007dfd1850 ffff88007dfd1c50 ffff880001431780 ffffffff80705000
ffff880001431780 ffff880004f72010 0000000000000000 0000000000000003
Call Trace:
<IRQ> <0> [<ffffffff80253f68>] tick_nohz_stop_sched_tick+0x17b/0x37f
[<ffffffff8023c023>] ? __do_softirq+0xf8/0x101
[<ffffffff8023bbec>] irq_exit+0x91/0xa2
[<ffffffff8021d05d>] smp_apic_timer_interrupt+0xa4/0xce
[<ffffffff8020c610>] apic_timer_interrupt+0x70/0x80
<EOI> <0> [<ffffffff80212df9>] ? mwait_idle+0x3e/0x48
[<ffffffff80212df0>] ? mwait_idle+0x35/0x48
[<ffffffff8020a930>] ? cpu_idle+0x51/0xba
[<ffffffff804dc06d>] ? start_secondary+0x185/0x18a
Code: 30 83 e6 3f 89 f1 48 63 c1 48 c1 e0 04 4a 8b 14 30 4d 8d 1c 06
eb 14 48 8b 42 10 41 ba 01 00 00 00 4c 39 e0 48 89 fa 4c 0f 48 e0 <48>
8b 3a 4c 39 da 0f 18 0f 75 e1 45 85 d2 74 10 85 f6 74 04 39
RIP  [<ffffffff80240061>] get_next_timer_interrupt+0x11b/0x1f0
RSP <ffff88007dfe3e98>
---[ end trace c0adcd63427ce040 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc5-next-20081119 #6
Call Trace:
<IRQ>  [<ffffffff804de999>] panic+0xaa/0x15f
[<ffffffff804deab5>] ? printk+0x67/0x6a
[<ffffffff803ba593>] ? account+0xde/0xed
[<ffffffff803ba6e5>] ? extract_entropy+0x50/0x97
[<ffffffff80239c6e>] do_exit+0x70/0x891
[<ffffffff803ba816>] ? get_random_bytes+0x1b/0x1d
[<ffffffff8020f650>] oops_end+0x89/0x8e
[<ffffffff8020f81c>] die+0x55/0x5e
[<ffffffff8020d9d8>] do_general_protection+0x11e/0x126
[<ffffffff8020d8ba>] ? do_general_protection+0x0/0x126
[<ffffffff804e1f22>] error_exit+0x0/0xa9
[<ffffffff80240061>] ? get_next_timer_interrupt+0x11b/0x1f0
[<ffffffff8023ff83>] ? get_next_timer_interrupt+0x3d/0x1f0
[<ffffffff80253f68>] tick_nohz_stop_sched_tick+0x17b/0x37f
[<ffffffff8023c023>] ? __do_softirq+0xf8/0x101
[<ffffffff8023bbec>] irq_exit+0x91/0xa2
[<ffffffff8021d05d>] smp_apic_timer_interrupt+0xa4/0xce
[<ffffffff8020c610>] apic_timer_interrupt+0x70/0x80
<EOI>  [<ffffffff80212df9>] ? mwait_idle+0x3e/0x48
[<ffffffff80212df0>] ? mwait_idle+0x35/0x48
[<ffffffff8020a930>] ? cpu_idle+0x51/0xba
[<ffffffff804dc06d>] ? start_secondary+0x185/0x18a
------------[ cut here ]------------
WARNING: at kernel/smp.c:333 smp_call_function_mask+0x40/0x1e6()
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc5-next-20081119 #6
Call Trace:
<IRQ>  [<ffffffff80236baf>] warn_on_slowpath+0x58/0x7d
[<ffffffff804deab5>] ? printk+0x67/0x6a
[<ffffffff804dc06d>] ? start_secondary+0x185/0x18a
[<ffffffff804dc06d>] ? start_secondary+0x185/0x18a
[<ffffffff804deab5>] ? printk+0x67/0x6a
[<ffffffff80237864>] ? vprintk+0x312/0x355
[<ffffffff8021d513>] ? touch_nmi_watchdog+0x54/0x58
[<ffffffff80212f6c>] ? stop_this_cpu+0x0/0x24
[<ffffffff8025df57>] smp_call_function_mask+0x40/0x1e6
[<ffffffff80212f6c>] ? stop_this_cpu+0x0/0x24
[<ffffffff8020f9d8>] ? print_context_stack+0xa8/0xc0
[<ffffffff8020eb24>] ? dump_trace+0x25d/0x285
[<ffffffff8020f88a>] ? show_trace_log_lvl+0x4c/0x58
[<ffffffff80212f6c>] ? stop_this_cpu+0x0/0x24
[<ffffffff8025e130>] smp_call_function+0x33/0x6c
[<ffffffff8021bad4>] native_smp_send_stop+0x22/0x48
[<ffffffff804de9a6>] panic+0xb7/0x15f
[<ffffffff804deab5>] ? printk+0x67/0x6a
[<ffffffff803ba593>] ? account+0xde/0xed
[<ffffffff803ba6e5>] ? extract_entropy+0x50/0x97
[<ffffffff80239c6e>] do_exit+0x70/0x891
[<ffffffff803ba816>] ? get_random_bytes+0x1b/0x1d
[<ffffffff8020f650>] oops_end+0x89/0x8e
[<ffffffff8020f81c>] die+0x55/0x5e
[<ffffffff8020d9d8>] do_general_protection+0x11e/0x126
[<ffffffff8020d8ba>] ? do_general_protection+0x0/0x126
[<ffffffff804e1f22>] error_exit+0x0/0xa9
[<ffffffff80240061>] ? get_next_timer_interrupt+0x11b/0x1f0
[<ffffffff8023ff83>] ? get_next_timer_interrupt+0x3d/0x1f0
[<ffffffff80253f68>] tick_nohz_stop_sched_tick+0x17b/0x37f
[<ffffffff8023c023>] ? __do_softirq+0xf8/0x101
[<ffffffff8023bbec>] irq_exit+0x91/0xa2
[<ffffffff8021d05d>] smp_apic_timer_interrupt+0xa4/0xce
[<ffffffff8020c610>] apic_timer_interrupt+0x70/0x80
<EOI>  [<ffffffff80212df9>] ? mwait_idle+0x3e/0x48
[<ffffffff80212df0>] ? mwait_idle+0x35/0x48
[<ffffffff8020a930>] ? cpu_idle+0x51/0xba
[<ffffffff804dc06d>] ? start_secondary+0x185/0x18a
---[ end trace c0adcd63427ce040 ]---
