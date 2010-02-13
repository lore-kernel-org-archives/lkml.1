Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0BMQbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:31:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab0BMQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:31:38 -0500
Message-ID: <4B76D3E7.6000904@forouher.de>
Date: Sat, 13 Feb 2010 17:31:35 +0100
From: Dariush Forouher <dariush@forouher.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Icedove/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ACPI/ata regression with hotplugging the dvd drive
Content-Type: multipart/mixed;
 boundary="------------010802030504080708070105"
X-Provags-ID: V01U2FsdGVkX19k/wsX581fKODs4K5dFUxVADW6sgNTo+kFa25
 vhULmeCyycNd+tQH72xSNeYk0q7t/IIymcwava1/AiXSyii+1x
 J5etRaILfEmuknwjIimaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010802030504080708070105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

since at least 2.6.32-rc6 inserting the dvd drive into my laptop at runtime
doesn't work anymore.

Usually (e.g. with 2.6.32) the kernel would print something like the following:

ACPI: \_SB_.PCI0.IDE1.PRI_.MAST - docking
ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
ata4: ACPI event
ata4: soft resetting link
ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D200, max UDMA/33
ata4.00: configured for UDMA/33
ata4: EH complete
scsi 3:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H D200 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 6x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg1 type 5

And then udev would go on and create the appropriate dev nodes etc.

But with current 2.6.33-rc's the freshly connected drive isn't recognized anymore.
The kernel doesn't give out any related messages and udev doesn't do anything either.

If I boot with the drive already placed in the bay, then it's recognized correctly
during start up.

Due to the total lack of kernel messages I'm kind of wondering if maybe some new
config option concerning hotplug or ACPI has been introduced between 2.6.32 and 2.6.33
which I simply forgot to enable. A diff between the old/new kernel configs doesn't
show anything suspicious, though.

The Laptop is a Dell Latitude D630.

Any ideas?

regards
Dariush

$ lspci
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)


--------------010802030504080708070105
Content-Type: text/x-log;
 name="dmesg-32.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-32.log"

