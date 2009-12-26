Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZLZRZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZLZRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 12:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZLZRZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 12:25:57 -0500
Received: from mail.anarazel.de ([217.115.131.40]:59514 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZLZRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 12:25:55 -0500
From: Andres Freund <andres@anarazel.de>
To: Zhao Yakui <yakui.zhao@intel.com>, David Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: lvds downclocking breaks on G45/thinkpad T500
Date: Sat, 26 Dec 2009 17:49:29 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc1-andres-00366-g2f99f5c-dirty; KDE/4.3.85; x86_64; ; )
Cc: Adam Jackson <ajax@redhat.com>
MIME-Version: 1.0
Message-Id: <200912261749.30839.andres@anarazel.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_a6jNLVnRkSlIaQx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_a6jNLVnRkSlIaQx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Zhao,

On 2.6.33-rc1 I noticed that the display of my T500 with a G45 reacts very 
slowly (you can see the text appearing) and colors take a time to "solidify". 
I.e. making a white terminal black takes some seconds.
 
After some bisecting and guessing I recognized that the problem showed up 
after:

commit 18f9ed12f8c977e25d65a16af8e8d73f72417ba1
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Nov 20 03:24:16 2009 +0000

    drm/i915: Enable LVDS downclock feature through EDID.
    
    If more than one mode with the same resolution defined in EDID has different
    refresh rate, it is thought that the downclock is found for LVDS.
    We will program the different FPx0/1 register so that we can select 
dynamically
    between the low and high frequency.
    
    On the g4x platform we will use the CxSR feature to switch the different
    refresh rate if the LVDS downclock feature is supported.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

Setting dev_priv->lvds_downclock_avail = 0 in intel_find_lvds_downclock() 
unsurprisingly avoids the issue.

Anything I can do to help analyzing the issue?

Andres

--Boundary-00=_a6jNLVnRkSlIaQx
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-after-disabling"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-after-disabling"

