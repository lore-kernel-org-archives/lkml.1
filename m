Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbXJ3OdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbXJ3OdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXJ3OdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:33:07 -0400
Received: from mailout02.sul.t-online.de ([194.25.134.17]:36011 "EHLO
	mailout02.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbXJ3OdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:33:06 -0400
X-Greylist: delayed 1407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 10:33:05 EDT
Message-ID: <47273B13.5060603@t-online.de>
Date: Tue, 30 Oct 2007 15:09:23 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070919)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc1: usb problem?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Xp+vDsZ6whBOyHoCTdrKbEEtK2jgnfO6arDYaNUW0fFTOLfFEiBxPCmhZ0xl9Ylw5S
X-TOI-MSGID: 0bde1797-efce-4fa4-8c98-c13009606c9e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I found this call trace in /var/kern.log:

:
:
Oct 30 14:59:36 pluto kernel: usb 1-2: config 1 descriptor has 1 excess byte, ignoring
Oct 30 14:59:36 pluto kernel: usb 1-2: configuration #1 chosen from 1 choice
Oct 30 14:59:36 pluto kernel: usb 1-3: new high speed USB device using ehci_hcd and address 4
Oct 30 14:59:36 pluto kernel: usb 1-3: configuration #1 chosen from 1 choice
Oct 30 14:59:36 pluto kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Oct 30 14:59:36 pluto kernel: ata3.00: ATA-7: SAMSUNG SP2504C, VT100-41, max UDMA7
Oct 30 14:59:36 pluto kernel: ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Oct 30 14:59:36 pluto kernel: ata3.00: configured for UDMA/100
Oct 30 14:59:36 pluto kernel: usb 1-5: new high speed USB device using ehci_hcd and address 5
Oct 30 14:59:36 pluto kernel: usb 1-5: configuration #1 chosen from 1 choice
Oct 30 14:59:36 pluto kernel: usb 1-1.1: new high speed USB device using ehci_hcd and address 6
Oct 30 14:59:36 pluto kernel: usb 1-1.1: configuration #1 chosen from 1 choice
Oct 30 14:59:36 pluto kernel: hub 1-1.1:1.0: USB hub found
Oct 30 14:59:36 pluto kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Oct 30 14:59:36 pluto kernel: hub 1-1.1:1.0: 4 ports detected
Oct 30 14:59:36 pluto kernel: sysfs: duplicate filename 'bInterfaceNumber' can not be created
Oct 30 14:59:36 pluto kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Oct 30 14:59:36 pluto kernel:
Oct 30 14:59:36 pluto kernel: Call Trace:
Oct 30 14:59:36 pluto kernel:  [<ffffffff802d250e>] sysfs_add_one+0xae/0xe0
Oct 30 14:59:36 pluto kernel:  [<ffffffff802d1dff>] sysfs_add_file+0x5f/0xb0
Oct 30 14:59:36 pluto kernel:  [<ffffffff802d3dfc>] sysfs_create_group+0x6c/0x120
Oct 30 14:59:36 pluto kernel:  [<ffffffff880283e6>] :usbcore:usb_create_sysfs_intf_files+0x46/0x100
Oct 30 14:59:36 pluto kernel:  [<ffffffff88023e76>] :usbcore:usb_set_configuration+0x336/0x5f0
Oct 30 14:59:36 pluto kernel:  [<ffffffff8802cd8c>] :usbcore:generic_probe+0x7c/0xb0
Oct 30 14:59:36 pluto kernel:  [<ffffffff8037875b>] driver_probe_device+0x9b/0x1c0
Oct 30 14:59:36 pluto kernel:  [<ffffffff80378880>] __device_attach+0x0/0x10
Oct 30 14:59:36 pluto kernel:  [<ffffffff80377828>] bus_for_each_drv+0x58/0x80
Oct 30 14:59:36 pluto kernel:  [<ffffffff80378958>] device_attach+0x88/0x90
Oct 30 14:59:36 pluto kernel:  [<ffffffff80377785>] bus_attach_device+0x55/0xa0
Oct 30 14:59:36 pluto kernel:  [<ffffffff80376468>] device_add+0x528/0x690
Oct 30 14:59:36 pluto kernel:  [<ffffffff8801e2e5>] :usbcore:usb_new_device+0x55/0xa0
Oct 30 14:59:36 pluto kernel:  [<ffffffff8801f759>] :usbcore:hub_thread+0x749/0xe10
Oct 30 14:59:36 pluto kernel:  [<ffffffff80229083>] set_next_entity+0x23/0x50
Oct 30 14:59:36 pluto kernel:  [<ffffffff802456b0>] autoremove_wake_function+0x0/0x30
Oct 30 14:59:36 pluto kernel:  [<ffffffff8801f010>] :usbcore:hub_thread+0x0/0xe10
Oct 30 14:59:36 pluto kernel:  [<ffffffff8024523b>] kthread+0x4b/0x80
Oct 30 14:59:36 pluto kernel:  [<ffffffff8020c538>] child_rip+0xa/0x12
Oct 30 14:59:36 pluto kernel:  [<ffffffff802451f0>] kthread+0x0/0x80
Oct 30 14:59:36 pluto kernel:  [<ffffffff8020c52e>] child_rip+0x0/0x12
Oct 30 14:59:36 pluto kernel:
Oct 30 14:59:36 pluto kernel: ata4.00: ATAPI: TSSTcorpCD/DVDW SH-S183A, SB02, max UDMA/33
Oct 30 14:59:36 pluto kernel: ata4.00: applying bridge limits
Oct 30 14:59:36 pluto kernel: ata4.00: configured for UDMA/33
Oct 30 14:59:36 pluto kernel: scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
Oct 30 14:59:36 pluto kernel: usb 1-1.1.1: new high speed USB device using ehci_hcd and address 7
Oct 30 14:59:36 pluto kernel: scsi 3:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S183A SB02 PQ: 0 ANSI: 5
Oct 30 14:59:36 pluto kernel: ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
Oct 30 14:59:36 pluto kernel: ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
:
:

uname says:
Linux pluto 2.6.24-rc1 #1 PREEMPT Sat Oct 27 22:56:02 CEST 2007 x86_64 GNU/Linux

Is this anything to worry about? Please mail if I can help to track this
down.


Regards

Harri

