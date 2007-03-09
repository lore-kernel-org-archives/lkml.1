Return-Path: <linux-kernel-owner+w=401wt.eu-S1161315AbXCIAKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161315AbXCIAKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161268AbXCIAKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:10:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161315AbXCIAKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:10:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.21-rc3-mm2: BUG: at drivers/pci/pci.c:679 pci_restore_state during suspend testing
Date: Fri, 9 Mar 2007 01:13:14 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703090113.14627.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following traces from 2.6.21-rc3-mm2 during the "resume" phase
of testing with 'echo test > /sys/power/disk && echo disk > /sys/power/state':

acpi thermal:00: resuming
pci 0000:00:00.0: resuming
pcieport-driver 0000:00:01.0: resuming
BUG: at drivers/pci/pci.c:679 pci_restore_state()

Call Trace:
 [<ffffffff803ab3e9>] pci_restore_state+0x229/0x270
 [<ffffffff803b10f9>] pcie_portdrv_restore_config+0x19/0x40
 [<ffffffff803b1171>] pcie_portdrv_resume+0x11/0x20
 [<ffffffff803ad92c>] pci_device_resume+0x2c/0x70
 [<ffffffff80411d41>] resume_device+0xe1/0x160
 [<ffffffff80411e69>] dpm_resume+0xa9/0x110
 [<ffffffff80411f18>] device_resume+0x48/0x60
 [<ffffffff802bb355>] pm_suspend_disk+0x235/0x250
 [<ffffffff802b99c5>] enter_state+0x65/0x250
 [<ffffffff802b9c2a>] state_store+0x7a/0xa0
 [<ffffffff80316734>] subsys_attr_store+0x24/0x30
 [<ffffffff803168a0>] sysfs_write_file+0x100/0x140
 [<ffffffff802181cf>] vfs_write+0xdf/0x180
 [<ffffffff80218d10>] sys_write+0x50/0x90
 [<ffffffff8026529e>] system_call+0x7e/0x83

PCI: Setting latency timer of device 0000:00:01.0 to 64
pcieport-driver 0000:00:02.0: resuming
BUG: at drivers/pci/pci.c:679 pci_restore_state()

Call Trace:
 [<ffffffff803ab3e9>] pci_restore_state+0x229/0x270
 [<ffffffff803b10f9>] pcie_portdrv_restore_config+0x19/0x40
 [<ffffffff803b1171>] pcie_portdrv_resume+0x11/0x20
 [<ffffffff803ad92c>] pci_device_resume+0x2c/0x70
 [<ffffffff80411d41>] resume_device+0xe1/0x160
 [<ffffffff80411e69>] dpm_resume+0xa9/0x110
 [<ffffffff80411f18>] device_resume+0x48/0x60
 [<ffffffff802bb355>] pm_suspend_disk+0x235/0x250
 [<ffffffff802b99c5>] enter_state+0x65/0x250
 [<ffffffff802b9c2a>] state_store+0x7a/0xa0
 [<ffffffff80316734>] subsys_attr_store+0x24/0x30
 [<ffffffff803168a0>] sysfs_write_file+0x100/0x140
 [<ffffffff802181cf>] vfs_write+0xdf/0x180
 [<ffffffff80218d10>] sys_write+0x50/0x90
 [<ffffffff8026529e>] system_call+0x7e/0x83

PCI: Setting latency timer of device 0000:00:02.0 to 64
agpgart-amd64 0000:00:04.0: resuming
pci 0000:00:05.0: resuming
PCI: Setting latency timer of device 0000:00:05.0 to 64
pci 0000:00:06.0: resuming
PCI: Setting latency timer of device 0000:00:06.0 to 64
pci 0000:00:07.0: resuming
pci 0000:00:07.1: resuming
Intel ICH 0000:00:08.0: resuming
ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 18 (level, low) -> IRQ 18
uli526x 0000:00:11.0: resuming
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:12.0: resuming
sata_uli 0000:00:12.1: resuming
ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: resuming
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.1: resuming
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:13.2: resuming
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:13.3: resuming
PCI: Enabling device 0000:00:13.3 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:13.3 to 64
PM: Writing back config space on device 0000:00:13.3 at offset f (was 20100400, writing 20100405)
PM: Writing back config space on device 0000:00:13.3 at offset 4 (was 0, writing ff6fe800)
PM: Writing back config space on device 0000:00:13.3 at offset 3 (was 804000, writing 802010)
PM: Writing back config space on device 0000:00:13.3 at offset 1 (was 2b00006, writing 2b00116)
pci 0000:00:18.0: resuming
pci 0000:00:18.1: resuming
pci 0000:00:18.2: resuming
k8temp 0000:00:18.3: resuming
pci 0000:01:00.0: resuming
BUG: at drivers/pci/pci.c:679 pci_restore_state()

Call Trace:
 [<ffffffff803ab3e9>] pci_restore_state+0x229/0x270
 [<ffffffff803ad93a>] pci_device_resume+0x3a/0x70
 [<ffffffff80411d41>] resume_device+0xe1/0x160
 [<ffffffff80411e69>] dpm_resume+0xa9/0x110
 [<ffffffff80411f18>] device_resume+0x48/0x60
 [<ffffffff802bb355>] pm_suspend_disk+0x235/0x250
 [<ffffffff802b99c5>] enter_state+0x65/0x250
 [<ffffffff802b9c2a>] state_store+0x7a/0xa0
 [<ffffffff80316734>] subsys_attr_store+0x24/0x30
 [<ffffffff803168a0>] sysfs_write_file+0x100/0x140
 [<ffffffff802181cf>] vfs_write+0xdf/0x180
 [<ffffffff80218d10>] sys_write+0x50/0x90
 [<ffffffff8026529e>] system_call+0x7e/0x83

pci 0000:01:00.1: resuming
BUG: at drivers/pci/pci.c:679 pci_restore_state()

Call Trace:
 [<ffffffff803ab3e9>] pci_restore_state+0x229/0x270
 [<ffffffff803ad93a>] pci_device_resume+0x3a/0x70
 [<ffffffff80411d41>] resume_device+0xe1/0x160
 [<ffffffff80411e69>] dpm_resume+0xa9/0x110
 [<ffffffff80411f18>] device_resume+0x48/0x60
 [<ffffffff802bb355>] pm_suspend_disk+0x235/0x250
 [<ffffffff802b99c5>] enter_state+0x65/0x250
 [<ffffffff802b9c2a>] state_store+0x7a/0xa0
 [<ffffffff80316734>] subsys_attr_store+0x24/0x30
 [<ffffffff803168a0>] sysfs_write_file+0x100/0x140
 [<ffffffff802181cf>] vfs_write+0xdf/0x180
 [<ffffffff80218d10>] sys_write+0x50/0x90
 [<ffffffff8026529e>] system_call+0x7e/0x83

8139too 0000:04:06.0: resuming
