Return-Path: <linux-kernel-owner+w=401wt.eu-S1751062Ab0AKVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab0AKVlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781Ab0AKVk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:40:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:32695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab0AKVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:40:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="231552730"
Subject: Re: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic
 id != 0 can boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "ananth@in.ibm.com" <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20100111045326.GA11725@in.ibm.com>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>  <20100111045326.GA11725@in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 13:39:45 -0800
Message-Id: <1263245985.2859.497.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 20:53 -0800, Ananth N Mavinakayanahalli wrote:
> On an 8-way machine with quad-core Xeon, booting 2.6.32 or newer kernels
> fails:
> 
> ...

Ananth, I can't reproduce this issue here. I tried on two different
Intel platforms (one with having same cpu as yours):

NHM-EP with only one socket populated (with BP's APIC ID as 0x10 and has
total 8-logical processors, quad-core with HT) and another system is
with Tigerton processors (MP foxcove platform but only two sockets
(quad-core) populated. So again 8 logical processors. And this system
has BP's apic id as 0x18).

Latest linux kernel boots fine on both these with no issues (dmesg
appended for the tigerton/foxcove platform).

Based on your dmesg, I think your system also uses Tigerton processors
but what is the chipset? It looks you are using IBM platform. Are you
using some IBM specific chipset?

> For now, revert this optimization so the machines in question boot
> at least.

So far, I don't see a need for the revert. Perhaps we need a quirk for
your platform?

-----
(dmesg for a successful boot on tigerton/foxcove platform)

[    0.000000] Linux version 2.6.33-rc3-00290-g1b4d40a (sbsiddha@prithvi) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #227 SMP Mon Jan 11 13:06:28 PST 2010
[    0.000000] Command line: ro root=LABEL=/
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007e835000 (usable)
[    0.000000]  BIOS-e820: 000000007e835000 - 000000007e936000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e936000 - 000000007f917000 (usable)
[    0.000000]  BIOS-e820: 000000007f917000 - 000000007f9c9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f9c9000 - 000000007fa2e000 (usable)
[    0.000000]  BIOS-e820: 000000007fa2e000 - 000000007fa93000 (reserved)
[    0.000000]  BIOS-e820: 000000007fa93000 - 000000007fadf000 (usable)
[    0.000000]  BIOS-e820: 000000007fadf000 - 000000007fb13000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fb13000 - 000000007fb19000 (usable)
[    0.000000]  BIOS-e820: 000000007fb19000 - 000000007fb33000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fb33000 - 000000007fc00000 (usable)
[    0.000000]  BIOS-e820: 000000007fc00000 - 0000000090000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff810000 - 00000000ff81c000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000480000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x480000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 base 007FC00000 mask FFFFC00000 uncachable
[    0.000000]   2 base 7FE0000000 mask FFE0000000 uncachable
[    0.000000]   3 base 0000000000 mask F000000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x7fc00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000fdd50] fdd50
[    0.000000] init_memory_mapping: 0000000000000000-000000007fc00000
[    0.000000]  0000000000 - 007fc00000 page 2M
[    0.000000] kernel direct mapping tables up to 7fc00000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000480000000
[    0.000000]  0100000000 - 0480000000 page 2M
[    0.000000] kernel direct mapping tables up to 480000000 @ 9000-1c000
[    0.000000] RAMDISK: 37e6f000 - 37fef601
[    0.000000] ACPI: RSDP 00000000000f03c0 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007fb32120 00084 (v01 INTEL    SFC4UR 00000000 INTL 01000013)
[    0.000000] ACPI: SLIC 000000007fb31000 00176 (v01 INTEL    SFC4UR 00000002 INTL 01000013)
[    0.000000] ACPI: FACP 000000007fb2f000 000F4 (v03 INTEL    SFC4UR 00000000 INTL 01000013)
[    0.000000] ACPI: DSDT 000000007fb28000 05350 (v02 INTEL    SFC4UR 00000001 INTL 01000013)
[    0.000000] ACPI: FACS 000000007fadf000 00040
[    0.000000] ACPI: APIC 000000007fb2e000 00218 (v01 INTEL    SFC4UR 00000000 INTL 01000013)
[    0.000000] ACPI: SPCR 000000007fb27000 00050 (v01 INTEL    SFC4UR 00000000 INTL 01000013)
[    0.000000] ACPI: HPET 000000007fb26000 00038 (v01 INTEL    SFC4UR 00000001 INTL 01000013)
[    0.000000] ACPI: MCFG 000000007fb25000 0003C (v01 INTEL    SFC4UR 00000001 INTL 01000013)
[    0.000000] ACPI: SSDT 000000007fb1e000 0697A (v02  INTEL EIST     00004000 INTL 20060317)
[    0.000000] ACPI: TCPA 000000007fb1d000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: HEST 000000007fb1c000 000A8 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 000000007fb1b000 00030 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 000000007fb1a000 00230 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 000000007fb19000 00130 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000480000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000480000000
[    0.000000]   NODE_DATA [0000000000017000 - 000000000001dfff]
[    0.000000]   bootmap [0000000000100000 -  000000000018ffff] pages 90
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 0480000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00022c25e8]    TEXT DATA BSS ==> [0001000000 - 00022c25e8]
[    0.000000]   #2 [0037e6f000 - 0037fef601]          RAMDISK ==> [0037e6f000 - 0037fef601]
[    0.000000]   #3 [00022c3000 - 00022c33ec]              BRK ==> [00022c3000 - 00022c33ec]
[    0.000000]   #4 [00000fdd60 - 0000100000]    BIOS reserved ==> [00000fdd60 - 0000100000]
[    0.000000]   #5 [00000fdd50 - 00000fdd60]     MP-table mpf ==> [00000fdd50 - 00000fdd60]
[    0.000000]   #6 [000009f000 - 00000ef020]    BIOS reserved ==> [000009f000 - 00000ef020]
[    0.000000]   #7 [00000ef304 - 00000fdd50]    BIOS reserved ==> [00000ef304 - 00000fdd50]
[    0.000000]   #8 [00000ef020 - 00000ef304]     MP-table mpc ==> [00000ef020 - 00000ef304]
[    0.000000]   #9 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #10 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #11 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000]   #12 [0000009000 - 0000017000]          PGTABLE ==> [0000009000 - 0000017000]
[    0.000000]  [ffffea0000000000-ffffea000fbfffff] PMD -> [ffff880028600000-ffff8800365fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00480000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007e835
[    0.000000]     0: 0x0007e936 -> 0x0007f917
[    0.000000]     0: 0x0007f9c9 -> 0x0007fa2e
[    0.000000]     0: 0x0007fa93 -> 0x0007fadf
[    0.000000]     0: 0x0007fb13 -> 0x0007fb19
[    0.000000]     0: 0x0007fb33 -> 0x0007fc00
[    0.000000]     0: 0x00100000 -> 0x00480000
[    0.000000] On node 0 totalpages: 4192569
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 118 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 504274 pages, LIFO batch:31
[    0.000000]   Normal zone: 50176 pages used for memmap
[    0.000000]   Normal zone: 3619840 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x97] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x98] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x99] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x9a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x9b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x9c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x9d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x9e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x9f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec81000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec81000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 32 CPUs, 24 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007e835000 - 000000007e936000
[    0.000000] PM: Registered nosave memory: 000000007f917000 - 000000007f9c9000
[    0.000000] PM: Registered nosave memory: 000000007fa2e000 - 000000007fa93000
[    0.000000] PM: Registered nosave memory: 000000007fadf000 - 000000007fb13000
[    0.000000] PM: Registered nosave memory: 000000007fb19000 - 000000007fb33000
[    0.000000] PM: Registered nosave memory: 000000007fc00000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000ff810000
[    0.000000] PM: Registered nosave memory: 00000000ff810000 - 00000000ff81c000
[    0.000000] PM: Registered nosave memory: 00000000ff81c000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 90000000 (gap: 90000000:6f810000)
[    0.000000] setup_percpu: NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:32 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880036600000 s75672 r8192 d22632 u131072
[    0.000000] pcpu-alloc: s75672 r8192 d22632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4127939
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=LABEL=/
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16450352k/18874368k available (5541k kernel code, 2104092k absent, 319924k reserved, 7194k data, 600k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2925.407 MHz processor.
[    0.002011] Calibrating delay loop (skipped), value calculated using timer frequency.. 5850.81 BogoMIPS (lpj=2925407)
[    0.003797] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.016644] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.022980] Mount-cache hash table entries: 256
[    0.023188] CPU: Physical Processor ID: 6
[    0.023453] CPU: Processor Core ID: 0
[    0.023719] mce: CPU supports 6 MCE banks
[    0.024009] CPU0: Thermal monitoring enabled (TM2)
[    0.024279] using mwait in idle threads.
[    0.024547] numa_add_cpu cpu 0 node 0: mask now 0
[    0.024549] Performance Events: Core2 events, Intel PMU driver.
[    0.025004] ... version:                2
[    0.025268] ... bit width:              40
[    0.025533] ... generic registers:      2
[    0.025800] ... value mask:             000000ffffffffff
[    0.026002] ... max period:             000000007fffffff
[    0.026269] ... fixed-purpose events:   3
[    0.026534] ... event mask:             0000000700000003
[    0.027024] ACPI: Core revision 20091214
[    0.042084] Setting APIC routing to flat
[    0.043593] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053865] CPU0: Genuine Intel(R) CPU                  @ 2.93GHz stepping 0b
[    0.054999] Booting Node   0, Processors  #1
[    0.002999] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.126405]  #2
[    0.002999] numa_add_cpu cpu 2 node 0: mask now 0-2
[    0.198364]  #3
[    0.002999] numa_add_cpu cpu 3 node 0: mask now 0-3
[    0.270361]  #4
[    0.002999] numa_add_cpu cpu 4 node 0: mask now 0-4
[    0.342369]  #5
[    0.002999] numa_add_cpu cpu 5 node 0: mask now 0-5
[    0.414366]  #6
[    0.002999] numa_add_cpu cpu 6 node 0: mask now 0-6
[    0.486459]  #7
[    0.002999] numa_add_cpu cpu 7 node 0: mask now 0-7
[    0.558267] Brought up 8 CPUs
[    0.558800] Total of 8 processors activated (46814.18 BogoMIPS).
[    0.562165] NET: Registered protocol family 16
[    0.563040] ACPI: bus type pci registered
[    0.564014] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    0.564523] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    0.573025] PCI: Using configuration type 1 for base access
[    0.584096] bio: create slab <bio-0> at 0
[    0.586975] ACPI: EC: Look up EC in DSDT
[    0.588336] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20091214/dsopcode-596)
[    0.588928] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_._OSC] (Node ffff88047e4e6cf0), AE_AML_BUFFER_LIMIT
[    0.591013] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.591557] 
[    0.592084] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.592634] 
[    0.593147] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.593697] 
[    0.594223] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.594774] 
[    0.595257] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.595804] 
[    0.596260] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.596811] 
[    0.597251] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.597804] 
[    0.598254] ACPI: Actual Package length (0x10) is larger than NumElements field (0x6), truncated
[    0.599002] 
[    0.613071] ACPI: Interpreter enabled
[    0.613339] ACPI: (supports S0 S1 S4 S5)
[    0.613813] ACPI: Using IOAPIC for interrupt routing
[    0.629031] ACPI: No dock devices found.
[    0.631985] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.632032] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.637929] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.637931] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.637933] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.637935] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000fffff] (ignored)
[    0.637938] pci_root PNP0A08:00: host bridge window [mem 0x90000000-0xfdffffff] (ignored)
[    0.637940] pci_root PNP0A08:00: host bridge window [mem 0xfe700000-0xfe7003ff] (ignored)
[    0.637942] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff] (ignored)
[    0.638027] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.638031] pci 0000:00:00.0: PME# disabled
[    0.638098] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.638101] pci 0000:00:01.0: PME# disabled
[    0.638169] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.638172] pci 0000:00:02.0: PME# disabled
[    0.638250] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.638253] pci 0000:00:03.0: PME# disabled
[    0.638320] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.638323] pci 0000:00:04.0: PME# disabled
[    0.638391] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.638393] pci 0000:00:06.0: PME# disabled
[    0.638439] pci 0000:00:08.0: reg 10: [mem 0xa8d00000-0xa8d003ff 64bit]
[    0.638465] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    0.638467] pci 0000:00:08.0: PME# disabled
[    0.639005] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.639009] pci 0000:00:1c.0: PME# disabled
[    0.639077] pci 0000:00:1d.0: reg 20: [io  0x7080-0x709f]
[    0.639144] pci 0000:00:1d.1: reg 20: [io  0x7060-0x707f]
[    0.639221] pci 0000:00:1d.2: reg 20: [io  0x7040-0x705f]
[    0.639290] pci 0000:00:1d.3: reg 20: [io  0x7020-0x703f]
[    0.639356] pci 0000:00:1d.7: reg 10: [mem 0xa8d00800-0xa8d00bff]
[    0.639404] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.639408] pci 0000:00:1d.7: PME# disabled
[    0.639596] pci 0000:00:1f.2: reg 10: [io  0x70b8-0x70bf]
[    0.639601] pci 0000:00:1f.2: reg 14: [io  0x70c4-0x70c7]
[    0.639606] pci 0000:00:1f.2: reg 18: [io  0x70b0-0x70b7]
[    0.639611] pci 0000:00:1f.2: reg 1c: [io  0x70c0-0x70c3]
[    0.639616] pci 0000:00:1f.2: reg 20: [io  0x70a0-0x70af]
[    0.639622] pci 0000:00:1f.2: reg 24: [mem 0xa8d00400-0xa8d007ff]
[    0.639641] pci 0000:00:1f.2: PME# supported from D3hot
[    0.639644] pci 0000:00:1f.2: PME# disabled
[    0.639707] pci 0000:00:1f.3: reg 20: [io  0x7000-0x701f]
[    0.639766] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.642183] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.642274] pci 0000:02:00.0: PME# disabled
[    0.644963] pci 0000:02:00.3: PME# supported from D0 D3hot D3cold
[    0.645045] pci 0000:02:00.3: PME# disabled
[    0.645717] pci 0000:00:02.0: PCI bridge to [bus 02-07]
[    0.646002] pci 0000:00:02.0:   bridge window [io  0x5000-0x6fff]
[    0.646005] pci 0000:00:02.0:   bridge window [mem 0x98000000-0x98afffff]
[    0.648596] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.648687] pci 0000:03:00.0: PME# disabled
[    0.651642] pci 0000:03:01.0: PME# supported from D0 D3hot D3cold
[    0.651733] pci 0000:03:01.0: PME# disabled
[    0.654688] pci 0000:03:02.0: PME# supported from D0 D3hot D3cold
[    0.654779] pci 0000:03:02.0: PME# disabled
[    0.656550] pci 0000:02:00.0: PCI bridge to [bus 03-06]
[    0.656872] pci 0000:02:00.0:   bridge window [io  0x5000-0x6fff]
[    0.657001] pci 0000:02:00.0:   bridge window [mem 0x98000000-0x989fffff]
[    0.658137] pci 0000:04:00.0: reg 10: [mem 0x98900000-0x9893ffff 64bit]
[    0.658320] pci 0000:04:00.0: reg 18: [io  0x6000-0x60ff]
[    0.658688] pci 0000:04:00.0: reg 1c: [mem 0x98940000-0x9897ffff 64bit]
[    0.659045] pci 0000:04:00.0: reg 30: [mem 0xffff8000-0xffffffff pref]
[    0.660274] pci 0000:04:00.0: supports D1
[    0.662274] pci 0000:03:00.0: PCI bridge to [bus 04-04]
[    0.662642] pci 0000:03:00.0:   bridge window [io  0x6000-0x6fff]
[    0.662734] pci 0000:03:00.0:   bridge window [mem 0x98900000-0x989fffff]
[    0.664550] pci 0000:03:01.0: PCI bridge to [bus 05-05]
[    0.666229] pci 0000:06:00.0: reg 10: [mem 0x98820000-0x9883ffff]
[    0.666412] pci 0000:06:00.0: reg 14: [mem 0x98400000-0x987fffff]
[    0.666596] pci 0000:06:00.0: reg 18: [io  0x5020-0x503f]
[    0.668275] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.668366] pci 0000:06:00.0: PME# disabled
[    0.669642] pci 0000:06:00.1: reg 10: [mem 0x98800000-0x9881ffff]
[    0.669825] pci 0000:06:00.1: reg 14: [mem 0x98000000-0x983fffff]
[    0.670001] pci 0000:06:00.1: reg 18: [io  0x5000-0x501f]
[    0.671734] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    0.671825] pci 0000:06:00.1: PME# disabled
[    0.673871] pci 0000:03:02.0: PCI bridge to [bus 06-06]
[    0.674090] pci 0000:03:02.0:   bridge window [io  0x5000-0x5fff]
[    0.674181] pci 0000:03:02.0:   bridge window [mem 0x98000000-0x988fffff]
[    0.676780] pci 0000:02:00.3: PCI bridge to [bus 07-07]
[    0.677828] pci 0000:08:00.0: reg 10: [mem 0xa8c60000-0xa8c7ffff]
[    0.677834] pci 0000:08:00.0: reg 14: [mem 0xa8c40000-0xa8c5ffff]
[    0.677840] pci 0000:08:00.0: reg 18: [io  0x4020-0x403f]
[    0.677846] pci 0000:08:00.0: reg 1c: [mem 0xa8c84000-0xa8c87fff]
[    0.677860] pci 0000:08:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.677889] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.677892] pci 0000:08:00.0: PME# disabled
[    0.678027] pci 0000:08:00.1: reg 10: [mem 0xa8c20000-0xa8c3ffff]
[    0.678033] pci 0000:08:00.1: reg 14: [mem 0xa8c00000-0xa8c1ffff]
[    0.678039] pci 0000:08:00.1: reg 18: [io  0x4000-0x401f]
[    0.678045] pci 0000:08:00.1: reg 1c: [mem 0xa8c80000-0xa8c83fff]
[    0.678060] pci 0000:08:00.1: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.678088] pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
[    0.678092] pci 0000:08:00.1: PME# disabled
[    0.678141] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.678411] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.678414] pci 0000:00:03.0:   bridge window [mem 0xa8c00000-0xa8cfffff]
[    0.678498] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    0.678502] pci 0000:09:00.0: PME# disabled
[    0.678542] pci 0000:00:04.0: PCI bridge to [bus 09-12]
[    0.678819] pci 0000:00:04.0:   bridge window [io  0x2000-0x3fff]
[    0.678822] pci 0000:00:04.0:   bridge window [mem 0xa0c00000-0xa8bfffff]
[    0.678826] pci 0000:00:04.0:   bridge window [mem 0x98b00000-0xa0afffff 64bit pref]
[    0.678915] pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
[    0.678918] pci 0000:0a:02.0: PME# disabled
[    0.679025] pci 0000:0a:04.0: PME# supported from D0 D3hot D3cold
[    0.679029] pci 0000:0a:04.0: PME# disabled
[    0.679067] pci 0000:09:00.0: PCI bridge to [bus 0a-12]
[    0.679341] pci 0000:09:00.0:   bridge window [io  0x2000-0x3fff]
[    0.679345] pci 0000:09:00.0:   bridge window [mem 0xa0c00000-0xa8bfffff]
[    0.679351] pci 0000:09:00.0:   bridge window [mem 0x98b00000-0xa0afffff 64bit pref]
[    0.679391] pci 0000:0a:02.0: PCI bridge to [bus 0b-0e]
[    0.679664] pci 0000:0a:02.0:   bridge window [io  0x3000-0x3fff]
[    0.679668] pci 0000:0a:02.0:   bridge window [mem 0xa4c00000-0xa8bfffff]
[    0.679674] pci 0000:0a:02.0:   bridge window [mem 0x9cb00000-0xa0afffff 64bit pref]
[    0.679723] pci 0000:0a:04.0: PCI bridge to [bus 0f-12]
[    0.680006] pci 0000:0a:04.0:   bridge window [io  0x2000-0x2fff]
[    0.680010] pci 0000:0a:04.0:   bridge window [mem 0xa0c00000-0xa4bfffff]
[    0.680016] pci 0000:0a:04.0:   bridge window [mem 0x98b00000-0x9cafffff 64bit pref]
[    0.680125] pci 0000:13:00.0: PME# supported from D0 D3hot D3cold
[    0.680129] pci 0000:13:00.0: PME# disabled
[    0.680170] pci 0000:00:06.0: PCI bridge to [bus 13-16]
[    0.680528] pci 0000:14:02.0: PME# supported from D0 D3hot D3cold
[    0.680532] pci 0000:14:02.0: PME# disabled
[    0.680624] pci 0000:14:04.0: PME# supported from D0 D3hot D3cold
[    0.680628] pci 0000:14:04.0: PME# disabled
[    0.680666] pci 0000:13:00.0: PCI bridge to [bus 14-16]
[    0.680989] pci 0000:14:02.0: PCI bridge to [bus 15-15]
[    0.681053] pci 0000:14:04.0: PCI bridge to [bus 16-16]
[    0.681384] pci 0000:00:1c.0: PCI bridge to [bus 17-17]
[    0.682001] pci 0000:18:0c.0: reg 10: [mem 0x90000000-0x97ffffff pref]
[    0.682008] pci 0000:18:0c.0: reg 14: [io  0x1000-0x10ff]
[    0.682014] pci 0000:18:0c.0: reg 18: [mem 0xa0b00000-0xa0b0ffff]
[    0.682035] pci 0000:18:0c.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.682054] pci 0000:18:0c.0: supports D1 D2
[    0.682096] pci 0000:00:1e.0: PCI bridge to [bus 18-18] (subtractive decode)
[    0.682368] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.682372] pci 0000:00:1e.0:   bridge window [mem 0xa0b00000-0xa0bfffff]
[    0.682377] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0x97ffffff 64bit pref]
[    0.682401] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.682495] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC32._PRT]
[    0.682534] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.682574] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW._PRT]
[    0.682624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIO._PRT]
[    0.682676] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIP._PRT]
[    0.682721] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIQ._PRT]
[    0.682758] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIF._PRT]
[    0.682819] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P061._PRT]
[    0.682858] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P061.IDTA._PRT]
[    0.682930] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P061.IDTA.IZAB._PRT]
[    0.682993] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P061.IDTA.IZAC._PRT]
[    0.683057] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIK._PRT]
[    0.683099] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE0._PRT]
[    0.683170] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P041._PRT]
[    0.683210] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P041.IDTA._PRT]
[    0.683273] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P041.IDTA.IZAB._PRT]
[    0.683390] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P041.IDTA.IZAC._PRT]
[    0.695015] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
[    0.695701] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
[    0.696365] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 *11)
[    0.697052] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.697722] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 *10 11)
[    0.698363] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 *11)
[    0.699073] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 10 *11)
[    0.699740] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 *10 11)
[    0.700363] vgaarb: device added: PCI:0000:18:0c.0,decodes=io+mem,owns=io+mem,locks=none
[    0.701002] vgaarb: loaded
[    0.701500] SCSI subsystem initialized
[    0.702038] libata version 3.00 loaded.
[    0.702048] usbcore: registered new interface driver usbfs
[    0.703023] usbcore: registered new interface driver hub
[    0.703300] usbcore: registered new device driver usb
[    0.704042] PCI: Using ACPI for IRQ routing
[    0.704288] PCI: pci_cache_line_size set to 64 bytes
[    0.705224] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.705330] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.706002] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.712006] Switching to clocksource tsc
[    0.712426] pnp: PnP ACPI init
[    0.712720] ACPI: bus type pnp registered
[    0.718865] pnp: PnP ACPI: found 11 devices
[    0.719136] ACPI: ACPI bus type pnp unregistered
[    0.719423] system 00:01: [mem 0x80000000-0x8fffffff] has been reserved
[    0.719703] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.719974] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    0.720256] system 00:01: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.720527] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.720807] system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
[    0.721079] system 00:01: [mem 0xfe000000-0xfe01ffff] has been reserved
[    0.721366] system 00:06: [io  0x0500-0x053f] has been reserved
[    0.721643] system 00:06: [io  0x0400-0x047f] has been reserved
[    0.721911] system 00:06: [io  0x0800-0x087f] has been reserved
[    0.722184] system 00:06: [io  0x0ca2-0x0ca7] has been reserved
[    0.722457] system 00:06: [io  0x0ca8-0x0caf] has been reserved
[    0.722733] system 00:06: [io  0x0161] has been reserved
[    0.723000] system 00:06: [io  0x0162] has been reserved
[    0.729207] pci 0000:04:00.0: no compatible bridge window for [mem 0xffff8000-0xffffffff pref]
[    0.729710] pci 0000:08:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.730201] pci 0000:08:00.1: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.730704] pci 0000:18:0c.0: address space collision: [mem 0xfffe0000-0xffffffff pref] already in use
[    0.732614] pci 0000:00:02.0: BAR 9: assigned [mem 0xa8e00000-0xa8efffff pref]
[    0.733105] pci 0000:00:03.0: BAR 9: assigned [mem 0xa8f00000-0xa8ffffff pref]
[    0.733599] pci 0000:00:06.0: BAR 8: assigned [mem 0xa9000000-0xa93fffff]
[    0.733881] pci 0000:00:06.0: BAR 9: assigned [mem 0xa9400000-0xa97fffff 64bit pref]
[    0.734366] pci 0000:00:06.0: BAR 7: assigned [io  0x8000-0x9fff]
[    0.734646] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.734922] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.735193] pci 0000:00:01.0:   bridge window [mem disabled]
[    0.735475] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    0.735749] pci 0000:02:00.0: BAR 9: assigned [mem 0xa8e00000-0xa8efffff pref]
[    0.736238] pci 0000:03:00.0: BAR 9: assigned [mem 0xa8e00000-0xa8efffff pref]
[    0.736726] pci 0000:04:00.0: BAR 6: assigned [mem 0xa8e00000-0xa8e07fff pref]
[    0.737212] pci 0000:03:00.0: PCI bridge to [bus 04-04]
[    0.737485] pci 0000:03:00.0:   bridge window [io  0x6000-0x6fff]
[    0.737852] pci 0000:03:00.0:   bridge window [mem 0x98900000-0x989fffff]
[    0.738220] pci 0000:03:00.0:   bridge window [mem 0xa8e00000-0xa8efffff pref]
[    0.738846] pci 0000:03:01.0: PCI bridge to [bus 05-05]
[    0.739123] pci 0000:03:01.0:   bridge window [io  disabled]
[    0.739485] pci 0000:03:01.0:   bridge window [mem disabled]
[    0.746325] pci 0000:03:01.0:   bridge window [mem pref disabled]
[    0.746739] pci 0000:03:02.0: PCI bridge to [bus 06-06]
[    0.747014] pci 0000:03:02.0:   bridge window [io  0x5000-0x5fff]
[    0.747427] pci 0000:03:02.0:   bridge window [mem 0x98000000-0x988fffff]
[    0.747748] pci 0000:03:02.0:   bridge window [mem pref disabled]
[    0.748162] pci 0000:02:00.0: PCI bridge to [bus 03-06]
[    0.748438] pci 0000:02:00.0:   bridge window [io  0x5000-0x6fff]
[    0.748805] pci 0000:02:00.0:   bridge window [mem 0x98000000-0x989fffff]
[    0.749127] pci 0000:02:00.0:   bridge window [mem 0xa8e00000-0xa8efffff pref]
[    0.749745] pci 0000:02:00.3: PCI bridge to [bus 07-07]
[    0.750015] pci 0000:02:00.3:   bridge window [io  disabled]
[    0.750386] pci 0000:02:00.3:   bridge window [mem disabled]
[    0.750707] pci 0000:02:00.3:   bridge window [mem pref disabled]
[    0.751169] pci 0000:00:02.0: PCI bridge to [bus 02-07]
[    0.751437] pci 0000:00:02.0:   bridge window [io  0x5000-0x6fff]
[    0.751706] pci 0000:00:02.0:   bridge window [mem 0x98000000-0x98afffff]
[    0.751985] pci 0000:00:02.0:   bridge window [mem 0xa8e00000-0xa8efffff pref]
[    0.752479] pci 0000:08:00.0: BAR 6: assigned [mem 0xa8f00000-0xa8f1ffff pref]
[    0.752967] pci 0000:08:00.1: BAR 6: assigned [mem 0xa8f20000-0xa8f3ffff pref]
[    0.753458] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.753726] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.754005] pci 0000:00:03.0:   bridge window [mem 0xa8c00000-0xa8cfffff]
[    0.754286] pci 0000:00:03.0:   bridge window [mem 0xa8f00000-0xa8ffffff pref]
[    0.754769] pci 0000:0a:02.0: PCI bridge to [bus 0b-0e]
[    0.755048] pci 0000:0a:02.0:   bridge window [io  0x3000-0x3fff]
[    0.755334] pci 0000:0a:02.0:   bridge window [mem 0xa4c00000-0xa8bfffff]
[    0.755608] pci 0000:0a:02.0:   bridge window [mem 0x9cb00000-0xa0afffff 64bit pref]
[    0.756105] pci 0000:0a:04.0: PCI bridge to [bus 0f-12]
[    0.756385] pci 0000:0a:04.0:   bridge window [io  0x2000-0x2fff]
[    0.756657] pci 0000:0a:04.0:   bridge window [mem 0xa0c00000-0xa4bfffff]
[    0.756938] pci 0000:0a:04.0:   bridge window [mem 0x98b00000-0x9cafffff 64bit pref]
[    0.757434] pci 0000:09:00.0: PCI bridge to [bus 0a-12]
[    0.757703] pci 0000:09:00.0:   bridge window [io  0x2000-0x3fff]
[    0.757986] pci 0000:09:00.0:   bridge window [mem 0xa0c00000-0xa8bfffff]
[    0.758264] pci 0000:09:00.0:   bridge window [mem 0x98b00000-0xa0afffff 64bit pref]
[    0.758759] pci 0000:00:04.0: PCI bridge to [bus 09-12]
[    0.759037] pci 0000:00:04.0:   bridge window [io  0x2000-0x3fff]
[    0.759314] pci 0000:00:04.0:   bridge window [mem 0xa0c00000-0xa8bfffff]
[    0.759592] pci 0000:00:04.0:   bridge window [mem 0x98b00000-0xa0afffff 64bit pref]
[    0.760085] pci 0000:13:00.0: BAR 8: assigned [mem 0xa9000000-0xa93fffff]
[    0.760367] pci 0000:13:00.0: BAR 9: assigned [mem 0xa9400000-0xa97fffff 64bit pref]
[    0.760845] pci 0000:13:00.0: BAR 7: assigned [io  0x8000-0x9fff]
[    0.761124] pci 0000:14:02.0: BAR 8: assigned [mem 0xa9000000-0xa91fffff]
[    0.761406] pci 0000:14:02.0: BAR 9: assigned [mem 0xa9400000-0xa95fffff 64bit pref]
[    0.761886] pci 0000:14:04.0: BAR 8: assigned [mem 0xa9200000-0xa93fffff]
[    0.762168] pci 0000:14:04.0: BAR 9: assigned [mem 0xa9600000-0xa97fffff 64bit pref]
[    0.762659] pci 0000:14:02.0: BAR 7: assigned [io  0x8000-0x8fff]
[    0.762930] pci 0000:14:04.0: BAR 7: assigned [io  0x9000-0x9fff]
[    0.763207] pci 0000:14:02.0: PCI bridge to [bus 15-15]
[    0.763487] pci 0000:14:02.0:   bridge window [io  0x8000-0x8fff]
[    0.763761] pci 0000:14:02.0:   bridge window [mem 0xa9000000-0xa91fffff]
[    0.764038] pci 0000:14:02.0:   bridge window [mem 0xa9400000-0xa95fffff 64bit pref]
[    0.764542] pci 0000:14:04.0: PCI bridge to [bus 16-16]
[    0.764812] pci 0000:14:04.0:   bridge window [io  0x9000-0x9fff]
[    0.765092] pci 0000:14:04.0:   bridge window [mem 0xa9200000-0xa93fffff]
[    0.765364] pci 0000:14:04.0:   bridge window [mem 0xa9600000-0xa97fffff 64bit pref]
[    0.765855] pci 0000:13:00.0: PCI bridge to [bus 14-16]
[    0.766132] pci 0000:13:00.0:   bridge window [io  0x8000-0x9fff]
[    0.766406] pci 0000:13:00.0:   bridge window [mem 0xa9000000-0xa93fffff]
[    0.766688] pci 0000:13:00.0:   bridge window [mem 0xa9400000-0xa97fffff 64bit pref]
[    0.767182] pci 0000:00:06.0: PCI bridge to [bus 13-16]
[    0.767456] pci 0000:00:06.0:   bridge window [io  0x8000-0x9fff]
[    0.767732] pci 0000:00:06.0:   bridge window [mem 0xa9000000-0xa93fffff]
[    0.768006] pci 0000:00:06.0:   bridge window [mem 0xa9400000-0xa97fffff 64bit pref]
[    0.768503] pci 0000:00:1c.0: PCI bridge to [bus 17-17]
[    0.768776] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.769048] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.769328] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.769609] pci 0000:18:0c.0: BAR 6: assigned [mem 0xa0b20000-0xa0b3ffff pref]
[    0.770089] pci 0000:00:1e.0: PCI bridge to [bus 18-18]
[    0.770367] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.770647] pci 0000:00:1e.0:   bridge window [mem 0xa0b00000-0xa0bfffff]
[    0.770921] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0x97ffffff 64bit pref]
[    0.771427] pci 0000:00:01.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    0.771707] pci 0000:00:01.0: setting latency timer to 64
[    0.771715] pci 0000:00:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.771987] pci 0000:00:02.0: setting latency timer to 64
[    0.772129] pci 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.772495] pci 0000:02:00.0: setting latency timer to 64
[    0.772726] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.773046] pci 0000:03:00.0: setting latency timer to 64
[    0.773281] pci 0000:03:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.773643] pci 0000:03:01.0: setting latency timer to 64
[    0.773875] pci 0000:03:02.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.774194] pci 0000:03:02.0: setting latency timer to 64
[    0.774516] pci 0000:02:00.3: setting latency timer to 64
[    0.774568] pci 0000:00:03.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    0.774849] pci 0000:00:03.0: setting latency timer to 64
[    0.774857] pci 0000:00:04.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    0.775128] pci 0000:00:04.0: setting latency timer to 64
[    0.775137] pci 0000:09:00.0: setting latency timer to 64
[    0.775147] pci 0000:0a:02.0: setting latency timer to 64
[    0.775158] pci 0000:0a:04.0: setting latency timer to 64
[    0.775166] pci 0000:00:06.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
[    0.775447] pci 0000:00:06.0: setting latency timer to 64
[    0.775457] pci 0000:13:00.0: setting latency timer to 64
[    0.775467] pci 0000:14:02.0: setting latency timer to 64
[    0.775477] pci 0000:14:04.0: setting latency timer to 64
[    0.775486] pci 0000:00:1c.0: setting latency timer to 64
[    0.775491] pci 0000:00:1e.0: setting latency timer to 64
[    0.775495] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.775497] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.775499] pci_bus 0000:02: resource 0 [io  0x5000-0x6fff]
[    0.775501] pci_bus 0000:02: resource 1 [mem 0x98000000-0x98afffff]
[    0.775503] pci_bus 0000:02: resource 2 [mem 0xa8e00000-0xa8efffff pref]
[    0.775505] pci_bus 0000:03: resource 0 [io  0x5000-0x6fff]
[    0.775507] pci_bus 0000:03: resource 1 [mem 0x98000000-0x989fffff]
[    0.775509] pci_bus 0000:03: resource 2 [mem 0xa8e00000-0xa8efffff pref]
[    0.775511] pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
[    0.775512] pci_bus 0000:04: resource 1 [mem 0x98900000-0x989fffff]
[    0.775514] pci_bus 0000:04: resource 2 [mem 0xa8e00000-0xa8efffff pref]
[    0.775517] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.775518] pci_bus 0000:06: resource 1 [mem 0x98000000-0x988fffff]
[    0.775520] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    0.775522] pci_bus 0000:08: resource 1 [mem 0xa8c00000-0xa8cfffff]
[    0.775524] pci_bus 0000:08: resource 2 [mem 0xa8f00000-0xa8ffffff pref]
[    0.775526] pci_bus 0000:09: resource 0 [io  0x2000-0x3fff]
[    0.775528] pci_bus 0000:09: resource 1 [mem 0xa0c00000-0xa8bfffff]
[    0.775530] pci_bus 0000:09: resource 2 [mem 0x98b00000-0xa0afffff 64bit pref]
[    0.775532] pci_bus 0000:0a: resource 0 [io  0x2000-0x3fff]
[    0.775533] pci_bus 0000:0a: resource 1 [mem 0xa0c00000-0xa8bfffff]
[    0.775535] pci_bus 0000:0a: resource 2 [mem 0x98b00000-0xa0afffff 64bit pref]
[    0.775537] pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
[    0.775539] pci_bus 0000:0b: resource 1 [mem 0xa4c00000-0xa8bfffff]
[    0.775541] pci_bus 0000:0b: resource 2 [mem 0x9cb00000-0xa0afffff 64bit pref]
[    0.775543] pci_bus 0000:0f: resource 0 [io  0x2000-0x2fff]
[    0.775545] pci_bus 0000:0f: resource 1 [mem 0xa0c00000-0xa4bfffff]
[    0.775546] pci_bus 0000:0f: resource 2 [mem 0x98b00000-0x9cafffff 64bit pref]
[    0.775548] pci_bus 0000:13: resource 0 [io  0x8000-0x9fff]
[    0.775550] pci_bus 0000:13: resource 1 [mem 0xa9000000-0xa93fffff]
[    0.775552] pci_bus 0000:13: resource 2 [mem 0xa9400000-0xa97fffff 64bit pref]
[    0.775554] pci_bus 0000:14: resource 0 [io  0x8000-0x9fff]
[    0.775556] pci_bus 0000:14: resource 1 [mem 0xa9000000-0xa93fffff]
[    0.775558] pci_bus 0000:14: resource 2 [mem 0xa9400000-0xa97fffff 64bit pref]
[    0.775560] pci_bus 0000:15: resource 0 [io  0x8000-0x8fff]
[    0.775562] pci_bus 0000:15: resource 1 [mem 0xa9000000-0xa91fffff]
[    0.775563] pci_bus 0000:15: resource 2 [mem 0xa9400000-0xa95fffff 64bit pref]
[    0.775565] pci_bus 0000:16: resource 0 [io  0x9000-0x9fff]
[    0.775567] pci_bus 0000:16: resource 1 [mem 0xa9200000-0xa93fffff]
[    0.775569] pci_bus 0000:16: resource 2 [mem 0xa9600000-0xa97fffff 64bit pref]
[    0.775571] pci_bus 0000:18: resource 0 [io  0x1000-0x1fff]
[    0.775573] pci_bus 0000:18: resource 1 [mem 0xa0b00000-0xa0bfffff]
[    0.775575] pci_bus 0000:18: resource 2 [mem 0x90000000-0x97ffffff 64bit pref]
[    0.775577] pci_bus 0000:18: resource 3 [io  0x0000-0xffff]
[    0.775579] pci_bus 0000:18: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.775657] NET: Registered protocol family 2
[    0.776298] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.778619] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.784898] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.786548] TCP: Hash tables configured (established 524288 bind 65536)
[    0.786822] TCP reno registered
[    0.787166] UDP hash table entries: 8192 (order: 7, 786432 bytes)
[    0.788020] UDP-Lite hash table entries: 8192 (order: 7, 786432 bytes)
[    0.789167] NET: Registered protocol family 1
[    0.789893] RPC: Registered udp transport module.
[    0.790179] RPC: Registered tcp transport module.
[    0.790451] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.791311] pci 0000:08:00.0: Disabling L0s
[    0.791578] pci 0000:08:00.1: Disabling L0s
[    0.791872] pci 0000:18:0c.0: Boot video device
[    0.791876] PCI: CLS 64 bytes, default 64
[    0.791937] Trying to unpack rootfs image as initramfs...
[    0.819144] Freeing initrd memory: 1537k freed
[    0.819906] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.820181] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.820679] software IO TLB at phys 0x20000000 - 0x24000000
[    0.826101] microcode: CPU0 sig=0x6fb, pf=0x8, revision=0xb6
[    0.826403] microcode: CPU1 sig=0x6fb, pf=0x8, revision=0xb6
[    0.826690] microcode: CPU2 sig=0x6fb, pf=0x8, revision=0xb6
[    0.826987] microcode: CPU3 sig=0x6fb, pf=0x8, revision=0xb6
[    0.827270] microcode: CPU4 sig=0x6fb, pf=0x8, revision=0xb6
[    0.827574] microcode: CPU5 sig=0x6fb, pf=0x8, revision=0xb6
[    0.827860] microcode: CPU6 sig=0x6fb, pf=0x8, revision=0xb6
[    0.828141] microcode: CPU7 sig=0x6fb, pf=0x8, revision=0xb6
[    0.828502] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.830890] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.832430] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.832919] msgmni has been set to 32132
[    0.833240] io scheduler noop registered
[    0.833530] io scheduler deadline registered
[    0.833827] io scheduler cfq registered (default)
[    0.834303] pcieport 0000:00:01.0: setting latency timer to 64
[    0.834346] pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
[    0.834531] pcieport 0000:00:02.0: setting latency timer to 64
[    0.834567] pcieport 0000:00:02.0: irq 49 for MSI/MSI-X
[    0.834749] pcieport 0000:00:03.0: setting latency timer to 64
[    0.834783] pcieport 0000:00:03.0: irq 50 for MSI/MSI-X
[    0.834966] pcieport 0000:00:04.0: setting latency timer to 64
[    0.835001] pcieport 0000:00:04.0: irq 51 for MSI/MSI-X
[    0.835207] pcieport 0000:00:06.0: setting latency timer to 64
[    0.835241] pcieport 0000:00:06.0: irq 52 for MSI/MSI-X
[    0.835427] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.835472] pcieport 0000:00:1c.0: irq 53 for MSI/MSI-X
[    0.835824] pcieport 0000:02:00.0: setting latency timer to 64
[    0.838028] pcieport 0000:03:00.0: setting latency timer to 64
[    0.839636] pcieport 0000:03:00.0: irq 54 for MSI/MSI-X
[    0.841380] pcieport 0000:03:01.0: setting latency timer to 64
[    0.842988] pcieport 0000:03:01.0: irq 55 for MSI/MSI-X
[    0.844733] pcieport 0000:03:02.0: setting latency timer to 64
[    0.846340] pcieport 0000:03:02.0: irq 56 for MSI/MSI-X
[    0.847868] pcieport 0000:09:00.0: setting latency timer to 64
[    0.848001] pcieport 0000:0a:02.0: setting latency timer to 64
[    0.848062] pcieport 0000:0a:02.0: irq 57 for MSI/MSI-X
[    0.848347] pcieport 0000:0a:04.0: setting latency timer to 64
[    0.848403] pcieport 0000:0a:04.0: irq 58 for MSI/MSI-X
[    0.848666] pcieport 0000:13:00.0: setting latency timer to 64
[    0.848805] pcieport 0000:14:02.0: setting latency timer to 64
[    0.848867] pcieport 0000:14:02.0: irq 59 for MSI/MSI-X
[    0.849136] pcieport 0000:14:04.0: setting latency timer to 64
[    0.849196] pcieport 0000:14:04.0: irq 60 for MSI/MSI-X
[    0.849550] Firmware did not grant requested _OSC control
[    0.849553] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    0.849562] Firmware did not grant requested _OSC control
[    0.849565] aer 0000:00:02.0:pcie02: AER service couldn't init device: no _OSC support
[    0.849574] Firmware did not grant requested _OSC control
[    0.849577] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    0.849585] Firmware did not grant requested _OSC control
[    0.849588] aer 0000:00:04.0:pcie02: AER service couldn't init device: no _OSC support
[    0.849597] Firmware did not grant requested _OSC control
[    0.849604] aer 0000:00:06.0:pcie02: AER service couldn't init device: no _OSC support
[    0.850213] uvesafb: failed to execute /sbin/v86d
[    0.850487] uvesafb: make sure that the v86d helper is installed and executable
[    0.850977] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    0.851256] uvesafb: vbe_init() failed with -22
[    0.851522] uvesafb: probe of uvesafb.0 failed with error -22
[    0.852337] input: Power Button as /class/input/input0
[    0.852616] ACPI: Power Button [PWRB]
[    0.853007] input: Power Button as /class/input/input1
[    0.853280] ACPI: Power Button [PWRF]
[    0.854380] Marking TSC unstable due to TSC halts in idle
[    0.854830] Switching to clocksource hpet
[    0.911305] Real Time Clock Driver v1.12b
[    0.912094] intel_rng: Firmware space is locked read-only. If you can't or
[    0.912096] intel_rng: don't want to disable this in firmware setup, and if
[    0.912098] intel_rng: you are certain that your system has a functional
[    0.912099] intel_rng: RNG, try using the 'no_fwh_detect' option.
[    0.913243] Linux agpgart interface v0.103
[    0.913746] [drm] Initialized drm 1.1.0 20060810
[    0.914243] [drm] radeon defaulting to userspace modesetting.
[    0.914780] pci 0000:18:0c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.915265] [drm] Initialized radeon 1.31.0 20080528 for 0000:18:0c.0 on minor 0
[    0.916857] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.917310] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.917739] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.918786] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.919369] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.931122] floppy0: no floppy controllers found
[    3.934565] brd: module loaded
[    3.936368] loop: module loaded
[    3.936645] Uniform Multi-Platform E-IDE driver
[    3.937049] ide-gd driver 1.18
[    3.938376] megasas: 00.00.04.12-rc1 Thu Sep. 17 11:41:51 PST 2009
[    3.938669] megasas: 0x1000:0x0060:0x8086:0x34cc: bus 4:slot 0:func 0
[    3.939138] megaraid_sas 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.939663] megaraid_sas 0000:04:00.0: setting latency timer to 64
[    3.939846] megasas: FW now in Ready state
[    3.975096] scsi0 : LSI SAS based MegaRAID driver
[    4.028820] scsi 0:0:16:0: Enclosure         ESG-SHV. SCA HSBP M12.... 2.09 PQ: 0 ANSI: 3
[    4.030901] scsi 0:0:17:0: Direct-Access     SEAGATE  ST973401SS       0002 PQ: 0 ANSI: 3
[    4.059101] scsi 0:2:0:0: Direct-Access     INTEL    SROMBSAS28E      1.11 PQ: 0 ANSI: 5
[    4.074381] sd 0:2:0:0: [sda] 140623872 512-byte logical blocks: (71.9 GB/67.0 GiB)
[    4.074596] scsi 0:0:16:0: Attached scsi generic sg0 type 13
[    4.074696] sd 0:2:0:0: Attached scsi generic sg1 type 0
[    4.074902] ata_piix 0000:00:1f.2: version 2.13
[    4.074930] ata_piix 0000:00:1f.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.074935] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    4.074976] ata_piix 0000:00:1f.2: setting latency timer to 64
[    4.075085] scsi1 : ata_piix
[    4.075240] scsi2 : ata_piix
[    4.076688] sd 0:2:0:0: [sda] Write Protect is off
[    4.076755] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x70a0 irq 14
[    4.076757] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x70a8 irq 15
[    4.077142] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    4.077143] Copyright (c) 1999-2006 Intel Corporation.
[    4.077237] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    4.077238] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    4.077763] e1000e 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.077991] e1000e 0000:06:00.0: setting latency timer to 64
[    4.078921] sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
[    4.079658] sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    4.080379] e1000e 0000:06:00.0: irq 61 for MSI/MSI-X
[    4.082373]  sda: sda1 sda2 sda3 < sda5 sda6
[    4.115481] 0000:06:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:0e:0c:e2:ef:b0
[    4.116236] 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.116583] 0000:06:00.0: eth0: MAC: 5, PHY: 5, PBA No: 303000-001
[    4.117369] e1000e 0000:06:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    4.117824] e1000e 0000:06:00.1: setting latency timer to 64
[    4.120213] e1000e 0000:06:00.1: irq 62 for MSI/MSI-X
[    4.165522] 0000:06:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:0e:0c:e2:ef:b1
[    4.166005] 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
[    4.166358] 0000:06:00.1: eth1: MAC: 5, PHY: 5, PBA No: 303000-001
[    4.166705] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[    4.166981] Copyright (c) 2007-2009 Intel Corporation.
[    4.167274] igb 0000:08:00.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    4.167549] igb 0000:08:00.0: setting latency timer to 64
[    4.167780] igb 0000:08:00.0: irq 63 for MSI/MSI-X
[    4.167783] igb 0000:08:00.0: irq 64 for MSI/MSI-X
[    4.167786] igb 0000:08:00.0: irq 65 for MSI/MSI-X
[    4.167789] igb 0000:08:00.0: irq 66 for MSI/MSI-X
[    4.167793] igb 0000:08:00.0: irq 67 for MSI/MSI-X
[    4.167796] igb 0000:08:00.0: irq 68 for MSI/MSI-X
[    4.167800] igb 0000:08:00.0: irq 69 for MSI/MSI-X
[    4.167803] igb 0000:08:00.0: irq 70 for MSI/MSI-X
[    4.167807] igb 0000:08:00.0: irq 71 for MSI/MSI-X
[    4.192043]  sda7 >
[    4.193443] sd 0:2:0:0: [sda] Attached SCSI disk
[    4.227851] ata1.01: NODEV after polling detection
[    4.239044] ata1.00: ATAPI: PHILIPS DVD-ROM SDR089, TQ02, max UDMA/33
[    4.239326] ata1.00: applying bridge limits
[    4.245257] ata1.00: configured for UDMA/33
[    4.248354] scsi 1:0:0:0: CD-ROM            PHILIPS  DVD-ROM SDR089   TQ02 PQ: 0 ANSI: 5
[    4.256190] sr0: scsi3-mmc drive: 4x/24x cd/rw xa/form2 cdda tray
[    4.256469] Uniform CD-ROM driver Revision: 3.20
[    4.256993] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.257281] sr 1:0:0:0: Attached scsi generic sg2 type 5
[    4.351728] igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network Connection
[    4.352002] igb 0000:08:00.0: eth2: (PCIe:2.5Gb/s:Width x4) 00:0e:0c:e2:fb:ea
[    4.352351] igb 0000:08:00.0: eth2: PBA No: 1040ff-0ff
[    4.352621] igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    4.353122] igb 0000:08:00.1: PCI INT B -> GSI 30 (level, low) -> IRQ 30
[    4.353397] igb 0000:08:00.1: setting latency timer to 64
[    4.353626] igb 0000:08:00.1: irq 72 for MSI/MSI-X
[    4.353629] igb 0000:08:00.1: irq 73 for MSI/MSI-X
[    4.353633] igb 0000:08:00.1: irq 74 for MSI/MSI-X
[    4.353636] igb 0000:08:00.1: irq 75 for MSI/MSI-X
[    4.353640] igb 0000:08:00.1: irq 76 for MSI/MSI-X
[    4.353643] igb 0000:08:00.1: irq 77 for MSI/MSI-X
[    4.353646] igb 0000:08:00.1: irq 78 for MSI/MSI-X
[    4.353649] igb 0000:08:00.1: irq 79 for MSI/MSI-X
[    4.353652] igb 0000:08:00.1: irq 80 for MSI/MSI-X
[    4.536543] igb 0000:08:00.1: Intel(R) Gigabit Ethernet Network Connection
[    4.536815] igb 0000:08:00.1: eth3: (PCIe:2.5Gb/s:Width x4) 00:0e:0c:e2:fb:eb
[    4.537166] igb 0000:08:00.1: eth3: PBA No: 1040ff-0ff
[    4.537435] igb 0000:08:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    4.538003] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.44-k2
[    4.538489] ixgbe: Copyright (c) 1999-2009 Intel Corporation.
[    4.538849] Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    4.539122] Copyright (c) 1999-2008 Intel Corporation.
[    4.539625] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.539900] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.540792] tun: Universal TUN/TAP device driver, 1.6
[    4.541063] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.541606] console [netcon0] enabled
[    4.541871] netconsole: network logging started
[    4.542142] Fusion MPT base driver 3.04.13
[    4.542408] Copyright (c) 1999-2008 LSI Corporation
[    4.542686] Fusion MPT SPI Host driver 3.04.13
[    4.543041] Fusion MPT FC Host driver 3.04.13
[    4.543410] Fusion MPT SAS Host driver 3.04.13
[    4.543939] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.544456] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.544755] ehci_hcd 0000:00:1d.7: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[    4.545042] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.545045] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.545438] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.545942] ehci_hcd 0000:00:1d.7: debug port 1
[    4.550097] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.550109] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xa8d00800
[    4.560077] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.560605] hub 1-0:1.0: USB hub found
[    4.560876] hub 1-0:1.0: 8 ports detected
[    4.561285] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.561643] uhci_hcd: USB Universal Host Controller Interface driver
[    4.561967] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.562250] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.562252] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.562622] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.563142] uhci_hcd 0000:00:1d.0: irq 22, io base 0x00007080
[    4.563634] hub 2-0:1.0: USB hub found
[    4.563902] hub 2-0:1.0: 2 ports detected
[    4.564218] uhci_hcd 0000:00:1d.1: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.564493] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.564496] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.564863] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.565375] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00007060
[    4.565861] hub 3-0:1.0: USB hub found
[    4.566136] hub 3-0:1.0: 2 ports detected
[    4.566445] uhci_hcd 0000:00:1d.2: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.566719] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.566721] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.567107] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.567615] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00007040
[    4.568116] hub 4-0:1.0: USB hub found
[    4.568381] hub 4-0:1.0: 2 ports detected
[    4.568686] uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.568959] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.568962] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.569341] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.569842] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00007020
[    4.570336] hub 5-0:1.0: USB hub found
[    4.570605] hub 5-0:1.0: 2 ports detected
[    4.571069] usbcore: registered new interface driver usblp
[    4.571345] Initializing USB Mass Storage driver...
[    4.571710] usbcore: registered new interface driver usb-storage
[    4.571979] USB Mass Storage support registered.
[    4.572424] usbcore: registered new interface driver usbserial
[    4.572766] USB Serial support registered for generic
[    4.573131] usbcore: registered new interface driver usbserial_generic
[    4.573402] usbserial: USB Serial Driver core
[    4.573740] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    4.574317] usbcore: registered new interface driver belkin
[    4.574592] belkin_sa: v1.2:USB Belkin Serial converter driver
[    4.574932] USB Serial support registered for debug
[    4.575292] usbcore: registered new interface driver debug
[    4.575841] PNP: No PS/2 controller found. Probing ports directly.
[    4.578690] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.578965] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.579557] mice: PS/2 mouse device common for all mice
[    4.580567] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    4.583551] cpuidle: using governor ladder
[    4.587338] cpuidle: using governor menu
[    4.590836] usbcore: registered new interface driver usbhid
[    4.591125] usbhid: USB HID core driver
[    4.591535] TCP cubic registered
[    4.592004] NET: Registered protocol family 10
[    4.593209] IPv6 over IPv4 tunneling driver
[    4.593813] NET: Registered protocol family 17
[    4.650722] Freeing unused kernel memory: 600k freed
[    4.651201] Write protecting the kernel read-only data: 10240k
[    4.651581] Testing CPA: undo ffffffff81000000-ffffffff81a00000
[    4.651906] Testing CPA: again
[    4.652316] Freeing unused kernel memory: 580k freed
[    4.652896] Freeing unused kernel memory: 1392k freed
[    4.914044] usb 1-7: new high speed USB device using ehci_hcd and address 3
[    4.927445] uhci_hcd: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    4.929227] ohci_hcd: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    4.930984] ehci_hcd: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.029722] hub 1-7:1.0: USB hub found
[    5.030090] hub 1-7:1.0: 3 ports detected
[    5.238044] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    5.436980] input: Avocent USB_AMIQ as /class/input/input2
[    5.437358] generic-usb 0003:0624:0200.0001: input: USB HID v1.10 Keyboard [Avocent USB_AMIQ] on usb-0000:00:1d.1-1/input0
[    5.447251] jbd: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.449281] ext3: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.451402] scsi_mod: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.453043] sd_mod: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.454665] megaraid_sas: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.456453] libata: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.458004] ata_piix: version magic '2.6.18-1.3002.el5 SMP mod_unload gcc-4.1' should be '2.6.33-rc3-00290-g1b4d40a SMP mod_unload '
[    5.468019] input: Avocent USB_AMIQ as /class/input/input3
[    5.468430] generic-usb 0003:0624:0200.0002: input: USB HID v1.10 Mouse [Avocent USB_AMIQ] on usb-0000:00:1d.1-1/input1
[    6.029392] kjournald starting.  Commit interval 5 seconds
[    6.029415] EXT3-fs (sda2): mounted filesystem with writeback data mode
[   23.300129] EXT3-fs (sda2): using internal journal
[   23.580733] kjournald starting.  Commit interval 5 seconds
[   23.580997] EXT3-fs (sda1): using internal journal
[   23.581003] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   23.690872] kjournald starting.  Commit interval 5 seconds
[   23.691142] EXT3-fs (sda5): using internal journal
[   23.691145] EXT3-fs (sda5): mounted filesystem with writeback data mode
[   27.104192] warning: process `kudzu' used the deprecated sysctl system call with 1.23.
[   30.827041] CPA self-test:
[   30.830541]  4k 2048 large 8186 gb 0 x 2045[ffff880000000000-ffff88003fe00000] miss 525312
[   30.847700]  4k 197632 large 7804 gb 0 x 20952[ffff880000000000-ffff88003fe00000] miss 525312
[   30.858251] process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
[   30.858693]  4k 197632 large 7804 gb 0 x 20952[ffff880000000000-ffff88003fe00000] miss 525312
[   30.858695] ok.
[   33.004064] e1000e 0000:06:00.0: irq 61 for MSI/MSI-X
[   33.056324] e1000e 0000:06:00.0: irq 61 for MSI/MSI-X
[   33.062140] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   34.777586] e1000e: eth2 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   34.777590] 0000:06:00.0: eth2: 10/100 speed: disabling TSO
[   34.792856] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[   39.773206] e1000e 0000:06:00.1: irq 62 for MSI/MSI-X
[   39.825329] e1000e 0000:06:00.1: irq 62 for MSI/MSI-X
[   39.831591] ADDRCONF(NETDEV_UP): eth3: link is not ready
[   45.391032] eth2: no IPv6 routers present
[   48.006793] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)


