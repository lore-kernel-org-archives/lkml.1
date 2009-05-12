Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZELXbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZELXbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbZELX0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:26:41 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54085 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbZELX0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xjlk+Y47uCMXNBm88f4UsHqW0ToTE5TudLQTKKz4jhQTeXKRs3fRK9sIzhuuDsGTrN
         D+YHdozZDYDV4Ic5Sg3iUI12aoT2EeF56+dD2Q0Ao8YWDnmgZBKbs59GiKP25eZNd60N
         PJuM79v1+wI3m7J7dbkFhlxhGsd4MpEt/E+pY=
MIME-Version: 1.0
In-Reply-To: <86802c440905121613h799b2c54x9b8734c0f01fafb1@mail.gmail.com>
References: <20090511175312.GA27905@sgi.com>
	 <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com>
	 <20090512150622.GA10015@sgi.com>
	 <86802c440905120810x6ea4b228t14ca19376dc13f13@mail.gmail.com>
	 <20090512161605.GB19747@sgi.com>
	 <86802c440905120940r3d3261dap9d1843a9c832b582@mail.gmail.com>
	 <20090512180349.GA1479@sgi.com>
	 <86802c440905121431q682e8924l427a5257da01c370@mail.gmail.com>
	 <20090512215838.GA24411@sgi.com>
	 <86802c440905121613h799b2c54x9b8734c0f01fafb1@mail.gmail.com>
Date: Tue, 12 May 2009 16:26:39 -0700
Message-ID: <86802c440905121626g29afb47dwa93439a9f8a46ab1@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jack Steiner <steiner@sgi.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 4:13 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> will find one system that only have node1 has memory.

duplicated that ...

