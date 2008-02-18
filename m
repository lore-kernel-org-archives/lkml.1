Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbYBRUwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbYBRUwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYBRUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:37877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753450AbYBRUw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:29 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18h8wlNpvMhn3GBuN1dfzDZokpatjmqqeQiM91aKW
	RuZPVVBKJknn4s
Date: Mon, 18 Feb 2008 21:52:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Greg KH <greg@kroah.com>
Subject: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
getting the following warnings (with a bit of context):

* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
pci 0000:00:14.3: quirk: region f800-f83f claimed by PIIX4 ACPI
pci 0000:00:14.3: quirk: region fc00-fc0f claimed by PIIX4 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: IRQ 5 override to level, low
PCI: setting IRQ 5 as level-triggered
pnp: IRQ 4 override to level, low
PCI: setting IRQ 4 as level-triggered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
PCI: Probing PCI hardware
kobject (c7c35b00): tried to init an initialized object, something is seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2 #6
 [<c01edef9>] kobject_init+0x89/0x90
 [<c025115e>] device_initialize+0x1e/0x90
 [<c0251a0b>] device_register+0xb/0x20
 [<c01f7c18>] pci_bus_add_devices+0x98/0x140
 [<c030c377>] ? pcibios_scan_root+0x27/0xa0
 [<c03f6b40>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c01041aa>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0104eaf>] kernel_thread_helper+0x7/0x18
 =======================
sysfs: duplicate filename '0000:01' can not be created
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one+0x80/0xa0()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc2 #6
 [<c0123584>] warn_on_slowpath+0x54/0x70
 [<c0123c4c>] ? __call_console_drivers+0x5c/0x70
 [<c0314cf1>] ? _spin_unlock_irqrestore+0x11/0x30
 [<c0123f09>] ? release_console_sem+0x1d9/0x1f0
 [<c012438d>] ? vprintk+0x2ad/0x3b0
 [<c01ed5b9>] ? ida_get_new_above+0x89/0x180
 [<c01ae230>] ? sysfs_ilookup_test+0x0/0x20
 [<c0314c4f>] ? _spin_unlock+0xf/0x30
 [<c01845ca>] ? ifind+0x8a/0x90
 [<c01244ab>] ? printk+0x1b/0x20
 [<c01ae5c0>] sysfs_add_one+0x80/0xa0
 [<c01aeaf9>] create_dir+0x49/0x90
 [<c01aeb6b>] sysfs_create_dir+0x2b/0x50
 [<c01ee1ee>] kobject_add_internal+0xae/0x190
 [<c01ee34d>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ee34d>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ee3af>] kobject_add_varg+0x4f/0x60
 [<c01ee69f>] kobject_add+0x2f/0x60
 [<c01ee0b2>] ? kobject_get+0x12/0x20
 [<c0251587>] device_add+0xd7/0x550
 [<c01eeded>] ? kref_init+0xd/0x10
 [<c01ede9b>] ? kobject_init+0x2b/0x90
 [<c0251a12>] device_register+0x12/0x20
 [<c01f7c18>] pci_bus_add_devices+0x98/0x140
 [<c030c377>] ? pcibios_scan_root+0x27/0xa0
 [<c03f6b40>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c01041aa>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0104eaf>] kernel_thread_helper+0x7/0x18
 =======================
---[ end trace ca143223eefdc828 ]---
kobject_add_internal failed for 0000:01 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2 #6
 [<c01ee279>] kobject_add_internal+0x139/0x190
 [<c01ee34d>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ee3af>] kobject_add_varg+0x4f/0x60
 [<c01ee69f>] kobject_add+0x2f/0x60
 [<c01ee0b2>] ? kobject_get+0x12/0x20
 [<c0251587>] device_add+0xd7/0x550
 [<c01eeded>] ? kref_init+0xd/0x10
 [<c01ede9b>] ? kobject_init+0x2b/0x90
 [<c0251a12>] device_register+0x12/0x20
 [<c01f7c18>] pci_bus_add_devices+0x98/0x140
 [<c030c377>] ? pcibios_scan_root+0x27/0xa0
 [<c03f6b40>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c01041aa>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0104eaf>] kernel_thread_helper+0x7/0x18
 =======================
pci 0000:00:01.0: Error registering pci_bus device bridge symlink, continuing...
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:14.0
PCI->APIC IRQ transform: 0000:00:0b.0[A] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:0c.0[A] -> IRQ 20
PCI->APIC IRQ transform: 0000:00:0d.0[B] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:0d.1[C] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:0d.2[D] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:0d.3[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:0e.0[A] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:0f.0[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:0f.1[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:10.0[A] -> IRQ 16
PCI: using PPB 0000:00:01.0[A] to get irq 22
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 22
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
system 00:0b: iomem range 0x0-0x9ffff could not be reserved
system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
system 00:0b: iomem range 0x100000-0xffffff could not be reserved
system 00:0b: iomem range 0xfffc0000-0xffffffff could not be reserved
system 00:0c: ioport range 0x15c-0x15d has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x77e-0x77f has been reserved
system 00:0c: ioport range 0xc06-0xc07 has been reserved
system 00:0c: ioport range 0xc50-0xc51 has been reserved
system 00:0c: ioport range 0xc70-0xc77 has been reserved
system 00:0c: ioport range 0xc82-0xc82 has been reserved
system 00:0d: ioport range 0xf800-0xf81f has been reserved
system 00:0d: ioport range 0xf820-0xf83f has been reserved
system 00:0d: ioport range 0xfc00-0xfc0f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0x50000000-0x510fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2

lspci:

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 02)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 02)
00:0b.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 04)
00:0c.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 05)
00:0d.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:0d.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:0d.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:0d.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
00:0e.0 SCSI storage controller: Tekram Technology Co.,Ltd. TRM-S1040 (rev 01)
00:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
00:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
00:10.0 SCSI storage controller: Advanced Micro Devices [AMD] 53c974 [PCscsi] (rev 10)
00:14.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:14.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:14.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:14.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
01:00.0 VGA compatible controller: Texas Instruments TVP4020 [Permedia 2] (rev 11)

Please say if .config is needed, although, theres nothing extraordinary 
there wrt PCI / ACPI. Booting with "acpi=noirq".

Thanks
Guennadi
---
Guennadi Liakhovetski