[    0.000000] Linux version 2.6.33-rc1-andres-00366-g2f99f5c-dirty (andres@alap2) (gcc version 4.4.2 (Ubuntu 4.4.2-6ubuntu1) ) #138 SMP Thu Dec 24 19:02:51 CET 2009
[    0.000000] Command line: BOOT_IMAGE=//vmlinuz-2.6.33-rc1-andres-00366-g2f99f5c-dirty root=/dev/mapper/root_crypt ro rw rootflags=data=writeback,acl
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 23C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000023c000000
[    0.000000]  0100000000 - 023c000000 page 2M
[    0.000000] kernel direct mapping tables up to 23c000000 @ a000-14000
[    0.000000] RAMDISK: 36e2b000 - 37feffa9
[    0.000000] ACPI: RSDP 00000000000f6450 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd949b7a 0009C (v01 LENOVO TP-6F    00003090  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd949d00 000F4 (v03 LENOVO TP-6F    00003090 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd94a10e 0FAC1 (v01 LENOVO TP-6F    00003090 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd949eb4 0025A (v01 LENOVO TP-6F    00003090 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd959bcf 00052 (v01 LENOVO TP-6F    00003090 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd959c21 00078 (v01 LENOVO TP-6F    00003090 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd959c99 0003C (v01 LENOVO TP-6F    00003090 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd959cd5 00038 (v01 LENOVO TP-6F    00003090 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-6F    00003090  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-6F    00003090  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-6F    00003090 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1fa 00568 (v01 LENOVO TP-6F    00003090 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T500
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 023c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00021b8050]    TEXT DATA BSS ==> [0001000000 - 00021b8050]
[    0.000000]   #2 [0036e2b000 - 0037feffa9]          RAMDISK ==> [0036e2b000 - 0037feffa9]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #4 [00021b9000 - 00021b914c]              BRK ==> [00021b9000 - 00021b914c]
[    0.000000]   #5 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #6 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #7 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #8 [000000a000 - 000000f000]          PGTABLE ==> [000000a000 - 000000f000]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880028600000-ffff88002f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0023c000
[    0.000000] On node 0 totalpages: 2070023
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 111 pages reserved
[    0.000000]   DMA zone: 3831 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 17696 pages used for memmap
[    0.000000]   Normal zone: 1276640 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
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
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880028200000 s94360 r8192 d24424 u524288
[    0.000000] pcpu-alloc: s94360 r8192 d24424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2037880
[    0.000000] Kernel command line: BOOT_IMAGE=//vmlinuz-2.6.33-rc1-andres-00366-g2f99f5c-dirty root=/dev/mapper/root_crypt ro rw rootflags=data=writeback,acl
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8048920k/9371648k available (8128k kernel code, 1091556k absent, 230228k reserved, 7689k data, 620k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:440
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.096 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.19 BogoMIPS (lpj=2394096)
[    0.001109] Security Framework initialized
[    0.001165] Mount-cache hash table entries: 256
[    0.002064] CPU: Physical Processor ID: 0
[    0.002102] CPU: Processor Core ID: 0
[    0.002143] mce: CPU supports 6 MCE banks
[    0.002189] CPU0: Thermal monitoring enabled (TM2)
[    0.002231] using mwait in idle threads.
[    0.002271] Performance Events: Core2 events, Intel PMU driver.
[    0.002329] ... version:                2
[    0.002924] ... bit width:              40
[    0.002964] ... generic registers:      2
[    0.003002] ... value mask:             000000ffffffffff
[    0.003044] ... max period:             000000007fffffff
[    0.003084] ... fixed-purpose events:   3
[    0.003123] ... event mask:             0000000700000003
[    0.004199] ACPI: Core revision 20091214
[    0.026058] Setting APIC routing to flat
[    0.027266] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.037315] CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
[    0.037999] Booting Node   0, Processors  #1
[    0.109024] Brought up 2 CPUs
[    0.109098] Total of 2 processors activated (9575.93 BogoMIPS).
[    0.110077] xor: automatically using best checksumming function: generic_sse
[    0.115007]    generic_sse:  8868.000 MB/sec
[    0.115046] xor: using function: generic_sse (8868.000 MB/sec)
[    0.115110] Time: 20:47:29  Date: 12/25/09
[    0.115160] NET: Registered protocol family 16
[    0.115160] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.115160] ACPI: bus type pci registered
[    0.115160] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.115160] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.119181] PCI: Using configuration type 1 for base access
[    0.127107] bio: create slab <bio-0> at 0
[    0.129806] ACPI: EC: EC description table is found, configuring boot EC
[    0.139090] ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.147010] ACPI: Interpreter enabled
[    0.147050] ACPI: (supports S0 S3 S4 S5)
[    0.147135] ACPI: Using IOAPIC for interrupt routing
[    0.160191] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.161046] ACPI: Power Resource [PUBS] (on)
[    0.163478] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.163913] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.164064] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.164098] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.164100] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.164102] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.164105] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
[    0.164107] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.164109] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.164112] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff] (ignored)
[    0.164167] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
[    0.164174] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.164178] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.164212] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
[    0.164263] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.164295] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.164299] pci 0000:00:03.0: PME# disabled
[    0.164384] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
[    0.164392] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
[    0.164399] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.164453] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.164458] pci 0000:00:19.0: PME# disabled
[    0.164517] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.164602] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.164687] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.164768] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.164834] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.164839] pci 0000:00:1a.7: PME# disabled
[    0.164884] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
[    0.164942] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.164947] pci 0000:00:1b.0: PME# disabled
[    0.165042] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.165046] pci 0000:00:1c.0: PME# disabled
[    0.165140] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.165145] pci 0000:00:1c.1: PME# disabled
[    0.165241] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.165245] pci 0000:00:1c.3: PME# disabled
[    0.165339] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.165344] pci 0000:00:1c.4: PME# disabled
[    0.165411] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.165496] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.165581] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.165662] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.165729] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.165734] pci 0000:00:1d.7: PME# disabled
[    0.165963] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.165971] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.165978] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.165986] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.165993] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.166004] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.166050] pci 0000:00:1f.2: PME# supported from D3hot
[    0.166055] pci 0000:00:1f.2: PME# disabled
[    0.166093] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.166111] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.166196] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.166317] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    0.166432] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.166439] pci 0000:03:00.0: PME# disabled
[    0.166519] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.166565] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.166628] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.166672] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.166676] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.166684] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.166742] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.166785] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.166790] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.166797] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.166839] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
[    0.166867] pci 0000:15:00.0: supports D1 D2
[    0.166869] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.166875] pci 0000:15:00.0: PME# disabled
[    0.166917] pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
[    0.166988] pci 0000:15:00.1: supports D1 D2
[    0.166990] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.166995] pci 0000:15:00.1: PME# disabled
[    0.167041] pci 0000:15:00.2: reg 10: [mem 0xf4801800-0xf48018ff]
[    0.167113] pci 0000:15:00.2: supports D1 D2
[    0.167115] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.167120] pci 0000:15:00.2: PME# disabled
[    0.167162] pci 0000:15:00.3: reg 10: [mem 0xf4801c00-0xf4801cff]
[    0.167234] pci 0000:15:00.3: supports D1 D2
[    0.167235] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.167241] pci 0000:15:00.3: PME# disabled
[    0.167282] pci 0000:15:00.4: reg 10: [mem 0xf4802000-0xf48020ff]
[    0.167353] pci 0000:15:00.4: supports D1 D2
[    0.167355] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.167361] pci 0000:15:00.4: PME# disabled
[    0.167403] pci 0000:15:00.5: reg 10: [mem 0xf4802400-0xf48024ff]
[    0.167474] pci 0000:15:00.5: supports D1 D2
[    0.167476] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.167481] pci 0000:15:00.5: PME# disabled
[    0.167558] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.167604] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.167608] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.167616] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.167671] pci_bus 0000:00: on NUMA node 0
[    0.167676] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.167816] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.167878] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.167943] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.168015] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.168084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.175127] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.175405] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.175680] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.176222] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.176496] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.176770] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.177052] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.177327] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.177513] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.177513] vgaarb: loaded
[    0.177513] SCSI subsystem initialized
[    0.178011] libata version 3.00 loaded.
[    0.178033] usbcore: registered new interface driver usbfs
[    0.178066] usbcore: registered new interface driver hub
[    0.178066] usbcore: registered new device driver usb
[    0.194954] raid6: int64x1   1878 MB/s
[    0.211937] raid6: int64x2   2312 MB/s
[    0.228950] raid6: int64x4   1851 MB/s
[    0.245928] raid6: int64x8   1566 MB/s
[    0.262939] raid6: sse2x1    3960 MB/s
[    0.279931] raid6: sse2x2    4203 MB/s
[    0.296933] raid6: sse2x4    7074 MB/s
[    0.296971] raid6: using algorithm sse2x4 (7074 MB/s)
[    0.297023] PCI: Using ACPI for IRQ routing
[    0.297043] PCI: pci_cache_line_size set to 64 bytes
[    0.297201] Bluetooth: Core ver 2.15
[    0.297201] NET: Registered protocol family 31
[    0.297201] Bluetooth: HCI device and connection manager initialized
[    0.297201] Bluetooth: HCI socket layer initialized
[    0.297201] cfg80211: Using static regulatory domain info
[    0.297201] cfg80211: Regulatory domain: 00
[    0.297201]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.297201]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.297201]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    0.297239]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    0.297283]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.297326]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.297374] cfg80211: Calling CRDA to update world regulatory domain
[    0.298018] NetLabel: Initializing
[    0.298043] NetLabel:  domain hash size = 128
[    0.298082] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.298133] NetLabel:  unlabeled traffic allowed by default
[    0.298192] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.298192] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.298192] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.301010] Switching to clocksource tsc
[    0.303057] Slow work thread pool: Starting up
[    0.303124] Slow work thread pool: Ready
[    0.303173] FS-Cache: Loaded
[    0.303250] CacheFiles: Loaded
[    0.303296] pnp: PnP ACPI init
[    0.303339] ACPI: bus type pnp registered
[    0.365880] pnp: PnP ACPI: found 10 devices
[    0.365924] ACPI: ACPI bus type pnp unregistered
[    0.365972] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.366016] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    0.366059] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    0.366102] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.366144] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.366187] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.366231] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.366274] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.366318] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.366361] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.366405] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.366448] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.366492] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.366535] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.366583] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.366625] system 00:02: [io  0x1180-0x11ff] has been reserved
[    0.366667] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.366709] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.366751] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.366793] system 00:02: [io  0x1680-0x169f] has been reserved
[    0.366835] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.366878] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.366925] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.366968] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.367011] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.367054] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.372166] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    0.372211] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.372282] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.372352] pci 0000:00:1c.0: BAR 7: assigned [io  0x8000-0x8fff]
[    0.372395] pci 0000:00:1c.1: BAR 7: assigned [io  0x9000-0x9fff]
[    0.372437] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.372479] pci 0000:00:1c.0:   bridge window [io  0x8000-0x8fff]
[    0.372524] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.372570] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.372645] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.372687] pci 0000:00:1c.1:   bridge window [io  0x9000-0x9fff]
[    0.372733] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.372778] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.372854] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.372896] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.372949] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.372994] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.373070] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.373112] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.373157] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.373203] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.373280] pci 0000:15:00.0: BAR 9: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.373350] pci 0000:15:00.0: BAR 10: assigned [mem 0xc4000000-0xc7ffffff]
[    0.373393] pci 0000:15:00.0: BAR 7: assigned [io  0x4000-0x40ff]
[    0.373435] pci 0000:15:00.0: BAR 8: assigned [io  0x4400-0x44ff]
[    0.373477] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.373518] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
[    0.373564] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
[    0.373609] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.373682] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.373728] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.373770] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.373816] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.373861] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.373949]   alloc irq_desc for 20 on node -1
[    0.373951]   alloc kstat_irqs on node -1
[    0.373957] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.374002] pci 0000:00:1c.0: setting latency timer to 64
[    0.374012]   alloc irq_desc for 21 on node -1
[    0.374013]   alloc kstat_irqs on node -1
[    0.374017] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.374062] pci 0000:00:1c.1: setting latency timer to 64
[    0.374072]   alloc irq_desc for 23 on node -1
[    0.374073]   alloc kstat_irqs on node -1
[    0.374078] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.374123] pci 0000:00:1c.3: setting latency timer to 64
[    0.374133] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.374178] pci 0000:00:1c.4: setting latency timer to 64
[    0.374185] pci 0000:00:1e.0: setting latency timer to 64
[    0.374197]   alloc irq_desc for 16 on node -1
[    0.374199]   alloc kstat_irqs on node -1
[    0.374202] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.374250] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.374252] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.374254] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.374256] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.374258] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.374260] pci_bus 0000:03: resource 0 [io  0x9000-0x9fff]
[    0.374262] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    0.374264] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.374267] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.374268] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.374270] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.374273] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.374274] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.374276] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.374279] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
[    0.374280] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
[    0.374283] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.374284] pci_bus 0000:15: resource 3 [io  0x0000-0xffff]
[    0.374286] pci_bus 0000:15: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.374289] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
[    0.374291] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
[    0.374293] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.374296] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.374317] NET: Registered protocol family 2
[    0.374419] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.375722] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.377595] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.378622] TCP: Hash tables configured (established 262144 bind 65536)
[    0.378666] TCP reno registered
[    0.378713] UDP hash table entries: 4096 (order: 6, 393216 bytes)
[    0.378958] UDP-Lite hash table entries: 4096 (order: 6, 393216 bytes)
[    0.379844] NET: Registered protocol family 1
[    0.379903] pci 0000:00:02.0: Boot video device
[    0.380121] PCI: CLS 64 bytes, default 64
[    0.380172] Trying to unpack rootfs image as initramfs...
[    0.716363] Freeing initrd memory: 18195k freed
[    0.724691] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.724739] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.724816] software IO TLB at phys 0x20000000 - 0x24000000
[    0.725307] Simple Boot Flag at 0x35 set to 0x1
[    0.726243] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.726290] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.726370] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.726570] Intel AES-NI instructions are not detected.
[    0.726844] audit: initializing netlink socket (disabled)
[    0.726895] type=2000 audit(1261774049.726:1): initialized
[    0.727447] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.730467] VFS: Disk quotas dquot_6.5.2
[    0.730577] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.731438] fuse init (API version 7.13)
[    0.731721] msgmni has been set to 15757
[    0.731910] alg: No test for cipher_null (cipher_null-generic)
[    0.731969] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.732027] alg: No test for digest_null (digest_null-generic)
[    0.732085] alg: No test for compress_null (compress_null-generic)
[    0.732692] alg: No test for fcrypt (fcrypt-generic)
[    0.734280] alg: No test for stdrng (krng)
[    0.738837] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.739021] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.739092] io scheduler noop registered
[    0.739130] io scheduler deadline registered
[    0.739223] io scheduler cfq registered (default)
[    0.739880] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.739926]   alloc irq_desc for 24 on node -1
[    0.739928]   alloc kstat_irqs on node -1
[    0.739940] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.740104] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.740147]   alloc irq_desc for 25 on node -1
[    0.740148]   alloc kstat_irqs on node -1
[    0.740159] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.740318] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.740361]   alloc irq_desc for 26 on node -1
[    0.740363]   alloc kstat_irqs on node -1
[    0.740372] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.740531] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.740575]   alloc irq_desc for 27 on node -1
[    0.740576]   alloc kstat_irqs on node -1
[    0.740586] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    0.740836] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.743901] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.743944] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.744298] acpiphp: Slot [1] registered
[    0.744402] acpiphp: Slot [1-1] registered
[    0.744887] ACPI: AC Adapter [AC] (on-line)
[    0.745045] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.745283] ACPI: Lid Switch [LID]
[    0.745380] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.745456] ACPI: Sleep Button [SLPB]
[    0.745571] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.745641] ACPI: Power Button [PWRF]
[    0.746265] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.747327] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.750637] Monitor-Mwait will be used to enter C-1 state
[    0.750658] Monitor-Mwait will be used to enter C-2 state
[    0.750676] Monitor-Mwait will be used to enter C-3 state
[    0.750683] Marking TSC unstable due to TSC halts in idle
[    0.750775] Switching to clocksource hpet
[    0.751360] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.752266] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.798456] thermal LNXTHERM:01: registered as thermal_zone0
[    0.798503] ACPI: Thermal Zone [THM0] (52 C)
[    0.800010] thermal LNXTHERM:02: registered as thermal_zone1
[    0.800058] ACPI: Thermal Zone [THM1] (48 C)
[    0.800480] XENFS: not registering filesystem on non-xen platform
[    0.809353] ACPI: Battery Slot [BAT0] (battery present)
[    0.835407] Non-volatile memory driver v1.3
[    0.835450] Linux agpgart interface v0.103
[    0.835505] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.836562] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.856987] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.857097] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.857185] Hangcheck: Using get_cycles().
[    0.857277] [drm] Initialized drm 1.1.0 20060810
[    0.857355] [drm] radeon defaulting to userspace modesetting.
[    0.858501] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.858547] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.858591] i915 0000:00:02.0: setting latency timer to 64
[    0.876926] mtrr: no more MTRRs available
[    0.876971] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.877074]   alloc irq_desc for 28 on node -1
[    0.877076]   alloc kstat_irqs on node -1
[    0.877087] i915 0000:00:02.0: irq 28 for MSI/MSI-X
[    0.877093] [drm] set up 31M of stolen space
[    1.519020] [drm] LVDS-8: set mode 1680x1050 c
[    1.569622] Console: switching to colour frame buffer device 210x65
[    1.573622] fb0: inteldrmfb frame buffer device
[    1.573642] registered panic notifier
[    1.576630] acpi device:01: registered as cooling_device2
[    1.576886] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.576931] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.577029] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.577113] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.579523] brd: module loaded
[    1.580411] loop: module loaded
[    1.580847] ahci 0000:00:1f.2: version 3.0
[    1.580861] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.580930]   alloc irq_desc for 29 on node -1
[    1.580932]   alloc kstat_irqs on node -1
[    1.580944] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.580980] ahci: SSS flag set, parallel bus scan disabled
[    1.581031] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    1.581070] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    1.581108] ahci 0000:00:1f.2: setting latency timer to 64
[    1.581263] scsi0 : ahci
[    1.581406] scsi1 : ahci
[    1.581527] scsi2 : ahci
[    1.581650] scsi3 : ahci
[    1.582405] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 29
[    1.582441] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 29
[    1.582473] ata3: DUMMY
[    1.582485] ata4: DUMMY
[    1.582639] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    1.582668] Copyright (c) 1999-2006 Intel Corporation.
[    1.582737] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.582763] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.582819] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.582854] e1000e 0000:00:19.0: setting latency timer to 64
[    1.582939]   alloc irq_desc for 30 on node -1
[    1.582940]   alloc kstat_irqs on node -1
[    1.582953] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[    1.721261] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:86:60:5d:d6
[    1.721296] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.721348] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    1.721424] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[    1.721453] Copyright (c) 2007-2009 Intel Corporation.
[    1.721516] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[    1.721545] Copyright (c) 2009 Intel Corporation.
[    1.721646] PPP generic driver version 2.4.2
[    1.722346] tun: Universal TUN/TAP device driver, 1.6
[    1.722370] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.722488] usbcore: registered new interface driver cdc_subset
[    1.722535] console [netcon0] enabled
[    1.722553] netconsole: network logging started
[    1.723580] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    1.887028] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.889867] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.889871] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.890948] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.893722] ata1.00: ATA-8: WDC WD3200BEKT-22F3T0, 11.01A11, max UDMA/133
[    1.894844] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.897853] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.897856] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.899048] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.901933] ata1.00: configured for UDMA/133
[    1.917429] ata1.00: configured for UDMA/133
[    1.918636] ata1: EH complete
[    1.919941] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BEKT-2 11.0 PQ: 0 ANSI: 5
[    1.921470] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.922142] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.922196] sd 0:0:0:0: [sda] Write Protect is off
[    1.922198] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.922218] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.922350]  sda: sda1 sda2 sda3
[    1.959713] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.232027] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.234827] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.234830] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.236274] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.238655] ata2.00: ATA-8: Hitachi HTS545050B9A300, PB4OC64G, max UDMA/133
[    2.240124] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.243049] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.243052] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.244497] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.246875] ata2.00: configured for UDMA/133
[    2.261100] ata2.00: configured for UDMA/133
[    2.262491] ata2: EH complete
[    2.263932] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HTS54505 PB4O PQ: 0 ANSI: 5
[    2.265524] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.266115] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.268389] sd 1:0:0:0: [sdb] Write Protect is off
[    2.269787] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.269807] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.271327]  sdb: sdb1
[    2.292462] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.415826] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    2.417269] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    2.418746] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x7fff
[    2.420221] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4800000 - 0xf7ffffff
[    2.421715] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf3ffffff
[    2.675214] usbcore: registered new interface driver hwa-rc
[    2.676872] usbcore: registered new interface driver hwa-hc
[    2.678402] usbcore: registered new interface driver cdc_acm
[    2.679862] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    2.681380] usbcore: registered new interface driver cdc_wdm
[    2.682867] Initializing USB Mass Storage driver...
[    2.684379] usbcore: registered new interface driver usb-storage
[    2.685857] USB Mass Storage support registered.
[    2.687372] usbcore: registered new interface driver libusual
[    2.688965] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.697801] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.699298] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.700988] mice: PS/2 mouse device common for all mice
[    2.702834] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    2.704408] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    2.705934] rtc_cmos 00:07: RTC can wake from S4
[    2.707497] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.709037] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.709646] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.712138] i2c /dev entries driver
[    2.713841] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.716848] Linux video capture interface: v2.00
[    2.718460] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[    2.720227] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    2.721878] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[    2.723481] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.725021] iTCO_vendor_support: vendor-support=0
[    2.726557] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    2.728078] md: linear personality registered for level -1
[    2.729616] md: raid0 personality registered for level 0
[    2.731163] md: raid1 personality registered for level 1
[    2.732676] md: raid10 personality registered for level 10
[    2.734184] md: raid6 personality registered for level 6
[    2.735689] md: raid5 personality registered for level 5
[    2.737169] md: raid4 personality registered for level 4
[    2.738621] md: multipath personality registered for level -4
[    2.740075] md: faulty personality registered for level -5
[    2.741679] device-mapper: uevent: version 1.0.3
[    2.743247] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    2.744728] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    2.746209] usbcore: registered new interface driver btusb
[    2.747643] EDAC MC: Ver: 2.1.0 Dec 24 2009
[    2.749573] cpuidle: using governor ladder
[    2.751590] cpuidle: using governor menu
[    2.755598] wacom driver registered
[    2.757531] usbcore: registered new interface driver hiddev
[    2.759007] usbcore: registered new interface driver usbhid
[    2.760850] usbhid: USB HID core driver
[    2.762509] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    2.764148] ALSA device list:
[    2.765525]   No soundcards found.
[    2.766905] GACT probability on
[    2.768253] Mirror/redirect action on
[    2.769588] Simple TC action Loaded
[    2.771246] u32 classifier
[    2.772539]     Performance counters on
[    2.773851]     input device check on 
[    2.775161]     Actions configured 
[    2.776442] Netfilter messages via NETLINK v0.30.
[    2.777782] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.779376] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    2.780726] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    2.782074] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    2.783515] ctnetlink v0.93: registering with nfnetlink.
[    2.785169] IPv4 over IPv4 tunneling driver
[    2.786766] GRE over IPv4 tunneling driver
[    2.788879] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.790210] TCP bic registered
[    2.791516] TCP cubic registered
[    2.792794] TCP westwood registered
[    2.794057] TCP highspeed registered
[    2.795302] TCP hybla registered
[    2.796558] TCP htcp registered
[    2.797789] TCP vegas registered
[    2.799023] TCP veno registered
[    2.800228] TCP scalable registered
[    2.801433] TCP lp registered
[    2.802631] TCP yeah registered
[    2.803821] TCP illinois registered
[    2.804984] Initializing XFRM netlink socket
[    2.806632] NET: Registered protocol family 10
[    2.808329] lo: Disabled Privacy Extensions
[    2.811252] tunl0: Disabled Privacy Extensions
[    2.813183] Mobile IPv6
[    2.814268] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.815449] IPv6 over IPv4 tunneling driver
[    2.816974] sit0: Disabled Privacy Extensions
[    2.818903] ip6tnl0: Disabled Privacy Extensions
[    2.820364] NET: Registered protocol family 17
[    2.821432] NET: Registered protocol family 15
[    2.822577] Bridge firewalling registered
[    2.823648] Bluetooth: L2CAP ver 2.14
[    2.824691] Bluetooth: L2CAP socket layer initialized
[    2.825801] Bluetooth: SCO (Voice Link) ver 0.6
[    2.826883] Bluetooth: SCO socket layer initialized
[    2.828005] Bluetooth: RFCOMM TTY layer initialized
[    2.829085] Bluetooth: RFCOMM socket layer initialized
[    2.830132] Bluetooth: RFCOMM ver 1.11
[    2.831193] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.832239] Bluetooth: BNEP filters: protocol multicast
[    2.833260] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.834386] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.835459] All bugs added by David S. Miller <davem@redhat.com>
[    2.838115] SCTP: Hash tables configured (established 65536 bind 65536)
[    2.839675] lib80211: common routines for IEEE802.11 drivers
[    2.840771] lib80211_crypt: registered algorithm 'NULL'
[    2.842070] PM: Resume from disk failed.
[    2.842078] registered taskstats version 1
[    2.843561]   Magic number: 5:275:802
[    2.844879] rtc_cmos 00:07: setting system clock to 2009-12-25 20:47:32 UTC (1261774052)
[    2.846127] Freeing unused kernel memory: 620k freed
[    2.849470] Write protecting the kernel read-only data: 12288k
[    2.852879] Freeing unused kernel memory: 40k freed
[    2.856015] Freeing unused kernel memory: 728k freed
[    3.030091] uhci_hcd: USB Universal Host Controller Interface driver
[    3.039606] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.040914] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.050372] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.050377] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.066305] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.067805] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.071192] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.072687] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    3.074042] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.075346] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.076651] usb usb1: Product: UHCI Host Controller
[    3.077946] usb usb1: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty uhci_hcd
[    3.079254] usb usb1: SerialNumber: 0000:00:1a.0
[    3.081875] hub 1-0:1.0: USB hub found
[    3.086859] hub 1-0:1.0: 2 ports detected
[    3.088588] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    3.089893] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.091246] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.091250] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.092678] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[    3.094187] ehci_hcd 0000:00:1a.7: debug port 1
[    3.099404] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    3.100673] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    3.112141] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.113611] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.114993] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.116335] usb usb2: Product: EHCI Host Controller
[    3.117687] usb usb2: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty ehci_hcd
[    3.119048] usb usb2: SerialNumber: 0000:00:1a.7
[    3.124508] hub 2-0:1.0: USB hub found
[    3.125921] hub 2-0:1.0: 6 ports detected
[    3.127362] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.128780] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.128783] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.130403] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    3.134779] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    3.136316] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.137735] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.139148] usb usb3: Product: UHCI Host Controller
[    3.140559] usb usb3: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty uhci_hcd
[    3.142003] usb usb3: SerialNumber: 0000:00:1a.1
[    3.144045] hub 3-0:1.0: USB hub found
[    3.145521] hub 3-0:1.0: 2 ports detected
[    3.147239] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    3.148707]   alloc irq_desc for 19 on node -1
[    3.148709]   alloc kstat_irqs on node -1
[    3.148716] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.150220] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.150224] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.151818] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    3.153330] ehci_hcd 0000:00:1d.7: debug port 1
[    3.158792] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.158818] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    3.170153] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.171668] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    3.173598] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.175146] usb usb4: Product: EHCI Host Controller
[    3.175148] usb usb4: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty ehci_hcd
[    3.175149] usb usb4: SerialNumber: 0000:00:1d.7
[    3.175273] hub 4-0:1.0: USB hub found
[    3.175279] hub 4-0:1.0: 6 ports detected
[    3.179994] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    3.180003]   alloc irq_desc for 22 on node -1
[    3.180005]   alloc kstat_irqs on node -1
[    3.180013] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.180022] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.180026] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.180082] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.180134] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    3.180177] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.180179] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.180181] usb usb5: Product: UHCI Host Controller
[    3.180182] usb usb5: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty uhci_hcd
[    3.180184] usb usb5: SerialNumber: 0000:00:1a.2
[    3.180257] hub 5-0:1.0: USB hub found
[    3.180261] hub 5-0:1.0: 2 ports detected
[    3.183157] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.183165] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.183172] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.183175] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.183237] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.183268] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    3.183310] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.183312] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.183314] usb usb6: Product: UHCI Host Controller
[    3.183315] usb usb6: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty uhci_hcd
[    3.183317] usb usb6: SerialNumber: 0000:00:1d.0
[    3.183392] hub 6-0:1.0: USB hub found
[    3.183396] hub 6-0:1.0: 2 ports detected
[    3.183444]   alloc irq_desc for 17 on node -1
[    3.183446]   alloc kstat_irqs on node -1
[    3.183453] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.183459] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.183462] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.183506] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.183542] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    3.183577] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.183579] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.183581] usb usb7: Product: UHCI Host Controller
[    3.183582] usb usb7: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty uhci_hcd
[    3.183584] usb usb7: SerialNumber: 0000:00:1d.1
[    3.183653] hub 7-0:1.0: USB hub found
[    3.183657] hub 7-0:1.0: 2 ports detected
[    3.183701]   alloc irq_desc for 18 on node -1
[    3.183702]   alloc kstat_irqs on node -1
[    3.183707] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.183713] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.183716] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.183752] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.183787] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    3.183825] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.183827] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.183829] usb usb8: Product: UHCI Host Controller
[    3.183830] usb usb8: Manufacturer: Linux 2.6.33-rc1-andres-00366-g2f99f5c-dirty uhci_hcd
[    3.183832] usb usb8: SerialNumber: 0000:00:1d.2
[    3.183912] hub 8-0:1.0: USB hub found
[    3.183916] hub 8-0:1.0: 2 ports detected
[    3.471530] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000
[    3.471541] serio: Synaptics pass-through port at isa0060/serio1/input0
[    3.513895] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
[    3.777077] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    3.933378] usb 3-1: New USB device found, idVendor=08ff, idProduct=2810
[    3.933386] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.933393] usb 3-1: Product: Fingerprint Sensor
[    4.142087] usb 3-2: new full speed USB device using uhci_hcd and address 3
[    4.297360] usb 3-2: New USB device found, idVendor=0a5c, idProduct=2145
[    4.297365] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.297369] usb 3-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    4.297372] usb 3-2: Manufacturer: Lenovo Computer Corp
[    4.403596] usb 4-4: new high speed USB device using ehci_hcd and address 2
[    4.593700] usb 4-4: New USB device found, idVendor=0bdb, idProduct=1900
[    4.593707] usb 4-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.593714] usb 4-4: Product: Ericsson F3507g Mobile Broadband Minicard Composite Device
[    4.593720] usb 4-4: Manufacturer: Ericsson
[    4.593725] usb 4-4: SerialNumber: 3541430202682800
[    4.613697] cdc_acm 4-4:1.1: ttyACM0: USB ACM device
[    4.619641] cdc_acm 4-4:1.3: ttyACM1: USB ACM device
[    4.625478] cdc_wdm 4-4:1.5: cdc-wdm-176: USB WDM device
[    4.627960] cdc_wdm 4-4:1.6: cdc-wdm-175: USB WDM device
[    4.635119] cdc_acm 4-4:1.9: ttyACM2: USB ACM device
[    9.094783] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    9.332126] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
[   26.608079] device-mapper: ioctl: unable to remove open device temporary-cryptsetup-2046
[   31.438921] device-mapper: ioctl: unable to remove open device temporary-cryptsetup-2096
[   34.918387] EXT4-fs (dm-0): warning: maximal mount count reached, running e2fsck is recommended
[   34.925265] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 82453
[   34.940060] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 517
[   34.953477] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 541620
[   34.971254] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 49982
[   34.995862] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 12175
[   35.008647] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 531651
[   35.049609] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 531648
[   35.076123] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 49977
[   35.100088] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 16781
[   35.115283] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 13271
[   35.115315] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 13270
[   35.124412] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 10774
[   35.124446] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 10373
[   35.124672] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 824
[   35.125004] EXT4-fs (dm-0): 14 orphan inodes deleted
[   35.129069] EXT4-fs (dm-0): recovery complete
[   36.074403] EXT4-fs (dm-0): mounted filesystem with writeback data mode
[   43.164456] Adding 3903236k swap on /dev/mapper/swap_crypt.  Priority:-1 extents:1 across:3903236k 
[   44.272775] kjournald starting.  Commit interval 5 seconds
[   44.274039] EXT3-fs (sda2): using internal journal
[   44.274050] EXT3-fs (sda2): mounted filesystem with writeback data mode
[   45.758775] udev: starting version 149
[   48.472322] wwan0: register 'cdc_ether' at usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[   48.481839] usbcore: registered new interface driver cdc_ether
[   49.562421] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 2.6.33-rc1-andres-00366-g2f99f5c-dirty-ks
[   49.565798] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   49.569261] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   49.572622] iwlagn 0000:03:00.0: setting latency timer to 64
[   49.576215] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
[   49.750741] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   49.754046] thinkpad_acpi: http://ibm-acpi.sf.net/
[   49.757323] thinkpad_acpi: ThinkPad BIOS 6FET79WW (3.09 ), EC 7VHT14WW-1.03
[   49.760622] thinkpad_acpi: Lenovo ThinkPad T500, model 208252G
[   49.766944] thinkpad_acpi: radio switch found; radios are enabled
[   49.770466] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   49.773813] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   49.782589] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   49.794363] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[   49.801363] Registered led device: tpacpi::thinklight
[   49.805045] Registered led device: tpacpi::power
[   49.810166] Registered led device: tpacpi::standby
[   49.817834] Registered led device: tpacpi::thinkvantage
[   49.823969] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   49.832861] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   49.841170] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[   50.177594] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   50.184970]   alloc irq_desc for 31 on node -1
[   50.185682]   alloc kstat_irqs on node -1
[   50.191521] HDA Intel 0000:00:1b.0: irq 31 for MSI/MSI-X
[   50.195632] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   50.835163] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input9
[   50.839725] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[   50.843119] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[   50.846394] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
m main process (4958) terminated with status 1
[   52.223433] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   52.226851]   alloc irq_desc for 32 on node -1
[   52.229004]   alloc kstat_irqs on node -1
[   52.234340] iwlagn 0000:03:00.0: irq 32 for MSI/MSI-X
[   52.242170] phy0: Selected rate control algorithm 'iwl-agn-rs'

