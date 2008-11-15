Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYKOEQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYKOEQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYKOEQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:16:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:4846 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKOEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=MdNjhYry4CXoc68YkQCt6BEbarwnrAIvZm7pLJUYmBsHmY6bGaj9VDG5Y3TMT1151S
         J71vp28lJapy1ksotPPUsLziVw2jgorFB3ifEPzqF2Pds1Ac51HpK8iXro6NDpLmC7mH
         VMr2iSdIVmdf1gjQ2xpc4gD7HYSiEOsGnH+d4=
Subject: ACPI: EC: GPE storm detected, transactions will use polling mode
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Nov 2008 20:16:17 -0800
Message-Id: <1226722577.3104.4.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just pulled the latest git today and am now noticing
the lovely gpe storm being triggered.(dmesg below);

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc4-00322-g58e20d8 (root@LiNuX) (gcc
version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Fri Nov 14 15:11:30 PST
2008
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI
data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI
data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000
(reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000
(reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000
(reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000
(reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000007000 (usable)
[    0.000000]  modified: 0000000000007000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092c00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  modified: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  modified: 000000003f2eb000 - 000000003febe000 (ACPI
data)
[    0.000000]  modified: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  modified: 000000003feef000 - 000000003ff00000 (ACPI
data)
[    0.000000]  modified: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-16000
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5
1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5
Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002
INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000
INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 120MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00012000 - 00018f00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 -
00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 000062bbe4]    TEXT DATA BSS ==>
[0000100000 - 000062bbe4]
[    0.000000]   #4 [000062c000 - 000062f000]    INIT_PG_TABLE ==>
[000062c000 - 000062f000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==>
[0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000019000]          BOOTMAP ==>
[0000012000 - 0000019000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f0ea
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x00000007
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258159
[    0.000000] free_area_init_node: node 0, pgdat c051f980, node_mem_map
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 242 pages used for memmap
[    0.000000]   HighMem zone: 30714 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000002000 -
0000000000006000
[    0.000000] PM: Registered nosave memory: 0000000000007000 -
0000000000010000
[    0.000000] PM: Registered nosave memory: 0000000000092000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:b0000000)
[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 256141
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.28-rc4-00322-g58e20d8 root=/dev/sda1 ro
vga=790 debug pnpacpi=off pci=routeirq audit=1 selinux=1 enforcing=1
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 2161.244 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.010000] Scanning for low memory corruption every 60 seconds
[    0.010000] Memory: 1017932k/1033128k available (2803k kernel code,
14344k reserved, 1506k data, 404k init, 123824k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfff82000 - 0xfffff000   ( 500 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.010000]       .init : 0xc053c000 - 0xc05a1000   ( 404 kB)
[    0.010000]       .data : 0xc03bce25 - 0xc05357c4   (1506 kB)
[    0.010000]       .text : 0xc0100000 - 0xc03bce25   (2803 kB)
[    0.010000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for
per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated using
timer frequency.. 4322.48 BogoMIPS (lpj=21612440)
[    0.010000] Security Framework initialized
[    0.010000] SELinux:  Initializing.
[    0.010000] SELinux:  Starting in enforcing mode
[    0.010000] Failure registering Root Plug module with the kernel
[    0.010000] Mount-cache hash table entries: 512
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#0.
[    0.010000] using mwait in idle threads.
[    0.010000] Checking 'hlt' instruction... OK.
[    0.040982] ACPI: Core revision 20080926
[    0.059747] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.159768] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping 06
[    0.160000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4322.52
BogoMIPS (lpj=21612624)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#1.
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new
0x7010600070106
[    0.311697] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping 06
[    0.311729] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.320021] Brought up 2 CPUs
[    0.320026] Total of 2 processors activated (8645.01 BogoMIPS).
[    0.320092] CPU0 attaching sched-domain:
[    0.320097]  domain 0: span 0-1 level MC
[    0.320101]   groups: 0 1
[    0.320109] CPU1 attaching sched-domain:
[    0.320113]  domain 0: span 0-1 level MC
[    0.320117]   groups: 1 0
[    0.320199] net_namespace: 540 bytes
[    0.320199] Booting paravirtualized kernel on bare hardware
[    0.320317] NET: Registered protocol family 16
[    0.320317] EISA bus registered
[    0.320317] ACPI: bus type pci registered
[    0.320317] PCI: Using configuration type 1 for base access
[    0.331038] ACPI: EC: EC description table is found, configuring boot
EC
[    0.331277] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.342048] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.343134] ACPI: Interpreter enabled
[    0.343139] ACPI: (supports S0 S3 S4 S5)
[    0.343213] ACPI: Using IOAPIC for interrupt routing
[    0.370295] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data =
0x62
[    0.370295] ACPI: EC: driver started in interrupt mode
[    0.370410] ACPI: No dock devices found.
[    0.370437] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.370494] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.370494] pci 0000:00:01.0: PME# disabled
[    0.370494] pci 0000:00:07.0: reg 10 32bit mmio:
[0x50404000-0x50404fff]
[    0.370494] pci 0000:00:1b.0: reg 10 64bit mmio:
[0x50400000-0x50403fff]
[    0.370494] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.370494] pci 0000:00:1b.0: PME# disabled
[    0.370494] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.370494] pci 0000:00:1c.0: PME# disabled
[    0.370494] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.370494] pci 0000:00:1c.1: PME# disabled
[    0.370508] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.370514] pci 0000:00:1c.2: PME# disabled
[    0.370585] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    0.370653] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    0.370720] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    0.370788] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    0.370858] pci 0000:00:1d.7: reg 10 32bit mmio:
[0x50405400-0x504057ff]
[    0.370907] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.370914] pci 0000:00:1d.7: PME# disabled
[    0.371081] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6
ACPI/GPIO/TCO
[    0.371088] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6
GPIO
[    0.371147] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
[    0.371157] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
[    0.371167] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
[    0.371176] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
[    0.371186] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    0.371245] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    0.371254] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    0.371264] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    0.371273] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    0.371282] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    0.371292] pci 0000:00:1f.2: reg 24 32bit mmio:
[0x50405000-0x504053ff]
[    0.371313] pci 0000:00:1f.2: PME# supported from D3hot
[    0.371319] pci 0000:00:1f.2: PME# disabled
[    0.371387] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.371454] pci 0000:01:00.0: reg 10 32bit mmio:
[0x40000000-0x47ffffff]
[    0.371464] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.371474] pci 0000:01:00.0: reg 18 32bit mmio:
[0x50300000-0x5030ffff]
[    0.371496] pci 0000:01:00.0: reg 30 32bit mmio:
[0xfffe0000-0xffffffff]
[    0.371508] pci 0000:01:00.0: supports D1 D2
[    0.371568] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.371573] pci 0000:00:01.0: bridge 32bit mmio:
[0x50300000-0x503fffff]
[    0.371580] pci 0000:00:01.0: bridge 64bit mmio pref:
[0x40000000-0x47ffffff]
[    0.371664] pci 0000:02:00.0: reg 10 64bit mmio:
[0x50200000-0x50203fff]
[    0.371677] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.371714] pci 0000:02:00.0: reg 30 32bit mmio:
[0xfffe0000-0xffffffff]
[    0.371731] pci 0000:02:00.0: supports D1 D2
[    0.371735] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.371743] pci 0000:02:00.0: PME# disabled
[    0.371805] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.371812] pci 0000:00:1c.0: bridge 32bit mmio:
[0x50200000-0x502fffff]
[    0.371904] pci 0000:03:00.0: reg 10 64bit mmio:
[0x50100000-0x5010ffff]
[    0.371963] pci 0000:03:00.0: supports D1
[    0.371966] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.371974] pci 0000:03:00.0: PME# disabled
[    0.372050] pci 0000:00:1c.1: bridge 32bit mmio:
[0x50100000-0x501fffff]
[    0.372119] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.372125] pci 0000:00:1c.2: bridge 32bit mmio:
[0x4c100000-0x500fffff]
[    0.372135] pci 0000:00:1c.2: bridge 64bit mmio pref:
[0x48000000-0x4bffffff]
[    0.372197] pci 0000:0c:03.0: reg 10 32bit mmio:
[0x4c004000-0x4c0047ff]
[    0.372209] pci 0000:0c:03.0: reg 14 32bit mmio:
[0x4c000000-0x4c003fff]
[    0.372261] pci 0000:0c:03.0: supports D1 D2
[    0.372264] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.372271] pci 0000:0c:03.0: PME# disabled
[    0.372333] pci 0000:00:1e.0: transparent bridge
[    0.372343] pci 0000:00:1e.0: bridge 32bit mmio:
[0x4c000000-0x4c0fffff]
[    0.372380] bus 00 -> node 0
[    0.372393] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.374259] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.374857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.375445] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.376038] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.376649] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.401106] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.401106] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[    0.401106] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.401106] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[    0.401354] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.401642] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.401932] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12
14 15)
[    0.402214] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14
15)
[    0.402326] SCSI subsystem initialized
[    0.402326] libata version 3.00 loaded.
[    0.402326] usbcore: registered new interface driver usbfs
[    0.402326] usbcore: registered new interface driver hub
[    0.402326] usbcore: registered new device driver usb
[    0.402326] PCI: Using ACPI for IRQ routing
[    0.402326] PCI: Routing PCI interrupts for all devices because
"pci=routeirq" specified
[    0.402326] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.402326] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.402326] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ
22
[    0.402326] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[    0.402326] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ
16
[    0.402326] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ
18
[    0.402326] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ
23
[    0.402326] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ
19
[    0.402326] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ
18
[    0.402326] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ
16
[    0.402326] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ
23
[    0.402326] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ
18
[    0.402326] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ
19
[    0.402326] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ
19
[    0.402326] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.402326] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.402326] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[    0.402326] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ
19
[    0.430080] cfg80211: Using static regulatory domain info
[    0.430080] cfg80211: Regulatory domain: US
[    0.430080] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
[    0.430080] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700
mBm)
[    0.430080] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[    0.430080] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[    0.430080] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[    0.430080] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[    0.430082] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000
mBm)
[    0.430087] cfg80211: Calling CRDA for country: US
[    0.430113] NetLabel: Initializing
[    0.430113] NetLabel:  domain hash size = 128
[    0.430113] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.430135] NetLabel:  unlabeled traffic allowed by default
[    0.430148] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.430154] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.460028] pnp: PnP ACPI: disabled
[    0.495970] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.495976] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.495982] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.495987] pci 0000:00:01.0:   PREFETCH window:
0x00000040000000-0x00000047ffffff
[    0.495996] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.496001] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.496009] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.496016] pci 0000:00:1c.0:   PREFETCH window:
0x00000050500000-0x000000505fffff
[    0.496026] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.496030] pci 0000:00:1c.1:   IO window: disabled
[    0.496037] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.496044] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.496053] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.496058] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.496066] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.496073] pci 0000:00:1c.2:   PREFETCH window:
0x00000048000000-0x0000004bffffff
[    0.496084] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.496087] pci 0000:00:1e.0:   IO window: disabled
[    0.496095] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.496101] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.496115] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.496121] pci 0000:00:01.0: setting latency timer to 64
[    0.496131] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[    0.496138] pci 0000:00:1c.0: setting latency timer to 64
[    0.496148] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ
16
[    0.496155] pci 0000:00:1c.1: setting latency timer to 64
[    0.496165] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ
18
[    0.496172] pci 0000:00:1c.2: setting latency timer to 64
[    0.496334] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.496343] pci 0000:00:1e.0: setting latency timer to 64
[    0.496349] bus: 00 index 0 io port: [0x00-0xffff]
[    0.496352] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.496356] bus: 01 index 0 io port: [0x3000-0x3fff]
[    0.496360] bus: 01 index 1 mmio: [0x50300000-0x503fffff]
[    0.496364] bus: 01 index 2 mmio: [0x40000000-0x47ffffff]
[    0.496367] bus: 01 index 3 mmio: [0x0-0x0]
[    0.496371] bus: 02 index 0 io port: [0x2000-0x2fff]
[    0.496374] bus: 02 index 1 mmio: [0x50200000-0x502fffff]
[    0.496378] bus: 02 index 2 mmio: [0x50500000-0x505fffff]
[    0.496381] bus: 02 index 3 mmio: [0x0-0x0]
[    0.496385] bus: 03 index 0 mmio: [0x0-0x0]
[    0.496388] bus: 03 index 1 mmio: [0x50100000-0x501fffff]
[    0.496392] bus: 03 index 2 mmio: [0x0-0x0]
[    0.496395] bus: 03 index 3 mmio: [0x0-0x0]
[    0.496398] bus: 04 index 0 io port: [0x1000-0x1fff]
[    0.496402] bus: 04 index 1 mmio: [0x4c100000-0x500fffff]
[    0.496405] bus: 04 index 2 mmio: [0x48000000-0x4bffffff]
[    0.496409] bus: 04 index 3 mmio: [0x0-0x0]
[    0.496412] bus: 0c index 0 mmio: [0x0-0x0]
[    0.496415] bus: 0c index 1 mmio: [0x4c000000-0x4c0fffff]
[    0.496419] bus: 0c index 2 mmio: [0x0-0x0]
[    0.496422] bus: 0c index 3 io port: [0x00-0xffff]
[    0.496426] bus: 0c index 4 mmio: [0x000000-0xffffffff]
[    0.496438] NET: Registered protocol family 2
[    0.501753] Switched to high resolution mode on CPU 1
[    0.510002] Switched to high resolution mode on CPU 0
[    0.520078] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[    0.520400] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.520841] TCP bind hash table entries: 65536 (order: 8, 1310720
bytes)
[    0.521393] TCP: Hash tables configured (established 131072 bind
65536)
[    0.521398] TCP reno registered
[    0.530152] NET: Registered protocol family 1
[    0.531157] platform rtc_cmos: registered platform RTC device (no PNP
device found)
[    0.533242] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.534651] Initializing RT-Tester: OK
[    0.534764] audit: initializing netlink socket (enabled)
[    0.534829] type=2000 audit(1226705960.531:1): initialized
[    0.539745] highmem bounce pool size: 64 pages
[    0.539753] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.555826] fuse init (API version 7.10)
[    0.556420] msgmni has been set to 1747
[    0.556663] SELinux:  Registering netfilter hooks
[    0.557586] alg: No test for stdrng (krng)
[    0.557607] io scheduler noop registered
[    0.557954] io scheduler cfq registered (default)
[    0.558112] pci 0000:01:00.0: Boot video device
[    0.579154] vesafb: framebuffer at 0x40000000, mapped to 0xf8100000,
using 3072k, total 16384k
[    0.579161] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    0.579165] vesafb: protected mode interface info at c000:ad0c
[    0.579169] vesafb: pmi: set display start = c00cad94, set palette =
c00cae50
[    0.579172] vesafb: scrolling: redraw
[    0.579176] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    0.603479] Console: switching to colour frame buffer device 128x48
[    0.625655] fb0: VESA VGA frame buffer device
[    0.639217] loop: module loaded
[    0.639369] Linux video capture interface: v2.00
[    0.639824] input: Macintosh mouse button emulation
as /class/input/input0
[    0.640456] Driver 'sd' needs updating - please use bus_type methods
[    0.640844] Driver 'sr' needs updating - please use bus_type methods
[    0.641493] ata_piix 0000:00:1f.1: version 2.12
[    0.641796] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.642093] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
[    0.642464] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.642822] scsi0 : ata_piix
[    0.643459] scsi1 : ata_piix
[    0.645607] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0
irq 14
[    0.645927] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8
irq 15
[    0.820579] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max
UDMA/66
[    0.860552] ata1.00: configured for UDMA/66
[    1.033370] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D
KCV9 PQ: 0 ANSI: 5
[    1.038018] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda
tray
[    1.046742] Uniform CD-ROM driver Revision: 3.20
[    1.055628] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.064347] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.072665] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    1.081012] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.240015] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.248352] scsi2 : ata_piix
[    1.256649] scsi3 : ata_piix
[    1.268272] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma
0x40a0 irq 19
[    1.276462] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma
0x40a8 irq 19
[    1.470509] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    1.478586] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth
0/32)
[    1.520516] ata3.01: configured for UDMA/100
[    1.691229] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B
0081 PQ: 0 ANSI: 5
[    1.699977] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors:
(120 GB/111 GiB)
[    1.708573] sd 2:0:1:0: [sda] Write Protect is off
[    1.717066] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.725483] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.734094] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors:
(120 GB/111 GiB)
[    1.742618] sd 2:0:1:0: [sda] Write Protect is off
[    1.751019] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.759358] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.767909]  sda: sda1 sda2
[    1.777068] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.785728] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.794189] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
Driver
[    1.802702] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    1.811342] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.819810] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.828288] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    1.840774] ehci_hcd 0000:00:1d.7: debug port 1
[    1.849145] ehci_hcd 0000:00:1d.7: cache line size of 32 is not
supported
[    1.857684] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    1.880009] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.888654] usb usb1: configuration #1 chosen from 1 choice
[    1.897201] hub 1-0:1.0: USB hub found
[    1.905706] hub 1-0:1.0: 8 ports detected
[    1.914792] usbcore: registered new interface driver usblcd
[    1.923460] usbcore: registered new interface driver usbled
[    1.932197] PNP: No PS/2 controller found. Probing ports directly.
[    1.941486] i8042.c: No controller found.
[    1.960234] mice: PS/2 mouse device common for all mice
[    1.969192] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    1.977661] EDAC MC: Ver: 2.1.0 Nov 14 2008
[    1.986518] cpuidle: using governor ladder
[    1.994982] cpuidle: using governor menu
[    2.005315] usbcore: registered new interface driver hiddev
[    2.013778] usbcore: registered new interface driver usbhid
[    2.022059] usbhid: v2.6:USB HID core driver
[    2.030387] Advanced Linux Sound Architecture Driver Version
1.0.18rc3.
[    2.038885] ALSA device list:
[    2.047231]   No soundcards found.
[    2.055827] oprofile: using NMI interrupt.
[    2.064503] IPVS: Registered protocols (TCP, AH, ESP)
[    2.073024] IPVS: Connection hash table configured (size=4096,
memory=32Kbytes)
[    2.081548] IPVS: ipvs loaded.
[    2.090149] Initializing XFRM netlink socket
[    2.098360] NET: Registered protocol family 17
[    2.106530] NET: Registered protocol family 15
[    2.114611] Using IPI No-Shortcut mode
[    2.160139] kjournald starting.  Commit interval 5 seconds
[    2.160149] EXT3-fs: mounted filesystem with ordered data mode.
[    2.160180] VFS: Mounted root (ext3 filesystem) readonly.
[    2.160485] Freeing unused kernel memory: 404k freed
[    2.370013] usb 1-4: new high speed USB device using ehci_hcd and
address 3
[    2.520992] usb 1-4: configuration #1 chosen from 1 choice
[    2.803163] SELinux: 8192 avtab hash slots, 173318 rules.
[    2.916909] SELinux: 8192 avtab hash slots, 173318 rules.
[    3.121050] SELinux:  7 users, 9 roles, 3230 types, 100 bools, 1
sens, 256 cats
[    3.128919] SELinux:  73 classes, 173318 rules
[    3.144236] SELinux:  Completing initialization.
[    3.152028] SELinux:  Setting up existing superblocks.
[    3.187600] SELinux: initialized (dev sda1, type ext3), uses xattr
[    3.338652] SELinux: initialized (dev usbfs, type usbfs), uses
genfs_contexts
[    3.346547] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    3.354544] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    3.362578] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses genfs_contexts
[    3.370625] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    3.378643] SELinux: initialized (dev inotifyfs, type inotifyfs),
uses genfs_contexts
[    3.386818] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    3.394979] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    3.403391] SELinux: initialized (dev pipefs, type pipefs), uses task
SIDs
[    3.411738] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    3.420100] SELinux: initialized (dev sockfs, type sockfs), uses task
SIDs
[    3.428408] SELinux: initialized (dev proc, type proc), uses
genfs_contexts
[    3.436592] SELinux: initialized (dev bdev, type bdev), uses
genfs_contexts
[    3.444492] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    3.452457] SELinux: initialized (dev sysfs, type sysfs), uses
genfs_contexts
[    3.495760] type=1403 audit(1226705963.490:2): policy loaded
auid=4294967295 ses=4294967295
[    4.184266] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.355686] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.368701] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    9.900482] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   10.829515] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000
INTL 20050309)
[   10.848402] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001
INTL 20050309)
[   10.858321] Monitor-Mwait will be used to enter C-1 state
[   10.867338] Monitor-Mwait will be used to enter C-2 state
[   10.876125] Monitor-Mwait will be used to enter C-3 state
[   10.884784] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   10.893341] processor ACPI_CPU:00: registered as cooling_device0
[   10.902062] ACPI: Processor [CPU0] (supports 8 throttling states)
[   10.910983] input: Power Button (FF) as /class/input/input1
[   10.936619] Marking TSC unstable due to TSC halts in idle
[   10.972663] ACPI: Power Button (FF) [PWRF]
[   10.984596] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
INTL 20050309)
[   10.994451] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
INTL 20050309)
[   11.008804] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   11.020792] processor ACPI_CPU:01: registered as cooling_device1
[   11.031546] ACPI: Processor [CPU1] (supports 8 throttling states)
[   11.119331] ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF: Return
Package type mismatch at index 9 - found Buffer, expected String
[20080926]
[   11.137971] power_supply BAT0: uevent
[   11.147121] power_supply BAT0: No power supply yet
[   11.156247] power_supply BAT0: power_supply_changed
[   11.165416] power_supply BAT0: power_supply_changed_work
[   11.234034] ACPI: Battery Slot [BAT0] (battery present)
[   11.243095] power_supply ADP1: uevent
[   11.253028] power_supply ADP1: No power supply yet
[   11.263293] power_supply ADP1: power_supply_changed
[   11.273053] ACPI: AC Adapter [ADP1] (on-line)
[   11.282814] input: Lid Switch as /class/input/input2
[   11.292548] power_supply ADP1: power_supply_changed_work
[   11.301924] power_supply ADP1: power_supply_update_gen_leds 1
[   11.312016] power_supply ADP1: uevent
[   11.320928] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   11.324526] ath9k: 0.1
[   11.324568] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   11.324580] ath9k 0000:03:00.0: setting latency timer to 64
[   11.354411] power_supply ADP1: Static prop TYPE=Mains
[   11.362728] power_supply ADP1: 1 dynamic props
[   11.376403] power_supply ADP1: prop ONLINE=1
[   11.412192] uhci_hcd: USB Universal Host Controller Interface driver
[   11.425703] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[   11.438977] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   11.451921] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   11.464900] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[   11.477767] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   11.490880] usb usb2: configuration #1 chosen from 1 choice
[   11.492576] phy0: Selected rate control algorithm
'ath9k_rate_control'
[   11.499406] power_supply BAT0: power_supply_update_bat_leds 4
[   11.499426] power_supply BAT0: uevent
[   11.499428] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   11.499433] power_supply BAT0: Static prop TYPE=Battery
[   11.499435] power_supply BAT0: 12 dynamic props
[   11.499438] power_supply BAT0: prop STATUS=Full
[   11.499441] power_supply BAT0: prop PRESENT=1
[   11.499445] power_supply BAT0: prop TECHNOLOGY=Unknown
[   11.499449] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[   11.499451] power_supply BAT0: prop VOLTAGE_NOW=12425000
[   11.499455] power_supply BAT0: prop CURRENT_NOW=0
[   11.499458] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[   11.499461] power_supply BAT0: prop ENERGY_FULL=50780000
[   11.499464] power_supply BAT0: prop ENERGY_NOW=48520000
[   11.499468] power_supply BAT0: prop MODEL_NAME=ASMB012
[   11.499471] power_supply BAT0: prop MANUFACTURER=SMPN012
[   11.499474] power_supply BAT0: prop SERIAL_NUMBER=
[   11.500395] Registered led device: ath9k-phy0:radio
[   11.500443] Registered led device: ath9k-phy0:assoc
[   11.500491] Registered led device: ath9k-phy0:tx
[   11.500538] Registered led device: ath9k-phy0:rx
[   11.501380] phy0: Atheros 5416: mem=0xf87a0000, irq=17
[   11.659873] hub 2-0:1.0: USB hub found
[   11.665853] hub 2-0:1.0: 2 ports detected
[   11.666147] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[   11.666158] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   11.666161] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.666220] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[   11.666256] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   11.666436] usb usb3: configuration #1 chosen from 1 choice
[   11.666501] hub 3-0:1.0: USB hub found
[   11.666521] hub 3-0:1.0: 2 ports detected
[   11.666760] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[   11.666768] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.666771] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.666835] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[   11.666880] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   11.667043] usb usb4: configuration #1 chosen from 1 choice
[   11.667114] hub 4-0:1.0: USB hub found
[   11.667126] hub 4-0:1.0: 2 ports detected
[   11.667374] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low)
-> IRQ 16
[   11.667382] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   11.667385] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   11.667445] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[   11.667489] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   11.667678] usb usb5: configuration #1 chosen from 1 choice
[   11.667742] hub 5-0:1.0: USB hub found
[   11.667754] hub 5-0:1.0: 2 ports detected
[   11.668209] ACPI: Lid Switch [LID0]
[   11.668326] input: Power Button (CM) as /class/input/input3
[   11.855903] ACPI: Power Button (CM) [PWRB]
[   11.862529] input: Sleep Button (CM) as /class/input/input4
[   11.897478] ACPI: Sleep Button (CM) [SLPB]
[   11.947016] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low)
-> IRQ 22
[   11.953941] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.978662] firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
[   12.022935] uvcvideo: Found UVC 1.00 device Built-in iSight
(05ac:8501)
[   12.032616] uvcvideo: Failed to query (135) UVC control 1 (unit 0) :
-32 (exp. 26).
[   12.042570] input: Built-in iSight as /class/input/input5
[   12.042610] usb 2-2: new full speed USB device using uhci_hcd and
address 2
[   12.059396] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   12.070735] usbcore: registered new interface driver uvcvideo
[   12.078879] USB Video Class driver (v0.1.0)
[   12.092523] firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI
version 1.10
[   12.256897] usb 2-2: configuration #1 chosen from 1 choice
[   12.282940] input: Apple Computer Apple Internal Keyboard / Trackpad
as /class/input/input6
[   12.320156] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard
[Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input0
[   12.341951] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   12.365052] input: Apple Computer Apple Internal Keyboard / Trackpad
as /class/input/input7
[   12.419321] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device
[Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input2
[   12.447937] appletouch: Geyser mode initialized.
[   12.469393] input: appletouch as /class/input/input8
[   12.484792] usbcore: registered new interface driver appletouch
[   12.497510] applesmc: Apple MacBook Pro detected:
[   12.508263] applesmc:  - Model with accelerometer
[   12.518950] applesmc:  - Model with light sensors and backlight
[   12.529972] applesmc:  - Model with 12 temperature sensors
[   12.542254] applesmc: device has already been initialized (0xe0,
0x00).
[   12.553133] applesmc: device successfully initialized.
[   12.564722] applesmc: 2 fans found.
[   12.571160] usb 4-2: new full speed USB device using uhci_hcd and
address 2
[   12.588267] input: applesmc as /class/input/input9
[   12.600311] firewire_core: created device fw0: GUID 0019e3fffe2ad87e,
S800
[   12.627058] Registered led device: smc::kbd_backlight
[   12.638345] applesmc: driver successfully loaded.
[   12.722988] Linux agpgart interface v0.103
[   12.776238] usb 4-2: configuration #1 chosen from 1 choice
[   12.797081] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11
Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[   12.820185] [drm] Initialized drm 1.1.0 20060810
[   12.862647] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[   12.873995] pci 0000:01:00.0: setting latency timer to 64
[   12.885470] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   12.954269] usb 5-1: new full speed USB device using uhci_hcd and
address 2
[   13.050730] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.161914] nf_conntrack version 0.5.0 (16142 buckets, 64568 max)
[   13.173667] CONFIG_NF_CT_ACCT is deprecated and will be removed soon.
Please use
[   13.185007] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack
module option or
[   13.196339] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   13.196524] usb 5-1: configuration #1 chosen from 1 choice
[   13.236747] drivers/hid/usbhid/hid-core.c: couldn't find an input
interrupt endpoint
[   13.253995] arp_tables: (C) 2002 David S. Miller
[   13.315123] ieee80211_crypt: registered algorithm 'NULL'
[   13.357786] ieee80211: 802.11 data/management/control stack,
git-1.1.13
[   13.369128] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   13.396245] ieee80211_crypt: registered algorithm 'TKIP'
[   13.471701] usbcore: registered new interface driver isight_firmware
[   13.525042] ipmi message handler version 39.2
[   13.551760] IPMI Watchdog: driver initialized
[   13.776369] Adding 2988360k swap on /dev/sda2.  Priority:-1 extents:1
across:2988360k
[   14.172515] EXT3 FS on sda1, internal journal
[   17.501470] warning: `avahi-daemon' uses 32-bit capabilities (legacy
support in use)
[   18.072715] applesmc: light sensor data length set to 6
[   19.427621] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[   19.452450] Bluetooth: Core ver 2.13
[   19.456615] NET: Registered protocol family 31
[   19.456619] Bluetooth: HCI device and connection manager initialized
[   19.456625] Bluetooth: HCI socket layer initialized
[   19.492652] Bluetooth: L2CAP ver 2.11
[   19.492657] Bluetooth: L2CAP socket layer initialized
[   19.531701] Bluetooth: RFCOMM socket layer initialized
[   19.531732] Bluetooth: RFCOMM TTY layer initialized
[   19.531736] Bluetooth: RFCOMM ver 1.10
[   19.549691] Bluetooth: SCO (Voice Link) ver 0.6
[   19.549696] Bluetooth: SCO socket layer initialized
[   19.740179] usb 5-1: USB disconnect, address 2
[   19.850721] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   19.850727] Bluetooth: BNEP filters: protocol multicast
[   20.023468] usb 5-1: new full speed USB device using uhci_hcd and
address 3
[   20.230853] usb 5-1: configuration #1 chosen from 1 choice
[   20.292586] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   20.292774] usbcore: registered new interface driver btusb
[   26.209069] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   26.215644] input: justinmattock’s mouse #1 as /class/input/input10
[   26.243603] generic-bluetooth 0005:0000:0000.0005: input: BLUETOOTH
HID v0.00 Mouse [justinmattock’s mouse #1] on 00:17:F2:B4:BC:F5
[   32.303010] [drm] Setting GART location based on new memory map
[   32.304544] [drm] Loading R500 Microcode
[   32.304597] [drm] Num pipes: 1
[   32.304610] [drm] writeback test succeeded in 1 usecs
[   82.162134] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[   82.164163] wlan0: authenticated
[   82.164169] wlan0: associate with AP 00:1e:2a:00:67:f0
[   82.166518] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431
status=0 aid=33)
[   82.166523] wlan0: associated
[ 1926.692564] CE: hpet increasing min_delta_ns to 15000 nsec
[ 6017.062769] power_supply ADP1: uevent
[ 6017.062775] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[ 6017.062787] power_supply ADP1: Static prop TYPE=Mains
[ 6017.062793] power_supply ADP1: 1 dynamic props
[ 6017.062799] power_supply ADP1: prop ONLINE=0
[ 6017.302516] power_supply BAT0: uevent
[ 6017.302522] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[ 6017.302535] power_supply BAT0: Static prop TYPE=Battery
[ 6017.302541] power_supply BAT0: 12 dynamic props
[ 6017.302547] power_supply BAT0: prop STATUS=Discharging
[ 6017.302554] power_supply BAT0: prop PRESENT=1
[ 6017.302561] power_supply BAT0: prop TECHNOLOGY=Unknown
[ 6017.302570] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[ 6017.302577] power_supply BAT0: prop VOLTAGE_NOW=12423000
[ 6017.302584] power_supply BAT0: prop CURRENT_NOW=0
[ 6017.302592] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[ 6017.302600] power_supply BAT0: prop ENERGY_FULL=50780000
[ 6017.302607] power_supply BAT0: prop ENERGY_NOW=48520000
[ 6017.302614] power_supply BAT0: prop MODEL_NAME=ASMB012
[ 6017.302621] power_supply BAT0: prop MANUFACTURER=SMPN012
[ 6017.302628] power_supply BAT0: prop SERIAL_NUMBER=
[ 6064.195248] power_supply ADP1: uevent
[ 6064.195254] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[ 6064.195265] power_supply ADP1: Static prop TYPE=Mains
[ 6064.195270] power_supply ADP1: 1 dynamic props
[ 6064.195276] power_supply ADP1: prop ONLINE=1
[ 6064.442624] power_supply BAT0: uevent
[ 6064.442630] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[ 6064.442643] power_supply BAT0: Static prop TYPE=Battery
[ 6064.442649] power_supply BAT0: 12 dynamic props
[ 6064.442655] power_supply BAT0: prop STATUS=Full
[ 6064.442662] power_supply BAT0: prop PRESENT=1
[ 6064.442669] power_supply BAT0: prop TECHNOLOGY=Unknown
[ 6064.442678] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[ 6064.442686] power_supply BAT0: prop VOLTAGE_NOW=12118000
[ 6064.442693] power_supply BAT0: prop CURRENT_NOW=23969000
[ 6064.442700] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[ 6064.442708] power_supply BAT0: prop ENERGY_FULL=50780000
[ 6064.442715] power_supply BAT0: prop ENERGY_NOW=48510000
[ 6064.442722] power_supply BAT0: prop MODEL_NAME=ASMB012
[ 6064.442729] power_supply BAT0: prop MANUFACTURER=SMPN012
[ 6064.442736] power_supply BAT0: prop SERIAL_NUMBER=
[ 6066.464031] power_supply BAT0: uevent
[ 6066.464037] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[ 6066.464049] power_supply BAT0: Static prop TYPE=Battery
[ 6066.464055] power_supply BAT0: 12 dynamic props
[ 6066.464061] power_supply BAT0: prop STATUS=Charging
[ 6066.464068] power_supply BAT0: prop PRESENT=1
[ 6066.464075] power_supply BAT0: prop TECHNOLOGY=Unknown
[ 6066.464087] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[ 6066.464095] power_supply BAT0: prop VOLTAGE_NOW=12373000
[ 6066.464103] power_supply BAT0: prop CURRENT_NOW=4058000
[ 6066.464111] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[ 6066.464119] power_supply BAT0: prop ENERGY_FULL=50780000
[ 6066.464127] power_supply BAT0: prop ENERGY_NOW=48510000
[ 6066.464135] power_supply BAT0: prop MODEL_NAME=ASMB012
[ 6066.464143] power_supply BAT0: prop MANUFACTURER=SMPN012
[ 6066.464150] power_supply BAT0: prop SERIAL_NUMBER=
[ 6527.737472] ACPI: EC: GPE storm detected, transactions will use
polling mode
[ 8255.325198] power_supply BAT0: uevent
[ 8255.325203] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[ 8255.325214] power_supply BAT0: Static prop TYPE=Battery
[ 8255.325219] power_supply BAT0: 12 dynamic props
[ 8255.325225] power_supply BAT0: prop STATUS=Full
[ 8255.325232] power_supply BAT0: prop PRESENT=1
[ 8255.325240] power_supply BAT0: prop TECHNOLOGY=Unknown
[ 8255.325250] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[ 8255.325258] power_supply BAT0: prop VOLTAGE_NOW=12603000
[ 8255.325265] power_supply BAT0: prop CURRENT_NOW=113000
[ 8255.325273] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[ 8255.325281] power_supply BAT0: prop ENERGY_FULL=50780000
[ 8255.325289] power_supply BAT0: prop ENERGY_NOW=51080000
[ 8255.325296] power_supply BAT0: prop MODEL_NAME=ASMB012
[ 8255.325303] power_supply BAT0: prop MANUFACTURER=SMPN012
[ 8255.325311] power_supply BAT0: prop SERIAL_NUMBER=

I thought it was because I disconnected the laptop and moved 
it into another area, but doesn't seem to be the case.





-- 
Justin P. Mattock <justinmattock@gmail.com>

