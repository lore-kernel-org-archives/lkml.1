Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYIPUEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYIPUEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYIPUEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:04:41 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:49245 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYIPUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:04:38 -0400
Date: Tue, 16 Sep 2008 13:04:14 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: [2.6.27-rc6 regression] Intermittent boot problem with 2.6.27-rc6
Message-ID: <20080916200414.GB16993@localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
Booting 2.6.27-rc6, or the current Linus' git on large x86_64 NUMA wedges
intermittently.  This happens on machines with more than 4 NUMA nodes.  The
same kernel boots on similar hardware with fewer NUMA nodes (or boards).
2.6.27-rc3 seemed to boot well on similar configurations, so looks like a
regression crept in between 2.6.27-rc3 and rc6.

I am trying a few things -- commandline options to eliminate popular
suspects (such as unsynced tsc clocksources)  as well as git bisect, but
wanted to report the regression in the meanwhile.
Here's the dmesg of a 24 core 6 node wedged system.

Thanks,
Kiran


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="paw40.dmesg"

[    0.000000] Linux version 2.6.27-rc6-00091-gbc45eb8-dirty (kiran@ScaleMPBuild) (gcc version 3.4.5 20051201 (Red Hat 3.4.5-2)) #34 SMP Tue Sep 16 13:32:34 PDT 2008
[    0.000000] Command line: ro root=LABEL=/ console=ttyS0,115200 console=tty1 earlyprintk=serial,ttyS0,115200 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c0000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000007c9300000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] last_pfn = 0x7c9300 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xc0000 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: c0000000 end: c0000000
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 7c9300000 end: 7c9300000
[    0.000000] RAMDISK: 37de1000 - 37fef91d
[    0.000000] vSMP CTL: capabilities:0x000001ff  control:0x000001b1
[    0.000000] vSMP CTL: control set to:0x000001a1
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000E0000, 0014 (r0   ScMP)
[    0.000000] ACPI: RSDT 000E0024, 0038 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: FACP 000E0070, 00F4 (r4   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI Error (tbfadt-0428): Required field "Pm1aEventBlock" has zero address and/or length: 0000000000000000/4 [20080609]
[    0.000000] ACPI Error (tbfadt-0428): Required field "PmTimerBlock" has zero address and/or length: 0000000000000000/4 [20080609]
[    0.000000] ACPI: DSDT 000E01C0, 0886 (r1   ScMP vSMP 1.7        1 INTL 20041203)
[    0.000000] ACPI: FACS 000E0180, 0040
[    0.000000] ACPI: APIC 000E0A46, 01D8 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: HPET 000E0C1E, 0038 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: SRAT 000E0C56, 02C8 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: SLIT 000E0F1E, 0050 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 7 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 17 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 23 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 32 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 33 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 38 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 39 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 48 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 49 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 54 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 55 -> Node 3
[    0.000000] SRAT: PXM 4 -> APIC 64 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 65 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 70 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 71 -> Node 4
[    0.000000] SRAT: PXM 5 -> APIC 80 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 81 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 86 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 87 -> Node 5
[    0.000000] SRAT: Node 0 PXM 0 0-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-190000000
[    0.000000] SRAT: Node 1 PXM 1 190000000-2d0000000
[    0.000000] SRAT: Node 2 PXM 2 2d0000000-410000000
[    0.000000] SRAT: Node 3 PXM 3 410000000-550000000
[    0.000000] SRAT: Node 4 PXM 4 550000000-690000000
[    0.000000] SRAT: Node 5 PXM 5 690000000-7c9300000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000190000000
[    0.000000]   NODE_DATA [0000000000027100 - 00000000000360ff]
[    0.000000]   bootmap [0000000000037000 -  0000000000068fff] pages 32
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0190000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS ==> [0000200000 - 0001a3d2b0]
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK ==> [0037de1000 - 0037fef91d]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE ==> [000000a000 - 0000027000]
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT ==> [0000001000 - 0000001050]
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP ==> [0000027000 - 0000027100]
[    0.000000] Bootmem setup node 1 0000000190000000-00000002d0000000
[    0.000000]   NODE_DATA [0000000190000000 - 000000019000efff]
[    0.000000]   bootmap [000000019000f000 -  0000000190036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0190000000 - 02d0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 2 00000002d0000000-0000000410000000
[    0.000000]   NODE_DATA [00000002d0000000 - 00000002d000efff]
[    0.000000]   bootmap [00000002d000f000 -  00000002d0036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [02d0000000 - 0410000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 3 0000000410000000-0000000550000000
[    0.000000]   NODE_DATA [0000000410000000 - 000000041000efff]
[    0.000000]   bootmap [000000041000f000 -  0000000410036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0410000000 - 0550000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 4 0000000550000000-0000000690000000
[    0.000000]   NODE_DATA [0000000550000000 - 000000055000efff]
[    0.000000]   bootmap [000000055000f000 -  0000000550036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0550000000 - 0690000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 5 0000000690000000-00000007c9300000
[    0.000000]   NODE_DATA [0000000690000000 - 000000069000efff]
[    0.000000]   bootmap [000000069000f000 -  000000069003625f] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0690000000 - 07c9300000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] found SMP MP-table at [ffff8800000fe000] 000fe000
[    0.000000] [ffffe20005780000-ffffe200057fffff] potential offnode page_structs
[    0.000000] [ffffe20009d80000-ffffe20009dfffff] potential offnode page_structs
[    0.000000] [ffffe2000e380000-ffffe2000e3fffff] potential offnode page_structs
[    0.000000] [ffffe20012980000-ffffe200129fffff] potential offnode page_structs
[    0.000000] [ffffe20016f80000-ffffe20016ffffff] potential offnode page_structs
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x007c9300
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000c0000
[    0.000000]     0: 0x00100000 -> 0x00190000
[    0.000000]     1: 0x00190000 -> 0x002d0000
[    0.000000]     2: 0x002d0000 -> 0x00410000
[    0.000000]     3: 0x00410000 -> 0x00550000
[    0.000000]     4: 0x00550000 -> 0x00690000
[    0.000000]     5: 0x00690000 -> 0x007c9300
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 15, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x1f] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 31, version 0, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x2f] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 47, version 0, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x3f] address[0xfec03000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 63, version 0, address 0xfec03000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x4f] address[0xfec04000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 79, version 0, address 0xfec04000, GSI 96-119
[    0.000000] ACPI: IOAPIC (id[0x5f] address[0xfec05000] gsi_base[120])
[    0.000000] IOAPIC[5]: apic_id 95, version 0, address 0xfec05000, GSI 120-143
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to physical flat
[    0.000000] ACPI: HPET id: 0x1a101 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:40000000)
[    0.000000] PERCPU: Allocating 59296 bytes of per cpu data
[    0.000000] Built 6 zonelists in Zone order, mobility grouping on.  Total pages: 7790104
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=LABEL=/ console=ttyS0,115200 console=tty1 earlyprintk=serial,ttyS0,115200 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: Using PIT calibration value
[    0.000000] Detected 2992.461 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console handover: boot [earlyser0] -> real [tty1]
[    0.000000] Linux version 2.6.27-rc6-00091-gbc45eb8-dirty (kiran@ScaleMPBuild) (gcc version 3.4.5 20051201 (Red Hat 3.4.5-2)) #34 SMP Tue Sep 16 13:32:34 PDT 2008
[    0.000000] Command line: ro root=LABEL=/ console=ttyS0,115200 console=tty1 earlyprintk=serial,ttyS0,115200 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c0000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000007c9300000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] last_pfn = 0x7c9300 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xc0000 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: c0000000 end: c0000000
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 7c9300000 end: 7c9300000
[    0.000000] RAMDISK: 37de1000 - 37fef91d
[    0.000000] vSMP CTL: capabilities:0x000001ff  control:0x000001b1
[    0.000000] vSMP CTL: control set to:0x000001a1
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000E0000, 0014 (r0   ScMP)
[    0.000000] ACPI: RSDT 000E0024, 0038 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: FACP 000E0070, 00F4 (r4   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI Error (tbfadt-0428): Required field "Pm1aEventBlock" has zero address and/or length: 0000000000000000/4 [20080609]
[    0.000000] ACPI Error (tbfadt-0428): Required field "PmTimerBlock" has zero address and/or length: 0000000000000000/4 [20080609]
[    0.000000] ACPI: DSDT 000E01C0, 0886 (r1   ScMP vSMP 1.7        1 INTL 20041203)
[    0.000000] ACPI: FACS 000E0180, 0040
[    0.000000] ACPI: APIC 000E0A46, 01D8 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: HPET 000E0C1E, 0038 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: SRAT 000E0C56, 02C8 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] ACPI: SLIT 000E0F1E, 0050 (r1   ScMP vSMP 1.7 20080822 ScMP 20080822)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 7 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 17 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 23 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 32 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 33 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 38 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 39 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 48 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 49 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 54 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 55 -> Node 3
[    0.000000] SRAT: PXM 4 -> APIC 64 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 65 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 70 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 71 -> Node 4
[    0.000000] SRAT: PXM 5 -> APIC 80 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 81 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 86 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 87 -> Node 5
[    0.000000] SRAT: Node 0 PXM 0 0-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-190000000
[    0.000000] SRAT: Node 1 PXM 1 190000000-2d0000000
[    0.000000] SRAT: Node 2 PXM 2 2d0000000-410000000
[    0.000000] SRAT: Node 3 PXM 3 410000000-550000000
[    0.000000] SRAT: Node 4 PXM 4 550000000-690000000
[    0.000000] SRAT: Node 5 PXM 5 690000000-7c9300000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000190000000
[    0.000000]   NODE_DATA [0000000000027100 - 00000000000360ff]
[    0.000000]   bootmap [0000000000037000 -  0000000000068fff] pages 32
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0190000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS ==> [0000200000 - 0001a3d2b0]
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK ==> [0037de1000 - 0037fef91d]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE ==> [000000a000 - 0000027000]
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT ==> [0000001000 - 0000001050]
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP ==> [0000027000 - 0000027100]
[    0.000000] Bootmem setup node 1 0000000190000000-00000002d0000000
[    0.000000]   NODE_DATA [0000000190000000 - 000000019000efff]
[    0.000000]   bootmap [000000019000f000 -  0000000190036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0190000000 - 02d0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 2 00000002d0000000-0000000410000000
[    0.000000]   NODE_DATA [00000002d0000000 - 00000002d000efff]
[    0.000000]   bootmap [00000002d000f000 -  00000002d0036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [02d0000000 - 0410000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 3 0000000410000000-0000000550000000
[    0.000000]   NODE_DATA [0000000410000000 - 000000041000efff]
[    0.000000]   bootmap [000000041000f000 -  0000000410036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0410000000 - 0550000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 4 0000000550000000-0000000690000000
[    0.000000]   NODE_DATA [0000000550000000 - 000000055000efff]
[    0.000000]   bootmap [000000055000f000 -  0000000550036fff] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0550000000 - 0690000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] Bootmem setup node 5 0000000690000000-00000007c9300000
[    0.000000]   NODE_DATA [0000000690000000 - 000000069000efff]
[    0.000000]   bootmap [000000069000f000 -  000000069003625f] pages 28
[    0.000000] (9 early reservations) ==> bootmem [0690000000 - 07c9300000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0001a3d2b0]    TEXT DATA BSS
[    0.000000]   #3 [0037de1000 - 0037fef91d]          RAMDISK
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #6 [000000a000 - 0000027000]          PGTABLE
[    0.000000]   #7 [0000001000 - 0000001050]        ACPI SLIT
[    0.000000]   #8 [0000027000 - 0000027100]       MEMNODEMAP
[    0.000000] found SMP MP-table at [ffff8800000fe000] 000fe000
[    0.000000] [ffffe20005780000-ffffe200057fffff] potential offnode page_structs
[    0.000000] [ffffe20009d80000-ffffe20009dfffff] potential offnode page_structs
[    0.000000] [ffffe2000e380000-ffffe2000e3fffff] potential offnode page_structs
[    0.000000] [ffffe20012980000-ffffe200129fffff] potential offnode page_structs
[    0.000000] [ffffe20016f80000-ffffe20016ffffff] potential offnode page_structs
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x007c9300
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000c0000
[    0.000000]     0: 0x00100000 -> 0x00190000
[    0.000000]     1: 0x00190000 -> 0x002d0000
[    0.000000]     2: 0x002d0000 -> 0x00410000
[    0.000000]     3: 0x00410000 -> 0x00550000
[    0.000000]     4: 0x00550000 -> 0x00690000
[    0.000000]     5: 0x00690000 -> 0x007c9300
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 15, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x1f] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 31, version 0, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x2f] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 47, version 0, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x3f] address[0xfec03000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 63, version 0, address 0xfec03000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x4f] address[0xfec04000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 79, version 0, address 0xfec04000, GSI 96-119
[    0.000000] ACPI: IOAPIC (id[0x5f] address[0xfec05000] gsi_base[120])
[    0.000000] IOAPIC[5]: apic_id 95, version 0, address 0xfec05000, GSI 120-143
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to physical flat
[    0.000000] ACPI: HPET id: 0x1a101 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:40000000)
[    0.000000] PERCPU: Allocating 59296 bytes of per cpu data
[    0.000000] Built 6 zonelists in Zone order, mobility grouping on.  Total pages: 7790104
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=LABEL=/ console=ttyS0,115200 console=tty1 earlyprintk=serial,ttyS0,115200 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: Using PIT calibration value
[    0.000000] Detected 2992.461 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console handover: boot [earlyser0] -> real [tty1]
[    0.010000] console [ttyS0] enabled
[    0.010000] Checking aperture...
[    0.010000] No AGP bridge found
[    0.010000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.010000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.010000] Memory: 31077616k/32656384k available (4153k kernel code, 529808k reserved, 1669k data, 612k init)
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5984.92 BogoMIPS (lpj=29924610)
[    0.015185] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.188018] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.276818] Mount-cache hash table entries: 256
[    0.281625] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.286553] CPU: L2 cache: 4096K
[    0.290004] CPU 0/0 -> Node 0
[    0.293114] CPU: Physical Processor ID: 0
[    0.297268] CPU: Processor Core ID: 0
[    0.300034] CPU0: Thermal monitoring enabled (TM2)
[    0.306441] Freeing SMP alternatives: 32k freed
[    0.310015] ACPI: Core revision 20080609
[    0.330702] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.439775] CPU0: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.440000] Using local APIC timer interrupts.
[    0.440000] Detected 20.781 MHz APIC timer.
[    0.440000] Booting processor 1/1 ip 6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 5984.97 BogoMIPS (lpj=29924854)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 1/1 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU1: Thermal monitoring enabled (TM2)
[    0.590505] CPU1: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.600404] Booting processor 2/6 ip 6000
[    0.010000] Initializing CPU#2
[    0.010000] Calibrating delay using timer specific routine.. 5985.03 BogoMIPS (lpj=29925189)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 2/6 -> Node 0
[    0.010000] CPU: Physical Processor ID: 3
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU2: Thermal monitoring enabled (TM2)
[    0.760459] CPU2: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.770326] Booting processor 3/7 ip 6000
[    0.010000] Initializing CPU#3
[    0.010000] Calibrating delay using timer specific routine.. 5985.01 BogoMIPS (lpj=29925070)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 3/7 -> Node 0
[    0.010000] CPU: Physical Processor ID: 3
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU3: Thermal monitoring enabled (TM2)
[    0.930395] CPU3: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.941558] Booting processor 4/16 ip 6000
[    0.010000] Initializing CPU#4
[    0.010000] Calibrating delay using timer specific routine.. 6006.32 BogoMIPS (lpj=30031635)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 4/10 -> Node 1
[    0.010000] CPU: Physical Processor ID: 8
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU4: Thermal monitoring enabled (TM2)
[    1.111055] CPU4: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    1.132863] Booting processor 5/17 ip 6000
[    0.010000] Initializing CPU#5
[    0.010000] Calibrating delay using timer specific routine.. 5998.88 BogoMIPS (lpj=29994415)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 5/11 -> Node 1
[    0.010000] CPU: Physical Processor ID: 8
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU5: Thermal monitoring enabled (TM2)
[    1.300921] CPU5: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    1.323363] Booting processor 6/22 ip 6000
[    0.010000] Initializing CPU#6
[    0.010000] Calibrating delay using timer specific routine.. 5998.86 BogoMIPS (lpj=29994309)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 6/16 -> Node 1
[    0.010000] CPU: Physical Processor ID: 11
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU6: Thermal monitoring enabled (TM2)
[    1.490815] CPU6: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    1.512776] Booting processor 7/23 ip 6000
[    0.010000] Initializing CPU#7
[    0.010000] Calibrating delay using timer specific routine.. 5999.75 BogoMIPS (lpj=29998758)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 7/17 -> Node 1
[    0.010000] CPU: Physical Processor ID: 11
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU7: Thermal monitoring enabled (TM2)
[    1.680795] CPU7: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    1.702474] Booting processor 8/32 ip 6000
[    0.010000] Initializing CPU#8
[    0.010000] Calibrating delay using timer specific routine.. 5996.28 BogoMIPS (lpj=29981444)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 8/20 -> Node 2
[    0.010000] CPU: Physical Processor ID: 16
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU8: Thermal monitoring enabled (TM2)
[    1.871093] CPU8: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    1.888181] Booting processor 9/33 ip 6000
[    0.010000] Initializing CPU#9
[    0.010000] Calibrating delay using timer specific routine.. 6001.41 BogoMIPS (lpj=30007054)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 9/21 -> Node 2
[    0.010000] CPU: Physical Processor ID: 16
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU9: Thermal monitoring enabled (TM2)
[    2.050911] CPU9: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    2.072908] Booting processor 10/38 ip 6000
[    0.010000] Initializing CPU#10
[    0.010000] Calibrating delay using timer specific routine.. 5999.81 BogoMIPS (lpj=29999088)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 10/26 -> Node 2
[    0.010000] CPU: Physical Processor ID: 19
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU10: Thermal monitoring enabled (TM2)
[    2.240887] CPU10: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    2.262896] Booting processor 11/39 ip 6000
[    0.010000] Initializing CPU#11
[    0.010000] Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=30002351)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 11/27 -> Node 2
[    0.010000] CPU: Physical Processor ID: 19
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU11: Thermal monitoring enabled (TM2)
[    2.430805] CPU11: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    2.452568] Booting processor 12/48 ip 6000
[    0.010000] Initializing CPU#12
[    0.010000] Calibrating delay using timer specific routine.. 5996.95 BogoMIPS (lpj=29984765)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 12/30 -> Node 3
[    0.010000] CPU: Physical Processor ID: 24
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU12: Thermal monitoring enabled (TM2)
[    2.621095] CPU12: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    2.642636] Booting processor 13/49 ip 6000
[    0.010000] Initializing CPU#13
[    0.010000] Calibrating delay using timer specific routine.. 5998.60 BogoMIPS (lpj=29993040)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 13/31 -> Node 3
[    0.010000] CPU: Physical Processor ID: 24
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU13: Thermal monitoring enabled (TM2)
[    2.810901] CPU13: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    2.832408] Booting processor 14/54 ip 6000
[    0.010000] Initializing CPU#14
[    0.010000] Calibrating delay using timer specific routine.. 5998.02 BogoMIPS (lpj=29990136)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 14/36 -> Node 3
[    0.010000] CPU: Physical Processor ID: 27
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU14: Thermal monitoring enabled (TM2)
[    3.000845] CPU14: <4>Clocksource tsc unstable (delta = -102331123 ns)
[    3.010071] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    3.022401] Booting processor 15/55 ip 6000
[    0.010000] Initializing CPU#15
[    0.010000] Calibrating delay using timer specific routine.. 5997.49 BogoMIPS (lpj=29987496)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 15/37 -> Node 3
[    0.010000] CPU: Physical Processor ID: 27
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU15: Thermal monitoring enabled (TM2)
[    3.190813] CPU15: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    3.212662] Booting processor 16/64 ip 6000
[    0.010000] Initializing CPU#16
[    0.010000] Calibrating delay using timer specific routine.. 5997.33 BogoMIPS (lpj=29986651)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 16/40 -> Node 4
[    0.010000] CPU: Physical Processor ID: 32
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU16: Thermal monitoring enabled (TM2)
[    3.381097] CPU16: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    3.402620] Booting processor 17/65 ip 6000
[    0.010000] Initializing CPU#17
[    0.010000] Calibrating delay using timer specific routine.. 5996.39 BogoMIPS (lpj=29981961)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 17/41 -> Node 4
[    0.010000] CPU: Physical Processor ID: 32
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU17: Thermal monitoring enabled (TM2)
[    3.570891] CPU17: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    3.592519] Booting processor 18/70 ip 6000
[    0.010000] Initializing CPU#18
[    0.010000] Calibrating delay using timer specific routine.. 6000.57 BogoMIPS (lpj=30002850)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 18/46 -> Node 4
[    0.010000] CPU: Physical Processor ID: 35
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU18: Thermal monitoring enabled (TM2)
[    3.760886] CPU18: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    3.782660] Booting processor 19/71 ip 6000
[    0.010000] Initializing CPU#19
[    0.010000] Calibrating delay using timer specific routine.. 5998.27 BogoMIPS (lpj=29991367)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 19/47 -> Node 4
[    0.010000] CPU: Physical Processor ID: 35
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU19: Thermal monitoring enabled (TM2)
[    3.950812] CPU19: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    3.972745] Booting processor 20/80 ip 6000
[    0.010000] Initializing CPU#20
[    0.010000] Calibrating delay using timer specific routine.. 5999.97 BogoMIPS (lpj=29999878)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 20/50 -> Node 5
[    0.010000] CPU: Physical Processor ID: 40
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU20: Thermal monitoring enabled (TM2)
[    4.141082] CPU20: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    4.162533] Booting processor 21/81 ip 6000
[    0.010000] Initializing CPU#21
[    0.010000] Calibrating delay using timer specific routine.. 5999.99 BogoMIPS (lpj=29999962)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 21/51 -> Node 5
[    0.010000] CPU: Physical Processor ID: 40
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU21: Thermal monitoring enabled (TM2)
[    4.331009] CPU21: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    4.352827] Booting processor 22/86 ip 6000
[    0.010000] Initializing CPU#22
[    0.010000] Calibrating delay using timer specific routine.. 5999.52 BogoMIPS (lpj=29997646)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 22/56 -> Node 5
[    0.010000] CPU: Physical Processor ID: 43
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU22: Thermal monitoring enabled (TM2)
[    4.520887] CPU22: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    4.542784] Booting processor 23/87 ip 6000
[    0.010000] Initializing CPU#23
[    0.010000] Calibrating delay using timer specific routine.. 5998.70 BogoMIPS (lpj=29993533)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 23/57 -> Node 5
[    0.010000] CPU: Physical Processor ID: 43
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU23: Thermal monitoring enabled (TM2)
[    4.710795] CPU23: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    4.730376] Brought up 24 CPUs
[    4.740691] Total of 24 processors activated (143923.61 BogoMIPS).
[    4.797727] net_namespace: 552 bytes
[    4.800793] Booting paravirtualized kernel on bare hardware
[    4.810251] xor: automatically using best checksumming function: generic_sse
[    4.860042]    generic_sse:  2461.200 MB/sec
[    4.864466] xor: using function: generic_sse (2461.200 MB/sec)
[    4.874658] NET: Registered protocol family 16
[    4.892177] No dock devices found.
[    4.908987] ACPI: bus type pci registered
[    4.921273] PCI: Using configuration type 1 for base access
[    5.248753] ACPI: Interpreter enabled
[    5.250000] ACPI: (supports S0 S5)
[    5.250431] ACPI: Using IOAPIC for interrupt routing
[    5.382689] ACPI: PCI Root Bridge [HB00] (0000:00)
[    5.393475] pci 0000:00:1e.0: transparent bridge
[    5.463924] ACPI: PCI Root Bridge [HB10] (0000:10)
[    5.513316] ACPI: PCI Root Bridge [HB20] (0000:20)
[    5.563848] ACPI: PCI Root Bridge [HB30] (0000:30)
[    5.614372] ACPI: PCI Root Bridge [HB40] (0000:40)
[    5.664367] ACPI: PCI Root Bridge [HB50] (0000:50)
[    5.723354] Linux Plug and Play Support v0.97 (c) Adam Belay
[    5.733138] pnp: PnP ACPI init
[    5.736370] ACPI: bus type pnp registered
[    5.740116] pnp: PnP ACPI: found 0 devices
[    5.744366] ACPI: ACPI bus type pnp unregistered
[    5.780337] SCSI subsystem initialized
[    5.831501] usbcore: registered new interface driver usbfs
[    5.844514] usbcore: registered new interface driver hub
[    5.856064] usbcore: registered new device driver usb
[    5.874213] PCI: Using ACPI for IRQ routing
[    5.930204] PCI-GART: No AMD northbridge found.
[    6.008189] pci 0000:02:02.0: PCI bridge, secondary bus 0000:05
[    6.011234] pci 0000:02:02.0:   IO window: 0xc000-0xcfff
[    6.011234] pci 0000:02:02.0:   MEM window: 0xef000000-0xefefffff
[    6.011234] pci 0000:02:02.0:   PREFETCH window: disabled
[    6.011234] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    6.011234] pci 0000:01:00.0:   IO window: 0xc000-0xcfff
[    6.011234] pci 0000:01:00.0:   MEM window: 0xef000000-0xefefffff
[    6.011234] pci 0000:01:00.0:   PREFETCH window: disabled
[    6.011234] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    6.011234] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    6.011234] pci 0000:00:02.0:   MEM window: 0xef000000-0xefefffff
[    6.011234] pci 0000:00:02.0:   PREFETCH window: disabled
[    6.011234] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    6.011234] pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
[    6.011234] pci 0000:00:1e.0:   MEM window: 0xeff00000-0xf96fffff
[    6.011234] pci 0000:00:1e.0:   PREFETCH window: disabled
[    6.101940] pci 0000:00:02.0: PCI INT A -> GSI 0 (level, low) -> IRQ 0
[    6.108637] pci 0000:01:00.0: PCI INT A -> GSI 0 (level, low) -> IRQ 0
[    6.111842] pci 0000:02:02.0: PCI INT A -> GSI 0 (level, low) -> IRQ 0
[    6.111842] pci 0000:12:02.0: PCI bridge, secondary bus 0000:15
[    6.111842] pci 0000:12:02.0:   IO window: 0xb000-0xbfff
[    6.111842] pci 0000:12:02.0:   MEM window: 0xee000000-0xeeffffff
[    6.111842] pci 0000:12:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:11:00.0: PCI bridge, secondary bus 0000:12
[    6.111842] pci 0000:11:00.0:   IO window: 0xb000-0xbfff
[    6.111842] pci 0000:11:00.0:   MEM window: 0xee000000-0xeeffffff
[    6.111842] pci 0000:11:00.0:   PREFETCH window: disabled
[    6.111842] pci 0000:10:02.0: PCI bridge, secondary bus 0000:11
[    6.111842] pci 0000:10:02.0:   IO window: 0xb000-0xbfff
[    6.111842] pci 0000:10:02.0:   MEM window: 0xee000000-0xeeffffff
[    6.111842] pci 0000:10:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:10:02.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    6.111842] pci 0000:11:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    6.111842] pci 0000:12:02.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    6.111842] pci 0000:22:02.0: PCI bridge, secondary bus 0000:25
[    6.111842] pci 0000:22:02.0:   IO window: 0xa000-0xafff
[    6.111842] pci 0000:22:02.0:   MEM window: 0xed000000-0xedffffff
[    6.111842] pci 0000:22:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:21:00.0: PCI bridge, secondary bus 0000:22
[    6.111842] pci 0000:21:00.0:   IO window: 0xa000-0xafff
[    6.111842] pci 0000:21:00.0:   MEM window: 0xed000000-0xedffffff
[    6.111842] pci 0000:21:00.0:   PREFETCH window: disabled
[    6.111842] pci 0000:20:02.0: PCI bridge, secondary bus 0000:21
[    6.111842] pci 0000:20:02.0:   IO window: 0xa000-0xafff
[    6.111842] pci 0000:20:02.0:   MEM window: 0xed000000-0xedffffff
[    6.111842] pci 0000:20:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:20:02.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    6.111842] pci 0000:21:00.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    6.111842] pci 0000:22:02.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    6.111842] pci 0000:32:02.0: PCI bridge, secondary bus 0000:35
[    6.111842] pci 0000:32:02.0:   IO window: 0x9000-0x9fff
[    6.111842] pci 0000:32:02.0:   MEM window: 0xec000000-0xecffffff
[    6.111842] pci 0000:32:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:31:00.0: PCI bridge, secondary bus 0000:32
[    6.111842] pci 0000:31:00.0:   IO window: 0x9000-0x9fff
[    6.111842] pci 0000:31:00.0:   MEM window: 0xec000000-0xecffffff
[    6.111842] pci 0000:31:00.0:   PREFETCH window: disabled
[    6.111842] pci 0000:30:02.0: PCI bridge, secondary bus 0000:31
[    6.111842] pci 0000:30:02.0:   IO window: 0x9000-0x9fff
[    6.111842] pci 0000:30:02.0:   MEM window: 0xec000000-0xecffffff
[    6.111842] pci 0000:30:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:30:02.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    6.111842] pci 0000:31:00.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    6.111842] pci 0000:32:02.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    6.111842] pci 0000:42:02.0: PCI bridge, secondary bus 0000:45
[    6.111842] pci 0000:42:02.0:   IO window: 0x8000-0x8fff
[    6.111842] pci 0000:42:02.0:   MEM window: 0xeb000000-0xebffffff
[    6.111842] pci 0000:42:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:41:00.0: PCI bridge, secondary bus 0000:42
[    6.111842] pci 0000:41:00.0:   IO window: 0x8000-0x8fff
[    6.111842] pci 0000:41:00.0:   MEM window: 0xeb000000-0xebffffff
[    6.111842] pci 0000:41:00.0:   PREFETCH window: disabled
[    6.111842] pci 0000:40:02.0: PCI bridge, secondary bus 0000:41
[    6.111842] pci 0000:40:02.0:   IO window: 0x8000-0x8fff
[    6.111842] pci 0000:40:02.0:   MEM window: 0xeb000000-0xebffffff
[    6.111842] pci 0000:40:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:40:02.0: PCI INT A -> GSI 100 (level, low) -> IRQ 100
[    6.111842] pci 0000:41:00.0: PCI INT A -> GSI 100 (level, low) -> IRQ 100
[    6.111842] pci 0000:42:02.0: PCI INT A -> GSI 100 (level, low) -> IRQ 100
[    6.111842] pci 0000:52:02.0: PCI bridge, secondary bus 0000:55
[    6.111842] pci 0000:52:02.0:   IO window: 0x7000-0x7fff
[    6.111842] pci 0000:52:02.0:   MEM window: 0xea000000-0xeaffffff
[    6.111842] pci 0000:52:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:51:00.0: PCI bridge, secondary bus 0000:52
[    6.111842] pci 0000:51:00.0:   IO window: 0x7000-0x7fff
[    6.111842] pci 0000:51:00.0:   MEM window: 0xea000000-0xeaffffff
[    6.111842] pci 0000:51:00.0:   PREFETCH window: disabled
[    6.111842] pci 0000:50:02.0: PCI bridge, secondary bus 0000:51
[    6.111842] pci 0000:50:02.0:   IO window: 0x7000-0x7fff
[    6.111842] pci 0000:50:02.0:   MEM window: 0xea000000-0xeaffffff
[    6.111842] pci 0000:50:02.0:   PREFETCH window: disabled
[    6.111842] pci 0000:50:02.0: PCI INT A -> GSI 124 (level, low) -> IRQ 124
[    6.111842] pci 0000:51:00.0: PCI INT A -> GSI 124 (level, low) -> IRQ 124
[    6.111842] pci 0000:52:02.0: PCI INT A -> GSI 124 (level, low) -> IRQ 124
[    6.111842] bus: 00 index 0 io port: [0, ffff]
[    6.111842] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 01 index 0 io port: [c000, cfff]
[    6.111842] bus: 01 index 1 mmio: [ef000000, efefffff]
[    6.111842] bus: 01 index 2 mmio: [0, 0]
[    6.111842] bus: 01 index 3 mmio: [0, 0]
[    6.111842] bus: 02 index 0 io port: [c000, cfff]
[    6.111842] bus: 02 index 1 mmio: [ef000000, efefffff]
[    6.111842] bus: 02 index 2 mmio: [0, 0]
[    6.111842] bus: 02 index 3 mmio: [0, 0]
[    6.111842] bus: 05 index 0 io port: [c000, cfff]
[    6.111842] bus: 05 index 1 mmio: [ef000000, efefffff]
[    6.111842] bus: 05 index 2 mmio: [0, 0]
[    6.111842] bus: 05 index 3 mmio: [0, 0]
[    6.111842] bus: 0c index 0 io port: [d000, dfff]
[    6.111842] bus: 0c index 1 mmio: [eff00000, f96fffff]
[    6.111842] bus: 0c index 2 mmio: [0, 0]
[    6.111842] bus: 0c index 3 io port: [0, ffff]
[    6.111842] bus: 0c index 4 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 10 index 0 io port: [0, ffff]
[    6.111842] bus: 10 index 1 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 11 index 0 io port: [b000, bfff]
[    6.111842] bus: 11 index 1 mmio: [ee000000, eeffffff]
[    6.111842] bus: 11 index 2 mmio: [0, 0]
[    6.111842] bus: 11 index 3 mmio: [0, 0]
[    6.111842] bus: 12 index 0 io port: [b000, bfff]
[    6.111842] bus: 12 index 1 mmio: [ee000000, eeffffff]
[    6.111842] bus: 12 index 2 mmio: [0, 0]
[    6.111842] bus: 12 index 3 mmio: [0, 0]
[    6.111842] bus: 15 index 0 io port: [b000, bfff]
[    6.111842] bus: 15 index 1 mmio: [ee000000, eeffffff]
[    6.111842] bus: 15 index 2 mmio: [0, 0]
[    6.111842] bus: 15 index 3 mmio: [0, 0]
[    6.111842] bus: 20 index 0 io port: [0, ffff]
[    6.111842] bus: 20 index 1 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 21 index 0 io port: [a000, afff]
[    6.111842] bus: 21 index 1 mmio: [ed000000, edffffff]
[    6.111842] bus: 21 index 2 mmio: [0, 0]
[    6.111842] bus: 21 index 3 mmio: [0, 0]
[    6.111842] bus: 22 index 0 io port: [a000, afff]
[    6.111842] bus: 22 index 1 mmio: [ed000000, edffffff]
[    6.111842] bus: 22 index 2 mmio: [0, 0]
[    6.111842] bus: 22 index 3 mmio: [0, 0]
[    6.111842] bus: 25 index 0 io port: [a000, afff]
[    6.111842] bus: 25 index 1 mmio: [ed000000, edffffff]
[    6.111842] bus: 25 index 2 mmio: [0, 0]
[    6.111842] bus: 25 index 3 mmio: [0, 0]
[    6.111842] bus: 30 index 0 io port: [0, ffff]
[    6.111842] bus: 30 index 1 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 31 index 0 io port: [9000, 9fff]
[    6.111842] bus: 31 index 1 mmio: [ec000000, ecffffff]
[    6.111842] bus: 31 index 2 mmio: [0, 0]
[    6.111842] bus: 31 index 3 mmio: [0, 0]
[    6.111842] bus: 32 index 0 io port: [9000, 9fff]
[    6.111842] bus: 32 index 1 mmio: [ec000000, ecffffff]
[    6.111842] bus: 32 index 2 mmio: [0, 0]
[    6.111842] bus: 32 index 3 mmio: [0, 0]
[    6.111842] bus: 35 index 0 io port: [9000, 9fff]
[    6.111842] bus: 35 index 1 mmio: [ec000000, ecffffff]
[    6.111842] bus: 35 index 2 mmio: [0, 0]
[    6.111842] bus: 35 index 3 mmio: [0, 0]
[    6.111842] bus: 40 index 0 io port: [0, ffff]
[    6.111842] bus: 40 index 1 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 41 index 0 io port: [8000, 8fff]
[    6.111842] bus: 41 index 1 mmio: [eb000000, ebffffff]
[    6.111842] bus: 41 index 2 mmio: [0, 0]
[    6.111842] bus: 41 index 3 mmio: [0, 0]
[    6.111842] bus: 42 index 0 io port: [8000, 8fff]
[    6.111842] bus: 42 index 1 mmio: [eb000000, ebffffff]
[    6.111842] bus: 42 index 2 mmio: [0, 0]
[    6.111842] bus: 42 index 3 mmio: [0, 0]
[    6.111842] bus: 45 index 0 io port: [8000, 8fff]
[    6.111842] bus: 45 index 1 mmio: [eb000000, ebffffff]
[    6.111842] bus: 45 index 2 mmio: [0, 0]
[    6.111842] bus: 45 index 3 mmio: [0, 0]
[    6.111842] bus: 50 index 0 io port: [0, ffff]
[    6.111842] bus: 50 index 1 mmio: [0, ffffffffffffffff]
[    6.111842] bus: 51 index 0 io port: [7000, 7fff]
[    6.111842] bus: 51 index 1 mmio: [ea000000, eaffffff]
[    6.111842] bus: 51 index 2 mmio: [0, 0]
[    6.111842] bus: 51 index 3 mmio: [0, 0]
[    6.111842] bus: 52 index 0 io port: [7000, 7fff]
[    6.111842] bus: 52 index 1 mmio: [ea000000, eaffffff]
[    6.111842] bus: 52 index 2 mmio: [0, 0]
[    6.111842] bus: 52 index 3 mmio: [0, 0]
[    6.111842] bus: 55 index 0 io port: [7000, 7fff]
[    6.111842] bus: 55 index 1 mmio: [ea000000, eaffffff]
[    6.111842] bus: 55 index 2 mmio: [0, 0]
[    6.111842] bus: 55 index 3 mmio: [0, 0]
[    6.998571] NET: Registered protocol family 2
[    7.117768] IP route cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    7.171272] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    7.214923] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    7.226305] TCP: Hash tables configured (established 524288 bind 65536)
[    7.233105] TCP reno registered
[    7.277976] NET: Registered protocol family 1
[    7.283448] checking if image is initramfs... it is
[    7.444909] Freeing initrd memory: 2106k freed

--Md/poaVZ8hnGTzuv--
