Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZAIV1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZAIV1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZAIV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:26:53 -0500
Received: from newbox.bazarnic.net ([209.188.29.80]:17264 "EHLO
	newbox.bazarnic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbZAIV0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:26:50 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=private; d=bazarnic.net;
  b=fI7Jlxjpms+BFUXd/KGscCeP8CjsXE3ZzFe0Z5uKIYqxrvKCrK0TQKYsVRO7mkQW;
From: "Doug Bazarnic" <doug@bazarnic.net>
To: <linux-kernel@vger.kernel.org>
Subject: GPF on 2.6.28 & 2.6.28-rc9-git3    e1000e / e1000 issues
Date: Fri, 9 Jan 2009 14:26:49 -0700
Message-ID: <007101c972a0$fc231060$f4693120$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclyoPkxvrqGoio8S629klZAjnnbrw==
Content-Language: en-us
x-cr-hashedpuzzle: A3pL BGVS BN21 CwPS Cxso ENQ6 ExP0 FYyk GKUU G1RW HHPI HjKv IOAc I0sb KErq LoZK;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{BCB6C25C-ABD4-4714-B8E1-025FCAF5D205};ZABvAHUAZwBAAGIAYQB6AGEAcgBuAGkAYwAuAG4AZQB0AA==;Fri, 09 Jan 2009 21:26:45 GMT;RwBQAEYAIABvAG4AIAAyAC4ANgAuADIAOAAgACYAIAAyAC4ANgAuADIAOAAtAHIAYwA5AC0AZwBpAHQAMwAgACAAIAAgAGUAMQAwADAAMABlACAALwAgAGUAMQAwADAAMAAgAGkAcwBzAHUAZQBzAA==
x-cr-puzzleid: {BCB6C25C-ABD4-4714-B8E1-025FCAF5D205}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I’ve moved mem3 back onto the onboard  e1000e nics, and every 12 hours or
so, a hard lockup occurs with heavy traffic on eth1.   When on the e1000
pci-x nics, I’d only get an occasional Tx Unit Hang.

This happens on both 2.6.28 and 2.6.28-rc9-git3, which was stable on the
e1000s.

This is a dual Xeon Quad, with 32g of ram, tyan s5397 motherboard, running
Centos 5.2 x86_64.

This is the first time I saw something on the console:

mem3 kernel: general protection fault: 0000 [#1] SMP 
mem3 kernel: last sysfs file: /sys/class/scsi_host/host8/proc_name
mem3 kernel: Stack:
mem3 kernel:  ffffe200184c28e0 0000000000000000 ffff88079b0c9350
0000000000000246
mem3 kernel:  ffff88079b0c9580 ffff88081ec6be80 ffff8806ce08d640
ffff8807390da180
mem3 kernel: Call Trace:
mem3 kernel:  [<ffffffff803a1e20>] ? xfs_get_blocks+0x0/0x10
mem3 kernel:  [<ffffffff80585198>] ? tcp_transmit_skb+0x3a8/0x6d0
mem3 kernel:  [<ffffffff802c55bd>] ? mpage_readpage+0x4d/0x70
mem3 kernel:  [<ffffffff803a1e20>] ? xfs_get_blocks+0x0/0x10
mem3 kernel:  [<ffffffff8058693d>] ? __tcp_push_pending_frames+0x14d/0x7e0
mem3 kernel:  [<ffffffff803ecc29>] ? radix_tree_next_hole+0x39/0x50
mem3 kernel:  [<ffffffff80278cca>] ? ondemand_readahead+0x12a/0x1b0
mem3 kernel:  [<ffffffff80272485>] ? generic_file_aio_read+0x1a5/0x5d0
mem3 kernel:  [<ffffffff803a95da>] ? xfs_read+0x10a/0x240
mem3 kernel:  [<ffffffff8029c209>] ? do_sync_read+0xd9/0x120
mem3 kernel:  [<ffffffff8024c0a0>] ? autoremove_wake_function+0x0/0x30
mem3 kernel:  [<ffffffff8029cb35>] ? vfs_read+0xc5/0x160
mem3 kernel:  [<ffffffff8029cf13>] ? sys_read+0x53/0x90
mem3 kernel:  [<ffffffff8020b5bb>] ? system_call_fastpath+0x16/0x1b
mem3 kernel: Code: 00 00 00 48 89 7c 24 28 48 89 74 24 20 89 54 24 1c 48 89
4c 24 10 4c 89 4c 24 08 48 8b 84 24 d0 00 00 00 48 89 04 24 48 8b 46 18 <48>
8b 00 48 89 44 24 30 8b 90 a0 00 00 00 89 54 24 3c f6 46 01 
mem3 kernel: general protection fault: 0000 [#2] SMP 
mem3 kernel: last sysfs file: /sys/class/scsi_host/host8/proc_name

This server is under heavy load.


====dmesg====
IOS EBDA/lowmem at: 0009a000/0009a000
Linux version 2.6.28-rc9-git3 (root@mem3) (gcc version 4.1.2 20071124 (Red
Hat 4.1.2-42)) #2 SMP Wed Jan 7 14:06:58 MST 2009
Command line: ro root=LABEL=/
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
 BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000c8000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000d0000 - 00000000000dc000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bff50000 (usable)
 BIOS-e820: 00000000bff50000 - 00000000bff5f000 (ACPI data)
 BIOS-e820: 00000000bff5f000 - 00000000bff60000 (ACPI NVS)
 BIOS-e820: 00000000bff60000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000840000000 (usable)
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x840000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
generic_get_mtrr+0x11e/0x130()
mtrr: your BIOS has set up an incorrect mask, fixing it up.
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc9-git3 #2
Call Trace:
 [<ffffffff802378fc>] warn_slowpath+0x10c/0x150
 [<ffffffff802500e6>] up+0x16/0x50
 [<ffffffff80238197>] release_console_sem+0x197/0x1d0
 [<ffffffff8023884d>] printk+0x8d/0xa0
 [<ffffffff8021947e>] generic_get_mtrr+0x11e/0x130
 [<ffffffff80789d0d>] mtrr_trim_uncached_memory+0xcd/0x670
 [<ffffffff80791fc8>] early_gart_iommu_check+0xb8/0x2d0
 [<ffffffff80218e60>] post_set+0x20/0x40
 [<ffffffff80785e8e>] setup_arch+0x36e/0x6d0
 [<ffffffff8077ea8d>] start_kernel+0x5d/0x360
 [<ffffffff8077e3aa>] x86_64_start_kernel+0xca/0xe0
---[ end trace 4eaa2a86a8e2da22 ]---
last_pfn = 0xbff50 max_arch_pfn = 0x3ffffffff
init_memory_mapping: 0000000000000000-00000000bff50000
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bff50000 page 4k
kernel direct mapping tables up to bff50000 @ 10000-15000
last_map_addr: bff50000 end: bff50000
init_memory_mapping: 0000000100000000-0000000840000000
 0100000000 - 0840000000 page 2M
kernel direct mapping tables up to 840000000 @ 13000-35000
last_map_addr: 840000000 end: 840000000
RAMDISK: 37dd3000 - 37fefaa2
ACPI: RSDP 000F7050, 0024 (r2 PTLTD )
ACPI: XSDT BFF58E4B, 009C (r1 PTLTD      XSDT    6040000  LTP        0)
ACPI: FACP BFF5ED60, 00F4 (r3 INTEL  TUMWATER  6040000 PTL         3)
ACPI: DSDT BFF5A9B9, 4333 (r1  Intel SEABURG   6040000 MSFT  3000000)
ACPI: FACS BFF5FFC0, 0040
ACPI: _MAR BFF5EE54, 0030 (r1 Intel  OEMDMAR   6040000 LOHR        1)
ACPI: APIC BFF5EE84, 00C8 (r1 PTLTD      APIC    6040000  LTP        0)
ACPI: MCFG BFF5EF4C, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: BOOT BFF5EF88, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SPCR BFF5EFB0, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: SSDT BFF5A75A, 025F (r1  PmRef  Cpu0Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A6B4, 00A6 (r1  PmRef  Cpu7Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A60E, 00A6 (r1  PmRef  Cpu6Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A568, 00A6 (r1  PmRef  Cpu5Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A4C2, 00A6 (r1  PmRef  Cpu4Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A41C, 00A6 (r1  PmRef  Cpu3Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A376, 00A6 (r1  PmRef  Cpu2Tst     3000 INTL 20050228)
ACPI: SSDT BFF5A2D0, 00A6 (r1  PmRef  Cpu1Tst     3000 INTL 20050228)
ACPI: SSDT BFF58EE7, 13E9 (r1  PmRef    CpuPm     3000 INTL 20050228)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 0840000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #2 [0000200000 - 0000889b74]    TEXT DATA BSS ==> [0000200000 -
0000889b74]
  #3 [0037dd3000 - 0037fefaa2]          RAMDISK ==> [0037dd3000 -
0037fefaa2]
  #4 [000009a000 - 0000100000]    BIOS reserved ==> [000009a000 -
0000100000]
  #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 -
0000013000]
  #6 [0000013000 - 0000030000]          PGTABLE ==> [0000013000 -
0000030000]
 [ffffe20000000000-ffffe2000f9fffff] PMD ->
[ffff880028200000-ffff880037bfffff] on node 0
 [ffffe2000fa00000-ffffe2001cdfffff] PMD ->
[ffff880038000000-ffff8800453fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00840000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009a
    0: 0x00000100 -> 0x000bff50
    0: 0x00100000 -> 0x00840000
On node 0 totalpages: 8388314
  DMA zone: 56 pages used for memmap
  DMA zone: 1810 pages reserved
  DMA zone: 2112 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 767880 pages, LIFO batch:31
  Normal zone: 103936 pages used for memmap
  Normal zone: 7498240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 0, address 0xfec88000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
SMP: Allowing 8 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 45056 bytes of per cpu data
NR_CPUS: 16, nr_cpu_ids: 8, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8268232
Kernel command line: ro root=LABEL=/
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 2660.001 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x20000000 - 0x24000000
Memory: 32954240k/34603008k available (3824k kernel code, 1049752k absent,
598068k reserved, 1599k data, 392k init)
Calibrating delay loop (skipped), value calculated using timer frequency..
5320.00 BogoMIPS (lpj=2660001)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Freeing SMP alternatives: 28k freed
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
Booting processor 1 APIC 0x4 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5319.28 BogoMIPS
(lpj=2659640)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x1 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5319.24 BogoMIPS
(lpj=2659622)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x5 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5319.26 BogoMIPS
(lpj=2659634)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Booting processor 4 APIC 0x2 ip 0x6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 5319.24 BogoMIPS
(lpj=2659621)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU4: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
Booting processor 5 APIC 0x6 ip 0x6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 5319.24 BogoMIPS
(lpj=2659623)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU5: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
Booting processor 6 APIC 0x3 ip 0x6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 5319.24 BogoMIPS
(lpj=2659621)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU6: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
Booting processor 7 APIC 0x7 ip 0x6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 5319.26 BogoMIPS
(lpj=2659630)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU7: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
Total of 8 processors activated (42554.78 BogoMIPS).
net_namespace: 552 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 31
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e1ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
pci 0000:00:1d.3: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xdc704000-0xdc7043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1880-0x188f]
pci 0000:00:1f.2: reg 10 io port: [0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14 io port: [0x18c8-0x18cb]
pci 0000:00:1f.2: reg 18 io port: [0x18c0-0x18c7]
pci 0000:00:1f.2: reg 1c io port: [0x1894-0x1897]
pci 0000:00:1f.2: reg 20 io port: [0x18a0-0x18bf]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xdc704400-0xdc7047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
pci 0000:01:00.0: reg 10 64bit mmio: [0xdc000000-0xdc1fffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x07ffff]
pci 0000:01:00.0: supports D1
pci 0000:00:01.0: bridge 32bit mmio: [0xdc000000-0xdc1fffff]
pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
pci 0000:09:00.0: PME# disabled
pci 0000:09:00.3: PME# supported from D0 D3hot D3cold
pci 0000:09:00.3: PME# disabled
pci 0000:00:09.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:09.0: bridge 32bit mmio: [0xdc300000-0xdc4fffff]
pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.0: PME# disabled
pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:02.0: PME# disabled
pci 0000:09:00.0: bridge io port: [0x2000-0x2fff]
pci 0000:09:00.0: bridge 32bit mmio: [0xdc400000-0xdc4fffff]
pci 0000:0f:00.0: reg 10 32bit mmio: [0xdc420000-0xdc43ffff]
pci 0000:0f:00.0: reg 14 32bit mmio: [0xdc400000-0xdc41ffff]
pci 0000:0f:00.0: reg 18 io port: [0x2000-0x201f]
pci 0000:0f:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:0f:00.1: reg 10 32bit mmio: [0xdc460000-0xdc47ffff]
pci 0000:0f:00.1: reg 14 32bit mmio: [0xdc440000-0xdc45ffff]
pci 0000:0f:00.1: reg 18 io port: [0x2020-0x203f]
pci 0000:0f:00.1: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:0f:00.1: PME# supported from D0 D3hot D3cold
pci 0000:0f:00.1: PME# disabled
pci 0000:0a:02.0: bridge io port: [0x2000-0x2fff]
pci 0000:0a:02.0: bridge 32bit mmio: [0xdc400000-0xdc4fffff]
pci 0000:20:05.0: reg 10 32bit mmio: [0xd8000000-0xdbffffff]
pci 0000:20:05.0: reg 14 32bit mmio: [0xdc200000-0xdc23ffff]
pci 0000:20:05.0: reg 18 io port: [0x3000-0x307f]
pci 0000:20:05.0: supports D1 D2
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xdc200000-0xdc2fffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd8000000-0xdbffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMF3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 14 15) *9
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 14 15) *12
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 *10 11 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
dca service started, version 1.4
PCI: Using ACPI for IRQ routing
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x800-0x80f has been reserved
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1180-0x11bf has been reserved
system 00:01: ioport range 0xfe00-0xfe00 has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfec88000-0xfec88fff has been reserved
system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xdc000000-0xdc1fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000c2000000-0x000000c20fffff
pci 0000:00:05.0: PCI bridge, secondary bus 0000:05
pci 0000:00:05.0:   IO window: disabled
pci 0000:00:05.0:   MEM window: disabled
pci 0000:00:05.0:   PREFETCH window: disabled
pci 0000:0a:00.0: PCI bridge, secondary bus 0000:0b
pci 0000:0a:00.0:   IO window: disabled
pci 0000:0a:00.0:   MEM window: disabled
pci 0000:0a:00.0:   PREFETCH window: disabled
pci 0000:0a:02.0: PCI bridge, secondary bus 0000:0f
pci 0000:0a:02.0:   IO window: 0x2000-0x2fff
pci 0000:0a:02.0:   MEM window: 0xdc400000-0xdc4fffff
pci 0000:0a:02.0:   PREFETCH window: 0x000000c2100000-0x000000c21fffff
pci 0000:09:00.0: PCI bridge, secondary bus 0000:0a
pci 0000:09:00.0:   IO window: 0x2000-0x2fff
pci 0000:09:00.0:   MEM window: 0xdc400000-0xdc4fffff
pci 0000:09:00.0:   PREFETCH window: 0x000000c2100000-0x000000c21fffff
pci 0000:09:00.3: PCI bridge, secondary bus 0000:10
pci 0000:09:00.3:   IO window: disabled
pci 0000:09:00.3:   MEM window: disabled
pci 0000:09:00.3:   PREFETCH window: disabled
pci 0000:00:09.0: PCI bridge, secondary bus 0000:09
pci 0000:00:09.0:   IO window: 0x2000-0x2fff
pci 0000:00:09.0:   MEM window: 0xdc300000-0xdc4fffff
pci 0000:00:09.0:   PREFETCH window: 0x000000c2100000-0x000000c21fffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:1f
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:20
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xdc200000-0xdc2fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:09.0: setting latency timer to 64
pci 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:09:00.0: setting latency timer to 64
pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:0a:00.0: setting latency timer to 64
pci 0000:0a:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:0a:02.0: setting latency timer to 64
pci 0000:09:00.3: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xdc000000-0xdc1fffff]
bus: 01 index 2 mmio: [0xc2000000-0xc20fffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 05 index 0 mmio: [0x0-0x0]
bus: 05 index 1 mmio: [0x0-0x0]
bus: 05 index 2 mmio: [0x0-0x0]
bus: 05 index 3 mmio: [0x0-0x0]
bus: 09 index 0 io port: [0x2000-0x2fff]
bus: 09 index 1 mmio: [0xdc300000-0xdc4fffff]
bus: 09 index 2 mmio: [0xc2100000-0xc21fffff]
bus: 09 index 3 mmio: [0x0-0x0]
bus: 0a index 0 io port: [0x2000-0x2fff]
bus: 0a index 1 mmio: [0xdc400000-0xdc4fffff]
bus: 0a index 2 mmio: [0xc2100000-0xc21fffff]
bus: 0a index 3 mmio: [0x0-0x0]
bus: 0b index 0 mmio: [0x0-0x0]
bus: 0b index 1 mmio: [0x0-0x0]
bus: 0b index 2 mmio: [0x0-0x0]
bus: 0b index 3 mmio: [0x0-0x0]
bus: 0f index 0 io port: [0x2000-0x2fff]
bus: 0f index 1 mmio: [0xdc400000-0xdc4fffff]
bus: 0f index 2 mmio: [0xc2100000-0xc21fffff]
bus: 0f index 3 mmio: [0x0-0x0]
bus: 10 index 0 mmio: [0x0-0x0]
bus: 10 index 1 mmio: [0x0-0x0]
bus: 10 index 2 mmio: [0x0-0x0]
bus: 10 index 3 mmio: [0x0-0x0]
bus: 1f index 0 mmio: [0x0-0x0]
bus: 1f index 1 mmio: [0x0-0x0]
bus: 1f index 2 mmio: [0x0-0x0]
bus: 1f index 3 mmio: [0x0-0x0]
bus: 20 index 0 io port: [0x3000-0x3fff]
bus: 20 index 1 mmio: [0xdc200000-0xdc2fffff]
bus: 20 index 2 mmio: [0xd8000000-0xdbffffff]
bus: 20 index 3 io port: [0x00-0xffff]
bus: 20 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2162k freed
Simple Boot Flag at 0x36 set to 0x80
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
audit: initializing netlink socket (disabled)
type=2000 audit(1231492835.753:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SGI XFS with security attributes, large block/inode numbers, no debug
enabled
msgmni has been set to 32768
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:20:05.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pcieport-driver 0000:00:01.0: irq 767 for MSI/MSI-X
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie01: allocate port service
pcieport-driver 0000:00:05.0: setting latency timer to 64
pcieport-driver 0000:00:05.0: found MSI capability
pcieport-driver 0000:00:05.0: irq 766 for MSI/MSI-X
pci_express 0000:00:05.0:pcie00: allocate port service
pci_express 0000:00:05.0:pcie01: allocate port service
pcieport-driver 0000:00:09.0: setting latency timer to 64
pcieport-driver 0000:00:09.0: found MSI capability
pcieport-driver 0000:00:09.0: irq 765 for MSI/MSI-X
pci_express 0000:00:09.0:pcie00: allocate port service
pci_express 0000:00:09.0:pcie01: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 764 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:09:00.0: setting latency timer to 64
pci_express 0000:09:00.0:pcie11: allocate port service
pcieport-driver 0000:0a:00.0: setting latency timer to 64
pcieport-driver 0000:0a:00.0: found MSI capability
pcieport-driver 0000:0a:00.0: irq 763 for MSI/MSI-X
pci_express 0000:0a:00.0:pcie21: allocate port service
pcieport-driver 0000:0a:02.0: setting latency timer to 64
pcieport-driver 0000:0a:02.0: found MSI capability
pcieport-driver 0000:0a:02.0: irq 762 for MSI/MSI-X
pci_express 0000:0a:02.0:pcie21: allocate port service
aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:05.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Non-volatile memory driver v1.2
intel_rng: FWH not detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:0f:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
e1000e 0000:0f:00.0: setting latency timer to 64
e1000e 0000:0f:00.0: irq 761 for MSI/MSI-X
0000:0f:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b3:f7:36
0000:0f:00.0: eth0: Intel(R) PRO/1000 Network Connection
0000:0f:00.0: eth0: MAC: 4, PHY: 5, PBA No: ffffff-0ff
e1000e 0000:0f:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
e1000e 0000:0f:00.1: setting latency timer to 64
e1000e 0000:0f:00.1: irq 760 for MSI/MSI-X
0000:0f:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b3:f7:37
0000:0f:00.1: eth1: Intel(R) PRO/1000 Network Connection
0000:0f:00.1: eth1: MAC: 4, PHY: 5, PBA No: ffffff-0ff
Uniform Multi-Platform E-IDE driver
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit pm led pmp slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq
23
ata2: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704580 irq 23
ata3: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704600 irq 23
ata4: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704680 irq 23
ata5: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704700 irq 23
ata6: SATA max UDMA/133 abar m1024@0xdc704400 port 0xdc704780 irq 23
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi6 : ata_piix
scsi7 : ata_piix
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
ata8: port disabled. ignoring.
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc704000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc)
Freeing unused kernel memory: 392k freed
Write protecting the kernel read-only data: 5048k
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input2
Adaptec aacraid driver 1.1-5[2456]-ms
aacraid 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
aacraid 0000:01:00.0: setting latency timer to 64
AAC0: kernel 5.2-0[16116] Jun 25 2008
AAC0: monitor 5.2-0[16116]
AAC0: bios 5.2-0[16116]
AAC0: serial 8A32108386D
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
scsi8 : aacraid
scsi 8:0:0:0: Direct-Access     Adaptec  Mem3             V1.0 PQ: 0 ANSI: 2
sd 8:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
sd 8:0:0:0: [sdb] 13457403904 512-byte hardware sectors: (6.89 TB/6.26 TiB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 06 00 10 00
sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO
and FUA
sd 8:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
sd 8:0:0:0: [sdb] 13457403904 512-byte hardware sectors: (6.89 TB/6.26 TiB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 06 00 10 00
sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO
and FUA
 sdb: unknown partition table
sd 8:0:0:0: [sdb] Attached SCSI removable disk
scsi 8:1:0:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:1:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:2:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:3:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:4:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:5:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:6:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:7:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:8:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:9:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI: 5
scsi 8:1:10:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:11:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:12:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:13:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:14:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:15:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:16:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:17:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:18:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:19:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:20:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:21:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:22:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
scsi 8:1:23:0: Direct-Access     SEAGATE  ST3300655SS      S527 PQ: 1 ANSI:
5
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XFS mounting filesystem sdb
Ending clean XFS mount for filesystem: sdb
Adding 16779884k swap on /dev/sda2.  Priority:-1 extents:1 across:16779884k
e1000e 0000:0f:00.0: irq 761 for MSI/MSI-X
e1000e 0000:0f:00.0: irq 761 for MSI/MSI-X
0000:0f:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
e1000e 0000:0f:00.1: irq 760 for MSI/MSI-X
e1000e 0000:0f:00.1: irq 760 for MSI/MSI-X
0000:0f:00.1: eth1: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
RPC: Registered udp transport module.
RPC: Registered tcp transport module.



Dmidecode:

# dmidecode 2.7
SMBIOS 2.5 present.
61 structures occupying 1876 bytes.
Table at 0xBFF60000.

Handle 0x0000, DMI type 0, 24 bytes.
BIOS Information
        Vendor: Phoenix Technologies LTD
        Version: V1.04B          
        Release Date: 10/21/2008
        Address: 0xE4CD0
        Runtime Size: 111408 bytes
        ROM Size: 1024 kB
        Characteristics:
                PCI is supported
                PNP is supported
                APM is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                ESCD support is available
                Boot from CD is supported
                Selectable boot is supported
                BIOS ROM is socketed
                EDD is supported
                ACPI is supported
                USB legacy is supported
                LS-120 boot is supported
                ATAPI Zip drive boot is supported
                BIOS boot specification is supported
        BIOS Revision: 1.3

Handle 0x0001, DMI type 1, 27 bytes.
System Information
        Manufacturer: Empty
        Product Name: Empty
        Version: Empty
        Serial Number: Empty
        UUID: 00000000-0000-0000-0000-F0AB0C00C04D
        Wake-up Type: Power Switch
        SKU Number: Not Specified
        Family: Not Specified

Handle 0x0002, DMI type 2, 8 bytes.
Base Board Information
        Manufacturer: TYAN
        Product Name: S5397
        Version: 1.0
        Serial Number: 0123456789

Handle 0x0003, DMI type 3, 17 bytes.
Chassis Information
        Manufacturer: Empty
        Type: Other
        Lock: Not Present
        Version: Empty
        Serial Number: Empty
        Asset Tag: Empty
        Boot-up State: Safe
        Power Supply State: Safe
        Thermal State: Safe
        Security Status: None
        OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 40 bytes.
Processor Information
        Socket Designation: LGA771
        Type: Central Processor
        Family: Pentium II Xeon
        Manufacturer: Intel
        ID: 76 06 01 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 23, Stepping 6
        Flags:
                FPU (Floating-point unit on-chip)
                VME (Virtual mode extension)
                DE (Debugging extension)
                PSE (Page size extension)
                TSC (Time stamp counter)
                MSR (Model specific registers)
                PAE (Physical address extension)
                MCE (Machine check exception)
                CX8 (CMPXCHG8 instruction supported)
                APIC (On-chip APIC hardware supported)
                SEP (Fast system call)
                MTRR (Memory type range registers)
                PGE (Page global enable)
                MCA (Machine check architecture)
                CMOV (Conditional move instruction supported)
                PAT (Page attribute table)
                PSE-36 (36-bit page size extension)
                CLFSH (CLFLUSH instruction supported)
                DS (Debug store)
                ACPI (ACPI supported)
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
                SSE2 (Streaming SIMD extensions 2)
                SS (Self-snoop)
                HTT (Hyper-threading technology)
                TM (Thermal monitor supported)
                PBE (Pending break enabled)
        Version:   
        Voltage: 1.2 V
        External Clock: Unknown
        Max Speed: 3800 MHz
        Current Speed: 2660 MHz
        Status: Populated, Enabled
        Upgrade: <OUT OF SPEC>
        L1 Cache Handle: 0x0006
        L2 Cache Handle: 0x0007
        L3 Cache Handle: Not Provided
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0005, DMI type 4, 40 bytes.
Processor Information
        Socket Designation: .
        Type: Central Processor
        Family: Pentium II Xeon
        Manufacturer: .
        ID: 76 06 01 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 23, Stepping 6
        Flags:
                FPU (Floating-point unit on-chip)
                VME (Virtual mode extension)
                DE (Debugging extension)
                PSE (Page size extension)
                TSC (Time stamp counter)
                MSR (Model specific registers)
                PAE (Physical address extension)
                MCE (Machine check exception)
                CX8 (CMPXCHG8 instruction supported)
                APIC (On-chip APIC hardware supported)
                SEP (Fast system call)
                MTRR (Memory type range registers)
                PGE (Page global enable)
                MCA (Machine check architecture)
                CMOV (Conditional move instruction supported)
                PAT (Page attribute table)
                PSE-36 (36-bit page size extension)
                CLFSH (CLFLUSH instruction supported)
                DS (Debug store)
                ACPI (ACPI supported)
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
                SSE2 (Streaming SIMD extensions 2)
                SS (Self-snoop)
                HTT (Hyper-threading technology)
                TM (Thermal monitor supported)
                PBE (Pending break enabled)
        Version: X
        Voltage: 1.2 V
        External Clock: Unknown
        Max Speed: 3800 MHz
        Current Speed: 2660 MHz
        Status: Populated, Enabled
        Upgrade: <OUT OF SPEC>
        L1 Cache Handle: 0x0008
        L2 Cache Handle: 0x0009
        L3 Cache Handle: Not Provided
        Serial Number: Not Specified
        Asset Tag: <BAD INDEX>
        Part Number: <BAD INDEX>

Handle 0x4C02, DMI type 2, 2 bytes.
Base Board Information

Handle 0x0007, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: L2 Cache
        Configuration: Enabled, Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 12288 KB
        Maximum Size: 8192 KB
        Supported SRAM Types:
                Burst
                Pipeline Burst
                Asynchronous
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x0008, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: L1 Cache
        Configuration: Enabled, Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 16 KB
        Maximum Size: 16 KB
        Supported SRAM Types:
                Burst
                Pipeline Burst
                Asynchronous
        Installed SRAM Type: Asynchronous
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x0009, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: L2 Cache
        Configuration: Enabled, Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 12288 KB
        Maximum Size: 8192 KB
        Supported SRAM Types:
                Burst
                Pipeline Burst
                Asynchronous
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x000A, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J4
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator: COM 1
        External Connector Type: DB-9 male
        Port Type: Serial Port 16550A Compatible

Handle 0x000B, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J20
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator: COM 2
        External Connector Type: DB-9 male
        Port Type: Serial Port 16550A Compatible

Handle 0x000C, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J1
        Internal Connector Type: None
        External Reference Designator: Keyboard
        External Connector Type: Circular DIN-8 male
        Port Type: Keyboard Port

Handle 0x000D, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J1
        Internal Connector Type: None
        External Reference Designator: PS/2 Mouse
        External Connector Type: Circular DIN-8 male
        Port Type: Keyboard Port

Handle 0x000E, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCI/33 Slot #1 - J1B1
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 1
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x000F, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #2 - J2B1
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0010, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #3 - J2B2
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0011, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #4 - J3B3
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0012, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #5 - J3B2
        Type: 32-bit PCI-X
        Current Usage: Available
        Length: Long
        ID: 5
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0013, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCIE Slot #6 - J4B1
        Type: 32-bit PCI Express
        Current Usage: Available
        Length: Long
        Characteristics:
                5.0 V is provided
                3.3 V is provided

Handle 0x0014, DMI type 10, 6 bytes.
On Board Device Information
        Type: Sound
        Status: Disabled
        Description: RealTek

Handle 0x0015, DMI type 11, 5 bytes.
OEM Strings
        String 1: 0
        String 2: 0
        String 3: .........................

Handle 0x0016, DMI type 15, 29 bytes.
System Event Log
        Area Length: 32 bytes
        Header Start Offset: 0x0000
        Header Length: 16 bytes
        Data Start Offset: 0x0010
        Access Method: General-purpose non-volatile data functions
        Access Address: 0x0000
        Status: Valid, Not Full
        Change Token: 0x000000E5
        Header Format: Type 1
        Supported Log Type Descriptors: 3
        Descriptor 1: POST error
        Data Format 1: POST results bitmap
        Descriptor 2: Single-bit ECC memory error
        Data Format 2: Multiple-event
        Descriptor 3: Multi-bit ECC memory error
        Data Format 3: Multiple-event

Handle 0x0017, DMI type 16, 15 bytes.
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 64 GB
        Error Information Handle: Not Provided
        Number Of Devices: 4

Handle 0x0018, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM1
        Bank Locator: DIMM1
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0019, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM2
        Bank Locator: DIMM2
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001A, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM3
        Bank Locator: DIMM3
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001B, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM4
        Bank Locator: DIMM4
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001C, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM5
        Bank Locator: DIMM5
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001D, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM6
        Bank Locator: DIMM6
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001E, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM7
        Bank Locator: DIMM7
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001F, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM8
        Bank Locator: DIMM8
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0020, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM9
        Bank Locator: DIMM9
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0021, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM10
        Bank Locator: DIMM10
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0022, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM11
        Bank Locator: DIMM11
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0023, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM12
        Bank Locator: DIMM12
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0024, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM13
        Bank Locator: DIMM13
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0025, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM14
        Bank Locator: DIMM14
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0026, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM15
        Bank Locator: DIMM15
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0027, DMI type 17, 27 bytes.
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: <OUT OF SPEC>
        Set: 1
        Locator: DIMM16
        Bank Locator: DIMM16
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0028, DMI type 19, 15 bytes.
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x007FFFFFFFF
        Range Size: 32 GB
        Physical Array Handle: 0x0017
        Partition Width: 0

Handle 0x0029, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0007FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0018
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002A, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00080000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0019
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002B, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00100000000
        Ending Address: 0x0017FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x001A
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002C, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00180000000
        Ending Address: 0x001FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x001B
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002D, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00200000000
        Ending Address: 0x0027FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x001C
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002E, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00280000000
        Ending Address: 0x002FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x001D
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x002F, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00300000000
        Ending Address: 0x0037FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x001E
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0030, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00380000000
        Ending Address: 0x003FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x001F
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0031, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00400000000
        Ending Address: 0x0047FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0020
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0032, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00480000000
        Ending Address: 0x004FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0021
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0033, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00500000000
        Ending Address: 0x0057FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0022
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0034, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00580000000
        Ending Address: 0x005FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0023
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0035, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00600000000
        Ending Address: 0x0067FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0024
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0036, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00680000000
        Ending Address: 0x006FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0025
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0037, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00700000000
        Ending Address: 0x0077FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0026
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0038, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00780000000
        Ending Address: 0x007FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0027
        Memory Array Mapped Address Handle: 0x0028
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0039, DMI type 23, 13 bytes.
System Reset
        Status: Enabled
        Watchdog Timer: Present
        Boot Option: Do Not Reboot
        Boot Option On Limit: Do Not Reboot
        Reset Count: Unknown
        Reset Limit: Unknown
        Timer Interval: Unknown
        Timeout: Unknown

Handle 0x003A, DMI type 32, 20 bytes.
System Boot Information
        Status: <OUT OF SPEC>

Handle 0x003B, DMI type 38, 18 bytes.
IPMI Device Information
        Interface Type: Unknown
        Specification Version: 0.0
        I2C Slave Address: 0x00
        NV Storage Device: Not Present
        Base Address: 0x0000000000000000 (Memory-mapped)
        Register Spacing: Successive Byte Boundaries
        Interrupt Polarity: Active Low
        Interrupt Trigger Mode: Edge

Handle 0x003C, DMI type 127, 4 bytes.
End Of Table


Doug Bazarnic


