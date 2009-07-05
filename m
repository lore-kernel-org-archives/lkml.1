Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZGEWUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZGEWUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 18:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZGEWUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 18:20:45 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:51634 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZGEWUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 18:20:44 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: Null Pointer BUG in uhci_hcd
Date: Sun, 5 Jul 2009 17:20:43 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907051720.45819.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone with suggestions about this one?

root@cb01:~# dmesg
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 10, io base 0x00004400
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-ce1200v-09185 uhci_hcd
usb usb1: SerialNumber: 0000:00:10.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: HCRESET not completed yet!
uhci_hcd 0000:00:10.1: irq 11, io base 0x00004420
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-ce1200v-09185 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 0 ports detected
uhci_hcd 0000:00:10.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: HCRESET not completed yet!
uhci_hcd 0000:00:10.2: irq 10, io base 0x00004440
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-ce1200v-09185 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.2
uhci_hcd 0000:00:10.2: host system error, PCI problems?
uhci_hcd 0000:00:10.2: host controller process error, something bad happened!
uhci_hcd 0000:00:10.2: host controller halted, very bad!
uhci_hcd 0000:00:10.2: HCRESET not completed yet!
uhci_hcd 0000:00:10.2: HC died; cleaning up
uhci_hcd 0000:00:10.1: host system error, PCI problems?
uhci_hcd 0000:00:10.1: host controller process error, something bad happened!
uhci_hcd 0000:00:10.1: host controller halted, very bad!
uhci_hcd 0000:00:10.1: HCRESET not completed yet!
uhci_hcd 0000:00:10.1: HC died; cleaning up
usb usb3: configuration #1 chosen from 1 choice
usb usb3: can't set config #1, error -108
uhci_hcd 0000:00:10.2: HC died; cleaning up
BUG: unable to handle kernel NULL pointer dereference at 00000050
IP: [<c03ae8b1>] usb_kick_khubd+0x21/0x40
*pde = 00000000
Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:10.0/usb1/bmAttributes
Modules linked in: uhci_hcd(+) joydev i2c_viapro rtl8187 [last unloaded: ehci_hcd]

Pid: 3562, comm: modprobe Tainted: G        W  (2.6.30-ce1200v-09185 #5) Everex gBook Series
EIP: 0060:[<c03ae8b1>] EFLAGS: 00010046 CPU: 0
EIP is at usb_kick_khubd+0x21/0x40
EAX: 00000000 EBX: 00000282 ECX: d90db39b EDX: 00000000
ESI: d9e15000 EDI: 00000000 EBP: d9e15000 ESP: d0749d60
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process modprobe (pid: 3562, ti=d0748000 task=d9e1e370 task.ti=d0748000)
Stack:
 d90db39b c03b071c c06b0840 dc7e31a2 db473bf0 d90db39b 00000000 00004440
 c03b1515 c06b08ec dc7e31a2 db473bf0 0000000a c0694a4c 00004440 00000000
 00000080 0000000a c048c054 d0749dbf d63fe800 db473bf0 db49f85c d90db39b
Call Trace:
 [<c03b071c>] ? usb_hc_died+0x8c/0xb0
 [<c03b1515>] ? usb_add_hcd+0x595/0x600
 [<c048c054>] ? pcibios_set_master+0x34/0xd0
 [<c03bf485>] ? usb_hcd_pci_probe+0x1c5/0x2d0
 [<c01f728a>] ? sysfs_do_create_link+0xca/0x150
 [<c02a283a>] ? local_pci_probe+0x1a/0x40
 [<c02a39ca>] ? pci_device_probe+0x7a/0xa0
 [<c034653c>] ? driver_probe_device+0x8c/0x170
 [<c02a2aea>] ? pci_match_device+0xca/0x110
 [<c03466ab>] ? __driver_attach+0x8b/0xa0
 [<c0346620>] ? __driver_attach+0x0/0xa0
 [<c0345988>] ? bus_for_each_dev+0x48/0x80
 [<c02a2860>] ? pci_device_shutdown+0x0/0x40
 [<c0346372>] ? driver_attach+0x22/0x40
 [<c0346620>] ? __driver_attach+0x0/0xa0
 [<c034615b>] ? bus_add_driver+0x1db/0x250
 [<c02a2860>] ? pci_device_shutdown+0x0/0x40
 [<c0346b14>] ? driver_register+0x64/0x130
 [<dc7d5000>] ? uhci_hcd_init+0x0/0xe1 [uhci_hcd]
 [<c02a3cb2>] ? __pci_register_driver+0x42/0xc0
 [<dc7d5000>] ? uhci_hcd_init+0x0/0xe1 [uhci_hcd]
 [<dc7d508f>] ? uhci_hcd_init+0x8f/0xe1 [uhci_hcd]
 [<c010112e>] ? do_one_initcall+0x3e/0x1a0
 [<c015ba72>] ? sys_init_module+0xb2/0x1f0
 [<c010313b>] ? sysenter_do_call+0x12/0x26
Code: 74 26 00 8d bc 27 00 00 00 00 83 ec 04 65 8b 15 14 00 00 00 89 14 24 31 d2 8b 14 24 65 33 15 14 00 00 00 75 12 8b 80 20 01 00 00 <8b> 40 50 8b 40 64 59 e9 a3 d7 ff ff e8 2e ba d7 ff 8d b4 26 00
EIP: [<c03ae8b1>] usb_kick_khubd+0x21/0x40 SS:ESP 0068:d0749d60
CR2: 0000000000000050
---[ end trace 15ef77c17c582a97 ]---
note: modprobe[3562] exited with preempt_count 1
root@cb01:~# 
