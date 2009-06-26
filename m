Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbZFZTTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbZFZTTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZFZTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:19:33 -0400
Received: from outbound-mail-320.bluehost.com ([67.222.54.252]:45164 "HELO
	outbound-mail-320.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752471AbZFZTT3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:19:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hVMUautmLMqKrpxQBCEhO3ziqBJuGEUP5Xq+LWmvB9H0yEAd9ppJ1psYDmoclKEbJozXN/UHvEeC7n0SAGMcnm+dD5LRARdzmeCsjtPjcBTehAzuIsGNtlsV3GALe+ej;
Date: Fri, 26 Jun 2009 12:19:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Alex Chiang <achiang@hp.com>, lenb@kernel.org, twmoure@szypr.net,
       alessandro.suardi@gmail.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 11/12] ACPI: video: convert to acpi_get_pci_dev
Message-ID: <20090626121926.12fccba0@jbarnes-g45>
In-Reply-To: <81b0412b0906260528j229f7e05i3c473fbdb643a2dd@mail.gmail.com>
References: <20090610194714.28982.51363.stgit@bob.kio>
	<20090610195600.28982.3404.stgit@bob.kio>
	<81b0412b0906251538j2614bf91ya2edbaf120796dfc@mail.gmail.com>
	<20090625230535.GE1723@ldl.fc.hp.com>
	<81b0412b0906260356p12fd7807y40223175bf785cc0@mail.gmail.com>
	<81b0412b0906260528j229f7e05i3c473fbdb643a2dd@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 14:28:29 +0200
Alex Riesen <raa.lkml@gmail.com> wrote:

> 2009/6/26 Alex Riesen <raa.lkml@gmail.com>:
> > 2009/6/26 Alex Chiang <achiang@hp.com>:
> >> Thanks for the bug report and sorry for the troubles.
> >>
> >> I've already got a debug patch here:
> >>
> >>        http://thread.gmane.org/gmane.linux.kernel/857228/focus=857468
> >>
> >> Perhaps you can try it too?
> >
> > Will do soon.
> >
> 
> Done, dmesg attached.

Here's the output from my machine, including ACPI paths (summary of not
found stuff at the top):

...
[    0.177188] + Adding \_SB_.PCI0.AGP_
[    0.177294] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.177407] Searching for 0000:00:01.0...not found
...
[    0.179259] + Adding \_SB_.PCI0.EXP2
[    0.179364] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.179477] Searching for 0000:00:1c.2...not found
...
[    0.180128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.180200] Starting root bridge search from \_SB_.PCI0.EXP3.EXUP
[    0.180310] + Adding \_SB_.PCI0.EXP3.EXUP
[    0.180418] + Adding \_SB_.PCI0.EXP3
[    0.180523] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.180636] Searching for 0000:00:1c.3...found
[    0.180787] Searching for 0000:05:00.0...not found
...

So looks like one is an express slot, another is the AGP this machine
lacks, and then there's this 05:00.0; not sure what that is.

At any rate, it does appear we have to take care not to assume
*everything* in the ACPI tree has an associated PCI dev, since
namespaces could be shared accross different platforms with just enable
or present bits to mask them out from the initial PCI scan.

