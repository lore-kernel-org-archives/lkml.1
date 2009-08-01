Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZHAF0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZHAF0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 01:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZHAF0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 01:26:02 -0400
Received: from mail.gmx.net ([213.165.64.20]:35919 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750820AbZHAFZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 01:25:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19sYmBP1ZFs0quOLgGCzxvjUKrqowY2useqEVqQWk
	73l8NKsbIwI1jL
Subject: rt2800usb: memory corruption?
From: Mike Galbraith <efault@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248955916.7995.47.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
	 <1248955916.7995.47.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Aug 2009 07:25:48 +0200
Message-Id: <1249104348.7146.60.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Fiddling with my box's builtin usb wireless adapter with the rt2x00
driver in .git.today to tinker with associate problem.

On Thu, 2009-07-30 at 14:12 +0200, Mike Galbraith wrote:

> This is nogo with rt2x00 driver fwiw.  Maybe some simple configuration
> thing, but I'm having no luck getting the bugger to work.
> 
> [   12.942335] phy0: Selected rate control algorithm 'minstrel'
> [   12.942440] Registered led device: rt2800usb-phy0::radio
> [   12.955279] Registered led device: rt2800usb-phy0::assoc
> [   12.968003] Registered led device: rt2800usb-phy0::quality
> [   12.981183] usbcore: registered new interface driver rt2800usb
> 
> [   33.032056] rt2800usb 1-5:1.0: firmware: requesting rt2870.bin
> [   33.161552] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.0/input/input4
> [   33.347130] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   34.513078] eth0: no IPv6 routers present
> [   35.935289] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
> [   35.937306] wlan0: authenticated
> [   35.937309] wlan0: associate with AP 00:1a:4f:9a:d0:12
> [   35.942551] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
> [   35.942555] wlan0: associated
> [   35.950948] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   37.314470] mtrr: base(0xd0000000) is not aligned on a size(0xff00000) boundary
> [   39.937271] wlan0: deauthenticated (Reason: 1)
snip repeat forever...

(My association problem seems to have improved markedly.  It's a little
wobbly as you can see in the dmesg output below, but does associate, and
I can ping router.  Can't use nic yet though, seems to be kinda limping
along.. shrug, progress)

Anyway, while piddling with above woes previously, I encountered a few
hard lockups while doing down/rmmod/modprobe cycles.  I encountered the
below (box survived this time obviously:) on third attempt this morning.

Full boot->boom

