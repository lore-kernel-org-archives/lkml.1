Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZELV6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZELV6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZELV6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:58:44 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46211 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751271AbZELV6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:58:43 -0400
Date: Tue, 12 May 2009 16:58:38 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090512215838.GA24411@sgi.com>
References: <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com> <86802c440905120810x6ea4b228t14ca19376dc13f13@mail.gmail.com> <20090512161605.GB19747@sgi.com> <86802c440905120940r3d3261dap9d1843a9c832b582@mail.gmail.com> <20090512180349.GA1479@sgi.com> <86802c440905121431q682e8924l427a5257da01c370@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440905121431q682e8924l427a5257da01c370@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> x2apic related?

No. 



> 
> can you disable x2apic in kernel?

Yes - We have a BIOS option to allow us to boot either in legacy apic mode OR
in x2apic mode.

Both behave the same...


	<6>Initializing cgroup subsys cpuset
	<6>Initializing cgroup subsys cpu
	<5>Linux version 2.6.30-rc5-next-20090512-medusa (steiner@alcatraz.americas.sgi.com) (gcc version 4.2.4) #7 SMP Tue May 12 16:54:27 CDT 2009
	<6>Command line: root=/dev/hda2 init=/bin/bash console=ttyS0,38400n8 fprom lpj=10000 nohpet loglevel=8 iommu=off dma32_size=4096
	<6>KERNEL supported cpus:
	<6>  Intel GenuineIntel
	<6>  AMD AuthenticAMD
	<6>  Centaur CentaurHauls
	<6>BIOS-provided physical RAM map:
	<6> BIOS-e820: 0000000000000000 - 0000000000006000 (usable)
	<6> BIOS-e820: 0000000000006000 - 0000000000200000 (reserved)
	<6> BIOS-e820: 0000000000200000 - 0000000010000000 (usable)
	<6> BIOS-e820: 0000000080000000 - 0000000090000000 (reserved)
	<6> BIOS-e820: 00000000f0000000 - 00000000fc000000 (reserved)
	<6> BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
	<6> BIOS-e820: 00000000fff60000 - 00000000fff6c000 (reserved)
	<6> BIOS-e820: 00000fe000000000 - 00000fe018000000 (reserved)
	<6>EFI v1.00 by SGI
	<6> ACPI 2.0=0xe0200  UVsystab=0xe08c0
	<6>EFI: mem00: type=7, attr=0x8, range=[0x0000000000000000-0x0000000000006000) (0MB)
	<6>EFI: mem01: type=5, attr=0x8000000000001000, range=[0x0000000000006000-0x00000000000b0000) (0MB)
	<6>EFI: mem02: type=6, attr=0x8000000000000008, range=[0x00000000000b0000-0x0000000000200000) (1MB)
	<6>EFI: mem03: type=7, attr=0x8, range=[0x0000000000200000-0x0000000010000000) (254MB)
	<6>EFI: mem04: type=6, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
	<6>EFI: mem05: type=6, attr=0x8000000000000001, range=[0x00000000f0000000-0x00000000fc000000) (192MB)
	<6>EFI: mem06: type=6, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
	<6>EFI: mem07: type=6, attr=0x8000000000000001, range=[0x00000000fff60000-0x00000000fff6c000) (0MB)
	<6>EFI: mem08: type=11, attr=0x8000000000000001, range=[0x00000fe000000000-0x00000fe018000000) (384MB)
	<6>DMI not present or invalid.
	<6>last_pfn = 0x10000 max_arch_pfn = 0x100000000
	<7>MTRR default type: write-back
	<7>MTRR fixed ranges enabled:
	<7>  00000-FFFFF write-back
	<7>MTRR variable ranges enabled:
	<7>  0 base 0   F0000000 mask FFF F0000000 uncachable
	<7>  1 base E0  00000000 mask FF0 00000000 uncachable
	<7>  2 base F0  00000000 mask FF0 00000000 uncachable
	<7>  3 base F00 00000000 mask FF0000000000 uncachable
	<7>  4 disabled
	<7>  5 disabled
	<7>  6 disabled
	<7>  7 disabled
	<6>x86 PAT enabled: cpu 0, old 0x606060606060606, new 0x7010600070106
	<6>init_memory_mapping: 0000000000000000-0000000010000000
	<7> 0000000000 - 0010000000 page 2M
	<7>kernel direct mapping tables up to 10000000 @ 93a000-93c000
	<4>ACPI: RSDP 00000000000e0200 00024 (v02       )
	<4>ACPI: XSDT 00000000000e0240 00054 (v01    SGI      UVL 00010001 FPRM 00000001)
	<4>ACPI: APIC 00000000000e02e0 00074 (v01    SGI      UVL 00010001 FPRM 00000001)
	<4>ACPI: SRAT 00000000000e0380 00078 (v01    SGI      UVL 00010001 FPRM 00000001)
	<4>ACPI: SLIT 00000000000e05e0 00030 (v01    SGI      UVL 00010001 FPRM 00000001)
	<4>ACPI: MCFG 00000000000e0640 0004C (v01    SGI      UVL 00010001 FPRM 00000001)
	<4>ACPI: FACP 00000000000e06a0 000F4 (v03    SGI      UVL 00030001 FPRM 00000001)
	<4>ACPI: DSDT 00000000000e02a0 00030 (v01    SGI      UVL 00010001 FPRM 00000001)
	<4>ACPI: FACS 00000000000e07a0 00040
	<4>ACPI: DMAR 00000000000e0860 0004C (v01    SGI      UVL 00010001 FPRM 00000001)
	<7>ACPI: Local APIC address 0xfee00000
	<6>SRAT: PXM 0 -> APIC 0 -> Node 0
	<6>SRAT: PXM 1 -> APIC 128 -> Node 1
	<6>SRAT: Node 1 PXM 1 0-fff6c000
	<7>NUMA: Using 63 for the hash shift.
	<6>Bootmem setup node 1 0000000000000000-0000000010000000
	<6>  NODE_DATA [0000000000939a80 - 000000000096da7f]
	<6>  bootmap [000000000096e000 -  000000000096ffff] pages 2
	<6>(7 early reservations) ==> bootmem [0000000000 - 0010000000]
	<6>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
	<6>  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
	<6>  #2 [0000200000 - 0000939a5c]    TEXT DATA BSS ==> [0000200000 - 0000939a5c]
	<6>  #3 [000009f000 - 00000e0900]    BIOS reserved ==> [000009f000 - 00000e0900]
	<6>  #4 [00000e0a68 - 0000100000]    BIOS reserved ==> [00000e0a68 - 0000100000]
	<6>  #5 [00000e0900 - 00000e0a68]       EFI memmap ==> [00000e0900 - 00000e0a68]
	<6>  #6 [0000001000 - 0000001030]        ACPI SLIT ==> [0000001000 - 0000001030]
	<7> [ffffe20000000000-ffffe200003fffff] PMD -> [ffff880001200000-ffff8800015fffff] on node 1
	<4>Zone PFN ranges:
	<4>  DMA      0x00000000 -> 0x00001000
	<4>  DMA32    0x00001000 -> 0x00100000
	<4>  Normal   0x00100000 -> 0x00100000
	<4>Movable zone start PFN for each node
	<4>early_node_map[2] active PFN ranges
	<4>    1: 0x00000000 -> 0x00000006
	<4>    1: 0x00000200 -> 0x00010000
	<7>On node 1 totalpages: 65030
	<7>  DMA zone: 56 pages used for memmap
	<7>  DMA zone: 1948 pages reserved
	<7>  DMA zone: 1586 pages, LIFO batch:0
	<7>  DMA32 zone: 840 pages used for memmap
	<7>  DMA32 zone: 60600 pages, LIFO batch:15
	<6>ACPI: PM-Timer IO Port: 0x1008
	<7>ACPI: Local APIC address 0xfee00000
	<6>ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
	<6>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x80] enabled)
	<6>ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
	<6>ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
	<6>ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
	<6>IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
	<6>ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
	<6>IOAPIC[1]: apic_id 9, version 0, address 0xfec80000, GSI 24-24
	<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
	<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
	<7>ACPI: IRQ0 used by override.
	<7>ACPI: IRQ2 used by override.
	<7>ACPI: IRQ9 used by override.
	<6>Using ACPI (MADT) for SMP configuration information
	<6>SMP: Allowing 2 CPUs, 0 hotplug CPUs
	<6>init_cpu_to_node:
	<6>cpu 0 -> apicid 0x0 -> node 1
	<6>cpu 1 -> apicid 0x80 -> node 1
	<7>nr_irqs_gsi: 25
	<6>PM: Registered nosave memory: 0000000000006000 - 0000000000200000
	<6>Allocating PCI resources starting at 18000000 (gap: 10000000:70000000)
	<6>NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
	<6>PERCPU: Embedded 26 pages at ffff880001005000, static data 76384 bytes
	<4> [<ffffffff806bd19e>] early_idt_handler+0x5e/0x71
	<4> [<ffffffff802942ad>] ? build_zonelists_node+0x2f/0x70
	<4> [<ffffffff8023417d>] ? __node_distance+0x59/0x70
	<4> [<ffffffff80295550>] __build_all_zonelists+0x1ae/0x55a
	<4> [<ffffffff80295b43>] build_all_zonelists+0x1b5/0x264
	<4> [<ffffffff806bdb73>] start_kernel+0x17a/0x3c5
	<4> [<ffffffff806bd140>] ? early_idt_handler+0x0/0x71
	<4> [<ffffffff806bd2a7>] x86_64_start_reservations+0xae/0xb2
	<4> [<ffffffff806bd3fd>] x86_64_start_kernel+0x152/0x161
	<4>RIP build_zonelists_node+0x2f/0x70



