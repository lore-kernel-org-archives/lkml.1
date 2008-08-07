Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbYHGOAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbYHGOAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYHGN7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:59:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41557 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYHGN7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:59:49 -0400
Date: Thu, 7 Aug 2008 09:59:48 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: New bug with 2.6.25-rt7
Message-ID: <alpine.LNX.1.10.0808061916000.6682@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I get the following traces time and again from 2.6.25-rt7. This did not 
happen with -rt6.

BUG: scheduling with irqs disabled: IRQ-21/0x00000000/261
caller is rt_spin_lock_slowlock+0x1c7/0x2a0

[Frame pointers and stack unwinding enabled in .config]
Pid: 261, comm: IRQ-21 Tainted: G        N 2.6.25.14-jen67-rt #1
Call Trace:
 [<ffffffff8020e26c>] dump_trace+0x5ec/0x620
 [<ffffffff8020e2f5>] show_trace+0x55/0x80
 [<ffffffff804b69f8>] dump_stack+0x72/0x7b
 [<ffffffff804b7d92>] schedule+0x102/0x110
 [<ffffffff804b9047>] rt_spin_lock_slowlock+0x1c7/0x2a0
 [<ffffffff804ba32d>] __rt_spin_lock+0x5d/0x60
 [<ffffffff804ba339>] rt_spin_lock+0x9/0x10
 [<ffffffff802c6ff2>] kmem_cache_free+0x42/0x80
 [<ffffffff88165a89>] :uhci_hcd:uhci_free_urb_priv+0x79/0xd0
 [<ffffffff88165b67>] :uhci_hcd:uhci_giveback_urb+0x87/0x240
 [<ffffffff881661c5>] :uhci_hcd:uhci_scan_schedule+0x355/0xab0
 [<ffffffff8816896a>] :uhci_hcd:uhci_irq+0x8a/0x190
 [<ffffffff88136cda>] :usbcore:usb_hcd_irq+0x4a/0xa0
 [<ffffffff8028db9d>] handle_IRQ_event+0x6d/0x130
 [<ffffffff8028dfea>] thread_simple_irq+0x6a/0xd0
 [<ffffffff8028e268>] do_irqd+0x218/0x380
 [<ffffffff80258089>] kthread+0x49/0x90
 [<ffffffff8020d698>] child_rip+0xa/0x12


           CPU0       CPU1       
  0:        362          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  4:          5          0   IO-APIC-edge    
  6:         30          0   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  8:   15570502          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 14:     228042          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:     940164          0   IO-APIC-fasteoi   HDA Intel
 18:          3          0   IO-APIC-fasteoi   uhci_hcd:usb4, ohci1394
 21:     297215          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb2
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
4346:     950261          0   PCI-MSI-edge      eth0
4347:     229217          0   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:   11474137   11575655   Local timer interrupts
RES:     371031    1059205   Rescheduling interrupts
CAL:    1070281    1087689   function call interrupts
TLB:      29799      22201   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

# lsusb -t
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
    |__ Port 1: Dev 2, If 0, Class=HID, Driver=usbhid, 1.5M
    |__ Port 2: Dev 3, If 0, Class=HID, Driver=usbhid, 1.5M