Jesse

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc1 (jbarnes@jbarnes-x200) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #5 SMP Fri Jun 26 12:12:14 PDT 2009
[    0.000000] Command line: root=/dev/sda1 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdc00 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  modified: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  modified: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  modified: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  modified: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  modified: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  modified: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  modified: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  modified: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  modified: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  modified: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  modified: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  modified: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  modified: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  modified: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  modified: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdc00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000] kernel direct mapping tables up to bdc00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] RAMDISK: 37d9e000 - 37fef9fd
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bdb7bd45 00094 (v01 LENOVO TP-6D    00001100  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bdb7bf00 000F4 (v03 LENOVO TP-6D    00001100 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bdb7c2f4 0D910 (v01 LENOVO TP-6D    00001100 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bdb8e000 00040
[    0.000000] ACPI: SSDT 00000000bdb7c0b4 00240 (v01 LENOVO TP-6D    00001100 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bdb89c04 00052 (v01 LENOVO TP-6D    00001100 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bdb89c56 00078 (v01 LENOVO TP-6D    00001100 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bdb89cce 0003C (v01 LENOVO TP-6D    00001100 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bdb89d0a 00038 (v01 LENOVO TP-6D    00001100 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bdb89dc2 00176 (v01 LENOVO TP-6D    00001100  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bdb89f38 00028 (v01 LENOVO TP-6D    00001100  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bdb89f60 000A0 (v16 LENOVO TP-6D    00001100 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bdb8d203 0055F (v01 LENOVO TP-6D    00001100 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd907000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000bd8d4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d3000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d2000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Bootmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [000000000000b000 - 000000000000ffff]
[    0.000000]   bootmap [0000000000010000 -  00000000000377ff] pages 28
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000196e224]    TEXT DATA BSS ==> [0001000000 - 000196e224]
[    0.000000]   #3 [0037d9e000 - 0037fef9fd]          RAMDISK ==> [0037d9e000 - 0037fef9fd]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [000196f000 - 000196f14c]              BRK ==> [000196f000 - 000196f14c]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f73c0] f73c0
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd6a1
[    0.000000]     0: 0x000bd6a7 -> 0x000bd7b7
[    0.000000]     0: 0x000bd80f -> 0x000bd8c7
[    0.000000]     0: 0x000bdbff -> 0x000bdc00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021955
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3834 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757922 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd6a1000 - 00000000bd6a7000
[    0.000000] PM: Registered nosave memory: 00000000bd7b7000 - 00000000bd80f000
[    0.000000] PM: Registered nosave memory: 00000000bd8c7000 - 00000000bd8d2000
[    0.000000] PM: Registered nosave memory: 00000000bd8d2000 - 00000000bd8d5000
[    0.000000] PM: Registered nosave memory: 00000000bd8d5000 - 00000000bd8d9000
[    0.000000] PM: Registered nosave memory: 00000000bd8d9000 - 00000000bd8dd000
[    0.000000] PM: Registered nosave memory: 00000000bd8dd000 - 00000000bd8e0000
[    0.000000] PM: Registered nosave memory: 00000000bd8e0000 - 00000000bd907000
[    0.000000] PM: Registered nosave memory: 00000000bd907000 - 00000000bd908000
[    0.000000] PM: Registered nosave memory: 00000000bd908000 - 00000000bdb0f000
[    0.000000] PM: Registered nosave memory: 00000000bdb0f000 - 00000000bdb9f000
[    0.000000] PM: Registered nosave memory: 00000000bdb9f000 - 00000000bdbff000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages at ffff880028023000, static data 77344 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1004156
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 3951820k/5177344k available (5105k kernel code, 1089524k absent, 136000k reserved, 3036k data, 560k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1861.918 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.83 BogoMIPS (lpj=1861918)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003286] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004385] Mount-cache hash table entries: 256
[    0.004673] Initializing cgroup subsys ns
[    0.004784] Initializing cgroup subsys cpuacct
[    0.004895] Initializing cgroup subsys freezer
[    0.005021] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005171] CPU: L2 cache: 6144K
[    0.005280] CPU 0/0x0 -> Node 0
[    0.005386] CPU: Physical Processor ID: 0
[    0.005494] CPU: Processor Core ID: 0
[    0.005602] mce: CPU supports 6 MCE banks
[    0.005715] CPU0: Thermal monitoring enabled (TM2)
[    0.005825] using mwait in idle threads.
[    0.005950] ACPI: Core revision 20090521
[    0.026065] Setting APIC routing to flat
[    0.026518] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.037126] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 06
[    0.037994] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3723.80 BogoMIPS (lpj=1861903)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 6144K
[    0.000999] CPU 1/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.109925] CPU1: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 06
[    0.110137] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.111004] Brought up 2 CPUs
[    0.111110] Total of 2 processors activated (7447.64 BogoMIPS).
[    0.111305] khelper used greatest stack depth: 5952 bytes left
[    0.112122] Time: 19:13:13  Date: 06/26/09
[    0.112179] NET: Registered protocol family 16
[    0.113008] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.113173] ACPI: bus type pci registered
[    0.113290] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.113290] PCI: MCFG area at e0000000 reserved in E820
[    0.118576] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.118683] PCI: Using configuration type 1 for base access
[    0.126093] bio: create slab <bio-0> at 0
[    0.128021] ACPI: EC: EC description table is found, configuring boot EC
[    0.135891] ACPI: BIOS _OSI(Linux) query ignored
[    0.135901] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.148297] ACPI: Interpreter enabled
[    0.148403] ACPI: (supports S0 S3 S4 S5)
[    0.148696] ACPI: Using IOAPIC for interrupt routing
[    0.166242] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.166270] ACPI: EC: driver started in interrupt mode
[    0.167349] ACPI: Power Resource [PUBS] (on)
[    0.170110] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.170613] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.171189] DMAR: Forcing write-buffer flush capability
[    0.171189] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.171189] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.171189] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.171189] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.171189] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.171189] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.171207] pci 0000:00:03.0: PME# disabled
[    0.171344] pci 0000:00:03.2: reg 10 io port: [0x1828-0x182f]
[    0.171350] pci 0000:00:03.2: reg 14 io port: [0x180c-0x180f]
[    0.171355] pci 0000:00:03.2: reg 18 io port: [0x1820-0x1827]
[    0.171361] pci 0000:00:03.2: reg 1c io port: [0x1808-0x180b]
[    0.171366] pci 0000:00:03.2: reg 20 io port: [0x1810-0x181f]
[    0.171419] pci 0000:00:03.3: reg 10 io port: [0x1830-0x1837]
[    0.171425] pci 0000:00:03.3: reg 14 32bit mmio: [0xf2624000-0xf2624fff]
[    0.171549] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.171558] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.171566] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.171621] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.171733] pci 0000:00:19.0: PME# disabled
[    0.171906] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.172004] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.172097] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.172191] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.172260] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.172372] pci 0000:00:1a.7: PME# disabled
[    0.172532] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.172592] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.172703] pci 0000:00:1b.0: PME# disabled
[    0.172890] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.172978] pci 0000:00:1c.0: PME# disabled
[    0.173168] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.173279] pci 0000:00:1c.1: PME# disabled
[    0.173470] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.173582] pci 0000:00:1c.3: PME# disabled
[    0.173765] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.173859] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.173981] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.174076] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.174144] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.174256] pci 0000:00:1d.7: PME# disabled
[    0.174613] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.174621] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.174629] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.174637] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.174645] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.174653] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.174700] pci 0000:00:1f.2: PME# supported from D3hot
[    0.174810] pci 0000:00:1f.2: PME# disabled
[    0.174955] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.174978] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.175196] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.175338] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.175473] pci 0000:03:00.0: PME# disabled
[    0.175682] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.175749] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.175754] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.175762] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29fffff]
[    0.175837] pci 0000:00:1e.0: transparent bridge
[    0.175987] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.176152] Starting root bridge search from \_SB_.PCI0.LPC_
[    0.176263] + Adding \_SB_.PCI0.LPC_
[    0.176368] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.176483] Searching for 0000:00:1f.0...found
[    0.176634] Starting root bridge search from \_SB_.PCI0.VID_
[    0.176744] + Adding \_SB_.PCI0.VID_
[    0.176850] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.176963] Searching for 0000:00:02.0...found
[    0.177078] Starting root bridge search from \_SB_.PCI0.AGP_
[    0.177188] + Adding \_SB_.PCI0.AGP_
[    0.177294] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.177407] Searching for 0000:00:01.0...not found
[    0.177557] Starting root bridge search from \_SB_.PCI0.IGBE
[    0.177666] + Adding \_SB_.PCI0.IGBE
[    0.177772] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.177884] Searching for 0000:00:19.0...found
[    0.178077] Starting root bridge search from \_SB_.PCI0.EXP0
[    0.178187] + Adding \_SB_.PCI0.EXP0
[    0.178292] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.178405] Searching for 0000:00:1c.0...found
[    0.178554] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.178627] Starting root bridge search from \_SB_.PCI0.EXP1
[    0.178738] + Adding \_SB_.PCI0.EXP1
[    0.178843] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.178956] Searching for 0000:00:1c.1...found
[    0.179077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.179149] Starting root bridge search from \_SB_.PCI0.EXP2
[    0.179259] + Adding \_SB_.PCI0.EXP2
[    0.179364] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.179477] Searching for 0000:00:1c.2...not found
[    0.179627] Starting root bridge search from \_SB_.PCI0.EXP3
[    0.179737] + Adding \_SB_.PCI0.EXP3
[    0.179842] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.179978] Searching for 0000:00:1c.3...found
[    0.180128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.180200] Starting root bridge search from \_SB_.PCI0.EXP3.EXUP
[    0.180310] + Adding \_SB_.PCI0.EXP3.EXUP
[    0.180418] + Adding \_SB_.PCI0.EXP3
[    0.180523] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.180636] Searching for 0000:00:1c.3...found
[    0.180787] Searching for 0000:05:00.0...not found
[    0.180936] Starting root bridge search from \_SB_.PCI0.SATA
[    0.180976] + Adding \_SB_.PCI0.SATA
[    0.181082] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.181194] Searching for 0000:00:1f.2...found
[    0.181344] Starting root bridge search from \_SB_.PCI0.SMBU
[    0.181454] + Adding \_SB_.PCI0.SMBU
[    0.181559] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.181671] Searching for 0000:00:1f.3...found
[    0.181820] Starting root bridge search from \_SB_.PCI0.USB0
[    0.181976] + Adding \_SB_.PCI0.USB0
[    0.182081] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.182194] Searching for 0000:00:1d.0...found
[    0.182343] Starting root bridge search from \_SB_.PCI0.USB1
[    0.182453] + Adding \_SB_.PCI0.USB1
[    0.182559] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.182672] Searching for 0000:00:1d.1...found
[    0.182821] Starting root bridge search from \_SB_.PCI0.USB2
[    0.182975] + Adding \_SB_.PCI0.USB2
[    0.183081] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.183193] Searching for 0000:00:1d.2...found
[    0.183343] Starting root bridge search from \_SB_.PCI0.USB3
[    0.183453] + Adding \_SB_.PCI0.USB3
[    0.183558] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.183670] Searching for 0000:00:1a.0...found
[    0.183820] Starting root bridge search from \_SB_.PCI0.USB4
[    0.183929] + Adding \_SB_.PCI0.USB4
[    0.183974] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.184086] Searching for 0000:00:1a.1...found
[    0.184236] Starting root bridge search from \_SB_.PCI0.USB5
[    0.184346] + Adding \_SB_.PCI0.USB5
[    0.184451] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.184563] Searching for 0000:00:1a.2...found
[    0.184713] Starting root bridge search from \_SB_.PCI0.EHC0
[    0.186975] + Adding \_SB_.PCI0.EHC0
[    0.187080] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.187193] Searching for 0000:00:1d.7...found
[    0.187342] Starting root bridge search from \_SB_.PCI0.EHC1
[    0.187342] + Adding \_SB_.PCI0.EHC1
[    0.187342] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.187342] Searching for 0000:00:1a.7...found
[    0.187342] Starting root bridge search from \_SB_.PCI0.HDEF
[    0.187452] + Adding \_SB_.PCI0.HDEF
[    0.187557] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    0.187669] Searching for 0000:00:1b.0...found
[    0.195128] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.195439] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196170] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196885] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.197597] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.198310] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.199063] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.199777] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.200997] SCSI subsystem initialized
[    0.201082] libata version 3.00 loaded.
[    0.201082] usbcore: registered new interface driver usbfs
[    0.201108] usbcore: registered new interface driver hub
[    0.201108] usbcore: registered new device driver usb
[    0.201163] PCI: Using ACPI for IRQ routing
[    0.216420] cfg80211: Using static regulatory domain info
[    0.216420] cfg80211: Regulatory domain: US
[    0.216420] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.216420] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.216465] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.216576] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.216686] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.216796] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.216906] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.216973] cfg80211: Calling CRDA for country: US
[    0.217611] NetLabel: Initializing
[    0.217611] NetLabel:  domain hash size = 128
[    0.217611] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.217611] NetLabel:  unlabeled traffic allowed by default
[    0.218091] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.218091] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.225385] pnp: PnP ACPI init
[    0.225496] ACPI: bus type pnp registered
[    0.290535] pnp: PnP ACPI: found 10 devices
[    0.290642] ACPI: ACPI bus type pnp unregistered
[    0.290757] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.290867] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.290978] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.291088] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.291198] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.291308] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.291426] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.291537] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.291647] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.291758] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.291868] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.291979] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.292090] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.292260] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.292434] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.292608] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.292719] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.292829] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.292939] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.293049] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.293158] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.293268] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.293383] system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
[    0.293494] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.293605] system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved
[    0.293716] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.293827] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.293938] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.299195] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.299304] pci 0000:00:1c.0:   IO window: disabled
[    0.299419] pci 0000:00:1c.0:   MEM window: disabled
[    0.299528] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.299639] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.299747] pci 0000:00:1c.1:   IO window: disabled
[    0.299859] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.299970] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.300080] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.300190] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.300302] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.300417] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x000000f29fffff
[    0.300592] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.300700] pci 0000:00:1e.0:   IO window: disabled
[    0.300811] pci 0000:00:1e.0:   MEM window: disabled
[    0.300920] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.301038]   alloc irq_desc for 20 on node 0
[    0.301040]   alloc kstat_irqs on node 0
[    0.301045] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.301158] pci 0000:00:1c.0: setting latency timer to 64
[    0.301166]   alloc irq_desc for 21 on node 0
[    0.301168]   alloc kstat_irqs on node 0
[    0.301172] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.301284] pci 0000:00:1c.1: setting latency timer to 64
[    0.301293]   alloc irq_desc for 23 on node 0
[    0.301294]   alloc kstat_irqs on node 0
[    0.301298] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.301414] pci 0000:00:1c.3: setting latency timer to 64
[    0.301422] pci 0000:00:1e.0: setting latency timer to 64
[    0.301426] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.301429] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffff]
[    0.301432] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.301435] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.301437] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.301440] pci_bus 0000:05: resource 2 pref mem [0xf2900000-0xf29fffff]
[    0.301443] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.301445] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffff]
[    0.301473] NET: Registered protocol family 2
[    0.301743] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.303505] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.307041] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.307643] TCP: Hash tables configured (established 524288 bind 65536)
[    0.307753] TCP reno registered
[    0.308005] NET: Registered protocol family 1
[    0.308185] Trying to unpack rootfs image as initramfs...
[    0.378810] Freeing initrd memory: 2374k freed
[    0.379803] Simple Boot Flag at 0x35 set to 0x1
[    0.380964] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.381077] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.381234] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.381428] Scanning for low memory corruption every 60 seconds
[    0.381853] audit: initializing netlink socket (disabled)
[    0.381976] type=2000 audit(1246043593.381:1): initialized
[    0.391254] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.394263] VFS: Disk quotas dquot_6.5.2
[    0.394458] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.395493] msgmni has been set to 7723
[    0.395718] SELinux:  Registering netfilter hooks
[    0.396223] alg: No test for stdrng (krng)
[    0.396445] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.396616] io scheduler noop registered
[    0.396721] io scheduler anticipatory registered
[    0.396828] io scheduler deadline registered
[    0.397004] io scheduler cfq registered (default)
[    0.397121] pci 0000:00:02.0: Boot video device
[    0.397139] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.397141] pci 0000:00:1a.0: Performing full reset
[    0.397160] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.397162] pci 0000:00:1a.1: Performing full reset
[    0.397182] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.397184] pci 0000:00:1a.2: Performing full reset
[    0.397234] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.397236] pci 0000:00:1d.0: Performing full reset
[    0.397256] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.397257] pci 0000:00:1d.1: Performing full reset
[    0.397276] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.397278] pci 0000:00:1d.2: Performing full reset
[    0.397508]   alloc irq_desc for 24 on node 0
[    0.397511]   alloc kstat_irqs on node 0
[    0.397523] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.397534] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.397804]   alloc irq_desc for 25 on node 0
[    0.397807]   alloc kstat_irqs on node 0
[    0.397816] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.397826] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.398165]   alloc irq_desc for 26 on node 0
[    0.398167]   alloc kstat_irqs on node 0
[    0.398176] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.398187] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.398464] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.399417] ACPI: AC Adapter [AC] (on-line)
[    0.399671] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.399842] ACPI: Power Button [PWRF]
[    0.400063] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.401239] ACPI: Lid Switch [LID]
[    0.401435] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.401610] ACPI: Sleep Button [SLPB]
[    0.402443] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.403362] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.406424] ACPI Warning: Invalid throttling state, reset 20090521 processor_throttling-843
[    0.407834] Monitor-Mwait will be used to enter C-1 state
[    0.407859] Monitor-Mwait will be used to enter C-2 state
[    0.407882] Monitor-Mwait will be used to enter C-3 state
[    0.407888] Marking TSC unstable due to TSC halts in idle
[    0.408021] Switched to high resolution mode on CPU 0
[    0.408052] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.408383] Switched to high resolution mode on CPU 1
[    0.408393] processor LNXCPU:00: registered as cooling_device0
[    0.408504] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.409268] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.410003] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.411086] ACPI Warning: Invalid throttling state, reset 20090521 processor_throttling-843
[    0.412777] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.413117] processor LNXCPU:01: registered as cooling_device1
[    0.413232] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.461062] thermal LNXTHERM:01: registered as thermal_zone0
[    0.461185] ACPI: Thermal Zone [THM0] (52 C)
[    0.462958] thermal LNXTHERM:02: registered as thermal_zone1
[    0.463081] ACPI: Thermal Zone [THM1] (53 C)
[    0.467795] Non-volatile memory driver v1.3
[    0.467902] Linux agpgart interface v0.103
[    0.468107] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    0.470529] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.475097] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.475385] [drm] Initialized drm 1.1.0 20060810
[    0.475698] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.475812]   alloc irq_desc for 16 on node 0
[    0.475814]   alloc kstat_irqs on node 0
[    0.475820] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.475932] i915 0000:00:02.0: setting latency timer to 64
[    0.502220]   alloc irq_desc for 27 on node 0
[    0.502223]   alloc kstat_irqs on node 0
[    0.502232] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.540264] ACPI: Battery Slot [BAT0] (battery present)
[    0.640403] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-B
[    0.643021] dp_aux_ch timeout status 0x51450085
[    0.643128] aux_ch failed -110
[    0.645544] dp_aux_ch timeout status 0x51450085
[    0.645650] aux_ch failed -110
[    0.677518] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-C
[    0.680138] dp_aux_ch timeout status 0x51450085
[    0.680243] aux_ch failed -110
[    0.682655] dp_aux_ch timeout status 0x51450085
[    0.682761] aux_ch failed -110
[    0.684703] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-D
[    0.687320] dp_aux_ch timeout status 0x51450085
[    0.687426] aux_ch failed -110
[    0.689837] dp_aux_ch timeout status 0x51450085
[    0.689943] aux_ch failed -110
[    0.831047] i2c-adapter i2c-2: unable to read EDID block.
[    0.831160] i915 0000:00:02.0: DVI-D-1: no EDID data
[    0.833777] dp_aux_ch timeout status 0x51450085
[    0.838314] i2c-adapter i2c-4: unable to read EDID block.
[    0.838421] i915 0000:00:02.0: DVI-D-2: no EDID data
[    0.841040] dp_aux_ch timeout status 0x51450085
[    0.843660] dp_aux_ch timeout status 0x51450085
[    0.849325] allocated 1440x900 fb: 0x02020000, bo ffff88013a1ca900
[    1.187170] [drm] LVDS-8: set mode 1440x900 c
[    1.427968] Console: switching to colour frame buffer device 180x56
[    1.431693] fb0: inteldrmfb frame buffer device
[    1.431719] registered panic notifier
[    1.431808] Starting root bridge search from \_SB_.PCI0.VID_
[    1.431844] + Adding \_SB_.PCI0.VID_
[    1.431867] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    1.431908] Searching for 0000:00:02.0...found
[    1.432409] Starting root bridge search from \_SB_.PCI0.VID_
[    1.432444] + Adding \_SB_.PCI0.VID_
[    1.432465] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    1.432504] Searching for 0000:00:02.0...found
[    1.432547] Starting root bridge search from \_SB_.PCI0.AGP_.VID_
[    1.432582] + Adding \_SB_.PCI0.AGP_.VID_
[    1.432607] + Adding \_SB_.PCI0.AGP_
[    1.432629] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    1.432667] Searching for 0000:00:01.0...not found
[    1.439878] acpi device:03: registered as cooling_device2
[    1.440220] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input3
[    1.440272] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.440323] Starting root bridge search from \_SB_.PCI0.AGP_.VID_
[    1.440358] + Adding \_SB_.PCI0.AGP_.VID_
[    1.440383] + Adding \_SB_.PCI0.AGP_
[    1.440405] pci_bus 0000:00: I'm a little pci_bus, short and stout...
[    1.440444] Searching for 0000:00:01.0...not found
[    1.440532] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.440576] work_for_cpu used greatest stack depth: 4264 bytes left
[    1.440639] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.440997] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    1.441312]   alloc irq_desc for 17 on node 0
[    1.441314]   alloc kstat_irqs on node 0
[    1.441321] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.441459] 0000:00:03.3: ttyS0 at I/O 0x1830 (irq = 17) is a 16550A
[    1.443759] brd: module loaded
[    1.445816] loop: module loaded
[    1.446886] input: Macintosh mouse button emulation as /devices/virtual/input/input4
[    1.448266] ahci 0000:00:1f.2: version 3.0
[    1.448276] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.449382]   alloc irq_desc for 28 on node 0
[    1.449384]   alloc kstat_irqs on node 0
[    1.449393] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    1.449418] ahci: SSS flag set, parallel bus scan disabled
[    1.450533] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    1.451672] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    1.452830] ahci 0000:00:1f.2: setting latency timer to 64
[    1.452982] scsi0 : ahci
[    1.454325] scsi1 : ahci
[    1.455629] scsi2 : ahci
[    1.456938] scsi3 : ahci
[    1.458712] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 28
[    1.459947] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 28
[    1.461185] ata3: DUMMY
[    1.462438] ata4: DUMMY
[    1.463945] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    1.465252] Copyright (c) 1999-2006 Intel Corporation.
[    1.466642] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.467996] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.469480] sky2 driver version 1.23
[    1.471057] console [netcon0] enabled
[    1.472411] netconsole: network logging started
[    1.473948] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.475335] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    1.476199] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    1.477594] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.478988] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.478992] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.480430] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.481814] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.481819] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    1.481842] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.485724] ehci_hcd 0000:00:1a.7: debug port 1
[    1.487079] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.487081] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    1.487096] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    1.488464] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.492338] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.499012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.500384] usb usb1: default language 0x0409
[    1.500392] usb usb1: udev 1, busnum 1, minor = 0
[    1.500394] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.501738] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.503099] usb usb1: Product: EHCI Host Controller
[    1.504442] usb usb1: Manufacturer: Linux 2.6.31-rc1 ehci_hcd
[    1.505817] usb usb1: SerialNumber: 0000:00:1a.7
[    1.507198] usb usb1: uevent
[    1.507245] usb usb1: usb_probe_device
[    1.507248] usb usb1: configuration #1 chosen from 1 choice
[    1.508601] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.508619] usb 1-0:1.0: uevent
[    1.508665] hub 1-0:1.0: usb_probe_interface
[    1.508668] hub 1-0:1.0: usb_probe_interface - got id
[    1.508670] hub 1-0:1.0: USB hub found
[    1.510015] hub 1-0:1.0: 6 ports detected
[    1.511333] hub 1-0:1.0: standalone hub
[    1.511334] hub 1-0:1.0: no power switching (usb 1.0)
[    1.511336] hub 1-0:1.0: individual port over-current protection
[    1.511338] hub 1-0:1.0: power on to power good time: 20ms
[    1.511343] hub 1-0:1.0: local power source is good
[    1.511345] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.511925] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.513238]   alloc irq_desc for 19 on node 0
[    1.513240]   alloc kstat_irqs on node 0
[    1.513245] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.514573] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.514577] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.515940] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.517279] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.517284] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    1.517305] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.521185] ehci_hcd 0000:00:1d.7: debug port 1
[    1.522503] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.522505] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.522519] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    1.523828] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.527705] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.534018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.535319] usb usb2: default language 0x0409
[    1.535326] usb usb2: udev 1, busnum 2, minor = 128
[    1.535329] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.536619] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.537906] usb usb2: Product: EHCI Host Controller
[    1.539177] usb usb2: Manufacturer: Linux 2.6.31-rc1 ehci_hcd
[    1.540454] usb usb2: SerialNumber: 0000:00:1d.7
[    1.541752] usb usb2: uevent
[    1.541797] usb usb2: usb_probe_device
[    1.541799] usb usb2: configuration #1 chosen from 1 choice
[    1.543058] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.543079] usb 2-0:1.0: uevent
[    1.543125] hub 2-0:1.0: usb_probe_interface
[    1.543127] hub 2-0:1.0: usb_probe_interface - got id
[    1.543129] hub 2-0:1.0: USB hub found
[    1.544391] hub 2-0:1.0: 6 ports detected
[    1.545631] hub 2-0:1.0: standalone hub
[    1.545633] hub 2-0:1.0: no power switching (usb 1.0)
[    1.545635] hub 2-0:1.0: individual port over-current protection
[    1.545637] hub 2-0:1.0: power on to power good time: 20ms
[    1.545641] hub 2-0:1.0: local power source is good
[    1.545643] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.545741] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.546974] ohci_hcd: block sizes: ed 80 td 96
[    1.547027] uhci_hcd: USB Universal Host Controller Interface driver
[    1.548991] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.550227] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.551456] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.551459] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.552720] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.553957] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.555193] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.555195] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.555210] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    1.555224] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    1.556519] usb usb3: default language 0x0409
[    1.556526] usb usb3: udev 1, busnum 3, minor = 256
[    1.556528] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.557768] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.559025] usb usb3: Product: UHCI Host Controller
[    1.560270] usb usb3: Manufacturer: Linux 2.6.31-rc1 uhci_hcd
[    1.561528] usb usb3: SerialNumber: 0000:00:1a.0
[    1.562826] usb usb3: uevent
[    1.562868] usb usb3: usb_probe_device
[    1.562870] usb usb3: configuration #1 chosen from 1 choice
[    1.564123] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.564143] usb 3-0:1.0: uevent
[    1.564186] hub 3-0:1.0: usb_probe_interface
[    1.564188] hub 3-0:1.0: usb_probe_interface - got id
[    1.564190] hub 3-0:1.0: USB hub found
[    1.565425] hub 3-0:1.0: 2 ports detected
[    1.566639] hub 3-0:1.0: standalone hub
[    1.566641] hub 3-0:1.0: no power switching (usb 1.0)
[    1.566643] hub 3-0:1.0: individual port over-current protection
[    1.566645] hub 3-0:1.0: power on to power good time: 2ms
[    1.566649] hub 3-0:1.0: local power source is good
[    1.566651] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.566732] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.567995] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.567998] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.569304] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.570578] uhci_hcd 0000:00:1a.1: detected 2 ports
[    1.571818] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.571820] uhci_hcd 0000:00:1a.1: Performing full reset
[    1.571836] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    1.571849] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    1.573141] usb usb4: default language 0x0409
[    1.573148] usb usb4: udev 1, busnum 4, minor = 384
[    1.573150] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.574391] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.575634] usb usb4: Product: UHCI Host Controller
[    1.576881] usb usb4: Manufacturer: Linux 2.6.31-rc1 uhci_hcd
[    1.578115] usb usb4: SerialNumber: 0000:00:1a.1
[    1.579390] usb usb4: uevent
[    1.579432] usb usb4: usb_probe_device
[    1.579435] usb usb4: configuration #1 chosen from 1 choice
[    1.580698] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.580716] usb 4-0:1.0: uevent
[    1.580758] hub 4-0:1.0: usb_probe_interface
[    1.580760] hub 4-0:1.0: usb_probe_interface - got id
[    1.580762] hub 4-0:1.0: USB hub found
[    1.582012] hub 4-0:1.0: 2 ports detected
[    1.583247] hub 4-0:1.0: standalone hub
[    1.583249] hub 4-0:1.0: no power switching (usb 1.0)
[    1.583250] hub 4-0:1.0: individual port over-current protection
[    1.583253] hub 4-0:1.0: power on to power good time: 2ms
[    1.583257] hub 4-0:1.0: local power source is good
[    1.583259] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.583843] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    1.585088]   alloc irq_desc for 22 on node 0
[    1.585090]   alloc kstat_irqs on node 0
[    1.585095] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.586350] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.586354] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.587685] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.588939] uhci_hcd 0000:00:1a.2: detected 2 ports
[    1.590185] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.590187] uhci_hcd 0000:00:1a.2: Performing full reset
[    1.590203] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    1.590217] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    1.591496] usb usb5: default language 0x0409
[    1.591503] usb usb5: udev 1, busnum 5, minor = 512
[    1.591505] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.592752] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.594007] usb usb5: Product: UHCI Host Controller
[    1.595246] usb usb5: Manufacturer: Linux 2.6.31-rc1 uhci_hcd
[    1.596497] usb usb5: SerialNumber: 0000:00:1a.2
[    1.597771] usb usb5: uevent
[    1.597815] usb usb5: usb_probe_device
[    1.597817] usb usb5: configuration #1 chosen from 1 choice
[    1.599060] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.599078] usb 5-0:1.0: uevent
[    1.599120] hub 5-0:1.0: usb_probe_interface
[    1.599123] hub 5-0:1.0: usb_probe_interface - got id
[    1.599124] hub 5-0:1.0: USB hub found
[    1.600380] hub 5-0:1.0: 2 ports detected
[    1.601621] hub 5-0:1.0: standalone hub
[    1.601623] hub 5-0:1.0: no power switching (usb 1.0)
[    1.601624] hub 5-0:1.0: individual port over-current protection
[    1.601627] hub 5-0:1.0: power on to power good time: 2ms
[    1.601631] hub 5-0:1.0: local power source is good
[    1.601633] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.602378] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.603637] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.604894] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.604898] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.606206] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.607475] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.608727] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.608729] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.608744] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.608758] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    1.610040] usb usb6: default language 0x0409
[    1.610047] usb usb6: udev 1, busnum 6, minor = 640
[    1.610049] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.611322] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.612584] usb usb6: Product: UHCI Host Controller
[    1.613834] usb usb6: Manufacturer: Linux 2.6.31-rc1 uhci_hcd
[    1.615078] usb usb6: SerialNumber: 0000:00:1d.0
[    1.616364] usb usb6: uevent
[    1.616389] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
[    1.616392] hub 1-0:1.0: port 4: status 0501 change 0001
[    1.616408] usb usb6: usb_probe_device
[    1.616410] usb usb6: configuration #1 chosen from 1 choice
[    1.617657] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    1.617675] usb 6-0:1.0: uevent
[    1.617718] hub 6-0:1.0: usb_probe_interface
[    1.617720] hub 6-0:1.0: usb_probe_interface - got id
[    1.617722] hub 6-0:1.0: USB hub found
[    1.618975] hub 6-0:1.0: 2 ports detected
[    1.620207] hub 6-0:1.0: standalone hub
[    1.620209] hub 6-0:1.0: no power switching (usb 1.0)
[    1.620210] hub 6-0:1.0: individual port over-current protection
[    1.620213] hub 6-0:1.0: power on to power good time: 2ms
[    1.620217] hub 6-0:1.0: local power source is good
[    1.620219] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    1.620295] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.621565] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.621569] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.622900] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.624164] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.625419] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.625421] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.625437] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    1.625450] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    1.626741] usb usb7: default language 0x0409
[    1.626748] usb usb7: udev 1, busnum 7, minor = 768
[    1.626751] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.628008] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.629262] usb usb7: Product: UHCI Host Controller
[    1.630509] usb usb7: Manufacturer: Linux 2.6.31-rc1 uhci_hcd
[    1.631777] usb usb7: SerialNumber: 0000:00:1d.1
[    1.633071] usb usb7: uevent
[    1.633113] usb usb7: usb_probe_device
[    1.633115] usb usb7: configuration #1 chosen from 1 choice
[    1.634374] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    1.634397] usb 7-0:1.0: uevent
[    1.634440] hub 7-0:1.0: usb_probe_interface
[    1.634442] hub 7-0:1.0: usb_probe_interface - got id
[    1.634444] hub 7-0:1.0: USB hub found
[    1.635694] hub 7-0:1.0: 2 ports detected
[    1.636931] hub 7-0:1.0: standalone hub
[    1.636933] hub 7-0:1.0: no power switching (usb 1.0)
[    1.636935] hub 7-0:1.0: individual port over-current protection
[    1.636937] hub 7-0:1.0: power on to power good time: 2ms
[    1.636941] hub 7-0:1.0: local power source is good
[    1.636943] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    1.637027]   alloc irq_desc for 18 on node 0
[    1.637029]   alloc kstat_irqs on node 0
[    1.637034] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.638307] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.638311] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.639633] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.640908] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.642149] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.642151] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.642167] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    1.642180] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    1.643454] usb usb8: default language 0x0409
[    1.643461] usb usb8: udev 1, busnum 8, minor = 896
[    1.643464] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.644713] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.645971] usb usb8: Product: UHCI Host Controller
[    1.647223] usb usb8: Manufacturer: Linux 2.6.31-rc1 uhci_hcd
[    1.648486] usb usb8: SerialNumber: 0000:00:1d.2
[    1.649781] usb usb8: uevent
[    1.649811] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.649820] usb usb8: usb_probe_device
[    1.649823] usb usb8: configuration #1 chosen from 1 choice
[    1.651077] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    1.651095] usb 8-0:1.0: uevent
[    1.651150] hub 8-0:1.0: usb_probe_interface
[    1.651152] hub 8-0:1.0: usb_probe_interface - got id
[    1.651154] hub 8-0:1.0: USB hub found
[    1.652410] hub 8-0:1.0: 2 ports detected
[    1.653643] hub 8-0:1.0: standalone hub
[    1.653645] hub 8-0:1.0: no power switching (usb 1.0)
[    1.653646] hub 8-0:1.0: individual port over-current protection
[    1.653648] hub 8-0:1.0: power on to power good time: 2ms
[    1.653653] hub 8-0:1.0: local power source is good
[    1.653655] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    1.653791] usbcore: registered new interface driver usblp
[    1.655055] Initializing USB Mass Storage driver...
[    1.656371] usbcore: registered new interface driver usb-storage
[    1.657629] USB Mass Storage support registered.
[    1.658948] usbcore: registered new interface driver libusual
[    1.660321] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.661618] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    1.667025] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.674014] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.675316] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.676702] mice: PS/2 mouse device common for all mice
[    1.678432] rtc_cmos 00:07: RTC can wake from S4
[    1.679781] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.681087] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.682455] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.683813] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    1.684126] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    1.685579] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    1.687603] cpuidle: using governor ladder
[    1.689640] cpuidle: using governor menu
[    1.693174] usbcore: registered new interface driver hiddev
[    1.694620] usbcore: registered new interface driver usbhid
[    1.695906] usbhid: v2.6:USB HID core driver
[    1.697562] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.702180] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.703781] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.705258] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.716059] hub 1-0:1.0: state 7 ports 6 chg 0010 evt 0000
[    1.716067] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    1.738781] ALSA device list:
[    1.740149]   #0: HDA Intel at 0xf2620000 irq 17
[    1.741538] Netfilter messages via NETLINK v0.30.
[    1.742872] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.744546] ctnetlink v0.93: registering with nfnetlink.
[    1.746474] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.747776] TCP cubic registered
[    1.749087] Initializing XFRM netlink socket
[    1.750768] NET: Registered protocol family 10
[    1.753030] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.754417] IPv6 over IPv4 tunneling driver
[    1.756454] NET: Registered protocol family 17
[    1.758049] RPC: Registered udp transport module.
[    1.759379] RPC: Registered tcp transport module.
[    1.761947] PM: Resume from disk failed.
[    1.761959] registered taskstats version 1
[    1.763434]   Magic number: 13:138:244
[    1.768238] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    1.768243] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
[    1.768247] hub 1-0:1.0: port 4 not reset yet, waiting 50ms
[    1.771190] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.790314] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    1.790318] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.791701] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    1.791705] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.793814] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    1.795059] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.819061] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
[    1.819083] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.819087] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.819098] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.819102] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    1.819109] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    1.819118] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    1.819126] hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    1.823468] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    1.823472] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.824905] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    1.824909] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.827079] ata1.00: configured for UDMA/100
[    1.843275] ata1.00: configured for UDMA/100
[    1.844526] ata1: EH complete
[    1.845856] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.CM PQ: 0 ANSI: 5
[    1.847395] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.847428] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.849992] sd 0:0:0:0: [sda] Write Protect is off
[    1.851238] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.851264] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.852655]  sda: sda1 sda2 < sda5 >
[    1.889854] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.923063] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    2.000052] Clocksource tsc unstable (delta = -198725434 ns)
[    2.025058] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    2.152069] ata2: SATA link down (SStatus 0 SControl 300)
[    2.164160] Freeing unused kernel memory: 560k freed
[    2.165621] Write protecting the kernel read-only data: 7348k
[    2.168175] usb 4-2: skipped 1 descriptor after interface
[    2.173165] usb 4-2: default language 0x0409
[    2.179922] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    2.182166] usb 4-2: udev 2, busnum 4, minor = 385
[    2.182168] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[    2.183521] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.184843] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    2.186202] usb 4-2: Manufacturer: Lenovo Computer Corp
[    2.187588] usb 4-2: uevent
[    2.187669] usb 4-2: usb_probe_device
[    2.187672] usb 4-2: configuration #1 chosen from 1 choice
[    2.191159] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    2.191181] usb 4-2:1.0: uevent
[    2.191498] usb 4-2: adding 4-2:1.1 (config #1, interface 1)
[    2.191518] usb 4-2:1.1: uevent
[    2.191616] usb 4-2: adding 4-2:1.2 (config #1, interface 2)
[    2.191631] usb 4-2:1.2: uevent
[    2.191728] usb 4-2: adding 4-2:1.3 (config #1, interface 3)
[    2.191745] usb 4-2:1.3: uevent
[    2.202068] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input6
[    2.259708] usb usb3: uevent
[    2.259729] usb 3-0:1.0: uevent
[    2.259792] usb usb4: uevent
[    2.259814] usb 4-0:1.0: uevent
[    2.259840] usb 4-2: uevent
[    2.259863] usb 4-2:1.0: uevent
[    2.259887] usb 4-2:1.1: uevent
[    2.259910] usb 4-2:1.2: uevent
[    2.259932] usb 4-2:1.3: uevent
[    2.259994] usb usb5: uevent
[    2.260027] usb 5-0:1.0: uevent
[    2.260088] usb usb1: uevent
[    2.260109] usb 1-0:1.0: uevent
[    2.260657] usb usb6: uevent
[    2.260678] usb 6-0:1.0: uevent
[    2.260741] usb usb7: uevent
[    2.260762] usb 7-0:1.0: uevent
[    2.260827] usb usb8: uevent
[    2.260849] usb 8-0:1.0: uevent
[    2.260911] usb usb2: uevent
[    2.260933] usb 2-0:1.0: uevent
[    2.279553] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    2.280910] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    2.288971] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.288982] e1000e 0000:00:19.0: setting latency timer to 64
[    2.289165]   alloc irq_desc for 29 on node 0
[    2.289167]   alloc kstat_irqs on node 0
[    2.289179] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    2.360779] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:11:0a:43
[    2.362157] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.363541] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    2.689691] PM: Starting manual resume from disk
[    2.691017] PM: Resume from partition 8:5
[    2.691018] PM: Checking hibernation image.
[    2.698018] PM: Resume from disk failed.
[    2.704062] usb usb3: suspend_rh (auto-stop)
[    2.704090] usb usb5: suspend_rh (auto-stop)
[    2.704116] usb usb6: suspend_rh (auto-stop)
[    2.704152] usb usb7: suspend_rh (auto-stop)
[    2.704183] usb usb8: suspend_rh (auto-stop)
[    2.735223] EXT3-fs: INFO: recovery required on readonly filesystem.
[    2.736580] EXT3-fs: write access will be enabled during recovery.
[    3.643458] kjournald starting.  Commit interval 5 seconds
[    3.643511] EXT3-fs: recovery complete.
[    3.647664] EXT3-fs: mounted filesystem with writeback data mode.
[    3.704119] hub 2-0:1.0: hub_suspend
[    3.704127] usb usb2: bus auto-suspend
[    3.704130] ehci_hcd 0000:00:1d.7: suspend root hub
[    3.704154] hub 3-0:1.0: hub_suspend
[    3.704157] usb usb3: bus auto-suspend
[    3.704160] usb usb3: suspend_rh
[    3.704179] hub 5-0:1.0: hub_suspend
[    3.704182] usb usb5: bus auto-suspend
[    3.704184] usb usb5: suspend_rh
[    4.704126] hub 6-0:1.0: hub_suspend
[    4.704133] usb usb6: bus auto-suspend
[    4.704136] usb usb6: suspend_rh
[    4.704153] hub 7-0:1.0: hub_suspend
[    4.704157] usb usb7: bus auto-suspend
[    4.704159] usb usb7: suspend_rh
[    4.704176] hub 8-0:1.0: hub_suspend
[    4.704180] usb usb8: bus auto-suspend
[    4.704182] usb usb8: suspend_rh
[    4.704199] hub 1-0:1.0: hub_suspend
[    4.704202] usb usb1: bus auto-suspend
[    4.704205] ehci_hcd 0000:00:1a.7: suspend root hub
[   10.247367] udev: starting version 142
[   10.280031] usb usb3: uevent
[   10.280054] usb 3-0:1.0: uevent
[   10.280120] usb usb4: uevent
[   10.280143] usb 4-0:1.0: uevent
[   10.280169] usb 4-2: uevent
[   10.280191] usb 4-2:1.0: uevent
[   10.280214] usb 4-2:1.1: uevent
[   10.280237] usb 4-2:1.2: uevent
[   10.280261] usb 4-2:1.3: uevent
[   10.280324] usb usb5: uevent
[   10.280347] usb 5-0:1.0: uevent
[   10.280408] usb usb1: uevent
[   10.280430] usb 1-0:1.0: uevent
[   10.280993] usb usb6: uevent
[   10.281026] usb 6-0:1.0: uevent
[   10.281092] usb usb7: uevent
[   10.281114] usb 7-0:1.0: uevent
[   10.281177] usb usb8: uevent
[   10.281199] usb 8-0:1.0: uevent
[   10.281266] usb usb2: uevent
[   10.281288] usb 2-0:1.0: uevent
[   11.419366] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   11.470179] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   11.470920] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.793041] Adding 9936160k swap on /dev/sda5.  Priority:-1 extents:1 across:9936160k 
[   12.204487] EXT3 FS on sda1, internal journal
[   13.065876] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   13.065880] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   13.066628] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.219844] usb usb3: uevent
[   17.219899] usb 3-0:1.0: uevent
[   17.220044] usb usb4: uevent
[   17.220105] usb 4-0:1.0: uevent
[   17.220439] usb 4-2: uevent
[   17.220505] usb 4-2:1.0: uevent
[   17.220559] usb 4-2:1.1: uevent
[   17.220612] usb 4-2:1.2: uevent
[   17.220664] usb 4-2:1.3: uevent
[   17.220807] usb usb5: uevent
[   17.220864] usb 5-0:1.0: uevent
[   17.220998] usb usb1: uevent
[   17.221068] usb 1-0:1.0: uevent
[   17.222817] usb usb6: uevent
[   17.222871] usb 6-0:1.0: uevent
[   17.223011] usb usb7: uevent
[   17.223080] usb 7-0:1.0: uevent
[   17.223485] usb usb8: uevent
[   17.223546] usb 8-0:1.0: uevent
[   17.223694] usb usb2: uevent
[   17.223747] usb 2-0:1.0: uevent
[   17.244167] host used greatest stack depth: 4216 bytes left
[   20.458716] svc: failed to register lockdv1 RPC service (errno 97).
[   20.462520] mount.nfs used greatest stack depth: 2792 bytes left