[    0.000000] Linux version 2.6.30-rc5-tip-01542-g60b6b0b-dirty
(yhlu@linux-mstp) (gcc version 4.3.2 [gcc-4_3-branch revision 141291]
(SUSE Linux) ) #222 SMP Tue May 12 13:45:54 PDT 2009ing
kernel.org/mydisk13_x86_64.gz
[    0.000000] Command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/mydisk13_x86_64.gz rw root=/dev/ram0 debug
unknown_nmi_panic initcall_debug apic=debug pci=routeirq,lastbus=255
ip=dhcp load_ramdisk=1 ramdisk_size=131072
BOOT_IMAGE=kernel.org/bzImage_2.6.30_k8.2
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
[    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffae000 - 000000007ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffbe000 - 000000007fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200n8')
[    0.000000] console [uart0] enabled
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x7ffb0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007ffb0000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0000000000 - 0040000000 page 1G
[    0.000000]  0040000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ffb0000 page 4k
[    0.000000] kernel direct mapping tables up to 7ffb0000 @ 8000-b000
[    0.000000] RAMDISK: 7d901000 - 7ff7f439
[    0.000000] ACPI: RSDP 00000000000fa570 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 000000007ffb0100 00094 (v01 SUN    X4x40
00000052 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007ffb0290 000F4 (v03 SUN    X4x40
00000052 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007ffb05d0 07EB4 (v01 SUN    X4x40
00000052 INTL 20051117)
[    0.000000] ACPI: FACS 000000007ffbe000 00040
[    0.000000] ACPI: APIC 000000007ffb0390 000EC (v01 SUN    X4x40
00000052 MSFT 00000097)
[    0.000000] ACPI: SPCR 000000007ffb0480 00050 (v01 SUN    X4x40
00000052 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007ffb04d0 0003C (v01 SUN    OEMMCFG
00000052 MSFT 00000097)
[    0.000000] ACPI: SLIT 000000007ffb0510 00030 (v01 SUN    OEMSLIT
00000052 MSFT 00000097)
[    0.000000] ACPI: SPMI 000000007ffb0580 00041 (v01 SUN    OEMSPMI
00000052 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007ffbe040 000AE (v01 SUN    X4x40
00000052 MSFT 00000097)
[    0.000000] ACPI: SRAT 000000007ffb8490 00100 (v01 AMD    FAM_F_10
00000002 AMD  00000001)
[    0.000000] ACPI: HPET 000000007ffb8590 00038 (v01 SUN    OEMHPET0
00000052 MSFT 00000097)
[    0.000000] ACPI: EINJ 000000007ffb85d0 00130 (v01  AMIER AMI_EINJ
10000815 MSFT 00000097)
[    0.000000] ACPI: BERT 000000007ffb8760 00030 (v01  AMIER AMI_BERT
10000815 MSFT 00000097)
[    0.000000] ACPI: ERST 000000007ffb8790 001B0 (v01  AMIER AMI_ERST
10000815 MSFT 00000097)
[    0.000000] ACPI: HEST 000000007ffb8940 000A8 (v01  AMIER AMI_HEST
10000815 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000007ffb89f0 010F4 (v01 A M I  POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 3 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 4 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 5 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 6 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 7 -> Node 1
[    0.000000] SRAT: Node 1 PXM 1 0-a0000
[    0.000000] Adding active range (1, 0x0, 0x99) 0 entries of 12800 used
[    0.000000] SRAT: Node 1 PXM 1 100000-80000000
[    0.000000] Adding active range (1, 0x100, 0x7ffa0) 1 entries of 12800 used
[    0.000000] Adding active range (1, 0x7ffae, 0x7ffb0) 2 entries of 12800 used
[    0.000000] ACPI: SLIT: nodes = 2
[    0.000000]    10 13
[    0.000000]    13 10
[    0.000000] NUMA: Allocated memnodemap from a000 - b040
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 1 0000000000000000-000000007ffb0000
[    0.000000]   NODE_DATA [000000000000b040 - 000000000001703f]
[    0.000000]   bootmap [0000000000018000 -  0000000000027ff7] pages 10
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 007ffb0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00020ae6d8]    TEXT DATA BSS ==>
[0000200000 - 00020ae6d8]
[    0.000000]   #3 [007d901000 - 007ff7f439]          RAMDISK ==>
[007d901000 - 007ff7f439]
[    0.000000]   #4 [0000099400 - 0000100000]    BIOS reserved ==>
[0000099400 - 0000100000]
[    0.000000]   #5 [00020af000 - 00020af308]              BRK ==>
[00020af000 - 00020af308]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==>
[0000008000 - 000000a000]
[    0.000000]   #7 [0000001000 - 0000001030]        ACPI SLIT ==>
[0000001000 - 0000001030]
[    0.000000]   #8 [000000a000 - 000000b040]       MEMNODEMAP ==>
[000000a000 - 000000b040]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]   mpc: fc4e0-fc6e4
[    0.000000]  [ffffea0000000000-ffffea7fffffffff] PGD
->ffff8800024b2000 on node 1
[    0.000000]  [ffffea0000000000-ffffea003fffffff] PUD
->ffff8800024b3000 on node 1
[    0.000000]  [ffffea0000000000-ffffea00033fffff] PMD ->
[ffff880002600000-ffff8800059fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     1: 0x00000000 -> 0x00000099
[    0.000000]     1: 0x00000100 -> 0x0007ffa0
[    0.000000]     1: 0x0007ffae -> 0x0007ffb0
[    0.000000] On node 1 totalpages: 524091
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 108 pages reserved
[    0.000000]   DMA zone: 3781 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13206 pages used for memmap
[    0.000000]   DMA32 zone: 506892 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xe008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xddfff000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xddfff000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] init_cpu_to_node:
[    0.000000] cpu 0 -> apicid 0x0 -> node 1
[    0.000000] cpu 1 -> apicid 0x1 -> node 1
[    0.000000] cpu 2 -> apicid 0x2 -> node 1
[    0.000000] cpu 3 -> apicid 0x3 -> node 1
[    0.000000] cpu 4 -> apicid 0x4 -> node 1
[    0.000000] cpu 5 -> apicid 0x5 -> node 1
[    0.000000] cpu 6 -> apicid 0x6 -> node 1
[    0.000000] cpu 7 -> apicid 0x7 -> node 1
[    0.000000] cpu 8 -> apicid 0xffff -> node 1
[    0.000000] cpu 9 -> apicid 0xffff -> node 1
[    0.000000] cpu 10 -> apicid 0xffff -> node 1
[    0.000000] cpu 11 -> apicid 0xffff -> node 1
[    0.000000] cpu 12 -> apicid 0xffff -> node 1
[    0.000000] cpu 13 -> apicid 0xffff -> node 1
[    0.000000] cpu 14 -> apicid 0xffff -> node 1
[    0.000000] cpu 15 -> apicid 0xffff -> node 1
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (ddfff000)
[    0.000000] nr_irqs_gsi: 48
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:60000000)
[    0.000000] NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:16 nr_node_ids:2
[    0.000000] PERCPU: Embedded 478 pages at ffff880005a00000, static
data 1925536 bytes
[    0.000000] Pid: 0, comm: swapper Not tainted
2.6.30-rc5-tip-01542-g60b6b0b-dirty #222
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff813a9195>] early_idt_handler+0x55/0x68
[    0.000000]  [<ffffffff8030d607>] ? next_zones_zonelist+0x27/0x6a
[    0.000000]  [<ffffffff8030d5ed>] ? next_zones_zonelist+0xd/0x6a
[    0.000000]  [<ffffffff802fdc99>] nr_free_zone_pages+0x51/0xaa
[    0.000000]  [<ffffffff8030f7b2>] ? mminit_verify_zonelist+0x16/0x170
[    0.000000]  [<ffffffff802fdd18>] nr_free_pagecache_pages+0x26/0x3c
[    0.000000]  [<ffffffff802fdf1c>] build_all_zonelists+0x1ee/0x292
[    0.000000]  [<ffffffff813a9d0a>] start_kernel+0x1a3/0x3fd
[    0.000000]  [<ffffffff813a92a9>] x86_64_start_reservations+0xb9/0xd4
[    0.000000]  [<ffffffff813a93b2>] x86_64_start_kernel+0xee/0x109
[    0.000000] RIP next_zones_zonelist+0x27/0x6a
