Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZFBRYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZFBRYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZFBRYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:24:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:44007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZFBRYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:24:40 -0400
Message-ID: <4A256050.2020305@kernel.org>
Date: Tue, 02 Jun 2009 10:24:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>
CC: linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
References: <1243625720.4426.0.camel@plop>  <4A203BFD.7040000@kernel.org> <1243949325.19053.100.camel@plop>
In-Reply-To: <1243949325.19053.100.camel@plop>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> Le vendredi 29 mai 2009 à 12:48 -0700, Yinghai Lu a écrit :
>> Pascal Terjan wrote:
>>> (Resending because of wrong To:, sorry for the duplicate)
>>>
>>> We have a machine here where hard disk is no longer detected at boot
>>> time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
>>> not on the same one with HIGHMEM64G). 
>>>
>>> Motherboard is ECS PF22 Extreme
>>>
>>> bisect blames this commit:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316
>>>
>> boot log with debug please.
>>
> 
> Linux version 2.6.29.2 (a@qadev1.mandriva.com) (gcc version 4.3.2
> (GCC) ) #6 SMP Fri May 29 17:35:31 CEST 2009
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
>  BIOS-e820: 000000001ffc0000 - 000000001ffce000 (ACPI data)
>  BIOS-e820: 000000001ffce000 - 000000001fff0000 (ACPI NVS)
>  BIOS-e820: 000000001fff0000 - 0000000020000000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
...
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> PCI: Not using MMCONFIG.
> PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
> PCI: Using MMCONFIG for extended config space
> pci 0000:00:1d.7: reg 10 32bit mmio: [0xfebff800-0xfebffbff]
> pci 0000:00:1f.2: reg 24 32bit mmio: [0xfebffc00-0xfebfffff]
> pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfcffffff]
> pci 0000:01:00.0: reg 1c 64bit mmio: [0xfa000000-0xfbffffff]
> pci 0000:01:00.0: reg 30 32bit mmio: [0xfde80000-0xfdefffff]
> pci 0000:00:01.0: bridge 32bit mmio: [0xf7e00000-0xfdefffff]
> pci 0000:03:00.0: reg 10 32bit mmio: [0xfe7e0000-0xfe7fffff]
> pci 0000:03:00.0: reg 14 32bit mmio: [0xfe000000-0xfe3fffff]
> pci 0000:00:1c.4: bridge 32bit mmio: [0xfdf00000-0xfe7fffff]
> pci 0000:04:00.0: reg 10 64bit mmio: [0xfe9ffc00-0xfe9ffc7f]
> pci 0000:04:00.0: reg 18 64bit mmio: [0xfe9f8000-0xfe9fbfff]
> pci 0000:04:00.0: reg 30 32bit mmio: [0xfe900000-0xfe97ffff]
> pci 0000:05:05.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff4ff]
> pci 0000:05:05.0: reg 30 32bit mmio: [0xfeac0000-0xfeadffff]
> pci 0000:00:1e.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]

> PnPBIOS: Disabled by ACPI PNP
> system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
> system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
> system 00:07: iomem range 0xfed20000-0xfed8ffff has been reserved
> system 00:09: iomem range 0xffc00000-0xfff7ffff has been reserved
> system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
> system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
> system 00:0e: iomem range 0xf0000000-0xf3ffffff has been reserved
> system 00:0f: iomem range 0x100000-0x1fffffff could not be reserved

> ahci 0000:00:1f.2: version 3.0
> ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> ahci 0000:00:1f.2: BAR 5: can't reserve mem region
> [0xfebffc00-0xfebfffff]
> ahci: probe of 0000:00:1f.2 failed with error -16
> scsi0 : ata_piix
> scsi1 : ata_piix
> sata_sil24 0000:04:00.0: version 1.1
> sata_sil24 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> sata_sil24 0000:04:00.0: BAR 0: can't reserve mem region
> [0xfe9ffc00-0xfe9ffc7f]
> sata_sil24 0000:04:00.0: PCI INT A disabled
> sata_sil24: probe of 0000:04:00.0 failed with error -16
> ohci1394 0000:05:04.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> ohci1394: MMIO resource (0xfeaff800 - 0xfeb00000) unavailable
> ohci1394: probe of 0000:05:04.0 failed with error -12
...

looks like MMCONFIG get enabled somehow with that patch.
it should not be used [0xf0000000 - 0xffffffff] for bus [0,0xff]

can you check if the mmconf was enabled with previous version?

YH