[    0.000000] Linux version 2.6.32 (root@polaris) (gcc version 4.3.4 (Debian 4.3.4-6) ) #5 SMP Fri Dec 4 20:45:05 CET 2009
[    0.000000] Command line: BOOT_IMAGE=//vmlinuz-2.6.32 root=/dev/sda2 ro quiet nmi_watchdog=0 log_buf_len=1024k
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  BIOS-e820: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf65a max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  modified: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df65a000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df65a000 page 4k
[    0.000000] kernel direct mapping tables up to df65a000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
[    0.000000] ACPI: RSDP 00000000000fbb10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df65d200 00064 (v01 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: FACP 00000000df65d09c 000F4 (v04 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df65d800 06114 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df66c000 00040
[    0.000000] ACPI: HPET 00000000df65d300 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000df65d400 00068 (v01 DELL    M08     27D80B18 ASL  00000047)
[    0.000000] ACPI: ASF! 00000000df65d000 0007E (v32 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000df65d3c0 0003E (v16 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000df65d700 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000df65d49c 00176 (v01 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df65b9c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0002296f60]    TEXT DATA BSS ==> [0001000000 - 0002296f60]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [0002297000 - 00022971ec]              BRK ==> [0002297000 - 00022971ec]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #6 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df65a
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1046004
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 105 pages reserved
[    0.000000]   DMA zone: 3833 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896658 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df65a000 - 00000000df65b000
[    0.000000] PM: Registered nosave memory: 00000000df65b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880028200000 s78872 r8192 d23528 u1048576
[    0.000000] pcpu-alloc: s78872 r8192 d23528 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029771
[    0.000000] Kernel command line: BOOT_IMAGE=//vmlinuz-2.6.32 root=/dev/sda2 ro quiet nmi_watchdog=0 log_buf_len=1024k
[    0.000000] log_buf_len: 1048576
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 4030892k/4718592k available (6572k kernel code, 534576k absent, 152176k reserved, 3249k data, 452k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.194 MHz processor.
[    0.001014] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.38 BogoMIPS (lpj=2194194)
[    0.001120] Mount-cache hash table entries: 256
[    0.002558] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.002560] CPU: L2 cache: 4096K
[    0.002563] CPU: Physical Processor ID: 0
[    0.002565] CPU: Processor Core ID: 0
[    0.002567] mce: CPU supports 6 MCE banks
[    0.002574] CPU0: Thermal monitoring enabled (TM2)
[    0.002578] using mwait in idle threads.
[    0.002579] Performance Events: Core2 events, Intel PMU driver.
[    0.002591] ... version:                2
[    0.002592] ... bit width:              40
[    0.002593] ... generic registers:      2
[    0.002595] ... value mask:             000000ffffffffff
[    0.002596] ... max period:             000000007fffffff
[    0.002598] ... fixed-purpose events:   3
[    0.002599] ... event mask:             0000000700000003
[    0.002635] ACPI: Core revision 20090903
[    0.014119] Setting APIC routing to flat
[    0.015404] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025411] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.025996] lockdep: fixing up alternatives.
[    0.025996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] Calibrating delay using timer specific routine.. 4388.77 BogoMIPS (lpj=2194385)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 4096K
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.001999] CPU1: Thermal monitoring enabled (TM2)
[    0.096046] CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.096055] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.097041] Brought up 2 CPUs
[    0.097043] Total of 2 processors activated (8777.15 BogoMIPS).
[    0.097631] CPU0 attaching sched-domain:
[    0.097636]  domain 0: span 0-1 level MC
[    0.097638]   groups: 0 1
[    0.097659] CPU1 attaching sched-domain:
[    0.097661]  domain 0: span 0-1 level MC
[    0.097664]   groups: 1 0
[    0.098167] devtmpfs: initialized
[    0.099180] NET: Registered protocol family 16
[    0.100075] ACPI: bus type pci registered
[    0.100090] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.100090] PCI: MCFG area at f8000000 reserved in E820
[    0.105490] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.105492] PCI: Using configuration type 1 for base access
[    0.117069] bio: create slab <bio-0> at 0
[    0.119848] ACPI: EC: Look up EC in DSDT
[    0.120143] ACPI: BIOS _OSI(Linux) query ignored
[    0.161727] ACPI: SSDT 00000000df66c080 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.180781] ACPI: Interpreter enabled
[    0.180785] ACPI: (supports S0 S3 S4 S5)
[    0.183371] ACPI: Using IOAPIC for interrupt routing
[    0.293348] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.312586] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.312697] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6e00000-0xf6efffff]
[    0.312697] pci 0000:00:02.0: reg 18 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.312697] pci 0000:00:02.0: reg 20 io port: [0xeff8-0xefff]
[    0.312963] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6f00000-0xf6ffffff]
[    0.313133] pci 0000:00:1a.0: reg 20 io port: [0x6f20-0x6f3f]
[    0.313216] pci 0000:00:1a.1: reg 20 io port: [0x6f00-0x6f1f]
[    0.313311] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.313392] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.313399] pci 0000:00:1a.7: PME# disabled
[    0.313468] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6dfc000-0xf6dfffff]
[    0.313547] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.313553] pci 0000:00:1b.0: PME# disabled
[    0.313671] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.313677] pci 0000:00:1c.0: PME# disabled
[    0.313798] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.313804] pci 0000:00:1c.1: PME# disabled
[    0.313933] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.313939] pci 0000:00:1c.5: PME# disabled
[    0.314024] pci 0000:00:1d.0: reg 20 io port: [0x6f80-0x6f9f]
[    0.314107] pci 0000:00:1d.1: reg 20 io port: [0x6f60-0x6f7f]
[    0.314191] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.314283] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.314364] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.314371] pci 0000:00:1d.7: PME# disabled
[    0.314590] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.314595] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
[    0.314600] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.314607] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.314676] pci 0000:00:1f.1: reg 10 io port: [0x1f0-0x1f7]
[    0.314685] pci 0000:00:1f.1: reg 14 io port: [0x3f4-0x3f7]
[    0.314695] pci 0000:00:1f.1: reg 18 io port: [0x170-0x177]
[    0.314704] pci 0000:00:1f.1: reg 1c io port: [0x374-0x377]
[    0.314713] pci 0000:00:1f.1: reg 20 io port: [0x6fa0-0x6faf]
[    0.314808] pci 0000:00:1f.2: reg 10 io port: [0x6eb0-0x6eb7]
[    0.314817] pci 0000:00:1f.2: reg 14 io port: [0x6eb8-0x6ebb]
[    0.314827] pci 0000:00:1f.2: reg 18 io port: [0x6ec0-0x6ec7]
[    0.314836] pci 0000:00:1f.2: reg 1c io port: [0x6ec8-0x6ecb]
[    0.314845] pci 0000:00:1f.2: reg 20 io port: [0x6ee0-0x6eff]
[    0.314855] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf6dfb800-0xf6dfbfff]
[    0.314909] pci 0000:00:1f.2: PME# supported from D3hot
[    0.314915] pci 0000:00:1f.2: PME# disabled
[    0.314960] pci 0000:00:1f.3: reg 10 32bit mmio: [0xf6dfb700-0xf6dfb7ff]
[    0.314992] pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]
[    0.315326] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf6cfe000-0xf6cfffff]
[    0.315525] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.315545] pci 0000:0c:00.0: PME# disabled
[    0.315683] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6c00000-0xf6cfffff]
[    0.315799] pci 0000:09:00.0: reg 10 64bit mmio: [0xf6bf0000-0xf6bfffff]
[    0.315926] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.315933] pci 0000:09:00.0: PME# disabled
[    0.316050] pci 0000:00:1c.5: bridge 32bit mmio: [0xf6b00000-0xf6bfffff]
[    0.316164] pci 0000:00:1e.0: transparent bridge
[    0.316212] pci_bus 0000:00: on NUMA node 0
[    0.316218] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.316708] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.317019] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.317134] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.317270] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.343043] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.343231] ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
[    0.343414] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    0.343571] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0, disabled.
[    0.343754] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.343939] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.344131] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    0.344296] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.344416] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.344448] vgaarb: loaded
[    0.345054] SCSI subsystem initialized
[    0.345054] libata version 3.00 loaded.
[    0.345057] usbcore: registered new interface driver usbfs
[    0.345057] usbcore: registered new interface driver hub
[    0.345057] usbcore: registered new device driver usb
[    0.346055] PCI: Using ACPI for IRQ routing
[    0.346253] Bluetooth: Core ver 2.15
[    0.346253] NET: Registered protocol family 31
[    0.346253] Bluetooth: HCI device and connection manager initialized
[    0.346253] Bluetooth: HCI socket layer initialized
[    0.347120] cfg80211: Calling CRDA to update world regulatory domain
[    0.347215] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.347215] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.350085] Switching to clocksource tsc
[    0.350248] pnp: PnP ACPI init
[    0.350281] ACPI: bus type pnp registered
[    0.418525] pnp 00:0b: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.418528] pnp 00:0b: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.418764] pnp 00:0c: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.418768] pnp 00:0c: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.418771] pnp 00:0c: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.418779] pnp 00:0c: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.445061] pnp: PnP ACPI: found 14 devices
[    0.445064] ACPI: ACPI bus type pnp unregistered
[    0.445081] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.445085] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.445097] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.445108] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.445113] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.445123] system 00:0b: ioport range 0x900-0x97f has been reserved
[    0.445126] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.445136] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.445139] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.445142] system 00:0c: ioport range 0x10c0-0x10df has been reserved
[    0.445145] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.445155] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.445159] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.445162] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.445164] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.445168] system 00:0d: iomem range 0x100000-0xdf65a7ff could not be reserved
[    0.445170] system 00:0d: iomem range 0xdf65a800-0xdf6fffff has been reserved
[    0.445173] system 00:0d: iomem range 0xdf700000-0xdf7fffff has been reserved
[    0.445177] system 00:0d: iomem range 0xdf700000-0xdfefffff could not be reserved
[    0.445180] system 00:0d: iomem range 0xffe00000-0xffffffff has been reserved
[    0.445183] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.445186] system 00:0d: iomem range 0xfec00000-0xfec0ffff could not be reserved
[    0.445189] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.445192] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.445195] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.445198] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.445201] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.445204] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.445207] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.445210] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.445213] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.450670] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.450674] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.450682] pci 0000:00:1c.0:   MEM window: 0xf0000000-0xf01fffff
[    0.450688] pci 0000:00:1c.0:   PREFETCH window: 0x000000f0200000-0x000000f03fffff
[    0.450698] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.450702] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
[    0.450709] pci 0000:00:1c.1:   MEM window: 0xf6c00000-0xf6cfffff
[    0.450715] pci 0000:00:1c.1:   PREFETCH window: 0x000000f0400000-0x000000f05fffff
[    0.450725] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:09
[    0.450729] pci 0000:00:1c.5:   IO window: 0x4000-0x4fff
[    0.450736] pci 0000:00:1c.5:   MEM window: 0xf6b00000-0xf6bfffff
[    0.450742] pci 0000:00:1c.5:   PREFETCH window: 0x000000f0600000-0x000000f07fffff
[    0.450751] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.450753] pci 0000:00:1e.0:   IO window: disabled
[    0.450760] pci 0000:00:1e.0:   MEM window: disabled
[    0.450765] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.450791] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.450798] pci 0000:00:1c.0: setting latency timer to 64
[    0.450812] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.450818] pci 0000:00:1c.1: setting latency timer to 64
[    0.450831] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.450837] pci 0000:00:1c.5: setting latency timer to 64
[    0.450847] pci 0000:00:1e.0: setting latency timer to 64
[    0.450852] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.450854] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.450857] pci_bus 0000:0b: resource 0 io:  [0x2000-0x2fff]
[    0.450859] pci_bus 0000:0b: resource 1 mem: [0xf0000000-0xf01fffff]
[    0.450861] pci_bus 0000:0b: resource 2 pref mem [0xf0200000-0xf03fffff]
[    0.450863] pci_bus 0000:0c: resource 0 io:  [0x3000-0x3fff]
[    0.450866] pci_bus 0000:0c: resource 1 mem: [0xf6c00000-0xf6cfffff]
[    0.450868] pci_bus 0000:0c: resource 2 pref mem [0xf0400000-0xf05fffff]
[    0.450870] pci_bus 0000:09: resource 0 io:  [0x4000-0x4fff]
[    0.450872] pci_bus 0000:09: resource 1 mem: [0xf6b00000-0xf6bfffff]
[    0.450874] pci_bus 0000:09: resource 2 pref mem [0xf0600000-0xf07fffff]
[    0.450877] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.450879] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.450940] NET: Registered protocol family 2
[    0.451158] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.452052] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.453768] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.459176] TCP: Hash tables configured (established 262144 bind 65536)
[    0.459230] TCP reno registered
[    0.459453] NET: Registered protocol family 1
[    0.459716] RPC: Registered udp transport module.
[    0.459718] RPC: Registered tcp transport module.
[    0.459720] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.459739] pci 0000:00:02.0: Boot video device
[    0.461288] Scanning for low memory corruption every 60 seconds
[    0.461667] Intel AES-NI instructions are not detected.
[    0.469273] Slow work thread pool: Starting up
[    0.469361] Slow work thread pool: Ready
[    0.469363] NTFS driver 2.1.29 [Flags: R/W].
[    0.469555] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.469739] fuse init (API version 7.13)
[    0.470107] msgmni has been set to 7874
[    0.470501] alg: No test for cipher_null (cipher_null-generic)
[    0.470538] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.470570] alg: No test for digest_null (digest_null-generic)
[    0.470606] alg: No test for compress_null (compress_null-generic)
[    0.471604] alg: No test for fcrypt (fcrypt-generic)
[    0.473772] alg: No test for stdrng (krng)
[    0.481222] alg: No test for ghash (ghash-generic)
[    0.481253] io scheduler noop registered
[    0.481255] io scheduler anticipatory registered
[    0.481257] io scheduler deadline registered
[    0.481283] io scheduler cfq registered (default)
[    0.481582] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.481596] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.481977] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.481991] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.482326] pcieport 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.482339] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.483442] ACPI: AC Adapter [AC] (on-line)
[    0.483823] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.484348] ACPI: Lid Switch [LID]
[    0.484466] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.484474] ACPI: Power Button [PBTN]
[    0.484587] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.484591] ACPI: Sleep Button [SBTN]
[    0.485360] ACPI: SSDT 00000000df65c4f6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.486328] ACPI: SSDT 00000000df65be8c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.487163] Monitor-Mwait will be used to enter C-1 state
[    0.487199] Monitor-Mwait will be used to enter C-2 state
[    0.487231] Monitor-Mwait will be used to enter C-3 state
[    0.487243] Marking TSC unstable due to TSC halts in idle
[    0.487485] Switching to clocksource hpet
[    0.487971] processor LNXCPU:00: registered as cooling_device0
[    0.488506] ACPI: SSDT 00000000df65c77c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.489309] ACPI: SSDT 00000000df65c471 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.490381] processor LNXCPU:01: registered as cooling_device1
[    0.555104] thermal LNXTHERM:01: registered as thermal_zone0
[    0.555119] ACPI: Thermal Zone [THM] (73 C)
[    0.555362] ACPI: Battery Slot [BAT0] (battery absent)
[    0.555432] ACPI: Battery Slot [BAT1] (battery absent)
[    0.608141] Non-volatile memory driver v1.3
[    0.608144] Linux agpgart interface v0.103
[    0.608171] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.609437] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    0.612381] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.612551] [drm] Initialized drm 1.1.0 20060810
[    0.612583] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.612588] i915 0000:00:02.0: setting latency timer to 64
[    0.651714] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.651724] [drm] set up 7M of stolen space
[    0.775153] integrated sync not supported
[    1.232884] 
[    1.232884] =============================================
[    1.232982] [ INFO: possible recursive locking detected ]
[    1.233003] 2.6.32 #5
[    1.233003] ---------------------------------------------
[    1.233003] swapper/1 is trying to acquire lock:
[    1.233003]  (&adap->bus_lock){+.+...}, at: [<ffffffff81498ad4>] i2c_transfer+0xf4/0x100
[    1.233003] 
[    1.233003] but task is already holding lock:
[    1.233003]  (&adap->bus_lock){+.+...}, at: [<ffffffff81498ad4>] i2c_transfer+0xf4/0x100
[    1.233003] 
[    1.233003] other info that might help us debug this:
[    1.233003] 1 lock held by swapper/1:
[    1.233003]  #0:  (&adap->bus_lock){+.+...}, at: [<ffffffff81498ad4>] i2c_transfer+0xf4/0x100
[    1.233003] 
[    1.233003] stack backtrace:
[    1.233003] Pid: 1, comm: swapper Not tainted 2.6.32 #5
[    1.233003] Call Trace:
[    1.233003]  [<ffffffff810735d0>] __lock_acquire+0x1060/0x1ce0
[    1.233003]  [<ffffffff810742ac>] lock_acquire+0x5c/0x80
[    1.233003]  [<ffffffff81498ad4>] ? i2c_transfer+0xf4/0x100
[    1.233003]  [<ffffffff816663e4>] mutex_lock_nested+0x44/0x310
[    1.233003]  [<ffffffff81498ad4>] ? i2c_transfer+0xf4/0x100
[    1.233003]  [<ffffffff81498ad4>] i2c_transfer+0xf4/0x100
[    1.233003]  [<ffffffff813801fc>] intel_sdvo_write_cmd+0x8c/0xf0
[    1.233003]  [<ffffffff81666617>] ? mutex_lock_nested+0x277/0x310
[    1.233003]  [<ffffffff81498ad4>] ? i2c_transfer+0xf4/0x100
[    1.233003]  [<ffffffff81381bc4>] intel_sdvo_master_xfer+0xb4/0xd0
[    1.233003]  [<ffffffff81498a9a>] i2c_transfer+0xba/0x100
[    1.233003]  [<ffffffff81359d28>] drm_do_probe_ddc_edid+0x48/0x60
[    1.233003]  [<ffffffff81359d67>] drm_ddc_read_edid+0x27/0x90
[    1.233003]  [<ffffffff81359e1e>] drm_get_edid+0x4e/0x130
[    1.233003]  [<ffffffff81383725>] intel_sdvo_hdmi_sink_detect+0x35/0x150
[    1.233003]  [<ffffffff81383979>] intel_sdvo_detect+0x139/0x140
[    1.233003]  [<ffffffff81347175>] drm_helper_probe_single_connector_modes+0x2c5/0x320
[    1.233003]  [<ffffffff81347216>] drm_helper_probe_connector_modes+0x46/0x80
[    1.233003]  [<ffffffff81347275>] drm_helper_initial_config+0x25/0x70
[    1.233003]  [<ffffffff8135fd97>] i915_driver_load+0x13c7/0x14e0
[    1.233003]  [<ffffffff813949e9>] ? device_register+0x19/0x20
[    1.233003]  [<ffffffff81352e05>] ? drm_sysfs_device_add+0x85/0xb0
[    1.233003]  [<ffffffff81350c22>] drm_get_dev+0x332/0x4e0
[    1.233003]  [<ffffffff816530a5>] i915_pci_probe+0x10/0x1b
[    1.233003]  [<ffffffff812c4bb2>] local_pci_probe+0x12/0x20
[    1.233003]  [<ffffffff812c5bd0>] pci_device_probe+0x80/0xa0
[    1.233003]  [<ffffffff81396dcb>] ? driver_sysfs_add+0x6b/0x90
[    1.233003]  [<ffffffff81396f1d>] driver_probe_device+0xad/0x1d0
[    1.233003]  [<ffffffff813970d3>] __driver_attach+0x93/0xa0
[    1.233003]  [<ffffffff81397040>] ? __driver_attach+0x0/0xa0
[    1.233003]  [<ffffffff81396628>] bus_for_each_dev+0x68/0x90
[    1.233003]  [<ffffffff81396d5c>] driver_attach+0x1c/0x20
[    1.233003]  [<ffffffff81395dbc>] bus_add_driver+0xbc/0x270
[    1.233003]  [<ffffffff819cf2b4>] ? i915_init+0x0/0x53
[    1.233003]  [<ffffffff813973fc>] driver_register+0x7c/0x160
[    1.233003]  [<ffffffff819cf2b4>] ? i915_init+0x0/0x53
[    1.233003]  [<ffffffff812c5e7a>] __pci_register_driver+0x6a/0xf0
[    1.233003]  [<ffffffff819cf2b4>] ? i915_init+0x0/0x53
[    1.233003]  [<ffffffff8134bef7>] drm_init+0xe7/0xf0
[    1.233003]  [<ffffffff819cf2b4>] ? i915_init+0x0/0x53
[    1.233003]  [<ffffffff819cf305>] i915_init+0x51/0x53
[    1.233003]  [<ffffffff81009048>] do_one_initcall+0x38/0x190
[    1.233003]  [<ffffffff819ad65d>] kernel_init+0x16a/0x1c2
[    1.233003]  [<ffffffff8100c3da>] child_rip+0xa/0x20
[    1.233003]  [<ffffffff8100bd7c>] ? restore_args+0x0/0x30
[    1.233003]  [<ffffffff819ad4f3>] ? kernel_init+0x0/0x1c2
[    1.233003]  [<ffffffff8100c3d0>] ? child_rip+0x0/0x20
[    1.525690] [drm] TV-16: set mode NTSC 480i 0
[    1.769258] [drm] DAC-6: set mode 1280x1024 40
[    1.842700] [drm] TMDS-14: set mode 1600x1200 45
[    2.054388] Console: switching to colour frame buffer device 160x64
[    2.058280] fb0: inteldrmfb frame buffer device
[    2.058281] registered panic notifier
[    2.059345] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input3
[    2.059403] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    2.059499] ACPI Warning for \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) (20090903/nspredef-433)
[    2.059667] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:02/input/input4
[    2.059721] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[    2.059812] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.059912] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.060119] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.061054] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.062494] loop: module loaded
[    2.062871] ahci 0000:00:1f.2: version 3.0
[    2.062916] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.063011] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    2.063106] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    2.063153] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    2.063200] ahci 0000:00:1f.2: setting latency timer to 64
[    2.066065] scsi0 : ahci
[    2.066235] scsi1 : ahci
[    2.066405] scsi2 : ahci
[    2.066798] ata1: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfb900 irq 28
[    2.066840] ata2: DUMMY
[    2.066857] ata3: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfba00 irq 28
[    2.066970] ata_piix 0000:00:1f.1: version 2.13
[    2.067012] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.067083] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.067187] scsi3 : ata_piix
[    2.067333] scsi4 : ata_piix
[    2.069688] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    2.069727] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    2.069870] ata5: port disabled. ignoring.
[    2.069973] tg3.c:v3.102 (September 1, 2009)
[    2.070025] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.070069] tg3 0000:09:00.0: setting latency timer to 64
[    2.078821] eth0: Tigon3 [partno(BCM95755m) rev a002] (PCI Express) MAC address 00:1c:23:21:0f:40
[    2.078870] eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    2.080143] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.081417] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.082756] PPP generic driver version 2.4.2
[    2.084217] PPP Deflate Compression module registered
[    2.085566] PPP BSD Compression module registered
[    2.087139] PPP MPPE Compression module registered
[    2.088547] NET: Registered protocol family 24
[    2.089956] PPPoL2TP kernel driver, V1.0
[    2.091380] tun: Universal TUN/TAP device driver, 1.6
[    2.092830] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.094401] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kd
[    2.095925] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    2.097545] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.099169] iwlagn 0000:0c:00.0: setting latency timer to 64
[    2.100827] iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[    2.152153] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[    2.153905] iwlagn 0000:0c:00.0: irq 29 for MSI/MSI-X
[    2.155826] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    2.158094] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.159835] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.161576] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.163305] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.165018] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.166773] ehci_hcd 0000:00:1a.7: debug port 1
[    2.172336] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.174055] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.185021] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.186795] usb usb1: configuration #1 chosen from 1 choice
[    2.188467] hub 1-0:1.0: USB hub found
[    2.190069] hub 1-0:1.0: 4 ports detected
[    2.191726] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.193343] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.194944] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.196537] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.198166] ehci_hcd 0000:00:1d.7: debug port 1
[    2.203648] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.205277] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.216021] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.217743] usb usb2: configuration #1 chosen from 1 choice
[    2.219367] hub 2-0:1.0: USB hub found
[    2.224274] hub 2-0:1.0: 6 ports detected
[    2.225946] uhci_hcd: USB Universal Host Controller Interface driver
[    2.227654] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.229278] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.230875] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.232452] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.234058] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    2.235777] usb usb3: configuration #1 chosen from 1 choice
[    2.237404] hub 3-0:1.0: USB hub found
[    2.238972] hub 3-0:1.0: 2 ports detected
[    2.240607] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.242193] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.243785] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.245362] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.246988] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    2.248718] usb usb4: configuration #1 chosen from 1 choice
[    2.250375] hub 4-0:1.0: USB hub found
[    2.251924] hub 4-0:1.0: 2 ports detected
[    2.253508] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.255071] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.256609] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.258150] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.259721] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    2.261411] usb usb5: configuration #1 chosen from 1 choice
[    2.263014] hub 5-0:1.0: USB hub found
[    2.264548] hub 5-0:1.0: 2 ports detected
[    2.266146] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.267707] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.269261] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.270801] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.272361] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    2.274035] usb usb6: configuration #1 chosen from 1 choice
[    2.275611] hub 6-0:1.0: USB hub found
[    2.277121] hub 6-0:1.0: 2 ports detected
[    2.278679] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.280204] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.281726] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.283229] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.284751] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.286404] usb usb7: configuration #1 chosen from 1 choice
[    2.287979] hub 7-0:1.0: USB hub found
[    2.289480] hub 7-0:1.0: 2 ports detected
[    2.291103] usbcore: registered new interface driver usblp
[    2.292594] Initializing USB Mass Storage driver...
[    2.294144] usbcore: registered new interface driver usb-storage
[    2.295653] USB Mass Storage support registered.
[    2.297203] usbcore: registered new interface driver ums-alauda
[    2.298751] usbcore: registered new interface driver ums-cypress
[    2.300300] usbcore: registered new interface driver ums-datafab
[    2.301823] usbcore: registered new interface driver ums-freecom
[    2.303326] usbcore: registered new interface driver ums-isd200
[    2.304821] usbcore: registered new interface driver ums-jumpshot
[    2.306300] usbcore: registered new interface driver ums-karma
[    2.307764] usbcore: registered new interface driver ums-onetouch
[    2.309210] usbcore: registered new interface driver ums-sddr09
[    2.310647] usbcore: registered new interface driver ums-sddr55
[    2.312071] usbcore: registered new interface driver ums-usbat
[    2.313524] usbcore: registered new interface driver usbserial
[    2.314903] USB Serial support registered for generic
[    2.316306] usbcore: registered new interface driver usbserial_generic
[    2.317667] usbserial: USB Serial Driver core
[    2.319141] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.323909] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.325331] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.326832] mice: PS/2 mouse device common for all mice
[    2.328663] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    2.330084] rtc_cmos 00:03: RTC can wake from S4
[    2.331555] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.332994] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.334439] Bluetooth: HCI UART driver ver 2.2
[    2.334708] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.337309] Bluetooth: HCI H4 protocol initialized
[    2.338748] Bluetooth: HCI BCSP protocol initialized
[    2.340177] Bluetooth: HCILL protocol initialized
[    2.341621] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    2.343118] usbcore: registered new interface driver btusb
[    2.344938] cpuidle: using governor ladder
[    2.347051] cpuidle: using governor menu
[    2.348728] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.352439] wacom driver registered
[    2.354036] usbcore: registered new interface driver usbhid
[    2.355512] usbhid: v2.6:USB HID core driver
[    2.357059] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    2.358829] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.360321] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.373283] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.374847] ata3: SATA link down (SStatus 0 SControl 300)
[    2.376434] ata1.00: ATA-7: ST9120822AS, 3.CDE, max UDMA/133
[    2.378057] ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    2.380655] ata1.00: configured for UDMA/133
[    2.393424] scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.CD PQ: 0 ANSI: 5
[    2.395284] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.396850] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    2.398413] sd 0:0:0:0: [sda] Write Protect is off
[    2.399913] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.401440] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.404070]  sda:
[    2.408192] ALSA device list:
[    2.411192]   #0: HDA Intel at 0xf6dfc000 irq 21
[    2.413171] IPv4 over IPv4 tunneling driver
[    2.415084] GRE over IPv4 tunneling driver
[    2.416659]  sda1 sda2 sda3 sda4 <
[    2.417068] TCP cubic registered
[    2.420019] Initializing XFRM netlink socket
[    2.421916] NET: Registered protocol family 10
[    2.424172] lo: Disabled Privacy Extensions
[    2.426914] tunl0: Disabled Privacy Extensions
[    2.429590] Mobile IPv6
[    2.431080] IPv6 over IPv4 tunneling driver
[    2.432664]  sda5
[    2.433182] sit0: Disabled Privacy Extensions
[    2.437339] ip6tnl0: Disabled Privacy Extensions
[    2.439452] NET: Registered protocol family 17
[    2.441013] NET: Registered protocol family 15
[    2.442593] Bluetooth: L2CAP ver 2.14
[    2.444153] Bluetooth: L2CAP socket layer initialized
[    2.445726]  sda6 >
[    2.447443] Bluetooth: SCO (Voice Link) ver 0.6
[    2.449014] Bluetooth: SCO socket layer initialized
[    2.450592] Bluetooth: RFCOMM TTY layer initialized
[    2.452119] Bluetooth: RFCOMM socket layer initialized
[    2.453628] Bluetooth: RFCOMM ver 1.11
[    2.455183] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.456691] Bluetooth: BNEP filters: protocol multicast
[    2.458189] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.459868] NET: Registered protocol family 33
[    2.461558] RxRPC: Registered security type 2 'rxkad'
[    2.461902] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.464530] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.466006] All bugs added by David S. Miller <davem@redhat.com>
[    2.467483] lib80211: common routines for IEEE802.11 drivers
[    2.468948] lib80211_crypt: registered algorithm 'NULL'
[    2.471535] kAFS: Red Hat AFS client v0.1 registering.
[    2.473875] rtc_cmos 00:03: setting system clock to 2010-02-13 16:00:07 UTC (1266076807)
[    2.496110] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    2.614398] usb 1-3: configuration #1 chosen from 1 choice
[    2.618242] hub 1-3:1.0: USB hub found
[    2.621908] hub 1-3:1.0: 4 ports detected
[    2.934199] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    2.937591] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input6
[    2.961937] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input7
[    2.988983] EXT3-fs: sda2: couldn't mount because of unsupported optional features (240).
[    3.018485] EXT4-fs (sda2): mounted filesystem with ordered data mode
[    3.022168] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    3.058151] devtmpfs: mounted
[    3.061820] Freeing unused kernel memory: 452k freed
[    3.108814] usb 7-1: configuration #1 chosen from 1 choice
[    3.115748] hub 7-1:1.0: USB hub found
[    3.121430] hub 7-1:1.0: 4 ports detected
[    3.194332] usb 1-3.1: new high speed USB device using ehci_hcd and address 3
[    3.274811] usb 1-3.1: configuration #1 chosen from 1 choice
[    3.279151] hub 1-3.1:1.0: USB hub found
[    3.283059] hub 1-3.1:1.0: 4 ports detected
[    3.351430] usb 1-3.3: new full speed USB device using ehci_hcd and address 4
[    3.434682] usb 1-3.3: configuration #1 chosen from 1 choice
[    3.441051] usblp0: USB Bidirectional printer dev 4 if 0 alt 0 proto 2 vid 0x04F9 pid 0x018C
[    3.445422] scsi5 : SCSI emulation for USB Mass Storage devices
[    3.449647] usb-storage: device found at 4
[    3.453327] usb-storage: waiting for device to settle before scanning
[    3.518445] usb 7-1.2: new full speed USB device using uhci_hcd and address 3
[    3.627956] usb 7-1.2: configuration #1 chosen from 1 choice
[    3.697556] usb 1-3.1.1: new low speed USB device using ehci_hcd and address 5
[    3.783461] usb 1-3.1.1: configuration #1 chosen from 1 choice
[    3.793048] input: Logitech Trackball as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.1/1-3.1.1/1-3.1.1:1.0/input/input8
[    3.797544] generic-usb 0003:046D:C404.0001: input: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1a.7-3.1.1/input0
[    3.876798] usb 1-3.1.2: new low speed USB device using ehci_hcd and address 6
[    3.965487] usb 1-3.1.2: configuration #1 chosen from 1 choice
[    3.973722] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.1/1-3.1.2/1-3.1.2:1.0/input/input9
[    3.978325] generic-usb 0003:046D:C313.0002: input: USB HID v1.10 Keyboard [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:1a.7-3.1.2/input0
[    3.986094] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.1/1-3.1.2/1-3.1.2:1.1/input/input10
[    3.990882] generic-usb 0003:046D:C313.0003: input: USB HID v1.10 Device [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:1a.7-3.1.2/input1
[    8.455842] usb-storage: device scan complete
[    8.466504] scsi 5:0:0:0: Direct-Access     Brother  DCP-115C         1.00 PQ: 0 ANSI: 2
[    8.473325] sd 5:0:0:0: Attached scsi generic sg1 type 0
[    8.516106] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[   14.222639] udev: starting version 150
[   16.262689] Adding 2048248k swap on /dev/sda5.  Priority:-1 extents:1 across:2048248k 
[   16.574369] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   16.581693] vboxdrv: NMI watchdog either active or at least initialized. Please disable the NMI
[   16.581696] vboxdrv: watchdog by specifying 'nmi_watchdog=0' at kernel command line.
[   16.606849] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   16.609929] vboxdrv: Successfully done.
[   16.613011] vboxdrv: Found 2 processor cores.
[   16.616310] VBoxDrv: dbg - g_abExecMemory=ffffffffa01c4860
[   16.619297] vboxdrv: fAsync=0 offMin=0x16b offMax=0x25a4
[   16.622609] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   16.625629] vboxdrv: Successfully loaded version 3.0.12_OSE (interface 0x00110000).
[   16.647236] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa036a3c0
[   16.694876] VBoxNetAdp: dbg - g_abExecMemory=ffffffffa0390b40
[   17.158575] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   17.189582] EXT4-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
[   17.196223] EXT4-fs (sda3): mounted filesystem with ordered data mode
[   17.246918] EXT4-fs (sda6): warning: maximal mount count reached, running e2fsck is recommended
[   17.254199] EXT4-fs (sda6): mounted filesystem with ordered data mode
[   20.021116] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   20.044904] iwlagn 0000:0c:00.0: loaded firmware version 228.61.2.24
[   20.263778] Registered led device: iwl-phy0::radio
[   20.267816] Registered led device: iwl-phy0::assoc
[   20.272078] Registered led device: iwl-phy0::RX
[   20.276381] Registered led device: iwl-phy0::TX
[   22.483797] cfg80211: Calling CRDA for country: DE
[   22.523119] cfg80211: Regulatory domain changed to country: DE
[   22.527178] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   22.531246] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   22.535286] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   22.539271] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[   23.850022] Registered led device: iwl-phy0::radio
[   23.854819] Registered led device: iwl-phy0::assoc
[   23.859432] Registered led device: iwl-phy0::RX
[   23.863636] Registered led device: iwl-phy0::TX
[   23.894224] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.906627] tg3 0000:09:00.0: irq 30 for MSI/MSI-X
[   23.946603] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   25.505978] [drm] TMDS-14: set mode 1280x1024 48
[   27.042087] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[   27.042091] tg3: eth0: Flow control is on for TX and on for RX.
[   27.042518] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   39.746409] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST - docking
[   39.747349] ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[   39.747352] ata4: ACPI event
[   39.747396] ata4: soft resetting link
[   39.936659] ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D200, max UDMA/33
[   39.993767] ata4.00: configured for UDMA/33
[   40.054870] ata4: EH complete
[   40.097239] scsi 3:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H D200 PQ: 0 ANSI: 5
[   40.247232] sr0: scsi3-mmc drive: 6x/24x writer cd/rw xa/form2 cdda tray
[   40.247243] Uniform CD-ROM driver Revision: 3.20
[   40.247659] sr 3:0:0:0: Attached scsi CD-ROM sr0
[   40.248025] sr 3:0:0:0: Attached scsi generic sg2 type 5
[   41.026840] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   52.754337] [drm] TMDS-14: set mode  49
[   53.422361] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   53.422435] cfg80211: Calling CRDA for country: DE
[   53.424897] cfg80211: Current regulatory domain updated by AP to: DE
[   53.424905] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   53.424913] 	(5170000 KHz - 5190000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   53.424920] 	(5180000 KHz - 5200000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   53.424927] 	(5190000 KHz - 5210000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   53.424933] 	(5210000 KHz - 5230000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   53.424939] 	(5220000 KHz - 5240000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   53.424945] 	(5230000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   53.424952] 	(5250000 KHz - 5255000 KHz @ 5000 KHz), (N/A, 2301 mBm)
[   53.424958] 	(5490000 KHz - 5510000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.424964] 	(5500000 KHz - 5520000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.424971] 	(5510000 KHz - 5530000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.424977] 	(5530000 KHz - 5550000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.424983] 	(5540000 KHz - 5560000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.424990] 	(5550000 KHz - 5570000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.424996] 	(5570000 KHz - 5590000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.425003] 	(5580000 KHz - 5600000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.425009] 	(5590000 KHz - 5610000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.425015] 	(5610000 KHz - 5630000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.425022] 	(5620000 KHz - 5640000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   53.425028] 	(5630000 KHz - 5650000 KHz @ 20000 KHz), (N/A, 3000 mBm)

