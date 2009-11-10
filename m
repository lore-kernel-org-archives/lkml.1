Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZKJReZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZKJReZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZKJReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:34:23 -0500
Received: from web58402.mail.re3.yahoo.com ([68.142.236.170]:22646 "HELO
	web58402.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756391AbZKJReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:34:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=bX+3hxbD5WTiaypJDTE7NzqQT8USYAQy8n9gZrDyVRZBD+milM1owua9RyP/PBEq2UgzmMzC+eGbNF73e+ZcmlNCpmnPr1VkJYbRtYqaD25Vk8C4ro02nc+t/655YtLtRv4FXNBWEChX7ssYDIre7ZcUfdMLXAxPpAFC+RneyY0=;
Message-ID: <761296.29412.qm@web58402.mail.re3.yahoo.com>
X-YMail-OSG: .sjZqgwVM1meoOW3FnebyicwDNkAFXpo8MkIHc2jwJhuwbZPVKTIvPFm2GPNJGfU9B1IucyAmoYjz8SdyGTzvCJx0xrHSguAzOzqBWoJbLx83nWgF6V7s_5yY6kC_qDvMoXMV47oUKp0bN6Wl837ivHvUyZbhA0pxkSEWs6_dEARLWo_vX0nWPGcaCVuqGr.Iwzwjt7hNZnzyb0MhMJ8JYrwqSbV8KaPoi9ppiQC.o60ZC2UZ2Q0_tUmsaPn5RbwyDJG2Vctwt3aXvKA8.neaFHdIgEcBJtoUSPBEBdAotWJ7m_eHdk5msymTr6tVj0BRxIs8g7En9Ql6aFI
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
Date: Tue, 10 Nov 2009 09:27:40 -0800 (PST)
From: Mikko Vinni <mmvinni@yahoo.com>
Subject: keyboard leds not restored after s2ram in 2.6.32-rc6-00166-g799dd75
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my laptop shows the caps lock and scroll lock leds as being on after s2ram
(and resume), even though they are off. If I press the caps lock key, the caps
lock led stays on, the num lock led turns off, and the screen unlock screen
warns about the caps lock being on.

I see there are in the git tree a couple of commits that probably solved these
problems for some machines, but on this one the problem still persists.
Those commits were fc0eb28c0031ec2da872dd296b551453eb1963c9
(http://lkml.org/lkml/2009/10/12/67) and 94dfb0d6334a281a979fe5bee187a3698a4dc176.

This problem does not appear in Arch Linux's 2.6.31 kernel, and I don't
remember seeing it in the 2.6.31-rcx kernels I compiled myself.

I have attached the dmesg of the kernel over a s2ram. I set the i8042.debug
parameter for the duration of the event. I must say that before the s2ram
shown in the log I did s2ram twice: once with the debug parameter set
and once without it. At the first time the keyboard leds behaved
correctly, so there is something undeterministic about the fault.
The keyboard in this laptop or some software layer above it appears
to be buggy in other aspects too, because sometimes I have to press
the keys multiple times before they show up on the screen. That may
or may not be related.

I'll be happy to test patches and/or provide hardware details.


Thanks,

Mikko


(let's hope this message doesn't get too big...)

[    0.000000] Linux version 2.6.32-rc6-CUST-00166-g799dd75-dirty (mikko@koni) (gcc version 4.4.2 (GCC) ) #15 SMP PREEMPT Tue Nov 10 17:43:00 EET 2009
[    0.000000] Command line: BOOT_IMAGE=Arch_GitKernel ro root=803 ro root=/dev/sda3
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfd70000 (usable)
[    0.000000]  BIOS-e820: 00000000bfd70000 - 00000000bfdbf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfdbf000 - 00000000bfe58000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe58000 - 00000000bfebf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfebf000 - 00000000bfeed000 (usable)
[    0.000000]  BIOS-e820: 00000000bfeed000 - 00000000bfeff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfeff000 - 00000000bff00000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00FFF00000 mask FFFFF00000 write-protect
[    0.000000]   1 base 0000000000 mask FF80000000 write-back
[    0.000000]   2 base 0080000000 mask FFC0000000 write-back
[    0.000000]   3 base 0100000000 mask FFC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000140000000 aka 5120M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbff00 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bfd70000 (usable)
[    0.000000]  modified: 00000000bfd70000 - 00000000bfdbf000 (reserved)
[    0.000000]  modified: 00000000bfdbf000 - 00000000bfe58000 (usable)
[    0.000000]  modified: 00000000bfe58000 - 00000000bfebf000 (ACPI NVS)
[    0.000000]  modified: 00000000bfebf000 - 00000000bfeed000 (usable)
[    0.000000]  modified: 00000000bfeed000 - 00000000bfeff000 (ACPI data)
[    0.000000]  modified: 00000000bfeff000 - 00000000bff00000 (usable)
[    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff00000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff00000 page 4k
[    0.000000] kernel direct mapping tables up to bff00000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ b000-11000
[    0.000000] RAMDISK: 7fc8e000 - 7ffffa94
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 00000000bfefe120 0005C (v01 HPQOEM SLIC-MPC 00000003      01000013)
[    0.000000] ACPI: FACP 00000000bfefd000 000F4 (v04 HP     3600     00000003 MSFT 01000013)
[    0.000000] ACPI: DSDT 00000000bfef0000 09825 (v01 HP     3600     F0000000 MSFT 01000013)
[    0.000000] ACPI: FACS 00000000bfe61000 00040
[    0.000000] ACPI: HPET 00000000bfefc000 00038 (v01 HP     3600     00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 00000000bfefb000 00084 (v02 HP     3600     00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 00000000bfefa000 0003C (v01 HP     3600     00000001 MSFT 01000013)
[    0.000000] ACPI: BOOT 00000000bfeef000 00028 (v01 HP     3600     00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 00000000bfeee000 00176 (v01 HPQOEM SLIC-MPC 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bfeed000 002B4 (v01 AMD    PowerNow 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0140000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000161ed78]    TEXT DATA BSS ==> [0001000000 - 000161ed78]
[    0.000000]   #3 [007fc8e000 - 007ffffa94]          RAMDISK ==> [007fc8e000 - 007ffffa94]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [000161f000 - 000161f1ec]              BRK ==> [000161f000 - 000161f1ec]
[    0.000000]   #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #7 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfd70
[    0.000000]     0: 0x000bfdbf -> 0x000bfe58
[    0.000000]     0: 0x000bfebf -> 0x000bfeed
[    0.000000]     0: 0x000bfeff -> 0x000bff00
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1048018
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3835 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767600 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x1002a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfd70000 - 00000000bfdbf000
[    0.000000] PM: Registered nosave memory: 00000000bfe58000 - 00000000bfebf000
[    0.000000] PM: Registered nosave memory: 00000000bfeed000 - 00000000bfeff000
[    0.000000] PM: Registered nosave memory: 00000000bff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bff00000 (gap: bff00000:20100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880028200000 s83416 r8192 d23080 u524288
[    0.000000] pcpu-alloc: s83416 r8192 d23080 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029995
[    0.000000] Kernel command line: BOOT_IMAGE=Arch_GitKernel ro root=803 ro root=/dev/sda3
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 4051228k/5242880k available (3108k kernel code, 1050808k absent, 139924k reserved, 1674k data, 468k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1050.046 MHz processor.
[    0.006693] Calibrating delay loop (skipped), value calculated using timer frequency.. 4201.17 BogoMIPS (lpj=7000283)
[    0.007065] Security Framework initialized
[    0.007302] Mount-cache hash table entries: 256
[    0.008044] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.008186] CPU: L2 Cache: 512K (64 bytes/line)
[    0.008318] tseg: 00bff00000
[    0.008327] CPU: Physical Processor ID: 0
[    0.008455] CPU: Processor Core ID: 0
[    0.008584] mce: CPU supports 5 MCE banks
[    0.008740] using C1E aware idle routine
[    0.008866] Performance Events: AMD PMU driver.
[    0.009101] ... version:                0
[    0.009228] ... bit width:              48
[    0.009354] ... generic registers:      4
[    0.009480] ... value mask:             0000ffffffffffff
[    0.009612] ... max period:             00007fffffffffff
[    0.009743] ... fixed-purpose events:   0
[    0.009869] ... event mask:             000000000000000f
[    0.010971] ACPI: Core revision 20090903
[    0.033749] Setting APIC routing to flat
[    0.034781] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069828] CPU0: AMD Athlon(tm) X2 Dual-Core QL-64 stepping 01
[    0.069999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.009999] Initializing CPU#1
[    0.009999] Calibrating delay using timer specific routine.. 4191.28 BogoMIPS (lpj=6982862)
[    0.009999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.009999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.009999] CPU: Physical Processor ID: 0
[    0.009999] CPU: Processor Core ID: 1
[    0.160180] CPU1: AMD Athlon(tm) X2 Dual-Core QL-64 stepping 01
[    0.161267] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.163332] Measured 206388276 cycles TSC warp between CPUs, turning off TSC clock.
[    0.163332] Marking TSC unstable due to check_tsc_sync_source failed
[    0.163459] Brought up 2 CPUs
[    0.164998] Total of 2 processors activated (8393.46 BogoMIPS).
[    0.165535] CPU0 attaching sched-domain:
[    0.165546]  domain 0: span 0-1 level MC
[    0.165558]   groups: 0 1
[    0.165578] CPU1 attaching sched-domain:
[    0.165586]  domain 0: span 0-1 level MC
[    0.165595]   groups: 1 0
[    0.165894] NET: Registered protocol family 16
[    0.166959] TOM: 00000000c0000000 aka 3072M
[    0.167094] Fam 10h mmconf [e0000000, e0ffffff]
[    0.167118] TOM2: 0000000140000000 aka 5120M
[    0.167278] ACPI: bus type pci registered
[    0.167767] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.167912] PCI: MCFG area at e0000000 reserved in E820
[    0.176666] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.176666] PCI: Using configuration type 1 for base access
[    0.176666] bio: create slab <bio-0> at 0
[    0.178976] ACPI: EC: Look up EC in DSDT
[    0.180364] ACPI: Executed 1 blocks of module-level executable AML code
[    0.187492] ACPI: BIOS _OSI(Linux) query ignored
[    0.199561] ACPI: Interpreter enabled
[    0.199704] ACPI: (supports S0 S3 S4 S5)
[    0.199999] ACPI: Using IOAPIC for interrupt routing
[    0.209455] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.209999] ACPI: No dock devices found.
[    0.212384] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.212880] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.213000] pci 0000:00:02.0: PME# disabled
[    0.213220] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.213332] pci 0000:00:04.0: PME# disabled
[    0.213332] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.213332] pci 0000:00:05.0: PME# disabled
[    0.213332] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.213332] pci 0000:00:06.0: PME# disabled
[    0.213332] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.213332] pci 0000:00:0a.0: PME# disabled
[    0.213332] pci 0000:00:11.0: reg 10 io port: [0x6038-0x603f]
[    0.213332] pci 0000:00:11.0: reg 14 io port: [0x604c-0x604f]
[    0.213332] pci 0000:00:11.0: reg 18 io port: [0x6030-0x6037]
[    0.213332] pci 0000:00:11.0: reg 1c io port: [0x6048-0x604b]
[    0.213332] pci 0000:00:11.0: reg 20 io port: [0x6010-0x601f]
[    0.213332] pci 0000:00:11.0: reg 24 32bit mmio: [0xd2408000-0xd24083ff]
[    0.213332] pci 0000:00:12.0: reg 10 32bit mmio: [0xd2407000-0xd2407fff]
[    0.213332] pci 0000:00:12.1: reg 10 32bit mmio: [0xd2406000-0xd2406fff]
[    0.213332] pci 0000:00:12.2: reg 10 32bit mmio: [0xd2408500-0xd24085ff]
[    0.213332] pci 0000:00:12.2: supports D1 D2
[    0.213332] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.213332] pci 0000:00:12.2: PME# disabled
[    0.213332] pci 0000:00:13.0: reg 10 32bit mmio: [0xd2405000-0xd2405fff]
[    0.213332] pci 0000:00:13.1: reg 10 32bit mmio: [0xd2404000-0xd2404fff]
[    0.213332] pci 0000:00:13.2: reg 10 32bit mmio: [0xd2408400-0xd24084ff]
[    0.213332] pci 0000:00:13.2: supports D1 D2
[    0.213332] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.213332] pci 0000:00:13.2: PME# disabled
[    0.213332] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.213332] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.213332] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.213347] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.213363] pci 0000:00:14.1: reg 20 io port: [0x6000-0x600f]
[    0.213525] pci 0000:00:14.2: reg 10 64bit mmio: [0xd2400000-0xd2403fff]
[    0.213627] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.213746] pci 0000:00:14.2: PME# disabled
[    0.214538] pci 0000:01:00.0: reg 10 32bit mmio pref: [0xc0000000-0xcfffffff]
[    0.214554] pci 0000:01:00.0: reg 14 io port: [0x5000-0x50ff]
[    0.214568] pci 0000:01:00.0: reg 18 32bit mmio: [0xd2300000-0xd230ffff]
[    0.214606] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfffe0000-0xffffffff]
[    0.214652] pci 0000:01:00.0: supports D1 D2
[    0.214733] pci 0000:01:00.1: reg 10 32bit mmio: [0xd2310000-0xd2313fff]
[    0.214826] pci 0000:01:00.1: supports D1 D2
[    0.214961] pci 0000:00:02.0: bridge io port: [0x5000-0x5fff]
[    0.214970] pci 0000:00:02.0: bridge 32bit mmio: [0xd2300000-0xd23fffff]
[    0.214983] pci 0000:00:02.0: bridge 64bit mmio pref: [0xc0000000-0xcfffffff]
[    0.215098] pci 0000:00:04.0: bridge io port: [0x3000-0x4fff]
[    0.215105] pci 0000:00:04.0: bridge 32bit mmio: [0xd1300000-0xd22fffff]
[    0.215117] pci 0000:00:04.0: bridge 64bit mmio pref: [0xd0000000-0xd0ffffff]
[    0.215223] pci 0000:08:00.0: reg 10 64bit mmio: [0xd1200000-0xd120ffff]
[    0.215546] pci 0000:00:05.0: bridge 32bit mmio: [0xd1200000-0xd12fffff]
[    0.215644] pci 0000:09:00.0: reg 10 io port: [0x2000-0x20ff]
[    0.215682] pci 0000:09:00.0: reg 18 64bit mmio pref: [0xd1010000-0xd1010fff]
[    0.215709] pci 0000:09:00.0: reg 20 64bit mmio pref: [0xd1000000-0xd100ffff]
[    0.215725] pci 0000:09:00.0: reg 30 32bit mmio pref: [0xffff0000-0xffffffff]
[    0.215796] pci 0000:09:00.0: supports D1 D2
[    0.215801] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.215990] pci 0000:09:00.0: PME# disabled
[    0.216244] pci 0000:00:06.0: bridge io port: [0x2000-0x2fff]
[    0.216257] pci 0000:00:06.0: bridge 64bit mmio pref: [0xd1000000-0xd10fffff]
[    0.216361] pci 0000:0a:00.0: reg 10 32bit mmio: [0xd1100000-0xd11007ff]
[    0.216382] pci 0000:0a:00.0: reg 14 32bit mmio: [0xd1100d00-0xd1100d7f]
[    0.216434] pci 0000:0a:00.0: reg 20 32bit mmio: [0xd1100c80-0xd1100cff]
[    0.216454] pci 0000:0a:00.0: reg 24 32bit mmio: [0xd1100c00-0xd1100c7f]
[    0.216652] pci 0000:0a:00.1: reg 10 32bit mmio: [0xd1100b00-0xd1100bff]
[    0.216666] pci 0000:0a:00.2: reg 10 32bit mmio: [0xd1100a00-0xd1100aff]
[    0.216666] pci 0000:0a:00.3: reg 10 32bit mmio: [0xd1100900-0xd11009ff]
[    0.216666] pci 0000:0a:00.4: reg 10 32bit mmio: [0xd1100800-0xd11008ff]
[    0.216666] pci 0000:00:0a.0: bridge 32bit mmio: [0xd1100000-0xd11fffff]
[    0.216666] pci 0000:00:14.4: transparent bridge
[    0.216666] pci 0000:00:14.4: bridge io port: [0x1000-0x1fff]
[    0.216666] pci_bus 0000:00: on NUMA node 0
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB2_._PRT]
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB10._PRT]
[    0.216666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.233332] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.233492] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.235085] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.236666] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.236666] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.236666] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.238166] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.239756] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.239999] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.239999] vgaarb: loaded
[    0.240092] PCI: Using ACPI for IRQ routing
[    0.240903] NetLabel: Initializing
[    0.241016] NetLabel:  domain hash size = 128
[    0.241124] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.241270] NetLabel:  unlabeled traffic allowed by default
[    0.243487] hpet: hpet2 irq 24 for MSI
[    0.243525] Switching to clocksource hpet
[    0.249088] pnp: PnP ACPI init
[    0.249321] ACPI: bus type pnp registered
[    0.252191] pnp: PnP ACPI: found 13 devices
[    0.252373] ACPI: ACPI bus type pnp unregistered
[    0.252511] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.252641] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.252775] system 00:09: ioport range 0x400-0x4cf has been reserved
[    0.252889] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    0.253013] system 00:09: ioport range 0x4d6-0x4d6 has been reserved
[    0.253129] system 00:09: ioport range 0x680-0x6ff has been reserved
[    0.253244] system 00:09: ioport range 0x77a-0x77a has been reserved
[    0.253359] system 00:09: ioport range 0xc00-0xc01 has been reserved
[    0.253473] system 00:09: ioport range 0xc14-0xc14 has been reserved
[    0.253589] system 00:09: ioport range 0xc50-0xc52 has been reserved
[    0.253704] system 00:09: ioport range 0xc6c-0xc6c has been reserved
[    0.253818] system 00:09: ioport range 0xc6f-0xc6f has been reserved
[    0.253932] system 00:09: ioport range 0xcd0-0xcdb has been reserved
[    0.254055] system 00:0a: iomem range 0xe0000-0xfffff could not be reserved
[    0.254171] system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
[    0.258357] pci 0000:01:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.258495] pci 0000:09:00.0: BAR 6: no parent found for of device [0xffff0000-0xffffffff]
[    0.258725] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.258842] pci 0000:00:02.0:   IO window: 0x5000-0x5fff
[    0.258960] pci 0000:00:02.0:   MEM window: 0xd2300000-0xd23fffff
[    0.259081] pci 0000:00:02.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
[    0.259216] pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
[    0.259332] pci 0000:00:04.0:   IO window: 0x3000-0x4fff
[    0.259450] pci 0000:00:04.0:   MEM window: 0xd1300000-0xd22fffff
[    0.259567] pci 0000:00:04.0:   PREFETCH window: 0x000000d0000000-0x000000d0ffffff
[    0.259701] pci 0000:00:05.0: PCI bridge, secondary bus 0000:08
[    0.259816] pci 0000:00:05.0:   IO window: disabled
[    0.259933] pci 0000:00:05.0:   MEM window: 0xd1200000-0xd12fffff
[    0.260053] pci 0000:00:05.0:   PREFETCH window: disabled
[    0.260171] pci 0000:00:06.0: PCI bridge, secondary bus 0000:09
[    0.260286] pci 0000:00:06.0:   IO window: 0x2000-0x2fff
[    0.260403] pci 0000:00:06.0:   MEM window: 0xd2500000-0xd25fffff
[    0.260455] pci 0000:00:06.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    0.260455] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:0a
[    0.260455] pci 0000:00:0a.0:   IO window: disabled
[    0.260455] pci 0000:00:0a.0:   MEM window: 0xd1100000-0xd11fffff
[    0.260455] pci 0000:00:0a.0:   PREFETCH window: disabled
[    0.260455] pci 0000:00:14.4: PCI bridge, secondary bus 0000:80
[    0.260455] pci 0000:00:14.4:   IO window: 0x1000-0x1fff
[    0.260455] pci 0000:00:14.4:   MEM window: disabled
[    0.260455] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.260455] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.260455] pci 0000:00:02.0: setting latency timer to 64
[    0.260455] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.260455] pci 0000:00:04.0: setting latency timer to 64
[    0.260455] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.260455] pci 0000:00:05.0: setting latency timer to 64
[    0.260455] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.260455] pci 0000:00:06.0: setting latency timer to 64
[    0.260455] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.260455] pci 0000:00:0a.0: setting latency timer to 64
[    0.260455] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.260455] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.260455] pci_bus 0000:01: resource 0 io:  [0x5000-0x5fff]
[    0.260455] pci_bus 0000:01: resource 1 mem: [0xd2300000-0xd23fffff]
[    0.260455] pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xcfffffff]
[    0.260455] pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
[    0.260455] pci_bus 0000:02: resource 1 mem: [0xd1300000-0xd22fffff]
[    0.260455] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xd0ffffff]
[    0.260455] pci_bus 0000:08: resource 1 mem: [0xd1200000-0xd12fffff]
[    0.260455] pci_bus 0000:09: resource 0 io:  [0x2000-0x2fff]
[    0.260455] pci_bus 0000:09: resource 1 mem: [0xd2500000-0xd25fffff]
[    0.260455] pci_bus 0000:09: resource 2 pref mem [0xd1000000-0xd10fffff]
[    0.260455] pci_bus 0000:0a: resource 1 mem: [0xd1100000-0xd11fffff]
[    0.260455] pci_bus 0000:80: resource 0 io:  [0x1000-0x1fff]
[    0.260455] pci_bus 0000:80: resource 3 io:  [0x00-0xffff]
[    0.260455] pci_bus 0000:80: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.260455] NET: Registered protocol family 2
[    0.260455] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.261768] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.263795] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.265022] TCP: Hash tables configured (established 262144 bind 65536)
[    0.265215] TCP reno registered
[    0.265575] NET: Registered protocol family 1
[    0.403519] pci 0000:01:00.0: Boot video device
[    0.403704] Unpacking initramfs...
[    0.477488] Freeing initrd memory: 3526k freed
[    0.480461] Simple Boot Flag at 0x44 set to 0x1
[    0.480461] Scanning for low memory corruption every 60 seconds
[    0.480461] audit: initializing netlink socket (disabled)
[    0.480461] type=2000 audit(1257869617.477:1): initialized
[    0.483659] VFS: Disk quotas dquot_6.5.2
[    0.483659] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.483659] msgmni has been set to 7921
[    0.483659] alg: No test for stdrng (krng)
[    0.483659] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.483659] io scheduler noop registered
[    0.483659] io scheduler anticipatory registered
[    0.483659] io scheduler deadline registered
[    0.483659] io scheduler cfq registered (default)
[    0.483992] pcieport 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.484010] pcieport 0000:00:02.0: setting latency timer to 64
[    0.484251] pcieport 0000:00:04.0: irq 26 for MSI/MSI-X
[    0.484263] pcieport 0000:00:04.0: setting latency timer to 64
[    0.484498] pcieport 0000:00:05.0: irq 27 for MSI/MSI-X
[    0.484510] pcieport 0000:00:05.0: setting latency timer to 64
[    0.484633] pcieport 0000:00:06.0: irq 28 for MSI/MSI-X
[    0.484633] pcieport 0000:00:06.0: setting latency timer to 64
[    0.484633] pcieport 0000:00:0a.0: irq 29 for MSI/MSI-X
[    0.484633] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.486835] Linux agpgart interface v0.103
[    0.487025] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.487129] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.487129] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.507718] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.507777] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.508008] mice: PS/2 mouse device common for all mice
[    0.508237] cpuidle: using governor ladder
[    0.508349] cpuidle: using governor menu
[    0.509068] TCP cubic registered
[    0.509250] NET: Registered protocol family 17
[    0.509570] registered taskstats version 1
[    0.510976] Initalizing network drop monitor service
[    0.510976] Freeing unused kernel memory: 468k freed
[    0.510976] Write protecting the kernel read-only data: 4364k
[    0.530430] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.832936] SCSI subsystem initialized
[    0.903797] libata version 3.00 loaded.
[    0.905165] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.905380] pata_acpi 0000:00:14.1: setting latency timer to 64
[    0.911998] scsi0 : pata_atiixp
[    0.920459] scsi1 : pata_atiixp
[    0.920459] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6000 irq 14
[    0.920459] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6008 irq 15
[    0.983795] ahci 0000:00:11.0: version 3.0
[    0.983795] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.983795] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.983795] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.996219] scsi2 : ahci
[    1.001568] scsi3 : ahci
[    1.010463] scsi4 : ahci
[    1.011696] scsi5 : ahci
[    1.021292] scsi6 : ahci
[    1.024322] scsi7 : ahci
[    1.024770] ata3: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408100 irq 22
[    1.024902] ata4: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408180 irq 22
[    1.025033] ata5: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408200 irq 22
[    1.025163] ata6: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408280 irq 22
[    1.025292] ata7: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408300 irq 22
[    1.025422] ata8: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408380 irq 22
[    1.373454] ata5: SATA link down (SStatus 0 SControl 300)
[    1.377200] ata6: SATA link down (SStatus 0 SControl 300)
[    1.386782] ata8: SATA link down (SStatus 0 SControl 300)
[    1.386952] ata7: SATA link down (SStatus 0 SControl 300)
[    1.513606] ata3: softreset failed (device not ready)
[    1.513721] ata3: applying SB600 PMP SRST workaround and retrying
[    1.517156] ata4: softreset failed (device not ready)
[    1.517270] ata4: applying SB600 PMP SRST workaround and retrying
[    1.673628] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.674261] ata3.00: ATA-8: FUJITSU MHZ2320BH G2, 8909, max UDMA/100
[    1.674379] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.675144] ata3.00: configured for UDMA/100
[    1.677177] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.686998] scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHZ2320B 8909 PQ: 0 ANSI: 5
[    1.693080] ata4.00: ATAPI: TSSTcorp CDDVDW TS-L633L, 0400, max UDMA/100
[    1.706900] ata4.00: configured for UDMA/100
[    1.724566] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-L633L  0400 PQ: 0 ANSI: 5
[    1.747127] sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.747127] sd 2:0:0:0: [sda] Write Protect is off
[    1.747127] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.747127] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.747127]  sda:sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.752796] Uniform CD-ROM driver Revision: 3.20
[    1.753136] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.821469]  sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.887191] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.868309] EXT4-fs (sda3): INFO: recovery required on readonly filesystem
[    2.868692] EXT4-fs (sda3): write access will be enabled during recovery
[    3.000654] EXT4-fs (sda3): recovery complete
[    3.001373] EXT4-fs (sda3): mounted filesystem with ordered data mode
[    4.250435] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    4.250574] rtc_cmos 00:05: RTC can wake from S4
[    4.250710] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    4.250780] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    4.906509] udev: starting version 146
[    5.036620] processor LNXCPU:00: registered as cooling_device0
[    5.036718] processor LNXCPU:01: registered as cooling_device1
[    5.177128] powernow-k8: Found 1 AMD Athlon(tm) X2 Dual-Core QL-64 processors (2 cpu cores) (version 2.20.00)
[    5.177128] powernow-k8:    0 : pstate 0 (2100 MHz)
[    5.177128] powernow-k8:    1 : pstate 1 (1050 MHz)
[    5.227098] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SMBI [0xb00-0xb0f]
[    5.227098] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.227780] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    5.227802] ACPI: Power Button [PWRB]
[    5.228033] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    5.228042] ACPI: Sleep Button [SLPB]
[    5.228333] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input4
[    5.229061] ACPI: Lid Switch [LID]
[    5.230659] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.237095] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    5.237095] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    5.239658] jmb38x_ms 0000:0a:00.3: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.239676] jmb38x_ms 0000:0a:00.3: setting latency timer to 64
[    5.247128] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    5.247128] ACPI: Power Button [PWRF]
[    5.323350] EDAC MC: Ver: 2.1.0 Nov 10 2009
[    5.366984] usbcore: registered new interface driver usbfs
[    5.367108] usbcore: registered new interface driver hub
[    5.394881] usbcore: registered new device driver usb
[    5.403611] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.403794] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.403979] ehci_hcd 0000:00:12.2: setting latency timer to 64
[    5.403987] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    5.404071] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    5.404226] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    5.404260] ehci_hcd 0000:00:12.2: debug port 1
[    5.404331] ehci_hcd 0000:00:12.2: irq 17, io mem 0xd2408500
[    5.407501] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.407560] r8169 0000:09:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.407691] r8169 0000:09:00.0: setting latency timer to 64
[    5.407858] r8169 0000:09:00.0: irq 30 for MSI/MSI-X
[    5.408453] eth0: RTL8168c/8111c at 0xffffc9000006a000, 00:23:8b:6a:a5:72, XID 1c4000c0 IRQ 30
[    5.413791] ACPI Exception: AE_OK, No or invalid critical threshold (20090903/thermal-386)
[    5.416951] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    5.417401] usb usb1: configuration #1 chosen from 1 choice
[    5.417552] hub 1-0:1.0: USB hub found
[    5.417577] hub 1-0:1.0: 6 ports detected
[    5.417967] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.418141] ehci_hcd 0000:00:13.2: setting latency timer to 64
[    5.418150] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    5.418181] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    5.418259] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    5.418291] ehci_hcd 0000:00:13.2: debug port 1
[    5.418358] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd2408400
[    5.420045] ACPI: WMI: Mapper loaded
[    5.430248] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    5.430535] usb usb2: configuration #1 chosen from 1 choice
[    5.430618] hub 2-0:1.0: USB hub found
[    5.430640] hub 2-0:1.0: 6 ports detected
[    5.437837] ACPI: AC Adapter [ACAD] (on-line)
[    5.480429] ohci1394 0000:0a:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.480429] ohci1394 0000:0a:00.0: setting latency timer to 64
[    5.483831] cfg80211: Calling CRDA to update world regulatory domain
[    5.486715] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.486715] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.486715] ohci_hcd 0000:00:12.0: setting latency timer to 64
[    5.486715] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    5.486715] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    5.486715] ohci_hcd 0000:00:12.0: irq 16, io mem 0xd2407000
[    5.500849] EDAC amd64_edac:  Ver: 3.2.0 Nov 10 2009
[    5.503794] ACPI: Battery Slot [BAT0] (battery absent)
[    5.511825] sdhci: Secure Digital Host Controller Interface driver
[    5.511833] sdhci: Copyright(c) Pierre Ossman
[    5.513796] lis3lv02d: hardware type HPDV5_A found.
[    5.513796] lis3lv02d: 1-byte sensor found
[    5.535993] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[d1100000-d11007ff]  Max Packet=[1024]  IR/IT contexts=[4/4]
[    5.545499] usb usb3: configuration #1 chosen from 1 choice
[    5.545650] hub 3-0:1.0: USB hub found
[    5.545679] hub 3-0:1.0: 3 ports detected
[    5.545977] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[    5.546705] EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
[    5.546705]  Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
[    5.546705]  Also, use of the override can cause unknown side effects.
[    5.546705] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    5.547132] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.547132] ohci_hcd 0000:00:12.1: setting latency timer to 64
[    5.547132] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    5.547132] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    5.547132] ohci_hcd 0000:00:12.1: irq 16, io mem 0xd2406000
[    5.561301] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input7
[    5.563079] Registered led device: hp::hddprotect
[    5.563475] lis3lv02d driver loaded.
[    5.574738] sdhci-pci 0000:0a:00.1: SDHCI controller found [197b:2382] (rev 0)
[    5.574796] sdhci-pci 0000:0a:00.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.575216] sdhci-pci 0000:0a:00.1: setting latency timer to 64
[    5.575235] Registered led device: mmc0::
[    5.575261] mmc0: SDHCI controller on PCI [0000:0a:00.1] using DMA
[    5.575289] sdhci-pci 0000:0a:00.2: SDHCI controller found [197b:2381] (rev 0)
[    5.575321] sdhci-pci 0000:0a:00.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.575337] sdhci-pci 0000:0a:00.2: Refusing to bind to secondary interface.
[    5.575350] sdhci-pci 0000:0a:00.2: PCI INT A disabled
[    5.605749] usb usb4: configuration #1 chosen from 1 choice
[    5.605885] hub 4-0:1.0: USB hub found
[    5.605960] hub 4-0:1.0: 3 ports detected
[    5.606299] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.606672] ohci_hcd 0000:00:13.0: setting latency timer to 64
[    5.606672] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    5.606672] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    5.606672] ohci_hcd 0000:00:13.0: irq 18, io mem 0xd2405000
[    5.624344] acpi device:09: registered as cooling_device2
[    5.624994] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/input/input8
[    5.624994] ACPI: Video Device [DVGA] (multi-head: yes  rom: no  post: no)
[    5.665142] usb usb5: configuration #1 chosen from 1 choice
[    5.665227] hub 5-0:1.0: USB hub found
[    5.665273] hub 5-0:1.0: 3 ports detected
[    5.665603] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.665778] ohci_hcd 0000:00:13.1: setting latency timer to 64
[    5.665786] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    5.665816] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    5.665871] ohci_hcd 0000:00:13.1: irq 18, io mem 0xd2404000
[    5.725274] usb usb6: configuration #1 chosen from 1 choice
[    5.725419] hub 6-0:1.0: USB hub found
[    5.725447] hub 6-0:1.0: 3 ports detected
[    5.817764] ath5k 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.817791] ath5k 0000:08:00.0: setting latency timer to 64
[    5.817999] ath5k 0000:08:00.0: registered as 'phy0'
[    5.830050] usb 1-3: new high speed USB device using ehci_hcd and address 3
[    5.907640] ath: EEPROM regdomain: 0x67
[    5.907647] ath: EEPROM indicates we should expect a direct regpair map
[    5.907658] ath: Country alpha2 being used: 00
[    5.907661] ath: Regpair used: 0x67
[    5.963756] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.963756] HDA Intel 0000:00:14.2: setting latency timer to 64
[    5.982838] usb 1-3: configuration #1 chosen from 1 choice
[    6.046188] Linux video capture interface: v2.00
[    6.067129] uvcvideo: Found UVC 1.00 device HP Webcam (064e:c107)
[    6.083442] input: HP Webcam as /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/input/input9
[    6.084242] usbcore: registered new interface driver uvcvideo
[    6.084256] USB Video Class driver (v0.1.0)
[    6.123703] phy0: Selected rate control algorithm 'minstrel'
[    6.124462] Registered led device: ath5k-phy0::rx
[    6.124505] Registered led device: ath5k-phy0::tx
[    6.124513] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    6.233443] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    6.394465] usb 3-1: configuration #1 chosen from 1 choice
[    6.454647] NET: Registered protocol family 8
[    6.454647] NET: Registered protocol family 20
[    6.455394] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    6.536269] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input10
[    6.821332] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00241b00322a5501]
[    6.960455] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input11
[    6.969496] input: HDA ATI SB Mic at Ext Front Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input12
[    6.969771] input: HDA ATI SB Mic at Sep UNKNOWN Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input13
[    6.970010] input: HDA ATI SB HP Out at Ext Front Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input14
[    6.970474] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.970474] HDA Intel 0000:01:00.1: irq 31 for MSI/MSI-X
[    6.970474] HDA Intel 0000:01:00.1: setting latency timer to 64
[    9.054302] cxacru 3-1:1.0: receive of cm 0x90 failed (-104)
[    9.054488] usbcore: registered new interface driver cxacru
[    9.054944] cxacru 3-1:1.0: firmware: requesting cxacru-fw.bin
[    9.150599] cxacru 3-1:1.0: found firmware cxacru-fw.bin
[    9.150610] cxacru 3-1:1.0: firmware: requesting cxacru-cf.bin
[   11.119188] EXT4-fs (sda5): mounted filesystem with ordered data mode
[   11.216543] Adding 3148700k swap on /dev/sda7.  Priority:-1 extents:1 across:3148700k 
[   16.964906] Bluetooth: Core ver 2.15
[   16.965190] NET: Registered protocol family 31
[   16.965195] Bluetooth: HCI device and connection manager initialized
[   16.965204] Bluetooth: HCI socket layer initialized
[   17.103758] Bluetooth: L2CAP ver 2.14
[   17.103758] Bluetooth: L2CAP socket layer initialized
[   17.585890] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   17.707635] Bridge firewalling registered
[   18.230922] Bluetooth: SCO (Voice Link) ver 0.6
[   18.230922] Bluetooth: SCO socket layer initialized
[   19.111562] [drm] Initialized drm 1.1.0 20060810
[   19.397126] [drm] radeon defaulting to userspace modesetting.
[   19.397126] pci 0000:01:00.0: power state changed by ACPI to D0
[   19.397126] pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   19.397126] pci 0000:01:00.0: setting latency timer to 64
[   19.398486] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
[   19.633904] [drm] Setting GART location based on new memory map
[   19.634272] [drm] Loading RV620 CP Microcode
[   19.634280] platform r600_cp.0: firmware: requesting radeon/RV620_pfp.bin
[   19.755855] platform r600_cp.0: firmware: requesting radeon/RV620_me.bin
[   19.802825] [drm] Resetting GPU
[   19.802948] [drm] writeback test succeeded in 1 usecs
[   34.514526] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   34.683803] CPU0 attaching NULL sched-domain.
[   34.683803] CPU1 attaching NULL sched-domain.
[   34.694007] CPU0 attaching sched-domain:
[   34.694024]  domain 0: span 0-1 level MC
[   34.694037]   groups: 0 1
[   34.694058] CPU1 attaching sched-domain:
[   34.694068]  domain 0: span 0-1 level MC
[   34.694077]   groups: 1 0
[   47.542469] NET: Registered protocol family 10
[   47.543684] lo: Disabled Privacy Extensions
[   58.821009] ATM dev 0: ADSL state: stopped
[   58.821026] ATM dev 0: ADSL line: down
[   60.354856] ATM dev 0: ADSL state: running
[   66.358184] ATM dev 0: ADSL line: attempting to activate
[   70.349698] ATM dev 0: ADSL line: training
[   72.363707] ATM dev 0: ADSL line: channel analysis
[   76.355312] ATM dev 0: ADSL line: exchange
[   77.359348] ATM dev 0: ADSL line: up (8000 kb/s down | 896 kb/s up)

