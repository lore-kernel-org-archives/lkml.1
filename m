Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbXI2Jhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbXI2Jhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXI2Jhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:37:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:19780 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXI2Jhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aXVNDU6pjcQpOETUAp5L5D36X2qRql4aqg6ZFLP4HqSLDZV5YfMGJdH51hvwISEeugdCe8YJXXryrxne724eUA0xIg7800dyhjGgvoVu4+8LZm78PoaNCqsSOmDRQ0kIj1qDNr3dWmYRdRvmC7Bzf4s8ni0DcVFiuYvbjR0B2ms=
Message-ID: <a8e1da0709290237p593c57f1t6b6464dc27d0ab0a@mail.gmail.com>
Date: Sat, 29 Sep 2007 17:37:29 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-mm2
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The kernel report warnings about sysfs filename duplicate under
rc8-mm1 and rc8-mm2.
 1.
----cut----
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb93e, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
sysfs: duplicate filename 'usbcore' can not be created
WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
 [<c010528f>] dump_trace+0x1bf/0x1d0
 [<c0105358>] show_trace_log_lvl+0x18/0x30
 [<c010537f>] show_trace+0xf/0x20
 [<c01054a2>] dump_stack+0x12/0x20
 [<c01c6680>] sysfs_add_one+0xa0/0xe0
 [<c01c69e8>] create_dir+0x48/0xb0
 [<c01c6a99>] sysfs_create_dir+0x29/0x50
 [<c02501eb>] create_dir+0x1b/0x50
 [<c02504b6>] kobject_add+0x46/0x150
 [<c05a38a0>] kernel_param_sysfs_setup+0x50/0xb0
 [<c05a39ee>] param_sysfs_builtin+0xee/0x130
 [<c05a3a54>] param_sysfs_init+0x24/0x60
 [<c0592866>] do_initcalls+0x46/0x1e0
 [<c0592aa2>] kernel_init+0x62/0xb0
 [<c0104fb3>] kernel_thread_helper+0x7/0x14
 =======================
kobject_add failed for usbcore with -EEXIST, don't try to register
things with the same name in the same directory.
 [<c010528f>] dump_trace+0x1bf/0x1d0
 [<c0105358>] show_trace_log_lvl+0x18/0x30
 [<c010537f>] show_trace+0xf/0x20
 [<c01054a2>] dump_stack+0x12/0x20
 [<c0250566>] kobject_add+0xf6/0x150
 [<c05a38a0>] kernel_param_sysfs_setup+0x50/0xb0
 [<c05a39ee>] param_sysfs_builtin+0xee/0x130
 [<c05a3a54>] param_sysfs_init+0x24/0x60
 [<c0592866>] do_initcalls+0x46/0x1e0
 [<c0592aa2>] kernel_init+0x62/0xb0
 [<c0104fb3>] kernel_thread_helper+0x7/0x14
 =======================
Module 'usbcore' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: EC: Look up EC in DSDT



2.
----cut----
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 18, io mem 0xffa80800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.23-rc8-mm2 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 18, io base 0x0000ff80
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.23-rc8-mm2 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ff60
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.23-rc8-mm2 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000ff40
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.23-rc8-mm2 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 21, io base 0x0000ff20
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
usb usb5: new device found, idVendor=0000, idProduct=0000
usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.23-rc8-mm2 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
sysfs: duplicate filename 'bInterfaceNumber' can not be created
WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
 [<c010528f>] dump_trace+0x1bf/0x1d0
 [<c0105358>] show_trace_log_lvl+0x18/0x30
 [<c010537f>] show_trace+0xf/0x20
 [<c01054a2>] dump_stack+0x12/0x20
 [<c01c6680>] sysfs_add_one+0xa0/0xe0
 [<c01c5afe>] sysfs_add_file+0x4e/0xb0
 [<c01c7cc1>] create_files+0x31/0x60
 [<c01c7d24>] sysfs_create_group+0x34/0xf0
 [<c034420a>] usb_create_sysfs_intf_files+0x2a/0xb0
 [<c03401fc>] usb_set_configuration+0x3dc/0x490
 [<c0347eb6>] generic_probe+0x76/0xb0
 [<c03405c8>] usb_probe_device+0x38/0x40
 [<c02bc974>] really_probe+0xa4/0x160
 [<c02bca82>] driver_probe_device+0x42/0x60
 [<c02bbb0a>] bus_for_each_drv+0x3a/0x60
 [<c02bcafc>] device_attach+0x4c/0x80
 [<c02bbdd5>] bus_attach_device+0x75/0xb0
 [<c02ba286>] device_add+0x136/0x350
 [<c0339c80>] usb_new_device+0x50/0x160
 [<c033b2ab>] hub_port_connect_change+0x1bb/0x3b0
 [<c033b6d2>] hub_events+0x232/0x470
 [<c033b931>] hub_thread+0x21/0x170
 [<c013fe89>] kthread+0x59/0xa0
 [<c0104fb3>] kernel_thread_helper+0x7/0x14
 =======================
usb 1-1: new device found, idVendor=0424, idProduct=2504
usb 1-1: new device strings: Mfr=0, Product=0, SerialNumber=0
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
usb 4-1: new device found, idVendor=0461, idProduct=4d15
usb 4-1: new device strings: Mfr=0, Product=2, SerialNumber=0
usb 4-1: Product: USB Optical Mouse
usb 4-2: new low speed USB device using uhci_hcd and address 3
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: new device found, idVendor=413c, idProduct=2003
usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: Dell USB Keyboard
usb 4-2: Manufacturer: Dell
usb 1-1.4: new full speed USB device using ehci_hcd and address 5
usb 1-1.4: configuration #1 chosen from 1 choice
usb 1-1.4: new device found, idVendor=0c10, idProduct=0000
usb 1-1.4: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.4: Product: SiW
usb 1-1.4: Manufacturer: SiW
usb 1-1.4: SerialNumber: E344F1EF1300
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
----cut----

lsusb output:

Bus 1 Device 2: ID 0424:2504 Standard Microsystems Corp.
Bus 1 Device 5: ID 0c10:0000
Bus 1 Device 1: ID 0000:0000
Bus 4 Device 3: ID 413c:2003 Dell Computer Corp.
Bus 4 Device 1: ID 0000:0000
Bus 4 Device 2: ID 0461:4d15 Primax Electronics, Ltd
Bus 2 Device 1: ID 0000:0000
Bus 5 Device 1: ID 0000:0000
Bus 3 Device 1: ID 0000:0000

Regards
dave
