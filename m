Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXEUGXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXEUGXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXEUGXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:23:04 -0400
Received: from nn7.de ([85.214.94.156]:40571 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXEUGXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:23:03 -0400
Subject: 2.6.22-rc2 BUG: at include/linux/slub_def.h:77 kmalloc_index()
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 08:22:59 +0200
Message-Id: <1179728579.11803.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a regression (well I switched to slub) happens on boot...

...
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004040
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-4: new high speed USB device using ehci_hcd and address 3
BUG: at include/linux/slub_def.h:77 kmalloc_index()
 [<c0176448>] get_slab+0x1c8/0x250
 [<c02f18f4>] usb_get_configuration+0x854/0xfa0
 [<c01778ec>] __kmalloc_track_caller+0x1c/0x80
 [<c0162e2a>] __kzalloc+0x1a/0x50
 [<c02f18f4>] usb_get_configuration+0x854/0xfa0
 [<c02ee560>] usb_start_wait_urb+0x70/0xb0
 [<c02e9250>] hub_port_init+0x90/0x5f0
 [<c02ea2e4>] usb_new_device+0x14/0x100
 [<c02eae2b>] hub_thread+0x5ab/0xc30
 [<c013f710>] autoremove_wake_function+0x0/0x50
 [<c02ea880>] hub_thread+0x0/0xc30
 [<c013f432>] kthread+0x42/0x70
 [<c013f3f0>] kthread+0x0/0x70
 [<c0104df3>] kernel_thread_helper+0x7/0x14
 =======================
usb 1-4: configuration #1 chosen from 1 choice
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
usb 4-2: new full speed USB device using uhci_hcd and address 2
...
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