---

[  342.807340] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [102697]
[  345.806433] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 0, 1) [103596]
[  345.807486] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [103597]
[  345.809983] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [103597]
[  345.809983] drivers/input/serio/i8042.c: 04 -> i8042 (kbd-data) [103597]
[  345.812024] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [103598]
[  345.877288] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 0, 1) [103618]
[  346.768071] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 0, 1) [103885]
[  346.768757] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [103885]
[  346.772050] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [103886]
[  346.772098] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [103886]
[  346.774512] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [103887]
[  346.838846] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 0, 1) [103906]
[  353.073449] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [105777]
[  353.075570] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [105777]
[  353.140642] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [105797]
[  353.144570] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [105798]
[  353.506119] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [105906]
[  353.507457] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [105907]
[  353.574572] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [105927]
[  353.578422] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [105928]
[  353.922984] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106031]
[  353.925076] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [106032]
[  353.992586] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106052]
[  353.996634] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [106053]
[  354.333348] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106155]
[  354.335208] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [106155]
[  354.402696] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106175]
[  354.405981] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [106176]
[  354.814692] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106299]
[  354.817166] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [106300]
[  354.882913] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106319]
[  354.886753] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [106321]
[  355.267137] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106435]
[  355.268471] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [106435]
[  355.336481] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [106455]
[  355.340152] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [106457]
[  356.140334] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [106697]
[  385.521319] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [115511]
[  386.568389] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115825]
[  386.571021] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115826]
[  386.572450] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 1, 12) [115826]
[  386.575434] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115827]
[  386.576947] drivers/input/serio/i8042.c: e3 <- i8042 (interrupt, 1, 12) [115828]
[  386.578449] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 1, 12) [115828]
[  386.581177] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115829]
[  386.582933] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115829]
[  386.584399] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [115830]
[  386.586190] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115830]
[  386.587685] drivers/input/serio/i8042.c: d2 <- i8042 (interrupt, 1, 12) [115831]
[  386.589135] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 1, 12) [115831]
[  386.592660] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115832]
[  386.594193] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115833]
[  386.595780] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 1, 12) [115833]
[  386.597217] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115834]
[  386.599963] drivers/input/serio/i8042.c: d2 <- i8042 (interrupt, 1, 12) [115834]
[  386.601509] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 1, 12) [115835]
[  386.605689] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115836]
[  386.607066] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115837]
[  386.608507] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 1, 12) [115837]
[  386.610192] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115838]
[  386.611534] drivers/input/serio/i8042.c: ad <- i8042 (interrupt, 1, 12) [115838]
[  386.612911] drivers/input/serio/i8042.c: 51 <- i8042 (interrupt, 1, 12) [115838]
[  386.617667] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115840]
[  386.619710] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115840]
[  386.621892] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115841]
[  386.623610] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115842]
[  386.625660] drivers/input/serio/i8042.c: 87 <- i8042 (interrupt, 1, 12) [115842]
[  386.627623] drivers/input/serio/i8042.c: 74 <- i8042 (interrupt, 1, 12) [115843]
[  386.629751] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115843]
[  386.631406] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115844]
[  386.632755] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115844]
[  386.634483] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115845]
[  386.636182] drivers/input/serio/i8042.c: 60 <- i8042 (interrupt, 1, 12) [115845]
[  386.638507] drivers/input/serio/i8042.c: 9b <- i8042 (interrupt, 1, 12) [115846]
[  386.642054] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115847]
[  386.643470] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 1, 12) [115848]
[  386.645269] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115848]
[  386.647237] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115849]
[  386.649905] drivers/input/serio/i8042.c: 37 <- i8042 (interrupt, 1, 12) [115849]
[  386.651751] drivers/input/serio/i8042.c: cc <- i8042 (interrupt, 1, 12) [115850]
[  386.653756] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115850]
[  386.654914] drivers/input/serio/i8042.c: bf <- i8042 (interrupt, 1, 12) [115851]
[  386.656447] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115851]
[  386.657913] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115852]
[  386.659478] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [115852]
[  386.661064] drivers/input/serio/i8042.c: 06 <- i8042 (interrupt, 1, 12) [115853]
[  386.665851] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115854]
[  386.667842] drivers/input/serio/i8042.c: be <- i8042 (interrupt, 1, 12) [115855]
[  386.670113] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115856]
[  386.672314] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115856]
[  386.673812] drivers/input/serio/i8042.c: dc <- i8042 (interrupt, 1, 12) [115857]
[  386.676041] drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 1, 12) [115857]
[  386.678751] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115858]
[  386.680435] drivers/input/serio/i8042.c: be <- i8042 (interrupt, 1, 12) [115859]
[  386.682680] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115859]
[  386.684299] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115860]
[  386.685705] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 1, 12) [115860]
[  386.687369] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115861]
[  386.689845] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115861]
[  386.691717] drivers/input/serio/i8042.c: be <- i8042 (interrupt, 1, 12) [115862]
[  386.693644] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [115863]
[  386.695110] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115863]
[  386.697064] drivers/input/serio/i8042.c: 79 <- i8042 (interrupt, 1, 12) [115864]
[  386.698579] drivers/input/serio/i8042.c: d9 <- i8042 (interrupt, 1, 12) [115864]
[  386.702257] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115865]
[  386.704097] drivers/input/serio/i8042.c: ce <- i8042 (interrupt, 1, 12) [115866]
[  386.706375] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115866]
[  386.708377] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115867]
[  386.710043] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [115868]
[  386.711430] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 1, 12) [115868]
[  386.714087] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115869]
[  386.716010] drivers/input/serio/i8042.c: ce <- i8042 (interrupt, 1, 12) [115869]
[  386.717812] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115870]
[  386.719256] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115870]
[  386.720760] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 1, 12) [115871]
[  386.723759] drivers/input/serio/i8042.c: 55 <- i8042 (interrupt, 1, 12) [115872]
[  386.726840] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115873]
[  386.728380] drivers/input/serio/i8042.c: cd <- i8042 (interrupt, 1, 12) [115873]
[  386.729931] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115873]
[  386.731482] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115874]
[  386.733423] drivers/input/serio/i8042.c: eb <- i8042 (interrupt, 1, 12) [115875]
[  386.735584] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 1, 12) [115875]
[  386.738904] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115876]
[  386.741089] drivers/input/serio/i8042.c: cd <- i8042 (interrupt, 1, 12) [115877]
[  386.743236] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115877]
[  386.745113] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115878]
[  386.747565] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [115879]
[  386.750173] drivers/input/serio/i8042.c: d5 <- i8042 (interrupt, 1, 12) [115879]
[  386.751716] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115880]
[  386.753294] drivers/input/serio/i8042.c: dd <- i8042 (interrupt, 1, 12) [115880]
[  386.755141] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115881]
[  386.756684] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115882]
[  386.758456] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 1, 12) [115882]
[  386.760098] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 1, 12) [115883]
[  386.762755] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115883]
[  386.763403] drivers/input/serio/i8042.c: dd <- i8042 (interrupt, 1, 12) [115884]
[  386.764885] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115884]
[  386.766423] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115884]
[  386.767868] drivers/input/serio/i8042.c: 70 <- i8042 (interrupt, 1, 12) [115885]
[  386.769308] drivers/input/serio/i8042.c: 53 <- i8042 (interrupt, 1, 12) [115885]
[  386.774058] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115887]
[  386.775480] drivers/input/serio/i8042.c: dd <- i8042 (interrupt, 1, 12) [115887]
[  386.777383] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115888]
[  386.779111] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115888]
[  386.780465] drivers/input/serio/i8042.c: 4c <- i8042 (interrupt, 1, 12) [115889]
[  386.782209] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 1, 12) [115889]
[  386.786154] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115890]
[  386.787993] drivers/input/serio/i8042.c: dd <- i8042 (interrupt, 1, 12) [115891]
[  386.789764] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115891]
[  386.792013] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115892]
[  386.793440] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [115893]
[  386.794912] drivers/input/serio/i8042.c: df <- i8042 (interrupt, 1, 12) [115893]
[  386.798626] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115894]
[  386.800012] drivers/input/serio/i8042.c: ed <- i8042 (interrupt, 1, 12) [115895]
[  386.802884] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115895]
[  386.804431] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115896]
[  386.806924] drivers/input/serio/i8042.c: 07 <- i8042 (interrupt, 1, 12) [115897]
[  386.808316] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 1, 12) [115897]
[  386.810854] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115898]
[  386.812427] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115898]
[  386.814687] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115899]
[  386.816681] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115900]
[  386.818615] drivers/input/serio/i8042.c: e4 <- i8042 (interrupt, 1, 12) [115900]
[  386.820054] drivers/input/serio/i8042.c: 5f <- i8042 (interrupt, 1, 12) [115901]
[  386.822653] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115901]
[  386.824256] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115902]
[  386.825637] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115902]
[  386.827168] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115903]
[  386.828581] drivers/input/serio/i8042.c: c7 <- i8042 (interrupt, 1, 12) [115903]
[  386.831380] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 1, 12) [115904]
[  386.834909] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115905]
[  386.836477] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115905]
[  386.838040] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115906]
[  386.839452] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115906]
[  386.841862] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 1, 12) [115907]
[  386.844190] drivers/input/serio/i8042.c: be <- i8042 (interrupt, 1, 12) [115908]
[  386.846798] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115909]
[  386.848175] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115909]
[  386.850267] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115910]
[  386.851744] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115910]
[  386.853119] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 1, 12) [115910]
[  386.855793] drivers/input/serio/i8042.c: db <- i8042 (interrupt, 1, 12) [115911]
[  386.859778] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115912]
[  386.861939] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115913]
[  386.863392] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115914]
[  386.864860] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115914]
[  386.866374] drivers/input/serio/i8042.c: 86 <- i8042 (interrupt, 1, 12) [115914]
[  386.867989] drivers/input/serio/i8042.c: ee <- i8042 (interrupt, 1, 12) [115915]
[  386.871838] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115916]
[  386.873186] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115916]
[  386.874812] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115917]
[  386.876480] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115917]
[  386.878762] drivers/input/serio/i8042.c: 7a <- i8042 (interrupt, 1, 12) [115918]
[  386.880915] drivers/input/serio/i8042.c: f6 <- i8042 (interrupt, 1, 12) [115919]
[  386.883947] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115920]
[  386.885734] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115920]
[  386.887680] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115921]
[  386.890493] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115922]
[  386.892006] drivers/input/serio/i8042.c: 74 <- i8042 (interrupt, 1, 12) [115922]
[  386.893387] drivers/input/serio/i8042.c: fb <- i8042 (interrupt, 1, 12) [115923]
[  386.896206] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115923]
[  386.897383] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115924]
[  386.899235] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115924]
[  386.901432] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115925]
[  386.902855] drivers/input/serio/i8042.c: 70 <- i8042 (interrupt, 1, 12) [115925]
[  386.904384] drivers/input/serio/i8042.c: fb <- i8042 (interrupt, 1, 12) [115926]
[  386.908106] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115927]
[  386.910668] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115928]
[  386.912112] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115928]
[  386.913739] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115929]
[  386.915368] drivers/input/serio/i8042.c: 70 <- i8042 (interrupt, 1, 12) [115929]
[  386.917533] drivers/input/serio/i8042.c: f7 <- i8042 (interrupt, 1, 12) [115930]
[  386.919614] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115930]
[  386.920922] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115931]
[  386.923262] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115931]
[  386.925168] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115932]
[  386.927028] drivers/input/serio/i8042.c: 73 <- i8042 (interrupt, 1, 12) [115933]
[  386.930236] drivers/input/serio/i8042.c: f0 <- i8042 (interrupt, 1, 12) [115934]
[  386.932350] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115934]
[  386.934637] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115935]
[  386.936187] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115935]
[  386.937689] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115936]
[  386.940616] drivers/input/serio/i8042.c: 73 <- i8042 (interrupt, 1, 12) [115937]
[  386.942163] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115937]
[  386.944286] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115938]
[  386.945265] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115938]
[  386.946963] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115939]
[  386.948316] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115939]
[  386.949909] drivers/input/serio/i8042.c: 76 <- i8042 (interrupt, 1, 12) [115939]
[  386.952225] drivers/input/serio/i8042.c: e6 <- i8042 (interrupt, 1, 12) [115940]
[  386.956131] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115941]
[  386.958046] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115942]
[  386.959712] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115942]
[  386.961465] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115943]
[  386.962816] drivers/input/serio/i8042.c: 7a <- i8042 (interrupt, 1, 12) [115943]
[  386.964259] drivers/input/serio/i8042.c: e2 <- i8042 (interrupt, 1, 12) [115944]
[  386.968399] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115945]
[  386.969889] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115945]
[  386.971302] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115946]
[  386.973032] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115946]
[  386.974938] drivers/input/serio/i8042.c: 7e <- i8042 (interrupt, 1, 12) [115947]
[  386.976582] drivers/input/serio/i8042.c: de <- i8042 (interrupt, 1, 12) [115947]
[  386.980685] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115949]
[  386.982064] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115949]
[  386.984084] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115950]
[  386.986292] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115950]
[  386.987839] drivers/input/serio/i8042.c: 82 <- i8042 (interrupt, 1, 12) [115951]
[  386.989656] drivers/input/serio/i8042.c: da <- i8042 (interrupt, 1, 12) [115951]
[  386.992427] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115952]
[  386.994178] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115953]
[  386.995909] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115953]
[  386.997988] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115954]
[  386.999508] drivers/input/serio/i8042.c: 88 <- i8042 (interrupt, 1, 12) [115954]
[  387.001435] drivers/input/serio/i8042.c: d7 <- i8042 (interrupt, 1, 12) [115955]
[  387.003999] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115956]
[  387.005610] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115956]
[  387.007715] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115957]
[  387.009314] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115957]
[  387.010693] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 1, 12) [115958]
[  387.013287] drivers/input/serio/i8042.c: d2 <- i8042 (interrupt, 1, 12) [115958]
[  387.016114] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115959]
[  387.017492] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115960]
[  387.019382] drivers/input/serio/i8042.c: 3d <- i8042 (interrupt, 1, 12) [115960]
[  387.020945] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115961]
[  387.022406] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 1, 12) [115961]
[  387.023954] drivers/input/serio/i8042.c: cc <- i8042 (interrupt, 1, 12) [115962]
[  387.027537] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115963]
[  387.029116] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115963]
[  387.030466] drivers/input/serio/i8042.c: 3e <- i8042 (interrupt, 1, 12) [115964]
[  387.033063] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115964]
[  387.034689] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 1, 12) [115965]
[  387.036216] drivers/input/serio/i8042.c: c9 <- i8042 (interrupt, 1, 12) [115965]
[  387.039838] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115966]
[  387.041208] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115967]
[  387.043395] drivers/input/serio/i8042.c: 3e <- i8042 (interrupt, 1, 12) [115968]
[  387.044813] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115968]
[  387.046238] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 1, 12) [115968]
[  387.048712] drivers/input/serio/i8042.c: c3 <- i8042 (interrupt, 1, 12) [115969]
[  387.052982] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115970]
[  387.054663] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115971]
[  387.056039] drivers/input/serio/i8042.c: 3e <- i8042 (interrupt, 1, 12) [115971]
[  387.058384] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115972]
[  387.060511] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 1, 12) [115973]
[  387.063661] drivers/input/serio/i8042.c: be <- i8042 (interrupt, 1, 12) [115973]
[  387.064477] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115974]
[  387.066817] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115975]
[  387.068271] drivers/input/serio/i8042.c: 3e <- i8042 (interrupt, 1, 12) [115975]
[  387.069716] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115975]
[  387.071590] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 1, 12) [115976]
[  387.073593] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 1, 12) [115977]
[  387.076334] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115977]
[  387.078202] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115978]
[  387.079610] drivers/input/serio/i8042.c: 3e <- i8042 (interrupt, 1, 12) [115978]
[  387.081092] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115979]
[  387.082762] drivers/input/serio/i8042.c: a9 <- i8042 (interrupt, 1, 12) [115979]
[  387.085022] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 1, 12) [115980]
[  387.089578] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115981]
[  387.090975] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115982]
[  387.092863] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [115982]
[  387.094385] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115983]
[  387.095737] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 1, 12) [115983]
[  387.097467] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 1, 12) [115984]
[  387.101286] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115985]
[  387.102668] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115985]
[  387.104076] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [115986]
[  387.106119] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115986]
[  387.108219] drivers/input/serio/i8042.c: ad <- i8042 (interrupt, 1, 12) [115987]
[  387.109582] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 1, 12) [115987]
[  387.113430] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115989]
[  387.114864] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115989]
[  387.117548] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [115990]
[  387.119038] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115990]
[  387.120460] drivers/input/serio/i8042.c: ad <- i8042 (interrupt, 1, 12) [115991]
[  387.122214] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 1, 12) [115991]
[  387.124843] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115992]
[  387.127385] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115993]
[  387.128843] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [115993]
[  387.130353] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115994]
[  387.131657] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 1, 12) [115994]
[  387.133195] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 1, 12) [115994]
[  387.137018] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115996]
[  387.138722] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [115996]
[  387.141434] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [115997]
[  387.142990] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [115997]
[  387.144459] drivers/input/serio/i8042.c: ac <- i8042 (interrupt, 1, 12) [115998]
[  387.147321] drivers/input/serio/i8042.c: b7 <- i8042 (interrupt, 1, 12) [115999]
[  387.148913] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [115999]
[  387.150541] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116000]
[  387.152086] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116000]
[  387.153736] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116001]
[  387.155038] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 1, 12) [116001]
[  387.156685] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 1, 12) [116002]
[  387.161515] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116003]
[  387.163780] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116004]
[  387.166536] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116004]
[  387.168743] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116005]
[  387.170256] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 1, 12) [116006]
[  387.172412] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 1, 12) [116006]
[  387.174767] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116007]
[  387.176368] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116007]
[  387.177919] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116008]
[  387.180112] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116009]
[  387.181458] drivers/input/serio/i8042.c: b0 <- i8042 (interrupt, 1, 12) [116009]
[  387.182863] drivers/input/serio/i8042.c: b7 <- i8042 (interrupt, 1, 12) [116009]
[  387.186723] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116011]
[  387.188457] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116011]
[  387.190919] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116012]
[  387.192935] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116012]
[  387.194764] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 1, 12) [116013]
[  387.196510] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 1, 12) [116013]
[  387.198173] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116014]
[  387.199586] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116014]
[  387.201772] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116015]
[  387.203191] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116015]
[  387.204566] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 1, 12) [116016]
[  387.206113] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 1, 12) [116016]
[  387.210440] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116018]
[  387.212040] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116018]
[  387.213573] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116019]
[  387.215591] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116019]
[  387.217170] drivers/input/serio/i8042.c: b0 <- i8042 (interrupt, 1, 12) [116020]
[  387.219065] drivers/input/serio/i8042.c: b7 <- i8042 (interrupt, 1, 12) [116020]
[  387.221683] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116021]
[  387.223191] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116021]
[  387.226102] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116022]
[  387.227819] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116023]
[  387.229223] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 1, 12) [116023]
[  387.230768] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 1, 12) [116024]
[  387.233348] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116025]
[  387.235687] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116025]
[  387.237846] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116026]
[  387.240234] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116027]
[  387.242382] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 1, 12) [116027]
[  387.244044] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 1, 12) [116028]
[  387.245765] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116028]
[  387.247239] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116029]
[  387.248965] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116029]
[  387.250904] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116030]
[  387.252458] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 1, 12) [116030]
[  387.253904] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 1, 12) [116031]
[  387.257392] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116032]
[  387.258814] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116032]
[  387.261021] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116033]
[  387.263015] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116033]
[  387.265437] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 1, 12) [116034]
[  387.268536] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 1, 12) [116035]
[  387.269805] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116035]
[  387.271527] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116036]
[  387.274567] drivers/input/serio/i8042.c: 3f <- i8042 (interrupt, 1, 12) [116037]
[  387.276300] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116037]
[  387.278540] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 1, 12) [116038]
[  387.280522] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 1, 12) [116039]
[  387.282245] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116039]
[  387.283766] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116040]
[  387.285431] drivers/input/serio/i8042.c: 3b <- i8042 (interrupt, 1, 12) [116040]
[  387.287322] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116041]
[  387.290067] drivers/input/serio/i8042.c: b0 <- i8042 (interrupt, 1, 12) [116042]
[  387.291896] drivers/input/serio/i8042.c: bb <- i8042 (interrupt, 1, 12) [116042]
[  387.293409] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116043]
[  387.295249] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116043]
[  387.296936] drivers/input/serio/i8042.c: 33 <- i8042 (interrupt, 1, 12) [116044]
[  387.298296] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116044]
[  387.299818] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 1, 12) [116044]
[  387.301249] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 1, 12) [116045]
[  387.305822] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116046]
[  387.307206] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116047]
[  387.309145] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 1, 12) [116047]
[  387.311146] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116048]
[  387.312563] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 1, 12) [116048]
[  387.314274] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 1, 12) [116049]
[  387.318062] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116050]
[  387.319434] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [116050]
[  387.320846] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 1, 12) [116051]
[  387.322740] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116051]
[  387.324895] drivers/input/serio/i8042.c: d6 <- i8042 (interrupt, 1, 12) [116052]
[  387.326383] drivers/input/serio/i8042.c: be <- i8042 (interrupt, 1, 12) [116052]
[  387.330026] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 1, 12) [116054]
[  387.331545] drivers/input/serio/i8042.c: ed <- i8042 (interrupt, 1, 12) [116054]
[  387.334324] drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 1, 12) [116055]
[  387.335821] drivers/input/serio/i8042.c: c4 <- i8042 (interrupt, 1, 12) [116055]
[  387.337188] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 1, 12) [116056]
[  387.338595] drivers/input/serio/i8042.c: c6 <- i8042 (interrupt, 1, 12) [116056]
[  387.341222] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116057]
[  387.342589] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116057]
[  387.344436] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [116058]
[  387.346758] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116059]
[  387.348609] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116059]
[  387.350446] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116060]
[  387.353622] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116061]
[  387.355565] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116061]
[  387.357043] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [116062]
[  387.358460] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116062]
[  387.360045] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116063]
[  387.362231] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116063]
[  387.366029] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116064]
[  387.367899] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116065]
[  387.369643] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116065]
[  387.371153] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116066]
[  387.374170] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116067]
[  387.375591] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116067]
[  387.378383] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116068]
[  387.379744] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116068]
[  387.381127] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116069]
[  387.383351] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116070]
[  387.385514] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116070]
[  387.387823] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116071]
[  387.389920] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116071]
[  387.391847] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116072]
[  387.393409] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116073]
[  387.394846] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116073]
[  387.397570] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116074]
[  387.399125] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116074]
[  387.402735] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116075]
[  387.403781] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116076]
[  387.405266] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116076]
[  387.406687] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116077]
[  387.408170] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116077]
[  387.409688] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116077]
[  387.414854] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116079]
[  387.416442] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116079]
[  387.417795] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116080]
[  387.419318] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116080]
[  387.422550] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116081]
[  387.423312] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116081]
[  387.425395] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116082]
[  387.427278] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116083]
[  387.428637] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116083]
[  387.430276] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116084]
[  387.433094] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116084]
[  387.434597] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116085]
[  387.438320] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116086]
[  387.439691] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116086]
[  387.441174] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116087]
[  387.442968] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116087]
[  387.444462] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116088]
[  387.446018] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116088]
[  387.449569] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116089]
[  387.452173] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116090]
[  387.453967] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116091]
[  387.455967] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116091]
[  387.457381] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116092]
[  387.459389] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [116092]
[  387.462123] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116093]
[  387.463662] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116094]
[  387.466386] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116094]
[  387.468276] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116095]
[  387.470266] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116096]
[  387.472440] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116096]
[  387.474036] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116097]
[  387.475489] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116097]
[  387.477044] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116098]
[  387.478540] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116098]
[  387.480141] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116099]
[  387.481997] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116099]
[  387.486378] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116100]
[  387.488251] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116101]
[  387.489616] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116101]
[  387.491378] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116102]
[  387.493094] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116102]
[  387.495872] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116103]
[  387.498645] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116104]
[  387.500114] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116105]
[  387.502148] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116105]
[  387.503683] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116106]
[  387.505096] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116106]
[  387.506715] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116107]
[  387.511388] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116108]
[  387.513069] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116108]
[  387.514442] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116109]
[  387.515994] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116109]
[  387.517825] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116110]
[  387.520871] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116111]
[  387.522383] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116111]
[  387.523759] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116112]
[  387.526490] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116112]
[  387.528278] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116113]
[  387.529776] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116113]
[  387.531621] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116114]
[  387.534124] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116115]
[  387.535541] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116115]
[  387.537699] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116116]
[  387.539196] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116116]
[  387.541051] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116117]
[  387.542545] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116117]
[  387.547104] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116119]
[  387.548512] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116119]
[  387.550377] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116120]
[  387.552068] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116120]
[  387.554302] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116121]
[  387.556246] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116121]
[  387.559388] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116122]
[  387.561050] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116123]
[  387.562993] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116123]
[  387.565772] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116124]
[  387.567546] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116125]
[  387.569017] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116125]
[  387.572078] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116126]
[  387.573595] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116127]
[  387.575145] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116127]
[  387.577392] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116128]
[  387.578794] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116128]
[  387.580495] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116129]
[  387.583351] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116130]
[  387.585051] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116130]
[  387.587085] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116131]
[  387.588463] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116131]
[  387.590271] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116132]
[  387.591748] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116132]
[  387.595442] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116133]
[  387.597392] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116134]
[  387.598744] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116134]
[  387.600477] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116135]
[  387.602123] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116135]
[  387.603688] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116136]
[  387.607237] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116137]
[  387.609970] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116137]
[  387.611477] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116138]
[  387.612945] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116138]
[  387.614392] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116139]
[  387.616516] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116139]
[  387.619824] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116140]
[  387.621256] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116141]
[  387.622643] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116141]
[  387.624022] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116142]
[  387.625719] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116142]
[  387.627164] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116143]
[  387.632102] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116144]
[  387.634847] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116145]
[  387.636568] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116145]
[  387.638025] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116146]
[  387.639825] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116146]
[  387.641418] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116147]
[  387.644199] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116148]
[  387.646390] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116148]
[  387.647824] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116149]
[  387.649540] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116149]
[  387.651799] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116150]
[  387.653740] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116151]
[  387.655800] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116151]
[  387.657232] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116152]
[  387.658924] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116152]
[  387.660469] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116153]
[  387.662678] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116153]
[  387.664089] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116154]
[  387.667626] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116155]
[  387.669152] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116155]
[  387.671100] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116156]
[  387.672569] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116156]
[  387.674393] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116157]
[  387.675929] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116157]
[  387.679980] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116158]
[  387.681821] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116159]
[  387.683665] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116160]
[  387.685774] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116160]
[  387.687184] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116161]
[  387.688721] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116161]
[  387.692263] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116162]
[  387.694246] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116163]
[  387.695975] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116163]
[  387.698156] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116164]
[  387.699519] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116164]
[  387.701108] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116165]
[  387.703945] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116166]
[  387.705389] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116166]
[  387.707026] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116167]
[  387.708668] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116167]
[  387.710339] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116168]
[  387.711677] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116168]
[  387.716442] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116169]
[  387.718185] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116170]
[  387.720388] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116171]
[  387.721852] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116171]
[  387.723425] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116172]
[  387.725725] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116172]
[  387.728603] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116173]
[  387.730776] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116174]
[  387.732696] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116174]
[  387.734780] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116175]
[  387.737475] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116176]
[  387.738969] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116176]
[  387.740889] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116177]
[  387.742317] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116177]
[  387.744016] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116178]
[  387.745360] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116178]
[  387.748326] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116179]
[  387.749767] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116179]
[  387.752580] drivers/input/serio/i8042.c: 81 <- i8042 (interrupt, 1, 12) [116180]
[  387.753955] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116181]
[  387.755387] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116181]
[  387.757874] drivers/input/serio/i8042.c: c1 <- i8042 (interrupt, 1, 12) [116182]
[  387.759313] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116182]
[  387.760649] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116183]
[  387.764247] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116184]
[  387.767174] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116185]
[  387.768619] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116185]
[  387.770309] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116186]
[  387.771752] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116186]
[  387.773332] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116187]
[  387.776479] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116187]
[  387.777574] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116188]
[  387.780398] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116188]
[  387.781267] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116189]
[  387.783312] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116189]
[  387.784452] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116190]
[  387.788406] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116191]
[  387.790521] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116192]
[  387.793725] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116192]
[  387.795179] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116193]
[  387.797059] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116193]
[  387.799821] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116194]
[  387.802514] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116195]
[  387.803332] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116195]
[  387.805177] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116196]
[  387.808040] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116197]
[  387.810006] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116197]
[  387.810853] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116198]
[  387.813322] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116198]
[  387.816348] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116199]
[  387.817357] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116200]
[  387.819391] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116200]
[  387.821766] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116201]
[  387.822992] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116201]
[  387.824450] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116202]
[  387.826256] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116202]
[  387.827965] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116203]
[  387.830240] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116204]
[  387.832191] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116204]
[  387.833890] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116205]
[  387.836632] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116205]
[  387.838457] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116206]
[  387.841253] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116207]
[  387.842655] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116207]
[  387.844067] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116208]
[  387.846957] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116209]
[  387.848973] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116209]
[  387.850505] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116210]
[  387.852795] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116210]
[  387.854295] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116211]
[  387.856381] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116211]
[  387.857782] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116212]
[  387.861605] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116213]
[  387.863903] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116214]
[  387.866121] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116214]
[  387.867877] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116215]
[  387.869250] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116215]
[  387.870753] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116216]
[  387.873221] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116216]
[  387.874579] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116217]
[  387.876247] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116217]
[  387.877626] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116218]
[  387.879345] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116218]
[  387.881111] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116219]
[  387.885904] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116220]
[  387.887425] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116221]
[  387.888775] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116221]
[  387.890356] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116222]
[  387.892392] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116222]
[  387.893938] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116223]
[  387.897677] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116224]
[  387.899194] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116224]
[  387.900548] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116225]
[  387.901963] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116225]
[  387.904065] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116226]
[  387.905738] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116226]
[  387.910475] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116228]
[  387.912392] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116228]
[  387.913787] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116229]
[  387.915622] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116229]
[  387.917214] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116230]
[  387.918694] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116230]
[  387.922484] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116231]
[  387.925591] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116232]
[  387.927359] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116233]
[  387.929809] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116233]
[  387.931657] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116234]
[  387.934727] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116235]
[  387.936392] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116235]
[  387.938103] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116236]
[  387.939923] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116236]
[  387.941397] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116237]
[  387.943074] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116237]
[  387.944927] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116238]
[  387.946521] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116238]
[  387.948003] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116239]
[  387.950254] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116240]
[  387.952227] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116240]
[  387.954778] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116241]
[  387.957113] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116242]
[  387.959151] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116242]
[  387.960852] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116243]
[  387.962950] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116243]
[  387.964526] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116244]
[  387.966076] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116244]
[  387.968677] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116245]
[  387.970551] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116246]
[  387.971951] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116246]
[  387.974877] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116247]
[  387.976448] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116247]
[  387.979079] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116248]
[  387.980497] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116249]
[  387.982280] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116249]
[  387.984324] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116250]
[  387.985825] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116250]
[  387.987782] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116251]
[  387.990005] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116252]
[  387.992204] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116252]
[  387.993848] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116253]
[  387.995403] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116253]
[  387.997599] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116254]
[  387.998996] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116254]
[  388.000393] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116255]
[  388.002306] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116255]
[  388.006026] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116256]
[  388.007423] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116257]
[  388.009049] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116257]
[  388.010601] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116258]
[  388.012024] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116258]
[  388.013867] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116259]
[  388.018828] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116260]
[  388.020241] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116261]
[  388.021573] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116261]
[  388.023492] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116262]
[  388.025390] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116262]
[  388.028053] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116263]
[  388.029578] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116263]
[  388.031179] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116264]
[  388.034111] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116265]
[  388.035573] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116265]
[  388.037073] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116266]
[  388.038572] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116266]
[  388.042079] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116267]
[  388.043664] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116268]
[  388.045930] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116268]
[  388.047979] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116269]
[  388.049925] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116269]
[  388.051856] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116270]
[  388.054318] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116271]
[  388.055747] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116271]
[  388.057502] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116272]
[  388.058925] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116272]
[  388.060654] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116273]
[  388.063710] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116274]
[  388.066315] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116274]
[  388.067826] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116275]
[  388.069330] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116275]
[  388.070709] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116276]
[  388.073254] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116276]
[  388.075502] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116277]
[  388.078005] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116278]
[  388.079419] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116278]
[  388.082578] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116279]
[  388.084399] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116280]
[  388.087164] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116281]
[  388.088675] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116281]
[  388.091230] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116282]
[  388.093280] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116282]
[  388.095006] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116283]
[  388.097399] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116284]
[  388.098874] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116284]
[  388.100579] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116285]
[  388.103101] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116285]
[  388.104456] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116286]
[  388.106000] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116286]
[  388.108340] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116287]
[  388.110532] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116288]
[  388.112026] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116288]
[  388.114680] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116289]
[  388.116548] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116289]
[  388.118342] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116290]
[  388.119877] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116290]
[  388.121726] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116291]
[  388.123256] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116291]
[  388.127287] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116293]
[  388.128674] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116293]
[  388.130060] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116294]
[  388.132058] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116294]
[  388.133582] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116295]
[  388.134881] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116295]
[  388.138608] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116296]
[  388.141400] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116297]
[  388.143128] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116297]
[  388.145425] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116298]
[  388.147452] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116299]
[  388.149177] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116299]
[  388.151284] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116300]
[  388.152680] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116300]
[  388.154261] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116301]
[  388.156971] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116302]
[  388.158556] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116302]
[  388.160045] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116303]
[  388.163538] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116304]
[  388.164952] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116304]
[  388.166625] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116304]
[  388.168109] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116305]
[  388.169524] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116305]
[  388.171231] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116306]
[  388.175017] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116307]
[  388.177064] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116308]
[  388.179004] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116308]
[  388.181132] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116309]
[  388.182499] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116309]
[  388.184509] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116310]
[  388.186991] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116311]
[  388.188751] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116311]
[  388.191732] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116312]
[  388.193278] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116312]
[  388.194681] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116313]
[  388.196158] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116313]
[  388.201112] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116315]
[  388.203459] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116316]
[  388.205389] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116316]
[  388.207163] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116317]
[  388.208576] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116317]
[  388.210451] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116318]
[  388.212305] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116318]
[  388.214983] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116319]
[  388.216673] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116320]
[  388.218155] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116320]
[  388.221101] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116321]
[  388.222603] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116321]
[  388.224155] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116322]
[  388.225623] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116322]
[  388.227173] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116323]
[  388.228580] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116323]
[  388.230612] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116324]
[  388.232927] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116324]
[  388.235740] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116325]
[  388.237982] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116326]
[  388.240293] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116327]
[  388.242029] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116327]
[  388.243417] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116328]
[  388.244887] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116328]
[  388.247452] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116329]
[  388.248826] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116329]
[  388.250477] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116330]
[  388.252397] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116330]
[  388.255107] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116331]
[  388.256673] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116332]
[  388.260534] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116333]
[  388.262030] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116333]
[  388.263678] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116334]
[  388.265032] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116334]
[  388.266551] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116334]
[  388.268005] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116335]
[  388.271892] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116336]
[  388.273592] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116337]
[  388.275702] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116337]
[  388.277181] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116338]
[  388.279524] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116338]
[  388.281477] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116339]
[  388.283913] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116340]
[  388.285631] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116340]
[  388.287075] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116341]
[  388.289255] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116341]
[  388.290656] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116342]
[  388.292256] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116342]
[  388.295782] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116343]
[  388.297172] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116344]
[  388.300237] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116345]
[  388.301677] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116345]
[  388.304189] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116346]
[  388.305578] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116346]
[  388.309159] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116347]
[  388.311402] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116348]
[  388.312855] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116348]
[  388.314453] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116349]
[  388.316779] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116350]
[  388.318939] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116350]
[  388.320712] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116351]
[  388.322091] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116351]
[  388.323702] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116352]
[  388.325501] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116352]
[  388.327707] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116353]
[  388.329254] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116353]
[  388.333988] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116355]
[  388.335398] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116355]
[  388.337150] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116356]
[  388.339104] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116356]
[  388.340639] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116357]
[  388.342025] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116357]
[  388.345320] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116358]
[  388.346958] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116359]
[  388.349095] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116359]
[  388.351403] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116360]
[  388.353408] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116361]
[  388.355121] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116361]
[  388.357112] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116362]
[  388.358656] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116362]
[  388.360691] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116363]
[  388.362166] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116363]
[  388.363688] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116364]
[  388.365094] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116364]
[  388.368686] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116365]
[  388.370766] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116366]
[  388.373510] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116367]
[  388.375399] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116367]
[  388.376891] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116368]
[  388.378534] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116368]
[  388.381403] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116369]
[  388.382962] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116369]
[  388.385227] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116370]
[  388.386927] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116371]
[  388.388403] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116371]
[  388.390246] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116372]
[  388.392807] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116372]
[  388.394619] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116373]
[  388.397611] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116374]
[  388.399116] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116374]
[  388.400536] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116375]
[  388.403167] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116375]
[  388.404867] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116376]
[  388.408865] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116377]
[  388.410318] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116378]
[  388.411192] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116378]
[  388.413432] drivers/input/serio/i8042.c: 4d <- i8042 (interrupt, 0, 1) [116379]
[  388.417586] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116380]
[  388.419972] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116380]
[  388.420572] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116381]
[  388.422247] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116381]
[  388.424082] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116382]
[  388.425142] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116382]
[  388.428046] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116383]
[  388.429885] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116383]
[  388.432293] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116384]
[  388.433766] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116385]
[  388.435424] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116385]
[  388.437403] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116386]
[  388.439857] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116386]
[  388.441764] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116387]
[  388.443551] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116387]
[  388.447060] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116388]
[  388.448137] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116389]
[  388.449601] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116389]
[  388.452215] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116390]
[  388.453614] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116391]
[  388.455321] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116391]
[  388.457208] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116392]
[  388.458756] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116392]
[  388.460358] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116393]
[  388.461661] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116393]
[  388.463815] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116394]
[  388.465285] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116394]
[  388.467147] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116395]
[  388.469503] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116395]
[  388.471456] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116396]
[  388.473233] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116396]
[  388.477100] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116398]
[  388.479156] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116398]
[  388.480255] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116399]
[  388.482406] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116399]
[  388.483861] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116400]
[  388.486464] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116400]
[  388.489508] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116401]
[  388.491584] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116402]
[  388.493028] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116402]
[  388.494407] drivers/input/serio/i8042.c: cd <- i8042 (interrupt, 0, 1) [116403]
[  388.496941] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116403]
[  388.497862] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116404]
[  388.500590] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116405]
[  388.502286] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116405]
[  388.503722] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116406]
[  388.506702] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116407]
[  388.508267] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116407]
[  388.509727] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116407]
[  388.511213] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116408]
[  388.512782] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116408]
[  388.514296] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116409]
[  388.516125] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116409]
[  388.517651] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116410]
[  388.519036] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116410]
[  388.520989] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116411]
[  388.522600] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116411]
[  388.525445] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116412]
[  388.526971] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116413]
[  388.528426] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116413]
[  388.530088] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116414]
[  388.531609] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116414]
[  388.533008] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116414]
[  388.534407] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116415]
[  388.536259] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116415]
[  388.537850] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116416]
[  388.539255] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116416]
[  388.541539] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116417]
[  388.543803] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116418]
[  388.545399] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116418]
[  388.547017] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116419]
[  388.550219] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116420]
[  388.551886] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116420]
[  388.554961] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116421]
[  388.556427] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116421]
[  388.557893] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116422]
[  388.560565] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116423]
[  388.562329] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116423]
[  388.563888] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116424]
[  388.565660] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116424]
[  388.567225] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116425]
[  388.568655] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116425]
[  388.570008] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116426]
[  388.574813] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116427]
[  388.576390] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116427]
[  388.578219] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116428]
[  388.580158] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116429]
[  388.582044] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116429]
[  388.583553] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116430]
[  388.585191] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116430]
[  388.586680] drivers/input/serio/i8042.c: 4d <- i8042 (interrupt, 0, 1) [116431]
[  388.590386] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116431]
[  388.592046] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116432]
[  388.594550] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116433]
[  388.596316] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116433]
[  388.597691] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116434]
[  388.599199] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116434]
[  388.601025] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116435]
[  388.603255] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116435]
[  388.604810] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116436]
[  388.606323] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116436]
[  388.608958] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116437]
[  388.610392] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116437]
[  388.611893] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116438]
[  388.614646] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116439]
[  388.616400] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116439]
[  388.617996] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116440]
[  388.619936] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116440]
[  388.622175] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116441]
[  388.624408] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116442]
[  388.626403] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116442]
[  388.628843] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116443]
[  388.630468] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116444]
[  388.631888] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116444]
[  388.634041] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116445]
[  388.635666] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116445]
[  388.637767] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116446]
[  388.639661] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116446]
[  388.641207] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116447]
[  388.644301] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116448]
[  388.646583] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116448]
[  388.647406] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116449]
[  388.649045] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116449]
[  388.650995] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116450]
[  388.652515] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116450]
[  388.655614] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116451]
[  388.657240] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116452]
[  388.659120] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116452]
[  388.660259] drivers/input/serio/i8042.c: cd <- i8042 (interrupt, 0, 1) [116453]
[  388.662414] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116453]
[  388.664194] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116454]
[  388.665713] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116454]
[  388.667412] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116455]
[  388.668738] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116455]
[  388.670300] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116456]
[  388.673357] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116457]
[  388.675195] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116457]
[  388.677871] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116458]
[  388.679669] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116458]
[  388.681061] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116459]
[  388.684112] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116460]
[  388.685685] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116460]
[  388.688202] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116461]
[  388.689589] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116461]
[  388.691041] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116462]
[  388.693230] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116462]
[  388.695486] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116463]
[  388.697845] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116464]
[  388.699869] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116464]
[  388.701205] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116465]
[  388.702937] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116465]
[  388.704461] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116466]
[  388.706793] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116467]
[  388.708846] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116467]
[  388.710795] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116468]
[  388.712971] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116468]
[  388.714413] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116469]
[  388.715968] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116469]
[  388.717820] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116470]
[  388.719890] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [116470]
[  388.721409] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116471]
[  388.723198] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116471]
[  388.725460] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [116472]
[  388.727391] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116473]
[  388.729117] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [116473]
[  388.836521] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116505]
[  388.838412] drivers/input/serio/i8042.c: 4d <- i8042 (interrupt, 0, 1) [116506]
[  388.975554] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116547]
[  388.979435] drivers/input/serio/i8042.c: cd <- i8042 (interrupt, 0, 1) [116548]
[  389.148809] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116599]
[  389.151543] drivers/input/serio/i8042.c: 4d <- i8042 (interrupt, 0, 1) [116600]
[  389.254375] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116631]
[  389.256657] drivers/input/serio/i8042.c: cd <- i8042 (interrupt, 0, 1) [116631]
[  389.553832] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116721]
[  389.556305] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [116721]
[  389.620443] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116741]
[  389.624060] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [116742]
[  389.724128] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116772]
[  389.726685] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [116773]
[  389.792223] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116792]
[  389.796297] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [116793]
[  389.875428] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116817]
[  389.877190] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [116818]
[  389.944444] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116838]
[  389.948355] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [116839]
[  390.024542] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116862]
[  390.026426] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [116862]
[  390.092950] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [116882]
[  390.096507] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [116883]
[  390.400189] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [116975]
[  390.469978] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [116995]
[  390.732805] CPU0 attaching NULL sched-domain.
[  390.732822] CPU1 attaching NULL sched-domain.
[  390.742086] CPU0 attaching sched-domain:
[  390.742086]  domain 0: span 0-1 level MC
[  390.742086]   groups: 0 1
[  390.742086] CPU1 attaching sched-domain:
[  390.742086]  domain 0: span 0-1 level MC
[  390.742086]   groups: 1 0
[  391.870387] [drm] Resetting GPU
[  391.879554] PM: Syncing filesystems ... done.
[  392.322721] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  392.324082] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  392.324082] Suspending console(s) (use no_console_suspend to debug)
[  392.390327] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  392.390473] sd 2:0:0:0: [sda] Stopping disk
[  393.273861] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117837]
[  393.275079] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [117837]
[  393.279355] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117838]
[  393.279390] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117838]
[  393.281846] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [117838]
[  393.284928] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117840]
[  393.284958] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117840]
[  393.287586] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [117840]
[  393.291302] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117842]
[  393.291327] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117842]
[  393.293753] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [117842]
[  393.297300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117844]
[  393.297325] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117844]
[  393.300617] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [117844]
[  393.303325] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117846]
[  393.303350] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117846]
[  393.306047] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [117846]
[  393.308800] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117847]
[  393.308826] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117847]
[  393.310737] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [117847]
[  393.313579] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117849]
[  393.313604] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117849]
[  393.315611] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [117849]
[  393.318613] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117850]
[  393.318638] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117850]
[  393.321715] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [117850]
[  393.323968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117852]
[  393.323993] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117852]
[  393.327041] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [117852]
[  393.329134] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117853]
[  393.329160] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117853]
[  393.331355] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [117853]
[  393.335341] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117855]
[  393.335365] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117855]
[  393.337374] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [117855]
[  393.340968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117857]
[  393.340995] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117857]
[  393.342388] drivers/input/serio/i8042.c: ff -> i8042 (parameter) [117857]
[  393.346420] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117858]
[  393.685014] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 1, 12) [117960]
[  393.685788] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [117960]
[  393.685813] drivers/input/serio/i8042.c: d4 -> i8042 (command) [117960]
[  393.688560] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [117960]
[  393.692143] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [117962]
[  393.692182] drivers/input/serio/i8042.c: ff -> i8042 (kbd-data) [117962]
[  393.694311] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [117963]
[  393.695404] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [117963]
[  393.793372] drivers/input/serio/i8042.c: 60 -> i8042 (command) [117993]
[  393.794072] drivers/input/serio/i8042.c: 7c -> i8042 (parameter) [117993]
[  393.796654] drivers/input/serio/i8042.c: 60 -> i8042 (command) [117993]
[  393.796654] drivers/input/serio/i8042.c: 6f -> i8042 (parameter) [117993]
[  393.796654] jmb38x_ms 0000:0a:00.3: PCI INT A disabled
[  393.806688] __ratelimit: 3 callbacks suppressed
[  393.806695] jmb38x_ms 0000:0a:00.3: Refused to change power state, currently in D3
[  393.809987] mmc0: Reset 0x1 never completed.
[  393.809987] sdhci: ============== REGISTER DUMP ==============
[  393.809987] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  393.809987] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  393.809987] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  393.809987] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  393.809987] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  393.809987] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  393.809987] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  393.809987] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  393.809987] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  393.809987] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  393.809987] sdhci: ===========================================
[  393.907185] sdhci-pci 0000:0a:00.1: PCI INT A disabled
[  393.920023] sdhci-pci 0000:0a:00.1: Refused to change power state, currently in D3
[  393.920031] ieee1394: hpsb_bus_reset called while bus reset already in progress
[  393.923322] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  394.027057] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  394.236672] ohci1394 0000:0a:00.0: Refused to change power state, currently in D3
[  394.236818] ath5k 0000:08:00.0: PCI INT A disabled
[  394.250068] HDA Intel 0000:01:00.1: PCI INT B disabled
[  394.250157] ACPI handle has no context!
[  394.263339] pci 0000:01:00.0: PCI INT A disabled
[  394.367707] HDA Intel 0000:00:14.2: PCI INT A disabled
[  394.367787] ACPI handle has no context!
[  394.380242] ehci_hcd 0000:00:13.2: PCI INT B disabled
[  394.380263] ohci_hcd 0000:00:13.1: PCI INT A disabled
[  394.380279] ohci_hcd 0000:00:13.0: PCI INT A disabled
[  394.380297] ehci_hcd 0000:00:12.2: PCI INT B disabled
[  394.380315] ohci_hcd 0000:00:12.1: PCI INT A disabled
[  394.380334] ohci_hcd 0000:00:12.0: PCI INT A disabled
[  394.460565] ahci 0000:00:11.0: PCI INT A disabled
[  394.475332] r8169 0000:09:00.0: PME# enabled
[  394.514158] ACPI: Preparing to enter system sleep state S3
[  394.520754] Disabling non-boot CPUs ...
[  394.522767] CPU 1 is now offline
[  394.522767] SMP alternatives: switching to UP code
[  394.527372] CPU0 attaching NULL sched-domain.
[  394.527380] CPU1 attaching NULL sched-domain.
[  394.527396] CPU0 attaching NULL sched-domain.
[  394.527939] CPU1 is down
[  394.527958] Back to C!
[  394.527958] Enabling non-boot CPUs ...
[  394.537037] SMP alternatives: switching to SMP code
[  394.543339] Booting processor 1 APIC 0x1 ip 0x6000
[  394.526908] Initializing CPU#1
[  394.526908] Calibrating delay using timer specific routine.. 4191.90 BogoMIPS (lpj=6982240)
[  394.526908] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  394.526908] CPU: L2 Cache: 512K (64 bytes/line)
[  394.526908] CPU: Physical Processor ID: 0
[  394.526908] CPU: Processor Core ID: 1
[  394.633478] CPU1: AMD Athlon(tm) X2 Dual-Core QL-64 stepping 01
[  394.633568] CPU0 attaching NULL sched-domain.
[  394.640054] CPU0 attaching sched-domain:
[  394.640061]  domain 0: span 0-1 level MC
[  394.640067]   groups: 0 1
[  394.640077] CPU1 attaching sched-domain:
[  394.640081]  domain 0: span 0-1 level MC
[  394.640085]   groups: 1 0
[  394.643753] CPU1 is up
[  394.644095] ACPI: Waking up from system sleep state S3
[  394.668829] pcieport 0000:00:02.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  394.668917] pcieport 0000:00:04.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  394.668983] pcieport 0000:00:05.0: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[  394.669001] pcieport 0000:00:05.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  394.669080] pcieport 0000:00:06.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  394.669146] pcieport 0000:00:0a.0: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[  394.669164] pcieport 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  394.669336] ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300003, writing 0x2300007)
[  394.669415] ohci_hcd 0000:00:12.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00013)
[  394.680119] ehci_hcd 0000:00:12.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
[  394.680199] ohci_hcd 0000:00:13.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00013)
[  394.693444] ehci_hcd 0000:00:13.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
[  394.694139] ath5k 0000:08:00.0: restoring config space at offset 0x1 (was 0x100003, writing 0x100007)
[  394.694139] r8169 0000:09:00.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  394.706713] ohci1394 0000:0a:00.0: Refused to change power state, currently in D3
[  394.720041] sdhci-pci 0000:0a:00.1: Refused to change power state, currently in D3
[  394.733560] pci 0000:0a:00.2: Refused to change power state, currently in D3
[  394.746894] jmb38x_ms 0000:0a:00.3: Refused to change power state, currently in D3
[  394.760226] pci 0000:0a:00.4: Refused to change power state, currently in D3
[  394.786617] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  394.786927] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  394.810077] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  394.833406] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  394.833442] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  394.856737] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  394.880068] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  394.882509] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  394.976687] pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  394.976687] pci 0000:01:00.0: setting latency timer to 64
[  394.976687] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  394.976687] HDA Intel 0000:01:00.1: setting latency timer to 64
[  394.976687] HDA Intel 0000:01:00.1: irq 31 for MSI/MSI-X
[  394.976687] ath5k 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  394.976687] r8169 0000:09:00.0: PME# disabled
[  394.986732] ohci1394 0000:0a:00.0: Refused to change power state, currently in D3
[  395.106745] ata8: SATA link down (SStatus 0 SControl 300)
[  395.106800] ata5: SATA link down (SStatus 0 SControl 300)
[  395.106853] ata7: SATA link down (SStatus 0 SControl 300)
[  395.106905] ata6: SATA link down (SStatus 0 SControl 300)
[  395.143572] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  395.263360] ata4: softreset failed (device not ready)
[  395.263366] ata4: applying SB600 PMP SRST workaround and retrying
[  395.296667] ohci1394: fw-host0: Runaway loop while stopping context: ...
[  395.350000] ohci1394: fw-host0: Runaway loop while stopping context: ...
[  395.404893] ohci1394: fw-host0: Runaway loop while stopping context: ...
[  395.423379] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  395.460000] ohci1394: fw-host0: Runaway loop while stopping context: ...
[  395.460000] ohci1394: fw-host0: OHCI-1394 165.165 (PCI): IRQ=[18]  MMIO=[d1100000-d11007ff]  Max Packet=[65536]  IR/IT contexts=[4/4]
[  395.460000] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  395.559158] ata4.00: configured for UDMA/100
[  395.562405] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  395.662861] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  395.763312] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  395.863701] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  395.964104] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.064502] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.164890] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.265312] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.365699] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.463771] ata3: softreset failed (device not ready)
[  396.463778] ata3: applying SB600 PMP SRST workaround and retrying
[  396.466088] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.566478] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.666865] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.767127] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  396.767253] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.867655] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  396.968204] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.068561] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.168982] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.266111] ata3.00: configured for UDMA/100
[  397.269399] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.369811] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.470232] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.570618] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.671006] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.771525] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.872142] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  397.972561] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  398.073080] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  398.173531] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  398.273952] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  398.374372] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  398.471545] ohci1394: fw-host0: Serial EEPROM has suspicious values, attempting to set max_packet_size to 512 bytes
[  398.474858] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
[  398.583611] sdhci-pci 0000:0a:00.1: Refused to change power state, currently in D3
[  398.596733] sdhci-pci 0000:0a:00.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  398.697496] mmc0: Reset 0x1 never completed.
[  398.697499] sdhci: ============== REGISTER DUMP ==============
[  398.697507] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.697514] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.697519] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.697525] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.697530] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.697535] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.697541] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.697546] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.697551] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.697557] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.697560] sdhci: ===========================================
[  398.723390] jmb38x_ms 0000:0a:00.3: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  398.723675] drivers/input/serio/i8042.c: 60 -> i8042 (command) [119472]
[  398.724717] drivers/input/serio/i8042.c: 7c -> i8042 (parameter) [119472]
[  398.726275] drivers/input/serio/i8042.c: 60 -> i8042 (command) [119472]
[  398.726686] drivers/input/serio/i8042.c: 5e -> i8042 (parameter) [119472]
[  398.726686] drivers/input/serio/i8042.c: 60 -> i8042 (command) [119472]
[  398.726686] drivers/input/serio/i8042.c: 4f -> i8042 (parameter) [119472]
[  398.730491] sd 2:0:0:0: [sda] Starting disk
[  398.731963] mmc0: Controller never released inhibit bit(s).
[  398.731963] sdhci: ============== REGISTER DUMP ==============
[  398.731963] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.731963] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.731963] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.731963] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.731963] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.731963] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.731963] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.731963] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.731963] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.731963] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.731963] sdhci: ===========================================
[  398.743089] mmc0: Reset 0x2 never completed.
[  398.743089] sdhci: ============== REGISTER DUMP ==============
[  398.743089] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.743089] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.743089] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.743089] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.743089] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.743089] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.743089] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.743089] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.743089] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.743089] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.743089] sdhci: ===========================================
[  398.743089] mmc0: Reset 0x4 never completed.
[  398.743089] sdhci: ============== REGISTER DUMP ==============
[  398.743089] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.743089] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.743089] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.743089] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.743089] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.743089] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.743089] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.743089] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.743089] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.743089] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.743089] sdhci: ===========================================
[  398.943895] mmc0: Controller never released inhibit bit(s).
[  398.943895] sdhci: ============== REGISTER DUMP ==============
[  398.943895] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.943895] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.943895] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.943895] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.943895] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.943895] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.943895] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.943895] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.943895] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.943895] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.943895] sdhci: ===========================================
[  398.956039] mmc0: Reset 0x2 never completed.
[  398.956039] sdhci: ============== REGISTER DUMP ==============
[  398.956039] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.956039] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.956039] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.956039] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.956039] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.956039] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.956039] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.956039] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.956039] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.956039] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.956039] sdhci: ===========================================
[  398.956039] mmc0: Reset 0x4 never completed.
[  398.956039] sdhci: ============== REGISTER DUMP ==============
[  398.956039] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  398.956039] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  398.956039] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  398.956039] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  398.956039] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  398.956039] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  398.956039] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  398.956039] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  398.956039] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  398.956039] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  398.956039] sdhci: ===========================================
[  399.156087] mmc0: Controller never released inhibit bit(s).
[  399.156087] sdhci: ============== REGISTER DUMP ==============
[  399.156087] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.156087] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.156087] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.156087] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.156087] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.156087] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.156087] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.156087] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.156087] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.156087] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.156087] sdhci: ===========================================
[  399.166211] mmc0: Reset 0x2 never completed.
[  399.166211] sdhci: ============== REGISTER DUMP ==============
[  399.166211] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.166211] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.166211] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.166211] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.166211] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.166211] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.166211] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.166211] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.166211] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.166211] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.166211] sdhci: ===========================================
[  399.166211] mmc0: Reset 0x4 never completed.
[  399.166211] sdhci: ============== REGISTER DUMP ==============
[  399.166211] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.166211] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.166211] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.166211] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.166211] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.166211] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.166211] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.166211] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.166211] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.166211] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.166211] sdhci: ===========================================
[  399.367026] mmc0: Controller never released inhibit bit(s).
[  399.367026] sdhci: ============== REGISTER DUMP ==============
[  399.367026] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.367026] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.367026] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.367026] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.367026] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.367026] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.367026] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.367026] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.367026] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.367026] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.367026] sdhci: ===========================================
[  399.377121] mmc0: Reset 0x2 never completed.
[  399.377121] sdhci: ============== REGISTER DUMP ==============
[  399.377121] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.377121] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.377121] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.377121] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.377121] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.377121] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.377121] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.377121] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.377121] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.377121] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.377121] sdhci: ===========================================
[  399.377121] mmc0: Reset 0x4 never completed.
[  399.377121] sdhci: ============== REGISTER DUMP ==============
[  399.377121] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.377121] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.377121] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.377121] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.377121] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.377121] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.377121] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.377121] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.377121] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.377121] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.377121] sdhci: ===========================================
[  399.577931] mmc0: Controller never released inhibit bit(s).
[  399.577931] sdhci: ============== REGISTER DUMP ==============
[  399.577931] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.577931] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.577931] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.577931] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.577931] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.577931] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.577931] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.577931] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.577931] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.577931] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.577931] sdhci: ===========================================
[  399.588045] mmc0: Reset 0x2 never completed.
[  399.588045] sdhci: ============== REGISTER DUMP ==============
[  399.588045] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.588045] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.588045] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.588045] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.588045] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.588045] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.588045] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.588045] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.588045] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.588045] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.588045] sdhci: ===========================================
[  399.588045] mmc0: Reset 0x4 never completed.
[  399.588045] sdhci: ============== REGISTER DUMP ==============
[  399.588045] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.588045] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.588045] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.588045] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.588045] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.588045] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.588045] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.588045] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.588045] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.588045] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.588045] sdhci: ===========================================
[  399.788838] mmc0: Controller never released inhibit bit(s).
[  399.788838] sdhci: ============== REGISTER DUMP ==============
[  399.788838] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.788838] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.788838] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.788838] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.788838] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.788838] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.788838] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.788838] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.788838] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.788838] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.788838] sdhci: ===========================================
[  399.798952] mmc0: Reset 0x2 never completed.
[  399.798952] sdhci: ============== REGISTER DUMP ==============
[  399.798952] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.798952] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.798952] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.798952] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.798952] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.798952] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.798952] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.798952] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.798952] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.798952] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.798952] sdhci: ===========================================
[  399.798952] mmc0: Reset 0x4 never completed.
[  399.798952] sdhci: ============== REGISTER DUMP ==============
[  399.798952] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.798952] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.798952] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.798952] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.798952] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.798952] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.798952] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.798952] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.798952] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.798952] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.798952] sdhci: ===========================================
[  399.999800] mmc0: Controller never released inhibit bit(s).
[  399.999800] sdhci: ============== REGISTER DUMP ==============
[  399.999800] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  399.999800] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  399.999800] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  399.999800] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  399.999800] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  399.999800] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  399.999800] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  399.999800] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  399.999800] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  399.999800] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  399.999800] sdhci: ===========================================
[  400.009896] mmc0: Reset 0x2 never completed.
[  400.009896] sdhci: ============== REGISTER DUMP ==============
[  400.009896] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.009896] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.009896] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.009896] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.009896] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.009896] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.009896] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.009896] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.009896] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.009896] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.009896] sdhci: ===========================================
[  400.009896] mmc0: Reset 0x4 never completed.
[  400.009896] sdhci: ============== REGISTER DUMP ==============
[  400.009896] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.009896] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.009896] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.009896] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.009896] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.009896] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.009896] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.009896] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.009896] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.009896] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.009896] sdhci: ===========================================
[  400.210149] mmc0: Controller never released inhibit bit(s).
[  400.210149] sdhci: ============== REGISTER DUMP ==============
[  400.210149] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.210149] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.210149] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.210149] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.210149] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.210149] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.210149] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.210149] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.210149] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.210149] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.210149] sdhci: ===========================================
[  400.220251] mmc0: Reset 0x2 never completed.
[  400.220251] sdhci: ============== REGISTER DUMP ==============
[  400.220251] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.220251] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.220251] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.220251] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.220251] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.220251] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.220251] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.220251] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.220251] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.220251] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.220251] sdhci: ===========================================
[  400.220251] mmc0: Reset 0x4 never completed.
[  400.220251] sdhci: ============== REGISTER DUMP ==============
[  400.220251] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.220251] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.220251] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.220251] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.220251] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.220251] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.220251] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.220251] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.220251] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.220251] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.220251] sdhci: ===========================================
[  400.420491] mmc0: Controller never released inhibit bit(s).
[  400.420491] sdhci: ============== REGISTER DUMP ==============
[  400.420491] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.420491] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.420491] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.420491] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.420491] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.420491] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.420491] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.420491] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.420491] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.420491] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.420491] sdhci: ===========================================
[  400.430590] mmc0: Reset 0x2 never completed.
[  400.430590] sdhci: ============== REGISTER DUMP ==============
[  400.430590] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.430590] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.430590] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.430590] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.430590] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.430590] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.430590] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.430590] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.430590] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.430590] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.430590] sdhci: ===========================================
[  400.430590] mmc0: Reset 0x4 never completed.
[  400.430590] sdhci: ============== REGISTER DUMP ==============
[  400.430590] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.430590] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.430590] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.430590] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.430590] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.430590] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.430590] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.430590] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.430590] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.430590] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.430590] sdhci: ===========================================
[  400.630829] mmc0: Controller never released inhibit bit(s).
[  400.630829] sdhci: ============== REGISTER DUMP ==============
[  400.630829] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.630829] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.630829] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.630829] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.630829] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.630829] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.630829] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.630829] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.630829] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.630829] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.630829] sdhci: ===========================================
[  400.640897] mmc0: Reset 0x2 never completed.
[  400.640897] sdhci: ============== REGISTER DUMP ==============
[  400.640897] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.640897] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.640897] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.640897] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.640897] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.640897] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.640897] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.640897] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.640897] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.640897] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.640897] sdhci: ===========================================
[  400.640897] mmc0: Reset 0x4 never completed.
[  400.640897] sdhci: ============== REGISTER DUMP ==============
[  400.640897] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.640897] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.640897] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.640897] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.640897] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.640897] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.640897] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.640897] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.640897] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.640897] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.640897] sdhci: ===========================================
[  400.841134] mmc0: Controller never released inhibit bit(s).
[  400.841134] sdhci: ============== REGISTER DUMP ==============
[  400.841134] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.841134] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.841134] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.841134] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.841134] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.841134] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.841134] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.841134] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.841134] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.841134] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.841134] sdhci: ===========================================
[  400.851232] mmc0: Reset 0x2 never completed.
[  400.851232] sdhci: ============== REGISTER DUMP ==============
[  400.851232] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.851232] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.851232] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.851232] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.851232] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.851232] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.851232] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.851232] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.851232] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.851232] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.851232] sdhci: ===========================================
[  400.851232] mmc0: Reset 0x4 never completed.
[  400.851232] sdhci: ============== REGISTER DUMP ==============
[  400.851232] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  400.851232] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  400.851232] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  400.851232] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  400.851232] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  400.851232] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  400.851232] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  400.851232] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  400.851232] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  400.851232] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  400.851232] sdhci: ===========================================
[  401.051448] mmc0: Reset 0x1 never completed.
[  401.051448] sdhci: ============== REGISTER DUMP ==============
[  401.051448] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[  401.051448] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[  401.051448] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[  401.051448] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[  401.051448] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[  401.051448] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[  401.051448] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[  401.051448] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[  401.051448] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[  401.051448] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[  401.051448] sdhci: ===========================================
[  401.256738] usb 1-3: reset high speed USB device using ehci_hcd and address 3
[  401.542159] ATM dev 0: ADSL state: running
[  401.542165] ATM dev 0: ADSL line: up (8000 kb/s down | 896 kb/s up)
[  401.542883] Restarting tasks ... 
[  401.543080] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [120317]
[  401.547312] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [120319]
[  401.549508] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [120319]
[  401.549975] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [120319]
[  401.554135] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [120321]
[  401.557022] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [120321]
[  401.557022] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120321]
[  401.557058] drivers/input/serio/i8042.c: ff -> i8042 (parameter) [120321]
[  401.563289] done.
[  401.563343] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120323]
[  401.899967] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 1, 12) [120424]
[  401.899967] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [120424]
[  401.899967] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120424]
[  401.899967] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120424]
[  401.906636] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120426]
[  401.906636] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120426]
[  401.906636] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120426]
[  401.913028] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120428]
[  401.913054] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120428]
[  401.913300] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120428]
[  401.916635] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120429]
[  401.916635] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120429]
[  401.916635] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120429]
[  401.923300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120431]
[  401.923300] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120431]
[  401.923300] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120431]
[  401.927884] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120433]
[  401.927904] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120433]
[  401.929863] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120433]
[  401.933301] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120434]
[  401.933301] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120434]
[  401.933301] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120434]
[  401.938829] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120436]
[  401.938846] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120436]
[  401.939967] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120436]
[  401.943899] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120438]
[  401.943924] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120438]
[  401.946635] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [120438]
[  401.956634] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120441]
[  401.956634] drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 1, 12) [120441]
[  401.957891] drivers/input/serio/i8042.c: 47 <- i8042 (interrupt, 1, 12) [120442]
[  401.959185] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 1, 12) [120442]
[  401.959210] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120442]
[  401.959968] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120442]
[  401.963960] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120444]
[  401.963983] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120444]
[  401.966635] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120444]
[  401.970559] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120446]
[  401.970576] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120446]
[  401.972536] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120446]
[  401.976241] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120447]
[  401.976267] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120447]
[  401.976635] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120447]
[  401.981627] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120449]
[  401.981646] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120449]
[  401.983302] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120449]
[  401.986634] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120450]
[  401.986634] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120450]
[  401.986634] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120450]
[  401.993300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120452]
[  401.993300] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120452]
[  401.993300] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120452]
[  401.999246] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120454]
[  401.999276] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120454]
[  401.999967] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120454]
[  402.005277] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120456]
[  402.005293] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120456]
[  402.006634] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120456]
[  402.010253] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120458]
[  402.010276] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120458]
[  402.013302] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [120458]
[  402.021279] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120461]
[  402.023300] drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 1, 12) [120461]
[  402.023522] drivers/input/serio/i8042.c: 47 <- i8042 (interrupt, 1, 12) [120462]
[  402.024974] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 1, 12) [120462]
[  402.024997] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120462]
[  402.026471] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120462]
[  402.029969] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120463]
[  402.029969] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120463]
[  402.029969] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120463]
[  402.034148] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120465]
[  402.034165] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120465]
[  402.036634] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120465]
[  402.039968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120466]
[  402.039968] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120466]
[  402.039968] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120466]
[  402.045597] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120468]
[  402.045616] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120468]
[  402.046634] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120468]
[  402.050477] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120470]
[  402.050500] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120470]
[  402.053021] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120470]
[  402.056889] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120472]
[  402.056905] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120472]
[  402.059966] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120472]
[  402.063302] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120473]
[  402.063302] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120473]
[  402.063302] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120473]
[  402.069967] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120475]
[  402.069967] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120475]
[  402.069967] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [120475]
[  402.074653] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120477]
[  402.074680] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120477]
[  402.076634] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [120477]
[  402.086057] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120480]
[  402.086634] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [120480]
[  402.088502] drivers/input/serio/i8042.c: c0 <- i8042 (interrupt, 1, 12) [120481]
[  402.089735] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 1, 12) [120481]
[  402.089760] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120481]
[  402.089968] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120481]
[  402.093301] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120482]
[  402.093301] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120482]
[  402.093301] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120482]
[  402.099577] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120484]
[  402.099596] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120484]
[  402.099967] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120484]
[  402.103590] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120486]
[  402.103613] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120486]
[  402.106515] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120486]
[  402.109968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120487]
[  402.109968] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120487]
[  402.109968] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120487]
[  402.114885] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120489]
[  402.114914] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120489]
[  402.116635] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120489]
[  402.120307] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120491]
[  402.120323] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120491]
[  402.123301] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120491]
[  402.126635] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120492]
[  402.126635] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120492]
[  402.127086] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120492]
[  402.133300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120494]
[  402.133300] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120494]
[  402.133300] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [120494]
[  402.139414] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120496]
[  402.139440] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120496]
[  402.139966] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [120496]
[  402.149035] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120499]
[  402.149967] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 1, 12) [120499]
[  402.149967] drivers/input/serio/i8042.c: 47 <- i8042 (interrupt, 1, 12) [120499]
[  402.149967] drivers/input/serio/i8042.c: 51 <- i8042 (interrupt, 1, 12) [120499]
[  402.149967] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120499]
[  402.149967] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120499]
[  402.156633] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120501]
[  402.156633] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120501]
[  402.156633] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120501]
[  402.161205] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120503]
[  402.161225] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120503]
[  402.163301] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120503]
[  402.167766] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120505]
[  402.167792] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120505]
[  402.169961] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120505]
[  402.173301] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120506]
[  402.173301] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120506]
[  402.173301] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120506]
[  402.177790] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120508]
[  402.177816] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120508]
[  402.179967] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120508]
[  402.183301] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120509]
[  402.183301] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120509]
[  402.183301] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [120509]
[  402.189966] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120511]
[  402.189966] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120511]
[  402.189966] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120511]
[  402.196634] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120513]
[  402.196634] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120513]
[  402.196634] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [120513]
[  402.203054] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120515]
[  402.203077] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120515]
[  402.203300] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [120515]
[  402.213300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120518]
[  402.214140] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 1, 12) [120519]
[  402.216635] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [120519]
[  402.216635] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [120519]
[  402.216635] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120519]
[  402.216635] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120519]
[  402.223074] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120521]
[  402.223103] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120521]
[  402.223300] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120521]
[  402.227350] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120523]
[  402.227367] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120523]
[  402.229364] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120523]
[  402.233302] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120524]
[  402.233302] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120524]
[  402.233302] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120524]
[  402.238015] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120526]
[  402.238035] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120526]
[  402.239968] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120526]
[  402.243302] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120527]
[  402.243302] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120527]
[  402.243302] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120527]
[  402.249966] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120529]
[  402.249966] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120529]
[  402.249966] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [120529]
[  402.256633] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120531]
[  402.256633] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120531]
[  402.256633] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120531]
[  402.261989] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120533]
[  402.262005] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120533]
[  402.263301] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120533]
[  402.266827] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120535]
[  402.266851] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120535]
[  402.269374] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [120535]
[  402.279967] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120538]
[  402.279967] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 1, 12) [120538]
[  402.281907] drivers/input/serio/i8042.c: 80 <- i8042 (interrupt, 1, 12) [120539]
[  402.283233] drivers/input/serio/i8042.c: 6a <- i8042 (interrupt, 1, 12) [120539]
[  402.283256] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120539]
[  402.283300] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120539]
[  402.287988] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120541]
[  402.288013] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120541]
[  402.289968] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120541]
[  402.293301] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120542]
[  402.293301] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120542]
[  402.293301] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [120542]
[  402.299966] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120544]
[  402.299966] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120544]
[  402.299966] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120544]
[  402.305549] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120546]
[  402.305567] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120546]
[  402.306634] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120546]
[  402.309968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120547]
[  402.309968] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120547]
[  402.309968] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120547]
[  402.315718] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120549]
[  402.315737] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120549]
[  402.316633] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [120549]
[  402.319968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120550]
[  402.319968] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120550]
[  402.319968] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120550]
[  402.326634] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120552]
[  402.326634] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120552]
[  402.326634] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [120552]
[  402.330993] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120554]
[  402.331017] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120554]
[  402.333301] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [120554]
[  402.338020] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120556]
[  402.338037] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120556]
[  402.339968] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [120556]
[  402.344892] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120558]
[  402.344921] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120558]
[  402.346636] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120558]
[  402.349969] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120559]
[  402.349969] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120559]
[  402.349969] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120559]
[  402.356633] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120561]
[  402.356633] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120561]
[  402.356633] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [120561]
[  402.362019] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120563]
[  402.362048] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120563]
[  402.363301] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120563]
[  402.367068] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120565]
[  402.367085] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120565]
[  402.369967] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [120565]
[  402.373765] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120567]
[  402.373788] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120567]
[  402.376634] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120567]
[  402.379968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120568]
[  402.379968] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120568]
[  402.379968] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [120568]
[  402.385184] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120570]
[  402.385213] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120570]
[  402.386634] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120570]
[  402.389968] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120571]
[  402.389968] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120571]
[  402.389968] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [120571]
[  402.396633] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120573]
[  402.396633] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120573]
[  402.396633] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [120573]
[  402.403300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120575]
[  402.403300] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120575]
[  402.403300] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [120575]
[  402.409966] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120577]
[  402.409966] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120577]
[  402.409966] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [120577]
[  402.415175] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120579]
[  402.415195] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120579]
[  402.416635] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [120579]
[  402.420572] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120581]
[  402.420594] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120581]
[  402.422906] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [120581]
[  402.426635] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120582]
[  402.426635] drivers/input/serio/i8042.c: d4 -> i8042 (command) [120582]
[  402.427088] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [120582]
[  402.433300] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [120584]
[  402.433300] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [120584]
[  402.436634] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [120585]
[  402.436634] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [120585]
[  402.439558] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [120586]
[  404.115097] CPU0 attaching NULL sched-domain.
[  404.115113] CPU1 attaching NULL sched-domain.
[  404.123447] CPU0 attaching sched-domain:
[  404.123455]  domain 0: span 0-1 level MC
[  404.123461]   groups: 0 1
[  404.123473] CPU1 attaching sched-domain:
[  404.123477]  domain 0: span 0-1 level MC
[  404.123483]   groups: 1 0
[  404.860359] [drm] Resetting GPU
[  404.963311] CPU0 attaching NULL sched-domain.
[  404.963311] CPU1 attaching NULL sched-domain.
[  404.976823] CPU0 attaching sched-domain:
[  404.976836]  domain 0: span 0-1 level MC
[  404.976842]   groups: 0 1
[  404.976856] CPU1 attaching sched-domain:
[  404.976860]  domain 0: span 0-1 level MC
[  404.976864]   groups: 1 0
[  408.409883] drivers/input/serio/i8042.c: 36 <- i8042 (interrupt, 0, 1) [122377]
[  408.478782] drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 0, 1) [122398]
[  410.203274] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 0, 1) [122915]
[  410.306657] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 0, 1) [122946]
[  410.469259] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [122995]
[  410.536739] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [123016]
[  410.624004] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [123042]
[  410.729433] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [123073]
[  410.830153] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [123104]
[  410.900386] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [123125]
[  411.028099] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [123163]
[  411.134666] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [123195]
[  411.414914] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 0, 1) [123279]
[  411.518006] drivers/input/serio/i8042.c: 88 <- i8042 (interrupt, 0, 1) [123310]
[  411.989949] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [123451]
[  412.061184] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [123473]
[  415.243300] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 0, 1) [124427]
[  415.244148] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [124428]
[  415.246583] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [124428]
[  415.246583] drivers/input/serio/i8042.c: 04 -> i8042 (kbd-data) [124428]
[  415.248114] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [124429]
[  415.312612] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 0, 1) [124448]
[  416.302459] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 0, 1) [124745]
[  416.303234] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [124745]
[  416.306659] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [124746]
[  416.306659] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [124746]
[  416.307679] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [124747]
[  416.371089] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 0, 1) [124766]
[  417.600275] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125135]
[  417.602020] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [125135]
[  417.667004] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125155]
[  417.670613] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [125156]
[  418.231384] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125324]
[  418.233732] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [125325]
[  418.299707] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125344]
[  418.303904] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [125346]
[  418.660917] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125453]
[  418.663300] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [125453]
[  418.729993] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125473]
[  418.733073] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [125474]
[  419.148158] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125599]
[  419.150588] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [125600]
[  419.219284] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [125620]
[  419.222714] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [125621]
[  419.749408] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [125779]


      