--------------010802030504080708070105
Content-Type: text/x-log;
 name="dmesg-33.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-33.log"

[    0.000000] Linux version 2.6.33-rc8 (dariush@babel) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #2 SMP Sat Feb 13 11:33:05 CET 2010
[    0.000000] Command line: BOOT_IMAGE=//vmlinuz-2.6.33-rc8 root=/dev/sda2 ro quiet nmi_watchdog=0 log_buf_len=1024k
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  BIOS-e820: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf65a max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  modified: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df65a000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df65a000 page 4k
[    0.000000] kernel direct mapping tables up to df65a000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 1a000-20000
[    0.000000] ACPI: RSDP 00000000000fbb10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df65d200 00064 (v01 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: FACP 00000000df65d09c 000F4 (v04 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df65d800 06114 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df66c000 00040
[    0.000000] ACPI: HPET 00000000df65d300 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000df65d400 00068 (v01 DELL    M08     27D80B18 ASL  00000047)
[    0.000000] ACPI: ASF! 00000000df65d000 0007E (v32 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000df65d3c0 0003E (v16 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000df65d700 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000df65d49c 00176 (v01 DELL    M08     27D80B18 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df65b9c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0002295b20]    TEXT DATA BSS ==> [0001000000 - 0002295b20]
[    0.000000]   #2 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #3 [0002296000 - 00022961ec]              BRK ==> [0002296000 - 00022961ec]
[    0.000000]   #4 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #5 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #6 [0000016000 - 000001a000]          PGTABLE ==> [0000016000 - 000001a000]
[    0.000000]   #7 [000001a000 - 000001b000]          PGTABLE ==> [000001a000 - 000001b000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df65a
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1045994
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3819 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896658 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df65a000 - 00000000df65b000
[    0.000000] PM: Registered nosave memory: 00000000df65b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880028200000 s79064 r8192 d23336 u1048576
[    0.000000] pcpu-alloc: s79064 r8192 d23336 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029757
[    0.000000] Kernel command line: BOOT_IMAGE=//vmlinuz-2.6.33-rc8 root=/dev/sda2 ro quiet nmi_watchdog=0 log_buf_len=1024k
[    0.000000] log_buf_len: 1048576
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4030852k/4718592k available (6551k kernel code, 534616k absent, 152172k reserved, 3280k data, 464k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.811 MHz processor.
[    0.001013] Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.62 BogoMIPS (lpj=2194811)
[    0.001120] Mount-cache hash table entries: 256
[    0.002592] CPU: Physical Processor ID: 0
[    0.002594] CPU: Processor Core ID: 0
[    0.002597] mce: CPU supports 6 MCE banks
[    0.002604] CPU0: Thermal monitoring enabled (TM2)
[    0.002608] using mwait in idle threads.
[    0.002609] Performance Events: Core2 events, Intel PMU driver.
[    0.002620] ... version:                2
[    0.002621] ... bit width:              40
[    0.002622] ... generic registers:      2
[    0.002624] ... value mask:             000000ffffffffff
[    0.002625] ... max period:             000000007fffffff
[    0.002627] ... fixed-purpose events:   3
[    0.002628] ... event mask:             0000000700000003
[    0.002664] ACPI: Core revision 20091214
[    0.015128] Setting APIC routing to flat
[    0.015538] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025634] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.025999] lockdep: fixing up alternatives.
[    0.025999] Booting Node   0, Processors  #1 Ok.
[    0.097067] Brought up 2 CPUs
[    0.097070] Total of 2 processors activated (8778.40 BogoMIPS).
[    0.098140] devtmpfs: initialized
[    0.099178] NET: Registered protocol family 16
[    0.100029] ACPI: bus type pci registered
[    0.100078] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.100082] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.105271] PCI: Using configuration type 1 for base access
[    0.117210] bio: create slab <bio-0> at 0
[    0.122059] ACPI: EC: Look up EC in DSDT
[    0.122349] ACPI: BIOS _OSI(Linux) query ignored
[    0.166743] ACPI: SSDT 00000000df66c080 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.188026] ACPI: Interpreter enabled
[    0.188030] ACPI: (supports S0 S3 S4 S5)
[    0.188271] ACPI: Using IOAPIC for interrupt routing
[    0.299699] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.319033] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.319139] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.357792] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.357795] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.357798] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.357800] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.357803] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf7ffffff] (ignored)
[    0.357805] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff] (ignored)
[    0.357808] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff] (ignored)
[    0.357810] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff] (ignored)
[    0.357813] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff] (ignored)
[    0.357815] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff] (ignored)
[    0.357818] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff] (ignored)
[    0.357820] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff] (ignored)
[    0.357822] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff] (ignored)
[    0.357954] pci 0000:00:02.0: reg 10: [mem 0xf6e00000-0xf6efffff 64bit]
[    0.357964] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.357970] pci 0000:00:02.0: reg 20: [io  0xeff8-0xefff]
[    0.358033] pci 0000:00:02.1: reg 10: [mem 0xf6f00000-0xf6ffffff 64bit]
[    0.358203] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.358285] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.358369] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.358450] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.358457] pci 0000:00:1a.7: PME# disabled
[    0.358514] pci 0000:00:1b.0: reg 10: [mem 0xf6dfc000-0xf6dfffff 64bit]
[    0.358593] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.358599] pci 0000:00:1b.0: PME# disabled
[    0.358722] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.358727] pci 0000:00:1c.0: PME# disabled
[    0.358854] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.358860] pci 0000:00:1c.1: PME# disabled
[    0.358995] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.359004] pci 0000:00:1c.5: PME# disabled
[    0.359082] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.359164] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.359246] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.359329] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.359410] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.359417] pci 0000:00:1d.7: PME# disabled
[    0.359622] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.359627] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    0.359632] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.359639] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.359705] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.359715] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.359724] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.359733] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.359743] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.359824] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.359833] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.359843] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.359852] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.359862] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.359871] pci 0000:00:1f.2: reg 24: [mem 0xf6dfb800-0xf6dfbfff]
[    0.359927] pci 0000:00:1f.2: PME# supported from D3hot
[    0.359932] pci 0000:00:1f.2: PME# disabled
[    0.359972] pci 0000:00:1f.3: reg 10: [mem 0xf6dfb700-0xf6dfb7ff]
[    0.360010] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.360147] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.360311] pci 0000:0c:00.0: reg 10: [mem 0xf6cfe000-0xf6cfffff 64bit]
[    0.360527] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.360542] pci 0000:0c:00.0: PME# disabled
[    0.360675] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.360685] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.360773] pci 0000:09:00.0: reg 10: [mem 0xf6bf0000-0xf6bfffff 64bit]
[    0.360900] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.360907] pci 0000:09:00.0: PME# disabled
[    0.361015] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.361025] pci 0000:00:1c.5:   bridge window [mem 0xf6b00000-0xf6bfffff]
[    0.361141] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.361190] pci_bus 0000:00: on NUMA node 0
[    0.361196] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.361657] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.361939] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.362058] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.362193] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.388207] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.388389] ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
[    0.388569] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    0.389073] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0, disabled.
[    0.389254] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.389437] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.389620] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    0.389780] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.390325] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.390325] vgaarb: loaded
[    0.390325] SCSI subsystem initialized
[    0.390325] libata version 3.00 loaded.
[    0.391031] usbcore: registered new interface driver usbfs
[    0.391044] usbcore: registered new interface driver hub
[    0.391057] usbcore: registered new device driver usb
[    0.391108] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    0.391108] PCI: Using ACPI for IRQ routing
[    0.391108] PCI: pci_cache_line_size set to 64 bytes
[    0.392197] Bluetooth: Core ver 2.15
[    0.392197] NET: Registered protocol family 31
[    0.392197] Bluetooth: HCI device and connection manager initialized
[    0.392197] Bluetooth: HCI socket layer initialized
[    0.392197] cfg80211: Calling CRDA to update world regulatory domain
[    0.393055] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.393055] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.393055] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.396082] Switching to clocksource tsc
[    0.396231] pnp: PnP ACPI init
[    0.396255] ACPI: bus type pnp registered
[    0.464781] pnp 00:0b: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.464785] pnp 00:0b: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.465012] pnp 00:0c: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.465016] pnp 00:0c: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.465019] pnp 00:0c: disabling [io  0x1060-0x107f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.465022] pnp 00:0c: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.491411] pnp: PnP ACPI: found 14 devices
[    0.491415] ACPI: ACPI bus type pnp unregistered
[    0.491431] system 00:05: [io  0x0c80-0x0caf] has been reserved
[    0.491434] system 00:05: [io  0x0cc0-0x0cff] could not be reserved
[    0.491446] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.491458] system 00:0a: [io  0x0cb0-0x0cbb] has been reserved
[    0.491462] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.491471] system 00:0b: [io  0x0900-0x097f] has been reserved
[    0.491474] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.491483] system 00:0c: [io  0xf400-0xf4fe] has been reserved
[    0.491486] system 00:0c: [io  0x1080-0x10bf] has been reserved
[    0.491489] system 00:0c: [io  0x10c0-0x10df] has been reserved
[    0.491492] system 00:0c: [io  0x0809] has been reserved
[    0.491501] system 00:0d: [mem 0x00000000-0x0009efff] could not be reserved
[    0.491505] system 00:0d: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.491508] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.491511] system 00:0d: [mem 0x000e0000-0x000fffff] has been reserved
[    0.491514] system 00:0d: [mem 0x00100000-0xdf65a7ff] could not be reserved
[    0.491517] system 00:0d: [mem 0xdf65a800-0xdf6fffff] has been reserved
[    0.491519] system 00:0d: [mem 0xdf700000-0xdf7fffff] has been reserved
[    0.491523] system 00:0d: [mem 0xdf700000-0xdfefffff] could not be reserved
[    0.491526] system 00:0d: [mem 0xffe00000-0xffffffff] has been reserved
[    0.491529] system 00:0d: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.491532] system 00:0d: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.491535] system 00:0d: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.491538] system 00:0d: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.491540] system 00:0d: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.491543] system 00:0d: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.491546] system 00:0d: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.491549] system 00:0d: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.491552] system 00:0d: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.491555] system 00:0d: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.491558] system 00:0d: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.497001] pci 0000:00:1c.0: BAR 8: assigned [mem 0xf0000000-0xf01fffff]
[    0.497006] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.497009] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.497012] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.497015] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    0.497018] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
[    0.497021] pci 0000:00:1c.5: BAR 7: assigned [io  0x4000-0x4fff]
[    0.497024] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.497028] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.497036] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    0.497042] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.497052] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.497056] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.497063] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.497069] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.497079] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.497083] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.497091] pci 0000:00:1c.5:   bridge window [mem 0xf6b00000-0xf6bfffff]
[    0.497097] pci 0000:00:1c.5:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.497106] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.497108] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.497115] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.497120] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.497144] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.497151] pci 0000:00:1c.0: setting latency timer to 64
[    0.497166] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.497172] pci 0000:00:1c.1: setting latency timer to 64
[    0.497185] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.497190] pci 0000:00:1c.5: setting latency timer to 64
[    0.497201] pci 0000:00:1e.0: setting latency timer to 64
[    0.497205] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.497207] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.497210] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    0.497212] pci_bus 0000:0b: resource 1 [mem 0xf0000000-0xf01fffff]
[    0.497214] pci_bus 0000:0b: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.497217] pci_bus 0000:0c: resource 0 [io  0x3000-0x3fff]
[    0.497219] pci_bus 0000:0c: resource 1 [mem 0xf6c00000-0xf6cfffff]
[    0.497221] pci_bus 0000:0c: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.497224] pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
[    0.497226] pci_bus 0000:09: resource 1 [mem 0xf6b00000-0xf6bfffff]
[    0.497228] pci_bus 0000:09: resource 2 [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.497230] pci_bus 0000:03: resource 3 [io  0x0000-0xffff]
[    0.497233] pci_bus 0000:03: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.497283] NET: Registered protocol family 2
[    0.497456] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.498273] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.500007] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.505161] TCP: Hash tables configured (established 262144 bind 65536)
[    0.505216] TCP reno registered
[    0.505225] UDP hash table entries: 2048 (order: 6, 262144 bytes)
[    0.505558] UDP-Lite hash table entries: 2048 (order: 6, 262144 bytes)
[    0.506086] NET: Registered protocol family 1
[    0.506317] RPC: Registered udp transport module.
[    0.506319] RPC: Registered tcp transport module.
[    0.506321] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.506341] pci 0000:00:02.0: Boot video device
[    0.506598] PCI: CLS 64 bytes, default 64
[    0.506672] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.506676] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.506678] software IO TLB at phys 0x20000000 - 0x24000000
[    0.507906] Scanning for low memory corruption every 60 seconds
[    0.508279] Intel AES-NI instructions are not detected.
[    0.515570] Slow work thread pool: Starting up
[    0.515683] Slow work thread pool: Ready
[    0.515685] NTFS driver 2.1.29 [Flags: R/W].
[    0.515877] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.516050] fuse init (API version 7.13)
[    0.516383] msgmni has been set to 7874
[    0.516764] alg: No test for cipher_null (cipher_null-generic)
[    0.516798] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.516831] alg: No test for digest_null (digest_null-generic)
[    0.516863] alg: No test for compress_null (compress_null-generic)
[    0.517906] alg: No test for fcrypt (fcrypt-generic)
[    0.520098] alg: No test for stdrng (krng)
[    0.527433] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.527506] io scheduler noop registered
[    0.527508] io scheduler deadline registered
[    0.527694] io scheduler cfq registered (default)
[    0.527943] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.528016] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.528295] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.528363] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.528614] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.528682] pcieport 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.529803] ACPI: AC Adapter [AC] (on-line)
[    0.530166] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.530694] ACPI: Lid Switch [LID]
[    0.530811] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.530819] ACPI: Power Button [PBTN]
[    0.530925] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.530929] ACPI: Sleep Button [SBTN]
[    0.531675] ACPI: SSDT 00000000df65c4f6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.533211] ACPI: SSDT 00000000df65be8c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.534587] Monitor-Mwait will be used to enter C-1 state
[    0.534623] Monitor-Mwait will be used to enter C-2 state
[    0.534661] Monitor-Mwait will be used to enter C-3 state
[    0.534673] Marking TSC unstable due to TSC halts in idle
[    0.534933] Switching to clocksource hpet
[    0.535857] ACPI: SSDT 00000000df65c77c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.537199] ACPI: SSDT 00000000df65c471 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.602858] thermal LNXTHERM:01: registered as thermal_zone0
[    0.602873] ACPI: Thermal Zone [THM] (80 C)
[    0.603117] ACPI: Battery Slot [BAT0] (battery absent)
[    0.603185] ACPI: Battery Slot [BAT1] (battery absent)
[    0.653555] Non-volatile memory driver v1.3
[    0.653558] Linux agpgart interface v0.103
[    0.653668] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.654945] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    0.659869] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.660052] [drm] Initialized drm 1.1.0 20060810
[    0.660083] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.660088] i915 0000:00:02.0: setting latency timer to 64
[    0.698549] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.698560] [drm] set up 7M of stolen space
[    0.822389] composite sync not supported
[    1.155416] [drm] initialized overlay support
[    2.198188] Console: switching to colour frame buffer device 160x64
[    2.202034] fb0: inteldrmfb frame buffer device
[    2.202036] registered panic notifier
[    2.203567] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input3
[    2.203576] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    2.203617] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
[    2.203692] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.203779] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.204047] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.205792] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.207775] loop: module loaded
[    2.208389] ahci 0000:00:1f.2: version 3.0
[    2.208412] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.208473] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    2.208557] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    2.208561] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    2.208567] ahci 0000:00:1f.2: setting latency timer to 64
[    2.210332] scsi0 : ahci
[    2.210703] scsi1 : ahci
[    2.210886] scsi2 : ahci
[    2.211428] ata1: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfb900 irq 28
[    2.211431] ata2: DUMMY
[    2.211434] ata3: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfba00 irq 28
[    2.211547] ata_piix 0000:00:1f.1: version 2.13
[    2.211556] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.211600] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.211690] scsi3 : ata_piix
[    2.211862] scsi4 : ata_piix
[    2.214512] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    2.214515] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    2.214638] ata5: port disabled. ignoring.
[    2.214779] tg3.c:v3.106 (January 12, 2010)
[    2.214796] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.214805] tg3 0000:09:00.0: setting latency timer to 64
[    2.222233] eth0: Tigon3 [partno(BCM95755m) rev a002] (PCI Express) MAC address 00:1c:23:21:0f:40
[    2.222236] eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    2.222239] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.222241] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.222320] PPP generic driver version 2.4.2
[    2.222559] PPP Deflate Compression module registered
[    2.222562] PPP BSD Compression module registered
[    2.222867] PPP MPPE Compression module registered
[    2.222870] NET: Registered protocol family 24
[    2.222889] PPPoL2TP kernel driver, V1.0
[    2.222891] tun: Universal TUN/TAP device driver, 1.6
[    2.222892] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.223033] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 2.6.33-rc8-kd
[    2.223036] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    2.223140] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.223159] iwlagn 0000:0c:00.0: setting latency timer to 64
[    2.223209] iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[    2.266466] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[    2.266639] iwlagn 0000:0c:00.0: irq 29 for MSI/MSI-X
[    2.267442] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    2.268379] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.268410] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.268426] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.268431] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.268543] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.268608] ehci_hcd 0000:00:1a.7: debug port 1
[    2.272500] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    2.272520] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.282031] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.283000] hub 1-0:1.0: USB hub found
[    2.283020] hub 1-0:1.0: 4 ports detected
[    2.283288] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.283304] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.283308] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.283319] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.283354] ehci_hcd 0000:00:1d.7: debug port 1
[    2.287240] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.287259] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.298018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.298319] hub 2-0:1.0: USB hub found
[    2.298327] hub 2-0:1.0: 6 ports detected
[    2.298485] uhci_hcd: USB Universal Host Controller Interface driver
[    2.298606] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.298615] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.298619] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.298629] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.298660] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    2.298969] hub 3-0:1.0: USB hub found
[    2.299023] hub 3-0:1.0: 2 ports detected
[    2.299138] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.299147] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.299151] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.299160] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.299202] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    2.299507] hub 4-0:1.0: USB hub found
[    2.299515] hub 4-0:1.0: 2 ports detected
[    2.299610] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.299619] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.299623] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.299632] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.299663] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    2.300026] hub 5-0:1.0: USB hub found
[    2.300034] hub 5-0:1.0: 2 ports detected
[    2.300126] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.300135] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.300139] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.300148] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.300179] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    2.300477] hub 6-0:1.0: USB hub found
[    2.300485] hub 6-0:1.0: 2 ports detected
[    2.300581] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.300590] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.300594] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.300603] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.300633] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.300941] hub 7-0:1.0: USB hub found
[    2.300950] hub 7-0:1.0: 2 ports detected
[    2.301182] usbcore: registered new interface driver usblp
[    2.301185] Initializing USB Mass Storage driver...
[    2.301314] usbcore: registered new interface driver usb-storage
[    2.301316] USB Mass Storage support registered.
[    2.301378] usbcore: registered new interface driver ums-alauda
[    2.301439] usbcore: registered new interface driver ums-cypress
[    2.301500] usbcore: registered new interface driver ums-datafab
[    2.301561] usbcore: registered new interface driver ums-freecom
[    2.301621] usbcore: registered new interface driver ums-isd200
[    2.301684] usbcore: registered new interface driver ums-jumpshot
[    2.301745] usbcore: registered new interface driver ums-karma
[    2.301806] usbcore: registered new interface driver ums-onetouch
[    2.301869] usbcore: registered new interface driver ums-sddr09
[    2.301934] usbcore: registered new interface driver ums-sddr55
[    2.301997] usbcore: registered new interface driver ums-usbat
[    2.302142] usbcore: registered new interface driver usbserial
[    2.302198] USB Serial support registered for generic
[    2.302281] usbcore: registered new interface driver usbserial_generic
[    2.302283] usbserial: USB Serial Driver core
[    2.302435] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.306033] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.306062] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.306405] mice: PS/2 mouse device common for all mice
[    2.307417] rtc_cmos 00:03: RTC can wake from S4
[    2.307600] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.307644] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.307702] Bluetooth: HCI UART driver ver 2.2
[    2.307705] Bluetooth: HCI H4 protocol initialized
[    2.307706] Bluetooth: HCI BCSP protocol initialized
[    2.307708] Bluetooth: HCILL protocol initialized
[    2.307710] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    2.307779] usbcore: registered new interface driver btusb
[    2.308306] cpuidle: using governor ladder
[    2.309249] cpuidle: using governor menu
[    2.309566] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.310189] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.312030] wacom driver registered
[    2.312242] usbcore: registered new interface driver usbhid
[    2.312244] usbhid: USB HID core driver
[    2.313138] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.313215] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[    2.313263] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.355733] ALSA device list:
[    2.355735]   #0: HDA Intel at 0xf6dfc000 irq 30
[    2.356417] IPv4 over IPv4 tunneling driver
[    2.357236] GRE over IPv4 tunneling driver
[    2.357884] TCP cubic registered
[    2.357886] Initializing XFRM netlink socket
[    2.358415] NET: Registered protocol family 10
[    2.359573] lo: Disabled Privacy Extensions
[    2.361388] tunl0: Disabled Privacy Extensions
[    2.362940] Mobile IPv6
[    2.362943] IPv6 over IPv4 tunneling driver
[    2.363753] sit0: Disabled Privacy Extensions
[    2.365517] ip6tnl0: Disabled Privacy Extensions
[    2.366265] NET: Registered protocol family 17
[    2.366298] NET: Registered protocol family 15
[    2.366367] Bluetooth: L2CAP ver 2.14
[    2.366369] Bluetooth: L2CAP socket layer initialized
[    2.366373] Bluetooth: SCO (Voice Link) ver 0.6
[    2.366374] Bluetooth: SCO socket layer initialized
[    2.372923] Bluetooth: RFCOMM TTY layer initialized
[    2.372927] Bluetooth: RFCOMM socket layer initialized
[    2.372929] Bluetooth: RFCOMM ver 1.11
[    2.372930] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.372932] Bluetooth: BNEP filters: protocol multicast
[    2.372934] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.373331] NET: Registered protocol family 33
[    2.373608] RxRPC: Registered security type 2 'rxkad'
[    2.373611] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.373613] All bugs added by David S. Miller <davem@redhat.com>
[    2.373641] lib80211: common routines for IEEE802.11 drivers
[    2.373652] lib80211_crypt: registered algorithm 'NULL'
[    2.378683] kAFS: Red Hat AFS client v0.1 registering.
[    2.379824] rtc_cmos 00:03: setting system clock to 2010-02-13 16:03:07 UTC (1266076987)
[    2.516208] ata3: SATA link down (SStatus 0 SControl 300)
[    2.516228] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.517372] ata1.00: ATA-7: ST9120822AS, 3.CDE, max UDMA/133
[    2.517380] ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    2.518750] ata1.00: configured for UDMA/133
[    2.530635] scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.CD PQ: 0 ANSI: 5
[    2.533002] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    2.533265] sd 0:0:0:0: [sda] Write Protect is off
[    2.533272] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.533370] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.534427] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.534931]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.565558] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.586300] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    2.701922] hub 1-3:1.0: USB hub found
[    2.702103] hub 1-3:1.0: 4 ports detected
[    2.905609] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input5
[    2.927764] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input6
[    2.966284] usb 1-3.1: new high speed USB device using ehci_hcd and address 3
[    2.973152] EXT4-fs (sda2): mounted filesystem with ordered data mode
[    2.973380] VFS: Mounted root (ext2 filesystem) readonly on device 8:2.
[    3.001434] devtmpfs: mounted
[    3.001504] Freeing unused kernel memory: 464k freed
[    3.043388] hub 1-3.1:1.0: USB hub found
[    3.043728] hub 1-3.1:1.0: 4 ports detected
[    3.108286] usb 1-3.3: new full speed USB device using ehci_hcd and address 4
[    3.191863] usblp0: USB Bidirectional printer dev 4 if 0 alt 0 proto 2 vid 0x04F9 pid 0x018C
[    3.193252] scsi5 : usb-storage 1-3.3:1.2
[    3.400200] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    3.540279] hub 7-1:1.0: USB hub found
[    3.541799] hub 7-1:1.0: 4 ports detected
[    3.610553] usb 1-3.1.1: new low speed USB device using ehci_hcd and address 5
[    3.699043] input: Logitech Trackball as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.1/1-3.1.1/1-3.1.1:1.0/input/input7
[    3.699764] generic-usb 0003:046D:C404.0001: input: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1a.7-3.1.1/input0
[    3.763657] usb 1-3.1.2: new low speed USB device using ehci_hcd and address 6
[    3.852692] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.1/1-3.1.2/1-3.1.2:1.0/input/input8
[    3.853557] generic-usb 0003:046D:C313.0002: input: USB HID v1.10 Keyboard [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:1a.7-3.1.2/input0
[    3.857494] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.1/1-3.1.2/1-3.1.2:1.1/input/input9
[    3.857964] generic-usb 0003:046D:C313.0003: input: USB HID v1.10 Device [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:1a.7-3.1.2/input1
[    3.924891] usb 7-1.2: new full speed USB device using uhci_hcd and address 3
[    8.202995] scsi 5:0:0:0: Direct-Access     Brother  DCP-115C         1.00 PQ: 0 ANSI: 2
[    8.206792] sd 5:0:0:0: Attached scsi generic sg1 type 0
[    8.241658] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[   14.002529] udev: starting version 150
[   16.283535] Adding 2048248k swap on /dev/sda5.  Priority:-1 extents:1 across:2048248k 
[   17.118426] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   17.154901] EXT4-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
[   17.155432] EXT4-fs (sda3): mounted filesystem with ordered data mode
[   17.201071] EXT4-fs (sda6): warning: maximal mount count reached, running e2fsck is recommended
[   17.202412] EXT4-fs (sda6): mounted filesystem with ordered data mode
[   20.689709] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   20.694831] iwlagn 0000:0c:00.0: loaded firmware version 228.61.2.24
[   23.325471] cfg80211: Calling CRDA for country: DE
[   23.365734] cfg80211: Regulatory domain changed to country: DE
[   23.365743]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.365750]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   23.365757]     (5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   23.365763]     (5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[   24.851596] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   24.858342] tg3 0000:09:00.0: irq 31 for MSI/MSI-X
[   24.894850] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   27.948157] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[   27.948157] tg3: eth0: Flow control is on for TX and on for RX.
[   27.949382] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   31.751894] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   31.752380] cfg80211: Calling CRDA for country: DE
[   31.758344] cfg80211: Current regulatory domain updated by AP to: DE
[   31.758352]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   31.758359]     (5170000 KHz - 5190000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   31.758366]     (5180000 KHz - 5200000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   31.758372]     (5190000 KHz - 5210000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   31.758378]     (5210000 KHz - 5230000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   31.758384]     (5220000 KHz - 5240000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   31.758390]     (5230000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2301 mBm)
[   31.758397]     (5250000 KHz - 5255000 KHz @ 5000 KHz), (N/A, 2301 mBm)
[   31.758403]     (5490000 KHz - 5510000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758409]     (5500000 KHz - 5520000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758415]     (5510000 KHz - 5530000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758421]     (5530000 KHz - 5550000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758427]     (5540000 KHz - 5560000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758434]     (5550000 KHz - 5570000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758440]     (5570000 KHz - 5590000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758446]     (5580000 KHz - 5600000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758452]     (5590000 KHz - 5610000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758458]     (5610000 KHz - 5630000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758464]     (5620000 KHz - 5640000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   31.758471]     (5630000 KHz - 5650000 KHz @ 20000 KHz), (N/A, 3000 mBm)
[   41.270085] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   73.483939] 
[   73.483942] =======================================================
[   73.483945] [ INFO: possible circular locking dependency detected ]
[   73.483948] 2.6.33-rc8 #2
[   73.483950] -------------------------------------------------------
[   73.483952] kacpi_hotplug/253 is trying to acquire lock:
[   73.483954]  (kacpid){+.+.+.}, at: [<ffffffff81055680>] flush_workqueue+0x0/0xb0
[   73.483963] 
[   73.483963] but task is already holding lock:
[   73.483965]  ((&dpc->work)){+.+.+.}, at: [<ffffffff81054699>] worker_thread+0x189/0x320
[   73.483971] 
[   73.483971] which lock already depends on the new lock.
[   73.483972] 
[   73.483973] 
[   73.483974] the existing dependency chain (in reverse order) is:
[   73.483976] 
[   73.483977] -> #1 ((&dpc->work)){+.+.+.}:
[   73.483981]        [<ffffffff8106de84>] __lock_acquire+0x13c4/0x1cd0
[   73.483986]        [<ffffffff8106e7ec>] lock_acquire+0x5c/0x80
[   73.483989]        [<ffffffff810546e5>] worker_thread+0x1d5/0x320
[   73.483993]        [<ffffffff81058c76>] kthread+0x96/0xb0
[   73.483996]        [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
[   73.484001] 
[   73.484002] -> #0 (kacpid){+.+.+.}:
[   73.484005]        [<ffffffff8106e73c>] __lock_acquire+0x1c7c/0x1cd0
[   73.484005]        [<ffffffff8106e7ec>] lock_acquire+0x5c/0x80
[   73.484005]        [<ffffffff810556ce>] flush_workqueue+0x4e/0xb0
[   73.484005]        [<ffffffff812c6df9>] acpi_os_wait_events_complete+0x10/0x1e
[   73.484005]        [<ffffffff812c6e24>] acpi_os_execute_deferred+0x1d/0x31
[   73.484005]        [<ffffffff810546eb>] worker_thread+0x1db/0x320
[   73.484005]        [<ffffffff81058c76>] kthread+0x96/0xb0
[   73.484005]        [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
[   73.484005] 
[   73.484005] other info that might help us debug this:
[   73.484005] 
[   73.484005] 2 locks held by kacpi_hotplug/253:
[   73.484005]  #0:  (kacpi_hotplug){+.+...}, at: [<ffffffff81054699>] worker_thread+0x189/0x320
[   73.484005]  #1:  ((&dpc->work)){+.+.+.}, at: [<ffffffff81054699>] worker_thread+0x189/0x320
[   73.484005] 
[   73.484005] stack backtrace:
[   73.484005] Pid: 253, comm: kacpi_hotplug Not tainted 2.6.33-rc8 #2
[   73.484005] Call Trace:
[   73.484005]  [<ffffffff8106c440>] print_circular_bug+0x100/0x110
[   73.484005]  [<ffffffff8106e73c>] __lock_acquire+0x1c7c/0x1cd0
[   73.484005]  [<ffffffff81054699>] ? worker_thread+0x189/0x320
[   73.484005]  [<ffffffff8106df15>] ? __lock_acquire+0x1455/0x1cd0
[   73.484005]  [<ffffffff812c6e07>] ? acpi_os_execute_deferred+0x0/0x31
[   73.484005]  [<ffffffff8106e7ec>] lock_acquire+0x5c/0x80
[   73.484005]  [<ffffffff81055680>] ? flush_workqueue+0x0/0xb0
[   73.484005]  [<ffffffff810556ce>] flush_workqueue+0x4e/0xb0
[   73.484005]  [<ffffffff81055680>] ? flush_workqueue+0x0/0xb0
[   73.484005]  [<ffffffff812c6df9>] acpi_os_wait_events_complete+0x10/0x1e
[   73.484005]  [<ffffffff812c6e24>] acpi_os_execute_deferred+0x1d/0x31
[   73.484005]  [<ffffffff810546eb>] worker_thread+0x1db/0x320
[   73.484005]  [<ffffffff81054699>] ? worker_thread+0x189/0x320
[   73.484005]  [<ffffffff8165f426>] ? schedule+0x3c6/0xa80
[   73.484005]  [<ffffffff81059120>] ? autoremove_wake_function+0x0/0x40
[   73.484005]  [<ffffffff8106bc1d>] ? trace_hardirqs_on+0xd/0x10
[   73.484005]  [<ffffffff81054510>] ? worker_thread+0x0/0x320
[   73.484005]  [<ffffffff81058c76>] kthread+0x96/0xb0
[   73.484005]  [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
[   73.484005]  [<ffffffff81662c3c>] ? restore_args+0x0/0x30
[   73.484005]  [<ffffffff81058be0>] ? kthread+0x0/0xb0
[   73.484005]  [<ffffffff810032d0>] ? kernel_thread_helper+0x0/0x10

--------------010802030504080708070105
Content-Type: text/plain;
 name="config-2.6.33-rc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-2.6.33-rc7"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33-rc7
# Mon Feb  8 21:08:20 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=y
# CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT is not set
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLAGN=y
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
CONFIG_P54_COMMON=m
# CONFIG_P54_USB is not set
CONFIG_P54_PCI=m
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
# CONFIG_WL12XX is not set
# CONFIG_ZD1211RW is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=8
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_88PM8607 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
# CONFIG_SND_HDA_CODEC_INTELHDMI is not set
CONFIG_SND_HDA_CODEC_CIRRUS=y
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
CONFIG_SND_HDA_CODEC_CA0110=y
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_KSYM_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--------------010802030504080708070105--