[    0.000000] Linux version 2.6.31-smp (root@marge) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1001 SMP Sat Aug 1 05:44:28 CEST 2009
[    0.000000] Command line: root=/dev/disk/by-id/scsi-SATA_ST3400620AS_6QG2LA0M-part3 resume=/dev/disk/by-id/scsi-SATA_ST3400620AS_6QG2LA0M-part2 splash=silent console=ttyS0,115200n8 console=tty showopts vga=0x31a
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe90000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe90000 - 00000000bfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfef0000 - 00000000bff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0xbfe90 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3071MB, range: 1MB, type UC
[    0.000000] total RAM coverred: 3071M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3071MB, range: 1MB, type UC
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe90000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfe90000 page 4k
[    0.000000] kernel direct mapping tables up to bfe90000 @ 8000-d000
[    0.000000] RAMDISK: 376b0000 - 37fefd3f
[    0.000000] ACPI: RSDP 00000000000f7f20 00014 (v00 MEDION)
[    0.000000] ACPI: RSDT 00000000bfee3000 0003C (v01 MEDION MEDIONAG 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 00000000bfee3080 00074 (v01 MEDION MEDIONAG 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 00000000bfee3100 04243 (v01 MEDION AWRDACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bfe90000 00040
[    0.000000] ACPI: HPET 00000000bfee75c0 00038 (v01 MEDION MEDIONAG 42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG 00000000bfee7600 0003C (v01 MEDION MEDIONAG 42302E31 AWRD 00000000)
[    0.000000] ACPI: SLIC 00000000bfee7380 00176 (v01 MEDION MEDIONAG 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 00000000bfee7500 00084 (v01 MEDION MEDIONAG 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 00000000bfee7f60 00380 (v01  PmRef    CpuPm 00003000 INTL 20041203)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 00bfe90000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00014c3f40]    TEXT DATA BSS ==> [0001000000 - 00014c3f40]
[    0.000000]   #3 [00376b0000 - 0037fefd3f]          RAMDISK ==> [00376b0000 - 0037fefd3f]
[    0.000000]   #4 [000009e400 - 0000100000]    BIOS reserved ==> [000009e400 - 0000100000]
[    0.000000]   #5 [00014c4000 - 00014c40ca]              BRK ==> [00014c4000 - 00014c40ca]
[    0.000000]   #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f3d20] f3d20
[    0.000000]  [ffffea0000000000-ffffea00029fffff] PMD -> [ffff880001a00000-ffff8800043fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bfe90
[    0.000000] On node 0 totalpages: 785966
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10691 pages used for memmap
[    0.000000]   DMA32 zone: 771277 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at bff00000 (gap: bff00000:20100000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages at ffff8800014e1000, static data 80224 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 775116
[    0.000000] Kernel command line: root=/dev/disk/by-id/scsi-SATA_ST3400620AS_6QG2LA0M-part3 resume=/dev/disk/by-id/scsi-SATA_ST3400620AS_6QG2LA0M-part2 splash=silent console=ttyS0,115200n8 console=tty showopts vga=0x31a
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3078992k/3144256k available (2576k kernel code, 392k absent, 64140k reserved, 1281k data, 392k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] NR_IRQS:384
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2392.678 MHz processor.
[    0.000025] Console: colour dummy device 80x25
[    0.000028] console [tty0] enabled
[    0.000217] console [ttyS0] enabled
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 4785.35 BogoMIPS (lpj=9570712)
[    0.012016] Security Framework initialized
[    0.016010] Mount-cache hash table entries: 256
[    0.020133] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.025658] CPU: L2 cache: 4096K
[    0.028003] CPU: Physical Processor ID: 0
[    0.032003] CPU: Processor Core ID: 0
[    0.036004] mce: CPU supports 6 MCE banks
[    0.040008] CPU0: Thermal monitoring enabled (TM2)
[    0.044004] using mwait in idle threads.
[    0.048003] Performance Counters: Core2 events, Intel PMU driver.
[    0.056003] ... version:                 2
[    0.060003] ... bit width:               40
[    0.064003] ... generic counters:        2
[    0.068003] ... value mask:              000000ffffffffff
[    0.072002] ... max period:              000000007fffffff
[    0.076003] ... fixed-purpose counters:  3
[    0.080003] ... counter mask:            0000000700000003
[    0.084018] ACPI: Core revision 20090521
[    0.096048] Setting APIC routing to flat
[    0.100358] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.144141] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.152001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4784.95 BogoMIPS (lpj=9569919)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.244492] CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.253233] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.256084] Booting processor 2 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 4784.99 BogoMIPS (lpj=9569985)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU2: Thermal monitoring enabled (TM2)
[    0.352524] CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.361233] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.364061] Booting processor 3 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 4785.00 BogoMIPS (lpj=9570001)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU3: Thermal monitoring enabled (TM2)
[    0.460516] CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.469231] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.472021] Brought up 4 CPUs
[    0.476003] Total of 4 processors activated (19140.30 BogoMIPS).
[    0.480050] CPU0 attaching sched-domain:
[    0.480053]  domain 0: span 0-1 level MC
[    0.480054]   groups: 0 1
[    0.480058]   domain 1: span 0-3 level CPU
[    0.480060]    groups: 0-1 2-3
[    0.480064] CPU1 attaching sched-domain:
[    0.480065]  domain 0: span 0-1 level MC
[    0.480067]   groups: 1 0
[    0.480070]   domain 1: span 0-3 level CPU
[    0.480072]    groups: 0-1 2-3
[    0.480075] CPU2 attaching sched-domain:
[    0.480077]  domain 0: span 2-3 level MC
[    0.480079]   groups: 2 3
[    0.480081]   domain 1: span 0-3 level CPU
[    0.480083]    groups: 2-3 0-1
[    0.480087] CPU3 attaching sched-domain:
[    0.480088]  domain 0: span 2-3 level MC
[    0.480090]   groups: 3 2
[    0.480093]   domain 1: span 0-3 level CPU
[    0.480095]    groups: 2-3 0-1
[    0.480130] NET: Registered protocol family 16
[    0.484041] ACPI: bus type pci registered
[    0.492047] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.496003] PCI: MCFG area at e0000000 reserved in E820
[    0.502601] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.504003] PCI: Using configuration type 1 for base access
[    0.508029] bio: create slab <bio-0> at 0
[    0.516420] ACPI: EC: Look up EC in DSDT
[    0.521746] ACPI: Interpreter enabled
[    0.524004] ACPI: (supports S0 S3 S4 S5)
[    0.529116] ACPI: Using IOAPIC for interrupt routing
[    0.540159] ACPI: No dock devices found.
[    0.544094] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.548083] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.552004] pci 0000:00:01.0: PME# disabled
[    0.556076] pci 0000:00:19.0: reg 10 32bit mmio: [0xfdfc0000-0xfdfdffff]
[    0.556083] pci 0000:00:19.0: reg 14 32bit mmio: [0xfdfff000-0xfdffffff]
[    0.556089] pci 0000:00:19.0: reg 18 io port: [0xff00-0xff1f]
[    0.556134] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.560005] pci 0000:00:19.0: PME# disabled
[    0.564055] pci 0000:00:1a.0: reg 20 io port: [0xfe00-0xfe1f]
[    0.564129] pci 0000:00:1a.1: reg 20 io port: [0xfd00-0xfd1f]
[    0.564203] pci 0000:00:1a.2: reg 20 io port: [0xfc00-0xfc1f]
[    0.564277] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfdffe000-0xfdffe3ff]
[    0.564330] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.568005] pci 0000:00:1a.7: PME# disabled
[    0.572045] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfdff4000-0xfdff7fff]
[    0.572093] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.576005] pci 0000:00:1b.0: PME# disabled
[    0.580055] pci 0000:00:1d.0: reg 20 io port: [0xfb00-0xfb1f]
[    0.580130] pci 0000:00:1d.1: reg 20 io port: [0xfa00-0xfa1f]
[    0.580203] pci 0000:00:1d.2: reg 20 io port: [0xf900-0xf91f]
[    0.580277] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfdffd000-0xfdffd3ff]
[    0.580330] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.584005] pci 0000:00:1d.7: PME# disabled
[    0.588124] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.592004] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.596004] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)
[    0.600004] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 001f)
[    0.604071] pci 0000:00:1f.2: reg 10 io port: [0xf800-0xf807]
[    0.604078] pci 0000:00:1f.2: reg 14 io port: [0xf700-0xf703]
[    0.604084] pci 0000:00:1f.2: reg 18 io port: [0xf600-0xf607]
[    0.604091] pci 0000:00:1f.2: reg 1c io port: [0xf500-0xf503]
[    0.604096] pci 0000:00:1f.2: reg 20 io port: [0xf400-0xf41f]
[    0.604102] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfdffc000-0xfdffc7ff]
[    0.604139] pci 0000:00:1f.2: PME# supported from D3hot
[    0.608005] pci 0000:00:1f.2: PME# disabled
[    0.612034] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfdffb000-0xfdffb0ff]
[    0.612049] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.612095] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.612103] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.612111] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.612116] pci 0000:01:00.0: reg 24 io port: [0xdf00-0xdf7f]
[    0.612121] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.612232] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.612235] pci 0000:00:01.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.612239] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.612271] pci 0000:02:00.0: reg 10 32bit mmio: [0xfddff000-0xfddff7ff]
[    0.612315] pci 0000:02:00.0: supports D1 D2
[    0.612349] pci 0000:02:02.0: reg 10 32bit mmio: [0xfddfe000-0xfddfe7ff]
[    0.612356] pci 0000:02:02.0: reg 14 io port: [0xcf00-0xcf7f]
[    0.612395] pci 0000:02:02.0: supports D2
[    0.612397] pci 0000:02:02.0: PME# supported from D2 D3hot D3cold
[    0.616005] pci 0000:02:02.0: PME# disabled
[    0.620043] pci 0000:00:1e.0: transparent bridge
[    0.624005] pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
[    0.624009] pci 0000:00:1e.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.624016] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xfde00000-0xfdefffff]
[    0.624025] pci_bus 0000:00: on NUMA node 0
[    0.624030] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.624178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.636783] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.642775] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.651182] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.658595] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.665848] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.673210] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.680375] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 *7 9 10 11 12 14 15)
[    0.686792] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.690719] PCI: Using ACPI for IRQ routing
[    0.712009] NetLabel: Initializing
[    0.715402] NetLabel:  domain hash size = 128
[    0.716003] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.720013] NetLabel:  unlabeled traffic allowed by default
[    0.724037] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.729217] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.744007] Switched to high resolution mode on CPU 0
[    0.745632] Switched to high resolution mode on CPU 1
[    0.747354] Switched to high resolution mode on CPU 3
[    0.747386] Switched to high resolution mode on CPU 2
[    0.764029] pnp: PnP ACPI init
[    0.767082] ACPI: bus type pnp registered
[    0.774109] pnp: PnP ACPI: found 14 devices
[    0.778290] ACPI: ACPI bus type pnp unregistered
[    0.782910] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.789256] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.795603] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.801958] system 00:0a: ioport range 0x400-0x4bf could not be reserved
[    0.808653] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.815781] system 00:0d: iomem range 0xf0000-0xfffff could not be reserved
[    0.822733] system 00:0d: iomem range 0xbff00000-0xbfffffff could not be reserved
[    0.830207] system 00:0d: iomem range 0xfed00000-0xfed000ff has been reserved
[    0.837334] system 00:0d: iomem range 0xbfe90000-0xbfefffff could not be reserved
[    0.844810] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.851417] system 00:0d: iomem range 0x100000-0xbfe8ffff could not be reserved
[    0.858720] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.866194] system 00:0d: iomem range 0xfed14000-0xfed1dfff has been reserved
[    0.873320] system 00:0d: iomem range 0xfed20000-0xfed9ffff has been reserved
[    0.880445] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.887571] system 00:0d: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.894697] system 00:0d: iomem range 0xfff00000-0xffffffff has been reserved
[    0.901823] system 00:0d: iomem range 0xe0000-0xeffff has been reserved
[    0.913493] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.919412] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.924721] pci 0000:00:01.0:   MEM window: 0xf8000000-0xfbffffff
[    0.930809] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.938370] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.944284] pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
[    0.949593] pci 0000:00:1e.0:   MEM window: 0xfdd00000-0xfddfffff
[    0.955681] pci 0000:00:1e.0:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
[    0.963249] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.969945] pci 0000:00:01.0: setting latency timer to 64
[    0.969951] pci 0000:00:1e.0: setting latency timer to 64
[    0.969955] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.969957] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.969959] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.969961] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
[    0.969963] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.969966] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.969968] pci_bus 0000:02: resource 1 mem: [0xfdd00000-0xfddfffff]
[    0.969970] pci_bus 0000:02: resource 2 pref mem [0xfde00000-0xfdefffff]
[    0.969972] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.969974] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.969985] NET: Registered protocol family 2
[    0.974362] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.981921] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.991156] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.998438] TCP: Hash tables configured (established 262144 bind 65536)
[    1.005048] TCP reno registered
[    1.008268] NET: Registered protocol family 1
[    1.012675] Unpacking initramfs...
[    1.215828] Freeing initrd memory: 9471k freed
[    1.225337] audit: initializing netlink socket (disabled)
[    1.230763] type=2000 audit(1249105647.228:1): initialized
[    1.236663] msgmni has been set to 6033
[    1.240786] alg: No test for stdrng (krng)
[    1.244978] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.252369] io scheduler noop registered
[    1.256291] io scheduler anticipatory registered
[    1.260903] io scheduler deadline registered
[    1.265169] io scheduler cfq registered (default)
[    1.270003] pci 0000:01:00.0: Boot video device
[    1.270148] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.270153] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.270592] vesafb: framebuffer at 0xf9000000, mapped to 0xffffc90010100000, using 5120k, total 14336k
[    1.279894] vesafb: mode is 1280x1024x16, linelength=2560, pages=1
[    1.286067] vesafb: scrolling: redraw
[    1.289725] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.315581] Console: switching to colour frame buffer device 160x64
[    1.340933] fb0: VESA VGA frame buffer device
[    1.357347] Non-volatile memory driver v1.3
[    1.361635] Linux agpgart interface v0.103
[    1.365822] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.372461] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.378750] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.385063] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    1.392844] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.398767] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.404821] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.411143] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.421009] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    1.428531] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.433711] mice: PS/2 mouse device common for all mice
[    1.439194] cpuidle: using governor ladder
[    1.443411] cpuidle: using governor menu
[    1.447450] IPv4 over IPv4 tunneling driver
[    1.451823] GRE over IPv4 tunneling driver
[    1.456151] TCP bic registered
[    1.459260] TCP cubic registered
[    1.462565] TCP westwood registered
[    1.462808] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.474918] TCP highspeed registered
[    1.478571] TCP hybla registered
[    1.481867] TCP htcp registered
[    1.485078] TCP vegas registered
[    1.488376] TCP veno registered
[    1.491578] TCP scalable registered
[    1.495149] TCP lp registered
[    1.498182] TCP yeah registered
[    1.501392] TCP illinois registered
[    1.504959] NET: Registered protocol family 17
[    1.509743] registered taskstats version 1
[    1.514091] Freeing unused kernel memory: 392k freed
[    1.559855] SCSI subsystem initialized
[    1.578604] libata version 3.00 loaded.
[    1.581353] ahci 0000:00:1f.2: version 3.0
[    1.581372] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.591693] ahci 0000:00:1f.2: irq 25 for MSI/MSI-X
[    1.591720] ahci: SSS flag set, parallel bus scan disabled
[    1.600808] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.612742] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems 
[    1.625427] ahci 0000:00:1f.2: setting latency timer to 64
[    1.664078] scsi0 : ahci
[    1.670606] scsi1 : ahci
[    1.677112] scsi2 : ahci
[    1.683687] scsi3 : ahci
[    1.690265] scsi4 : ahci
[    1.696875] scsi5 : ahci
[    1.703481] ata1: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc100 irq 25
[    1.715064] ata2: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc180 irq 25
[    1.726664] ata3: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc200 irq 25
[    1.738271] ata4: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc280 irq 25
[    1.749892] ata5: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc300 irq 25
[    1.761530] ata6: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc380 irq 25
[    2.256023] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.282973] ata1.00: ATA-8: WDC WD5000AACS-00ZUB0, 01.01B01, max UDMA/133
[    2.294272] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.306306] ata1.00: configured for UDMA/133
[    2.328129] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AACS-0 01.0 PQ: 0 ANSI: 5
[    3.228015] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.241573] ata2.00: ATAPI: HL-DT-ST DVDRAM GH20NS10, EL00, max UDMA/100
[    3.256187] ata2.00: configured for UDMA/100
[    3.394872] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH20NS10  EL00 PQ: 0 ANSI: 5
[    3.728025] ata3: SATA link down (SStatus 0 SControl 300)
[    4.072025] ata4: SATA link down (SStatus 0 SControl 300)
[    4.984022] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.037531] ata5.00: ATA-7: ST3400620AS, 3.AAK, max UDMA/133
[    5.048128] ata5.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.095852] ata5.00: configured for UDMA/133
[    5.120595] scsi 4:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
[    5.452025] ata6: SATA link down (SStatus 0 SControl 300)
[    5.490753] fan PNP0C0B:00: registered as cooling_device0
[    5.501051] ACPI: Fan [FAN] (on)
[    5.510844] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    5.529665] udevd version 128 started
[    5.574594] usbcore: registered new interface driver usbfs
[    5.576922] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    5.576957] sd 0:0:0:0: [sda] Write Protect is off
[    5.576959] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.576976] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.577087]  sda:
[    5.577140] sd 4:0:0:0: [sdb] 781422768 512-byte logical blocks: (400 GB/372 GiB)
[    5.577170] sd 4:0:0:0: [sdb] Write Protect is off
[    5.577172] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.577189] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.577266]  sdb: sda1 sda2 < sdb1 sdb2 sdb3
[    5.677913]  sda5
[    5.678174] usbcore: registered new interface driver hub
[    5.678212] usbcore: registered new device driver usb
[    5.706322]  >
[    5.713557] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.723909] sd 4:0:0:0: [sdb] Attached SCSI disk
[    5.736415] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.737881] uhci_hcd: USB Universal Host Controller Interface driver
[    5.737914] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.737924] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.737928] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.737959] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.737997] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000fe00
[    5.738036] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.738038] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.738039] usb usb1: Product: UHCI Host Controller
[    5.738041] usb usb1: Manufacturer: Linux 2.6.31-smp uhci_hcd
[    5.738042] usb usb1: SerialNumber: 0000:00:1a.0
[    5.738107] usb usb1: configuration #1 chosen from 1 choice
[    5.738132] hub 1-0:1.0: USB hub found
[    5.738137] hub 1-0:1.0: 2 ports detected
[    5.738197] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.738203] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.738206] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.738212] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    5.738241] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fd00
[    5.738268] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.738270] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.738271] usb usb2: Product: UHCI Host Controller
[    5.738273] usb usb2: Manufacturer: Linux 2.6.31-smp uhci_hcd
[    5.738274] usb usb2: SerialNumber: 0000:00:1a.1
[    5.738309] usb usb2: configuration #1 chosen from 1 choice
[    5.738331] hub 2-0:1.0: USB hub found
[    5.738335] hub 2-0:1.0: 2 ports detected
[    5.738387] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.738392] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.738395] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.738400] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    5.738428] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fc00
[    5.738455] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.738457] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.738459] usb usb3: Product: UHCI Host Controller
[    5.738460] usb usb3: Manufacturer: Linux 2.6.31-smp uhci_hcd
[    5.738462] usb usb3: SerialNumber: 0000:00:1a.2
[    5.738498] usb usb3: configuration #1 chosen from 1 choice
[    5.738519] hub 3-0:1.0: USB hub found
[    5.738523] hub 3-0:1.0: 2 ports detected
[    5.738576] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.738581] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.738583] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.738590] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    5.738617] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fb00
[    5.738644] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.738646] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.738648] usb usb4: Product: UHCI Host Controller
[    5.738649] usb usb4: Manufacturer: Linux 2.6.31-smp uhci_hcd
[    5.738650] usb usb4: SerialNumber: 0000:00:1d.0
[    5.738686] usb usb4: configuration #1 chosen from 1 choice
[    5.738707] hub 4-0:1.0: USB hub found
[    5.738712] hub 4-0:1.0: 2 ports detected
[    5.738763] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.738768] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.738771] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.738777] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    5.738798] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fa00
[    5.738826] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.738827] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.738829] usb usb5: Product: UHCI Host Controller
[    5.738830] usb usb5: Manufacturer: Linux 2.6.31-smp uhci_hcd
[    5.738832] usb usb5: SerialNumber: 0000:00:1d.1
[    5.738871] usb usb5: configuration #1 chosen from 1 choice
[    5.738892] hub 5-0:1.0: USB hub found
[    5.738896] hub 5-0:1.0: 2 ports detected
[    5.738961] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.738966] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.738969] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.738975] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    5.739003] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f900
[    5.739032] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.739034] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.739036] usb usb6: Product: UHCI Host Controller
[    5.739037] usb usb6: Manufacturer: Linux 2.6.31-smp uhci_hcd
[    5.739038] usb usb6: SerialNumber: 0000:00:1d.2
[    5.739074] usb usb6: configuration #1 chosen from 1 choice
[    5.739097] hub 6-0:1.0: USB hub found
[    5.739101] hub 6-0:1.0: 2 ports detected
[    6.052028] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    6.577549] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    6.591746] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.605662] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.605666] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.616297] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    6.633155] ehci_hcd 0000:00:1a.7: debug port 1
[    6.643063] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.643070] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdffe000
[    6.669028] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.680114] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    6.692320] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.695960] usb 1-1: New USB device found, idVendor=0424, idProduct=2228
[    6.695962] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.696040] usb 1-1: configuration #1 chosen from 1 choice
[    6.740790] usb usb7: Product: EHCI Host Controller
[    6.751201] usb usb7: Manufacturer: Linux 2.6.31-smp ehci_hcd
[    6.762390] usb usb7: SerialNumber: 0000:00:1a.7
[    6.772391] usb 1-1: can't set config #1, error -71
[    6.773591] usb usb7: configuration #1 chosen from 1 choice
[    6.773650] hub 7-0:1.0: USB hub found
[    6.773656] hub 7-0:1.0: 6 ports detected
[    6.773762] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.773775] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.773777] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.773784] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    6.777681] ehci_hcd 0000:00:1d.7: debug port 1
[    6.777687] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.777693] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffd000
[    6.793505] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.793519] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    6.793521] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.793522] usb usb8: Product: EHCI Host Controller
[    6.793524] usb usb8: Manufacturer: Linux 2.6.31-smp ehci_hcd
[    6.793525] usb usb8: SerialNumber: 0000:00:1d.7
[    6.793603] usb usb8: configuration #1 chosen from 1 choice
[    6.793659] hub 8-0:1.0: USB hub found
[    6.793664] hub 8-0:1.0: 6 ports detected
[    7.041563] PM: Starting manual resume from disk
[    7.349052] usb 1-1: USB disconnect, address 2
[    7.404015] kjournald starting.  Commit interval 5 seconds
[    7.413278] EXT3 FS on sdb3, internal journal
[    7.413282] EXT3-fs: mounted filesystem with writeback data mode.
[    7.612022] usb 7-1: new high speed USB device using ehci_hcd and address 2
[    7.846541] usb 7-1: New USB device found, idVendor=0424, idProduct=2228
[    7.859635] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.873182] usb 7-1: Product: Flash Card Reader
[    7.884102] usb 7-1: Manufacturer: Generic
[    7.894551] usb 7-1: SerialNumber: 000022272228
[    7.905540] usb 7-1: configuration #1 chosen from 1 choice
[    8.028017] usb 7-5: new high speed USB device using ehci_hcd and address 3
[    8.194265] usb 7-5: New USB device found, idVendor=13d3, idProduct=3247
[    8.207305] usb 7-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.220814] usb 7-5: Product: 802.11 n WLAN
[    8.220817] usb 7-5: Manufacturer: Ralink
[    8.220818] usb 7-5: SerialNumber: 1.0
[    8.220889] usb 7-5: configuration #1 chosen from 1 choice
[    8.576040] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    8.766250] usb 3-2: New USB device found, idVendor=0bc7, idProduct=0006
[    8.779297] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.792772] usb 3-2: Product: RF receiver
[    8.803060] usb 3-2: Manufacturer: X10 WTI
[    8.803143] usb 3-2: configuration #1 chosen from 1 choice
[    9.040043] usb 6-2: new low speed USB device using uhci_hcd and address 2
[    9.236787] usb 6-2: New USB device found, idVendor=045e, idProduct=008c
[    9.250028] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.263700] usb 6-2: Product: Microsoft Wireless Optical Mouse® 1.0A
[    9.276787] usb 6-2: Manufacturer: Microsoft
[    9.276867] usb 6-2: configuration #1 chosen from 1 choice
[    9.611118] udevd version 128 started
[   10.326338] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.338336] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   10.350663] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   10.425520] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   10.439936] ACPI: Power Button [PWRF]
[   10.450448] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[   10.465527] ACPI: Power Button [PWRB]
[   11.193089] ACPI: SSDT 00000000bfee7680 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20041203)
[   11.208404] processor LNXCPU:00: registered as cooling_device1
[   11.221362] ACPI: SSDT 00000000bfee7b40 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
[   11.236900] processor LNXCPU:01: registered as cooling_device2
[   11.252901] ACPI: SSDT 00000000bfee7ca0 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20041203)
[   11.268429] processor LNXCPU:02: registered as cooling_device3
[   11.268619] thermal LNXTHERM:01: registered as thermal_zone0
[   11.268628] ACPI: Thermal Zone [THRM] (22 C)
[   11.304822] ACPI: SSDT 00000000bfee7e00 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20041203)
[   11.320219] processor LNXCPU:03: registered as cooling_device4
[   11.346954] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   11.359543] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   11.372184] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.385917] e1000e 0000:00:19.0: setting latency timer to 64
[   11.386001] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   11.496322] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1d:92:6c:2e:10
[   11.510523] 0000:00:19.0: eth0: Intel(R) PRO/10/100 Network Connection
[   11.510553] 0000:00:19.0: eth0: MAC: 7, PHY: 7, PBA No: ffffff-0ff
[   11.559578] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   11.573804] usbcore: registered new interface driver libusual
[   11.584634] rtc_cmos 00:04: RTC can wake from S4
[   11.584690] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[   11.584738] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[   11.652585] cfg80211: Calling CRDA to update world regulatory domain
[   11.767805] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   11.782154] Uniform CD-ROM driver Revision: 3.20
[   11.794049] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   11.797613] usbcore: registered new interface driver hiddev
[   11.828991] Initializing USB Mass Storage driver...
[   11.840841] scsi6 : SCSI emulation for USB Mass Storage devices
[   11.843090] input: Microsoft Microsoft Wireless Optical Mouse® 1.0A as /devices/pci0000:00/0000:00:1d.2/usb6/6-2/6-2:1.0/input/input3
[   11.843157] generic-usb 0003:045E:008C.0001: input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse® 1.0A] on usb-0000:00:1d.2-2/input0
[   11.843176] usbcore: registered new interface driver usbhid
[   11.843178] usbhid: v2.6:USB HID core driver
[   11.919134] usb-storage: device found at 2
[   11.919136] usb-storage: waiting for device to settle before scanning
[   11.919157] usbcore: registered new interface driver usb-storage
[   11.920503] ohci1394 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   11.920516] ohci1394 0000:02:02.0: setting latency timer to 64
[   11.947856] USB Mass Storage support registered.
[   11.978554] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[fddfe000-fddfe7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   12.643836] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   12.658858] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.705190] phy0: Selected rate control algorithm 'minstrel'
[   12.705296] Registered led device: rt2800usb-phy0::radio
[   12.718364] Registered led device: rt2800usb-phy0::assoc
[   12.731490] Registered led device: rt2800usb-phy0::quality
[   12.744974] usbcore: registered new interface driver rt2800usb
[   13.280112] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc000152c873]
[   13.306198] Adding 2104504k swap on /dev/sdb2.  Priority:-1 extents:1 across:2104504k 
[   13.996380] device-mapper: uevent: version 1.0.3
[   14.009166] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   15.564712] loop: module loaded
[   15.601346] kjournald starting.  Commit interval 5 seconds
[   15.614148] EXT3 FS on sdb1, internal journal
[   15.625311] EXT3-fs: mounted filesystem with writeback data mode.
[   16.224757] fuse init (API version 7.12)
[   16.926296] usb-storage: device scan complete
[   16.930401] scsi 6:0:0:0: Direct-Access     Generic  Flash HS-CF      5.14 PQ: 0 ANSI: 0
[   16.947529] scsi 6:0:0:1: Direct-Access     Generic  Flash HS-MS/SD   5.14 PQ: 0 ANSI: 0
[   16.964775] scsi 6:0:0:2: Direct-Access     Generic  Flash HS-SM      5.14 PQ: 0 ANSI: 0
[   16.979417] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   16.991097] sd 6:0:0:1: Attached scsi generic sg4 type 0
[   17.004347] sd 6:0:0:2: Attached scsi generic sg5 type 0
[   17.015892] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   17.033884] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[   17.081509] sd 6:0:0:2: [sde] Attached SCSI removable disk
[   18.467620] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb3
[   18.478595] platform microcode: firmware: requesting intel-ucode/06-0f-0b
[   18.562553] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb3
[   18.573242] platform microcode: firmware: requesting intel-ucode/06-0f-0b
[   18.588288] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb3
[   18.599097] platform microcode: firmware: requesting intel-ucode/06-0f-0b
[   18.614667] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb3
[   18.625631] platform microcode: firmware: requesting intel-ucode/06-0f-0b
[   18.642004] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   18.824397] microcode: CPU0 updated to revision 0xb6, date = 2007-07-13 
[   18.840502] microcode: CPU1 updated to revision 0xb6, date = 2007-07-13 
[   18.862336] microcode: CPU2 updated to revision 0xb6, date = 2007-07-13 
[   18.881558] microcode: CPU3 updated to revision 0xb6, date = 2007-07-13 
[   19.335772] NET: Registered protocol family 10
[   19.345391] lo: Disabled Privacy Extensions
[   19.354889] tunl0: Disabled Privacy Extensions
[   19.546466] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   20.067968] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.401533] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.412974] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   20.425681] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   20.439178] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   22.736219] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   22.788056] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   22.788623] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.396774] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   24.409760] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   24.421544] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   30.512635] RPC: Registered udp transport module.
[   30.523405] RPC: Registered tcp transport module.
[   30.761744] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   31.022097] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   31.036486] NFSD: starting 90-second grace period
[   32.835900] rt2800usb 7-5:1.0: firmware: requesting rt2870.bin
[   32.966290] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5:1.0/input/input4
[   33.155122] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   34.557036] eth0: no IPv6 routers present
[   35.739263] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   35.741898] wlan0: authenticated
[   35.741903] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   35.750153] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   35.750156] wlan0: associated
[   35.758512] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   37.142949] mtrr: base(0xd0000000) is not aligned on a size(0xff00000) boundary
[   39.744125] wlan0: deauthenticated (Reason: 1)
[   40.744022] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   40.748042] wlan0 direct probe responded
[   40.748046] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   41.752024] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   41.754462] wlan0 direct probe responded
[   41.754465] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   41.756334] wlan0: authenticated
[   41.756338] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   41.760960] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   41.760964] wlan0: associated
[   45.784006] wlan0: no IPv6 routers present
[   51.767874] wlan0: disassociating by local choice (reason=3)
[   51.770733] wlan0: deauthenticated (Reason: 6)
[   53.812070] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   53.813953] wlan0: authenticated
[   53.813955] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   53.819343] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   53.819346] wlan0: associated
[   57.814077] wlan0: deauthenticated (Reason: 1)
[   58.812508] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   58.816596] wlan0 direct probe responded
[   58.816599] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   59.816548] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[   59.818987] wlan0 direct probe responded
[   59.818990] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[   59.820979] wlan0: authenticated
[   59.820981] wlan0: associate with AP 00:1a:4f:9a:d0:12
[   59.825606] wlan0: RX ReassocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[   59.825608] wlan0: associated
[  497.373019] wlan0: deauthenticating by local choice (reason=3)
[  514.061145] SysRq : Changing Loglevel
[  514.065134] Loglevel set to 9
[  531.236085] usbcore: deregistering interface driver rt2800usb
[  541.310842] phy1: Selected rate control algorithm 'minstrel'
[  541.320854] Registered led device: rt2800usb-phy1::radio
[  541.330044] Registered led device: rt2800usb-phy1::assoc
[  541.339353] Registered led device: rt2800usb-phy1::quality
[  541.353367] usbcore: registered new interface driver rt2800usb
[  541.442636] rt2800usb 7-5:1.0: firmware: requesting rt2870.bin
[  541.492492] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5:1.0/input/input5
[  541.683185] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  544.251254] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  544.263266] wlan0 direct probe responded
[  544.271148] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  544.282631] wlan0: authenticated
[  544.289472] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  544.303006] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  544.314561] wlan0: associated
[  544.330059] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  546.883815] martian source 255.255.255.255 from 192.168.178.1, on dev wlan0
[  546.890383] ll header: ff:ff:ff:ff:ff:ff:00:1a:4f:7b:e8:48:08:00
[  546.980440] martian source 255.255.255.255 from 192.168.178.1, on dev wlan0
[  546.992455] ll header: ff:ff:ff:ff:ff:ff:00:1a:4f:7b:e8:48:08:00
[  554.672005] wlan0: no IPv6 routers present
[ 1273.685021] device wlan0 entered promiscuous mode
[ 1444.008014] device wlan0 left promiscuous mode
[ 1454.721520] wlan0: deauthenticating by local choice (reason=3)
[ 1466.830862] usbcore: deregistering interface driver rt2800usb
[ 1529.625525] phy2: Selected rate control algorithm 'minstrel'
[ 1529.638474] Registered led device: rt2800usb-phy2::radio
[ 1529.650467] Registered led device: rt2800usb-phy2::assoc
[ 1529.662011] Registered led device: rt2800usb-phy2::quality
[ 1529.675227] usbcore: registered new interface driver rt2800usb
[ 1529.736962] rt2800usb 7-5:1.0: firmware: requesting rt2870.bin
[ 1529.812574] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5:1.0/input/input6
[ 1530.011246] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1532.575208] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[ 1532.589467] wlan0: authenticated
[ 1532.599358] wlan0: associate with AP 00:1a:4f:9a:d0:12
[ 1532.616210] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[ 1532.629818] wlan0: associated
[ 1532.647010] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1534.905025] device wlan0 entered promiscuous mode
[ 1535.202677] martian source 255.255.255.255 from 192.168.178.1, on dev wlan0
[ 1535.206611] ll header: ff:ff:ff:ff:ff:ff:00:1a:4f:7b:e8:48:08:00
[ 1535.298916] martian source 255.255.255.255 from 192.168.178.1, on dev wlan0
[ 1535.306059] ll header: ff:ff:ff:ff:ff:ff:00:1a:4f:7b:e8:48:08:00
[ 1536.512420] ------------[ cut here ]------------
[ 1536.516065] kernel BUG at mm/slub.c:2929!
[ 1536.516065] invalid opcode: 0000 [#1] SMP 
[ 1536.516065] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 1536.516065] CPU 0 
[ 1536.516065] Modules linked in: rt2800usb xt_tcpudp xt_pkttype xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables cpufreq_conservative ip6table_filter cpufreq_ondemand ip6_tables cpufreq_userspace x_tables cpufreq_powersave acpi_cpufreq ipv6 microcode fuse loop dm_mod snd_hda_codec_realtek arc4 ecb snd_hda_intel snd_hda_codec rt2x00usb rt2x00lib firewire_ohci snd_hwdep snd_pcm led_class firewire_core snd_timer input_polldev crc_itu_t mac80211 snd ohci1394 usb_storage usbhid soundcore sr_mod rtc_cmos usb_libusual i2c_i801 cfg80211 snd_page_alloc rtc_core hid e1000e thermal processor ieee1394 i2c_core cdrom crc_ccitt intel_agp rtc_lib button sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 mbcache jbd ahci libata scsi_mod [last unloaded: rt2800usb]
[ 1536.516065] Pid: 6982, comm: gam_server Not tainted 2.6.31-smp #1001 MS-7502
[ 1536.516065] RIP: 0010:[<ffffffff810b7306>]  [<ffffffff810b7306>] kfree+0x82/0x187
[ 1536.516065] RSP: 0018:ffff8800ad1b5df8  EFLAGS: 00010246
[ 1536.516065] RAX: 4000000000000000 RBX: ffff88009d7113a8 RCX: 0000000000000000
[ 1536.516065] RDX: ffffea0000000000 RSI: ffffffff814b39f2 RDI: ffff88001818500b
[ 1536.516065] RBP: ffff8800ad1b5e28 R08: 0000000000000000 R09: ffff8800ad1b5e48
[ 1536.516065] R10: ffff8800ad1b5e48 R11: 0000000000000246 R12: ffffea0000545518
[ 1536.516065] R13: 0000000000000010 R14: ffff88001818500b R15: 0000000001eeb460
[ 1536.516065] FS:  00007f08d83726f0(0000) GS:ffff8800014e1000(0000) knlGS:0000000000000000
[ 1536.516065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1536.516065] CR2: 00007f05b5c4e048 CR3: 00000000ad1a8000 CR4: 00000000000006f0
[ 1536.516065] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1536.516065] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1536.516065] Process gam_server (pid: 6982, threadinfo ffff8800ad1b4000, task ffff8800be290cc0)
[ 1536.516065] Stack:
[ 1536.516065]  ffff8800ad1b5e38 ffff88009d7113a8 ffff88009d7113a8 0000000000000010
[ 1536.516065] <0> 0000000000000002 0000000001eeb460 ffff8800ad1b5e48 ffffffff810e3b4c
[ 1536.516065] <0> ffff8800ad1b5e48 0000000000000020 ffff8800ad1b5f08 ffffffff810e5e3b
[ 1536.516065] Call Trace:
[ 1536.516065]  [<ffffffff810e3b4c>] fsnotify_put_event+0x45/0x58
[ 1536.891064]  [<ffffffff810e5e3b>] inotify_read+0x1f0/0x282
[ 1536.891064]  [<ffffffff81050bba>] ? autoremove_wake_function+0x0/0x38
[ 1536.891064]  [<ffffffff810bc2ac>] vfs_read+0xab/0x167
[ 1536.891064]  [<ffffffff810bc42c>] sys_read+0x47/0x6f
[ 1536.891064]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
[ 1536.891064] Code: 00 ea ff ff 48 c1 e8 0c 48 6b c0 38 4c 8d 24 10 66 41 83 3c 24 00 79 05 4d 8b 64 24 10 49 8b 04 24 84 c0 78 17 66 a9 00 c0 75 04 <0f> 0b eb fe 4c 89 e7 e8 98 44 fe ff e9 e8 00 00 00 4d 8b 6c 24 
[ 1536.891064] RIP  [<ffffffff810b7306>] kfree+0x82/0x187
[ 1536.891064]  RSP <ffff8800ad1b5df8>
[ 1537.069331] ---[ end trace 432a664becb6485b ]---
[ 1543.056005] wlan0: no IPv6 routers present