--Boundary-00=_a6jNLVnRkSlIaQx
Content-Type: text/plain;
  charset="utf-8";
  name="lspcivvv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspcivvv"

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
	Subsystem: Lenovo Device 20e0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 2114
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at f4400000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4189
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 2114
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f4200000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
	Subsystem: Lenovo Device 20e6
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc226800 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Device 20ee
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 30
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 414a
	Capabilities: [e0] PCIe advanced features <?>
	Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 18a0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at fc226c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo Device 20f2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 31
	Region 0: Memory at fc020000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 41e9
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00008000-00008fff
	Memory behind bridge: c0000000-c01fffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: f4300000-f43fffff
	Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  1, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f8000000-f9ffffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f40fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fa000000-fbffffff
	Prefetchable memory behind bridge: 00000000f4100000-00000000f41fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  4, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4181
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18e0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1c00 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fc227000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
	I/O behind bridge: 00004000-00007fff
	Memory behind bridge: f4800000-f7ffffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f3ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Lenovo Device 20f4

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
	Subsystem: Lenovo Device 20f5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01)
	Subsystem: Lenovo Device 20f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 29
	Region 0: I/O ports at 1c48 [size=8]
	Region 1: I/O ports at 183c [size=4]
	Region 2: I/O ports at 1c40 [size=8]
	Region 3: I/O ports at 1838 [size=4]
	Region 4: I/O ports at 1c20 [size=32]
	Region 5: Memory at fc226000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/4 Enable+
		Address: fee0100c  Data: 4191
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo Device 20f9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fc227400 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c60 [size=32]
	Kernel driver in use: i801_smbus

03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5300
	Subsystem: Intel Corporation Device 1011
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 32
	Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0100c  Data: 41c9
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number 20-f3-e3-ff-ff-ea-16-00
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Device 20c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f4800000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
	Memory window 0: f0000000-f3fff000 (prefetchable)
	Memory window 1: c4000000-c7fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10)
	Subsystem: Lenovo Device 20c7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at f4801000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel modules: firewire-ohci

15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
	Subsystem: Lenovo Device 20c8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4801800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

15:00.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 11)
	Subsystem: Lenovo Device 20c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4801c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 11)
	Subsystem: Lenovo Device 20ca
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4802000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
	Subsystem: Lenovo Device 20cb
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4802400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-


--Boundary-00=_a6jNLVnRkSlIaQx--
