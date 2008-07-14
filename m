Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYGNN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYGNN7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYGNN7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:59:10 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:59029 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753472AbYGNN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:59:09 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 09:59:09 EDT
Date: Mon, 14 Jul 2008 09:51:08 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080714135108.GA9197@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Is anyone able to boot the 2.6.26rc9git9 or 2.6.26rc9git12
kernels on a Macintel machine? On my MacBook Pro (second gen with
rEFIt installed for dual booting), I find that MMCONFIG doesn't
seem to be in use under the 2.6.26 kernels. I get the following
hang when booting rc9git9 or rc9git12...

ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG
PCI: Using configuration type 1 for base access
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received switching to interrupt mode
ACPI: BIOS_OSI (Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
PCI: Not using MMCONFIG
ACPI: EC:GPE=0x17, I/O: command/status=0x66, data=0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO

This compares to the same section in a normal boot of 2.6.25.10...

ACPI: bus type pci registered
PCI: Using MMCONFIG at f0000000 - ffffffff
PCI: Using configuration type 1
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
ACPI: EC: non-query interrupt received, switching to interrupt mode
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing

..etc. My understanding is that the EFI in use on Macintel requires the
use of MMCONFIG so the boot failure isn't surprising but the absence of
MMCONFIG is.
                   Jack
