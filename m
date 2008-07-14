Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYGNRCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYGNRCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYGNRCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:02:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49058 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYGNRCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:02:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 14 Jul 2008 19:02:15 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080714135108.GA9197@bromo.msbb.uc.edu>
Message-ID: <tkrat.392407daaf07e315@s5r6.in-berlin.de>
References: <20080714135108.GA9197@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Howarth wrote:
>    Is anyone able to boot the 2.6.26rc9git9 or 2.6.26rc9git12
> kernels on a Macintel machine? On my MacBook Pro (second gen with
> rEFIt installed for dual booting), I find that MMCONFIG doesn't
> seem to be in use under the 2.6.26 kernels. I get the following
> hang when booting rc9git9 or rc9git12...
> 
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> PCI: Not using MMCONFIG
> PCI: Using configuration type 1 for base access
> ACPI: EC: EC description table is found, configuring boot EC
> ACPI: EC: non-query interrupt received switching to interrupt mode
> ACPI: BIOS_OSI (Linux) query ignored via DMI
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
> PCI: Not using MMCONFIG
> ACPI: EC:GPE=0x17, I/O: command/status=0x66, data=0x62
> ACPI: EC: driver started in interrupt mode
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> 
> This compares to the same section in a normal boot of 2.6.25.10...
> 
> ACPI: bus type pci registered
> PCI: Using MMCONFIG at f0000000 - ffffffff
> PCI: Using configuration type 1
> ACPI: EC: EC description table is found, configuring boot EC
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> ACPI: BIOS _OSI(Linux) query ignored via DMI
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in poll mode
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> PCI: Transparent bridge - 0000:00:1e.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[...]
> ..etc. My understanding is that the EFI in use on Macintel requires the
> use of MMCONFIG so the boot failure isn't surprising but the absence of
> MMCONFIG is.

I have no idea...  Here is a Mac mini which just booted 2.6.26 x86-64:

ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
ACPI: EC: EC description table is found, configuring boot EC
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
[...]

There is a CONFIG_PCI_MMCONFIG=y in its .config, FWIW.  I too have rEFIt
installed on this mini.  dmidecode says it is a Macmini1,1.
-- 
Stefan Richter
-=====-==--- -=== -===-
http://arcgraph.de/sr/

