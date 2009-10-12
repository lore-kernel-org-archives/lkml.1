Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbZJLTrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbZJLTrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZJLTrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:47:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:53375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019AbZJLTrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:47:16 -0400
Message-ID: <4AD38734.2040600@kernel.org>
Date: Mon, 12 Oct 2009 12:44:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden
 code
References: <200908072333.24631.storm@sys49152.net> <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org> <200910121059.10366.bjorn.helgaas@hp.com> <4AD37CA4.90601@kernel.org> <20091012192242.GA2691@elte.hu>
In-Reply-To: <20091012192242.GA2691@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>> This feels like a hack that accidentally covers up the problem.  I 
>>> don't think we understand what's happening well enough.
>> yes, we need to figure out why when acpi=on, those BAR are cleared, 
>> before pci code try to scan and read BAR. (node early pic print out 
>> untouched, but after APCI subsystem is enabled, those BAR got 
>> clearred)
> 
> I'm wondering, how did it get cleared - some AML script told the kernel 
> to clear it?


[    0.012392] ACPI: Core revision 20090521
...
[    0.117217] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.117223] ACPI: bus type pci registered
[    0.117292] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.117297] PCI: Not using MMCONFIG.
[    0.117301] PCI: Using configuration type 1 for base access
[    0.118064] bio: create slab <bio-0> at 0
[    0.118995] ACPI: EC: Look up EC in DSDT
[    0.125066] ACPI: BIOS _OSI(Linux) query ignored
[    0.127077] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.632002] ACPI: EC: missing confirmations, switch off interrupt mode.
[    0.793109] ACPI: Interpreter enabled
[    0.793114] ACPI: (supports S0 S3 S4 S5)
[    0.793139] ACPI: Using IOAPIC for interrupt routing
[    0.793193] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.795871] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.806419] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.812767] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.812772] ACPI: EC: driver started in poll mode
[    0.813206] ACPI: No dock devices found.
[    0.813879] ACPI: PCI Root Bridge [PCI0] (0000:00)

could be ACPI EC AML code related.

because with pci=nommconf, the BARs still get cleared.

need the reporter to boot with acpi.debug_layer=0x400000 acpi.debug_level=
to get more info

YH
