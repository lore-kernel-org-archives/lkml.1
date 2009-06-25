Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZFYWuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZFYWuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbZFYWty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:49:54 -0400
Received: from vena.lwn.net ([206.168.112.25]:37594 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbZFYWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:49:52 -0400
Date: Thu, 25 Jun 2009 16:49:50 -0600
From: Jake Edge <jake@lwn.net>
To: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>, nico@cam.org,
       pierre@ossman.eu, saschasommer@freenet.de
Subject: errors when booting with SDCard present (2.6.31-rc1 and others)
Message-ID: <20090625164950.1157936f@chukar>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting some strange (to me anyway) errors in /var/log/messages
when I boot with an SD Card present in the card reader on my laptop ... 'irq 20: nobody cared' and 'inconsistent lock state' ... so far, I have reproduced similar behavior on 2.6.31-rc1, 2.6.30, 2.6.29, and a (slightly old) Fedora 11 kernel: 2.6.29.2-126.fc11.i586

(from 2.6.31-rc1)

It starts with an:

irq 20: nobody cared (try booting with the "irqpoll" option)

(irq 20 corresponds to a USB host controller) with the following backtrace:

Jun 25 15:42:19 ouzel kernel: Pid: 1093, comm: plymouthd Not tainted 2.6.31-rc1-jake #27
Jun 25 15:42:19 ouzel kernel: Call Trace:
Jun 25 15:42:19 ouzel kernel: [<c047db7c>] __report_bad_irq+0x33/0x74
Jun 25 15:42:19 ouzel kernel: [<c047dcb7>] note_interrupt+0xfa/0x153
Jun 25 15:42:19 ouzel kernel: [<c047e23d>] handle_fasteoi_irq+0x92/0xb5
Jun 25 15:42:19 ouzel kernel: [<c047e1ab>] ? handle_fasteoi_irq+0x0/0xb5
Jun 25 15:42:19 ouzel kernel: <IRQ>  [<c0404ad4>] ? do_IRQ+0x49/0x9c
Jun 25 15:42:19 ouzel kernel: [<c043df85>] ? __do_softirq+0x0/0x1bc
Jun 25 15:42:19 ouzel kernel: [<c0403aae>] ? common_interrupt+0x2e/0x34
Jun 25 15:42:19 ouzel kernel: [<c043df85>] ? __do_softirq+0x0/0x1bc
Jun 25 15:42:19 ouzel kernel: [<c045007b>] ? down_interruptible+0x19/0x3c
Jun 25 15:42:19 ouzel kernel: [<c043dfda>] ? __do_softirq+0x55/0x1bc
Jun 25 15:42:19 ouzel kernel: [<c043df85>] ? __do_softirq+0x0/0x1bc
Jun 25 15:42:19 ouzel kernel: <IRQ>  [<c043e405>] ? irq_exit+0x3d/0x75
Jun 25 15:42:19 ouzel kernel: [<c0417abd>] ? smp_apic_timer_interrupt+0x6c/0x7a
Jun 25 15:42:19 ouzel kernel: [<c049b888>] ? perf_swcounter_event+0xca/0x18a
Jun 25 15:42:19 ouzel kernel: [<c0403dbb>] ? apic_timer_interrupt+0x2f/0x34
Jun 25 15:42:19 ouzel kernel: [<c049b888>] ? perf_swcounter_event+0xca/0x18a
Jun 25 15:42:19 ouzel kernel: [<c045cc1b>] ? lock_acquire+0xce/0xdd
Jun 25 15:42:19 ouzel kernel: [<c049b888>] ? perf_swcounter_event+0xca/0x18a
Jun 25 15:42:19 ouzel kernel: [<c049b8c5>] ? perf_swcounter_event+0x107/0x18a
Jun 25 15:42:19 ouzel kernel: [<c049b888>] ? perf_swcounter_event+0xca/0x18a
Jun 25 15:42:19 ouzel kernel: [<c074d8d1>] ? do_page_fault+0x262/0x2d0
Jun 25 15:42:19 ouzel kernel: [<c074d66f>] ? do_page_fault+0x0/0x2d0
Jun 25 15:42:19 ouzel kernel: [<c074be4b>] ? error_code+0x6b/0x70
Jun 25 15:42:19 ouzel kernel: [<c074d66f>] ? do_page_fault+0x0/0x2d0
Jun 25 15:42:19 ouzel kernel: handlers:
Jun 25 15:42:19 ouzel kernel: [<c0667e65>] (usb_hcd_irq+0x0/0x8d)
Jun 25 15:42:19 ouzel kernel: [<c0667e65>] (usb_hcd_irq+0x0/0x8d)
Jun 25 15:42:19 ouzel kernel: Disabling IRQ #20

Then there are messages about an 'inconsistent lock state':

Jun 25 15:42:19 ouzel kernel: =================================
Jun 25 15:42:19 ouzel kernel: [ INFO: inconsistent lock state ]
Jun 25 15:42:19 ouzel kernel: 2.6.31-rc1-jake #27
Jun 25 15:42:19 ouzel kernel: ---------------------------------
Jun 25 15:42:19 ouzel kernel: inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
Jun 25 15:42:19 ouzel kernel: swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
Jun 25 15:42:19 ouzel kernel: (&irq_desc_lock_class){?.-...}, at: [<c047d9f8>] try_one_irq+0x1d/0xfa
Jun 25 15:42:19 ouzel kernel: {IN-HARDIRQ-W} state was registered at:
Jun 25 15:42:19 ouzel kernel:  [<c045bb1b>] __lock_acquire+0x20f/0xadc
Jun 25 15:42:19 ouzel kernel:  [<c045cc07>] lock_acquire+0xba/0xdd
Jun 25 15:42:19 ouzel kernel:  [<c074b3c9>] _spin_lock+0x2d/0x5d
Jun 25 15:42:19 ouzel kernel:  [<c047e27c>] handle_level_irq+0x1c/0xb3
Jun 25 15:42:19 ouzel kernel:  [<ffffffff>] 0xffffffff
Jun 25 15:42:19 ouzel kernel: irq event stamp: 435284
Jun 25 15:42:19 ouzel kernel: hardirqs last  enabled at (435284): [<c074ba1c>] _spin_unlock_irq+0x27/0x4f
Jun 25 15:42:19 ouzel kernel: hardirqs last disabled at (435283): [<c074b472>] _spin_lock_irq+0x17/0x68
Jun 25 15:42:19 ouzel kernel: softirqs last  enabled at (435270): [<c043e132>] __do_softirq+0x1ad/0x1bc
Jun 25 15:42:19 ouzel kernel: softirqs last disabled at (435281): [<c040543e>] do_softirq+0x6e/0xcc
Jun 25 15:42:19 ouzel kernel:
Jun 25 15:42:19 ouzel kernel: other info that might help us debug this:
Jun 25 15:42:19 ouzel kernel: 1 lock held by swapper/0:
Jun 25 15:42:19 ouzel kernel: #0:  (kernel/irq/spurious.c:21){+.-...}, at: [<c0441ab4>] run_timer_softirq+0xfc/0x1e6
Jun 25 15:42:19 ouzel kernel:
Jun 25 15:42:19 ouzel kernel: stack backtrace:
Jun 25 15:42:19 ouzel kernel: Pid: 0, comm: swapper Not tainted 2.6.31-rc1-jake #27
Jun 25 15:42:19 ouzel kernel: Call Trace:
Jun 25 15:42:19 ouzel kernel: [<c07490d2>] ? printk+0x14/0x1a
Jun 25 15:42:19 ouzel kernel: [<c045ac3d>] valid_state+0x12a/0x13d
Jun 25 15:42:19 ouzel kernel: [<c045ad41>] mark_lock+0xf1/0x1d9
Jun 25 15:42:19 ouzel kernel: [<c045b426>] ? check_usage_backwards+0x0/0x3f
Jun 25 15:42:19 ouzel kernel: [<c045bb89>] __lock_acquire+0x27d/0xadc
Jun 25 15:42:19 ouzel kernel: [<c047d9f8>] ? try_one_irq+0x1d/0xfa
Jun 25 15:42:19 ouzel kernel: [<c045cc07>] lock_acquire+0xba/0xdd
Jun 25 15:42:19 ouzel kernel: [<c047d9f8>] ? try_one_irq+0x1d/0xfa
Jun 25 15:42:19 ouzel kernel: [<c074b3c9>] _spin_lock+0x2d/0x5d
Jun 25 15:42:19 ouzel kernel: [<c047d9f8>] ? try_one_irq+0x1d/0xfa
Jun 25 15:42:19 ouzel kernel: [<c047d9f8>] try_one_irq+0x1d/0xfa
Jun 25 15:42:19 ouzel kernel: [<c047db05>] poll_all_shared_irqs+0x30/0x43
Jun 25 15:42:19 ouzel kernel: [<c047db25>] poll_spurious_irqs+0xd/0x22
Jun 25 15:42:19 ouzel kernel: [<c0441b29>] run_timer_softirq+0x171/0x1e6
Jun 25 15:42:19 ouzel kernel: [<c0441ab4>] ? run_timer_softirq+0xfc/0x1e6
Jun 25 15:42:19 ouzel kernel: [<c047db18>] ? poll_spurious_irqs+0x0/0x22
Jun 25 15:42:19 ouzel kernel: [<c043e068>] __do_softirq+0xe3/0x1bc
Jun 25 15:42:19 ouzel kernel: [<c043df85>] ? __do_softirq+0x0/0x1bc
Jun 25 15:42:19 ouzel kernel: <IRQ>  [<c043e405>] ? irq_exit+0x3d/0x75
Jun 25 15:42:19 ouzel kernel: [<c0404b13>] ? do_IRQ+0x88/0x9c
Jun 25 15:42:19 ouzel kernel: [<c0403aae>] ? common_interrupt+0x2e/0x34
Jun 25 15:42:19 ouzel kernel: [<c045007b>] ? down_interruptible+0x19/0x3c
Jun 25 15:42:19 ouzel kernel: [<c05f14cb>] ? acpi_idle_enter_simple+0x11e/0x14f
Jun 25 15:42:19 ouzel kernel: [<c06b0ea2>] ? cpuidle_idle_call+0x6a/0xa0
Jun 25 15:42:19 ouzel kernel: [<c0402609>] ? cpu_idle+0x58/0x8b
Jun 25 15:42:19 ouzel kernel: [<c0739884>] ? rest_init+0x6c/0x6e
Jun 25 15:42:19 ouzel kernel: [<c0942838>] ? start_kernel+0x316/0x31b
Jun 25 15:42:19 ouzel kernel: [<c0942071>] ? __init_begin+0x71/0x79

I seem to get none of this behavior when I boot without that card present ... it just has a VFAT filesystem, which seems to be in reasonable shape when I look at it ... the machine seems to run fine, but these messages don't look good ...

apologies if I cast too wide of a net on the email ... it is a Ricoh R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter according to lspci ...

further checking shows that I have CONFIG_MMC_SDRICOH_CS turned off, on my
kernels (not sure why), but that module is available for the Fedora kernel
which seems to have the same behavior.

any thoughts?

thanks,

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
