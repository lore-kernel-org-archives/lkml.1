Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZETRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZETRuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbZETRue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:50:34 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:55227 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZETRud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:50:33 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Lockdep dump, 2.6.30 repository head.
Date: Wed, 20 May 2009 12:50:25 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201250.29380.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git head @ 279e677faa775ad16e75c32e1bf4a37f8158bc61

Possible significant background - -
ehci_hcd driver flooding printk buffer (cause of flood is separate problem) - -
kernel/printk.c has some bit-rot, 
  causing problems handling message floods (separate problem) - -

kernel configured "tickless" disabled, "preempt" disabled, Uni-processor -
(required to work-around the printk.c problems)

usb 1-5: USB disconnect, address 3
ehci_hcd 0000:00:10.4: force halt; handhake dc724014 00004000 00004000 -> -19
irq 23: nobody cared (try booting with the "irqpoll" option)
Pid: 3281, comm: vlc Not tainted 2.6.30-rc6-ce1200v-09140db #19
Call Trace:
 [<c015db87>] __report_bad_irq+0x27/0x90
 [<c015dd47>] note_interrupt+0x157/0x1a0
 [<c015e64c>] handle_fasteoi_irq+0xac/0xe0
 [<c0104d64>] handle_irq+0x34/0x60
 [<c0104cd9>] do_IRQ+0x39/0x90
 [<c01033ee>] common_interrupt+0x2e/0x34
 [<c045ec5f>] ? tcp_v4_do_rcv+0xf/0x330
 [<c051ed97>] ? _spin_lock_nested+0x37/0x40
 [<c0461003>] tcp_v4_rcv+0x593/0x800
 [<c044406a>] ip_local_deliver_finish+0xca/0x1f0
 [<c0443fd0>] ? ip_local_deliver_finish+0x30/0x1f0
 [<c0444510>] ip_local_deliver+0x30/0xa0
 [<c0443dae>] ip_rcv_finish+0xfe/0x2f0
 [<c0444408>] ip_rcv+0x168/0x240
 [<c0443cb0>] ? ip_rcv_finish+0x0/0x2f0
 [<c04442a0>] ? ip_rcv+0x0/0x240
 [<c04206a3>] netif_receive_skb+0x313/0x5e0
 [<c04204b0>] ? netif_receive_skb+0x120/0x5e0
 [<c033f9d1>] rtl8139_poll+0x271/0x400
 [<c04236c7>] net_rx_action+0x167/0x1e0
 [<c04235ae>] ? net_rx_action+0x4e/0x1e0
 [<c01278e8>] __do_softirq+0x68/0x110
 [<c051ecbd>] ? _spin_unlock+0x1d/0x20
 [<c015e62c>] ? handle_fasteoi_irq+0x8c/0xe0
 [<c01279d6>] do_softirq+0x46/0x50
 [<c0127cf5>] irq_exit+0x35/0x40
 [<c0104ce2>] do_IRQ+0x42/0x90
 [<c0144cfe>] ? trace_hardirqs_on_caller+0xee/0x150
 [<c01033ee>] common_interrupt+0x2e/0x34
handlers:
[<c0355260>] (usb_hcd_irq+0x0/0x90)
Disabling IRQ #23

=================================
[ INFO: inconsistent lock state ]
2.6.30-rc6-ce1200v-09140db #19
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
pulseaudio/3088 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&irq_desc_lock_class){?.-...}, at: [<c015d9f8>] try_one_irq+0x18/0x110
{IN-HARDIRQ-W} state was registered at:
  [<c0147820>] __lock_acquire+0x8e0/0x9f0
  [<c014798c>] lock_acquire+0x5c/0x80
  [<c051edd2>] _spin_lock+0x32/0x40
  [<c015e7c8>] handle_level_irq+0x18/0xd0
  [<c0104d64>] handle_irq+0x34/0x60
  [<c0104cd9>] do_IRQ+0x39/0x90
  [<c01033ee>] common_interrupt+0x2e/0x34
  [<c015d3f7>] __setup_irq+0x177/0x250
  [<c015d5e1>] setup_irq+0x21/0x30
  [<c0723e1b>] x86_quirk_time_init+0x2b/0x30
  [<c0723d06>] hpet_time_init+0x16/0x20
  [<c0720ac0>] start_kernel+0x1e0/0x2f0
  [<c0720334>] i386_start_kernel+0x84/0x90
  [<ffffffff>] 0xffffffff
irq event stamp: 14245306
hardirqs last  enabled at (14245306): [<c051f162>] _spin_unlock_irq+0x22/0x30
hardirqs last disabled at (14245305): [<c051f0af>] _spin_lock_irq+0xf/0x50
softirqs last  enabled at (14245280): [<c012793b>] __do_softirq+0xbb/0x110
softirqs last disabled at (14245303): [<c01279d6>] do_softirq+0x46/0x50

other info that might help us debug this:
1 lock held by pulseaudio/3088:
 #0:  (kernel/irq/spurious.c:21){+.-...}, at: [<c012bae0>] run_timer_softirq+0xe0/0x200

stack backtrace:
Pid: 3088, comm: pulseaudio Not tainted 2.6.30-rc6-ce1200v-09140db #19
Call Trace:
 [<c01445bb>] print_usage_bug+0x16b/0x1b0
 [<c0144b66>] mark_lock+0x566/0x5a0
 [<c0145880>] ? check_usage_backwards+0x0/0xa0
 [<c0147240>] __lock_acquire+0x300/0x9f0
 [<c014798c>] lock_acquire+0x5c/0x80
 [<c015d9f8>] ? try_one_irq+0x18/0x110
 [<c051edd2>] _spin_lock+0x32/0x40
 [<c015d9f8>] ? try_one_irq+0x18/0x110
 [<c015d9f8>] try_one_irq+0x18/0x110
 [<c015db3b>] poll_spurious_irqs+0x4b/0x70
 [<c012bb81>] run_timer_softirq+0x181/0x200
 [<c012bae0>] ? run_timer_softirq+0xe0/0x200
 [<c015daf0>] ? poll_spurious_irqs+0x0/0x70
 [<c01278e8>] __do_softirq+0x68/0x110
 [<c0142287>] ? tick_program_event+0x17/0x20
 [<c0139b1e>] ? hrtimer_interrupt+0xbe/0x1b0
 [<c01279d6>] do_softirq+0x46/0x50
 [<c0127cf5>] irq_exit+0x35/0x40
 [<c0112fe7>] smp_apic_timer_interrupt+0x47/0x80
 [<c024c9f4>] ? trace_hardirqs_off_thunk+0xc/0x18
 [<c0103457>] apic_timer_interrupt+0x2f/0x34

Enjoy - this one is beyond my skill-level to fix.

Mike
