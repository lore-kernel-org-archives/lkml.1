Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZK3V6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZK3V6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZK3V6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:58:30 -0500
Received: from kroah.org ([198.145.64.141]:58804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZK3V6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:58:06 -0500
Date: Mon, 30 Nov 2009 13:33:37 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/15] sysfs lazification final
Message-ID: <20091130213337.GA3468@kroah.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
 <m1pr7tmqb4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 07, 2009 at 11:25:03PM -0800, Eric W. Biederman wrote:
> 
> The sysfs code updates the vfs caches immediately when the sysfs data
> structures change causing a lot of unnecessary complications.  The
> following patchset untangles that beast.  Allowing for simpler
> more straight forward code, the removal of a hack from the vfs
> to support sysfs, and human comprehensible locking on sysfs.
> 
> Most of these patches have already been reviewed and acked from the
> last time I had time to work on sysfs.
> 
> This acks have been folded in and the two small bugs found in the
> previous review have been fixed in the trailing patches (they are
> minor enough nits that even a bisect that happens to land in the
> middle should not see sysfs problems).

I've applied all of these to my tree now, and sorry, but something is
broken pretty badly.

When doing a simple 'ls /sys/class/input/' the process locks up.  This
means that X can't find any input devices, which makes for a bit of a
problem when wanting to use your mouse or keyboard :(

Attached is the state of my processes when this happens, if that helps
out any.

So I'm going to drop all of these from my tree again, as they are not
ready for merging at this point :(

sorry,

greg k-h

--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: 8bit

0] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 07F000000 mask FFF000000 uncachable
[    0.000000]   3 base 07EF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000ede00 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007e0d5000 (usable)
[    0.000000]  modified: 000000007e0d5000 - 000000007e2d6000 (ACPI NVS)
[    0.000000]  modified: 000000007e2d6000 - 000000007eebf000 (ACPI data)
[    0.000000]  modified: 000000007eebf000 - 000000007eeef000 (ACPI NVS)
[    0.000000]  modified: 000000007eeef000 - 000000007ef00000 (ACPI data)
[    0.000000]  modified: 000000007ef00000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 7eefd120 00074 (v01 APPLE   Apple00 00000055      01000013)
[    0.000000] ACPI: FACP 7eefb000 000F4 (v03 APPLE   Apple00 00000055 Loki 0000005F)
[    0.000000] ACPI: DSDT 7eef1000 0389A (v01 APPLE   Macmini 00010001 INTL 20050309)
[    0.000000] ACPI: FACS 7eec1000 00040
[    0.000000] ACPI: HPET 7eefa000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 7eef9000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: MCFG 7eef8000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! 7eef7000 0009C (v32 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 7eef6000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 7eef5000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 7eebd000 0064F (v01 APPLE   SataPri 00001000 INTL 20050309)
[    0.000000] ACPI: SSDT 7eebc000 0069C (v01 APPLE   SataSec 00001000 INTL 20050309)
[    0.000000] ACPI: SSDT 7eef0000 004DC (v01 APPLE     CpuPm 00003000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1128MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001689dc8]    TEXT DATA BSS ==> [0001000000 - 0001689dc8]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [000168a000 - 00016911f1]              BRK ==> [000168a000 - 00016911f1]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007e0d5
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007e0d5
[    0.000000] On node 0 totalpages: 516208
[    0.000000] free_area_init_node: node 0, pgdat c156f1c0, node_mem_map c1693000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2258 pages used for memmap
[    0.000000]   HighMem zone: 286725 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2800000 s35480 r0 d21864 u2097152
[    0.000000] pcpu-alloc: s35480 r0 d21864 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 512174
[    0.000000] Kernel command line: root=/dev/sda3 vga=0x0305 netconsole=6665@192.168.0.14/eth0,6666@192.168.0.104/00:1F:29:AE:FC:95
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007e0d5)
[    0.000000] Memory: 2039992k/2065236k available (3339k kernel code, 23868k reserved, 2328k data, 352k init, 1155932k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1589000 - 0xc15e1000   ( 352 kB)
[    0.000000]       .data : 0xc1342c88 - 0xc1588e60   (2328 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1342c88   (3339 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1833.151 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3666.30 BogoMIPS (lpj=7332604)
[    0.004034] Mount-cache hash table entries: 512
[    0.004199] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004205] CPU: L2 cache: 2048K
[    0.004210] CPU: Physical Processor ID: 0
[    0.004213] CPU: Processor Core ID: 0
[    0.004219] mce: CPU supports 6 MCE banks
[    0.004231] CPU0: Thermal monitoring enabled (TM2)
[    0.004236] using mwait in idle threads.
[    0.004246] Performance Events: unsupported p6 CPU model 14 no PMU driver, software events only.
[    0.004256] Checking 'hlt' instruction... OK.
[    0.020413] ACPI: Core revision 20090903
[    0.028439] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068380] CPU0: Genuine Intel(R) CPU            1400  @ 1.83GHz stepping 08
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.008000] Initializing CPU#1
[    0.008000] Calibrating delay using timer specific routine.. 3666.62 BogoMIPS (lpj=7333252)
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 2048K
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 1
[    0.008000] CPU1: Thermal monitoring enabled (TM2)
[    0.156058] CPU1: Genuine Intel(R) CPU            1400  @ 1.83GHz stepping 08
[    0.156090] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160046] Brought up 2 CPUs
[    0.160052] Total of 2 processors activated (7332.92 BogoMIPS).
[    0.160462] CPU0 attaching sched-domain:
[    0.160466]  domain 0: span 0-1 level MC
[    0.160469]   groups: 0 1
[    0.160476] CPU1 attaching sched-domain:
[    0.160478]  domain 0: span 0-1 level MC
[    0.160481]   groups: 1 0
[    0.160571] tmpfs: No value for mount option 'mode'
[    0.160571] devtmpfs: initialized
[    0.160571] NET: Registered protocol family 16
[    0.161637] ACPI: bus type pci registered
[    0.161654] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.161654] PCI: MCFG area at e0000000 reserved in E820
[    0.161654] PCI: Using MMCONFIG for extended config space
[    0.161654] PCI: Using configuration type 1 for base access
[    0.168040] bio: create slab <bio-0> at 0
[    0.168542] ACPI: EC: EC description table is found, configuring boot EC
[    0.169743] ACPI: BIOS _OSI(Linux) query ignored
[    0.172185] ACPI: Interpreter enabled
[    0.172199] ACPI: (supports S0 S3 S5)
[    0.172218] ACPI: Using IOAPIC for interrupt routing
[    0.180461] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.180461] ACPI: No dock devices found.
[    0.181136] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.181170] pci 0000:00:02.0: reg 10 32bit mmio: [0x90380000-0x903fffff]
[    0.181170] pci 0000:00:02.0: reg 14 io port: [0x20f0-0x20f7]
[    0.181170] pci 0000:00:02.0: reg 18 32bit mmio pref: [0x80000000-0x8fffffff]
[    0.181170] pci 0000:00:02.0: reg 1c 32bit mmio: [0x90400000-0x9043ffff]
[    0.181170] pci 0000:00:07.0: reg 10 32bit mmio: [0x90444000-0x90444fff]
[    0.181170] pci 0000:00:1b.0: reg 10 64bit mmio: [0x90440000-0x90443fff]
[    0.181170] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.181170] pci 0000:00:1b.0: PME# disabled
[    0.181170] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.181170] pci 0000:00:1c.0: PME# disabled
[    0.181170] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.181170] pci 0000:00:1c.1: PME# disabled
[    0.181170] pci 0000:00:1d.0: reg 20 io port: [0x20a0-0x20bf]
[    0.181170] pci 0000:00:1d.1: reg 20 io port: [0x2080-0x209f]
[    0.181170] pci 0000:00:1d.2: reg 20 io port: [0x2060-0x207f]
[    0.181170] pci 0000:00:1d.3: reg 20 io port: [0x2040-0x205f]
[    0.184048] pci 0000:00:1d.7: reg 10 32bit mmio: [0x90445400-0x904457ff]
[    0.184110] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.184118] pci 0000:00:1d.7: PME# disabled
[    0.184291] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.184300] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.184308] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.184316] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
[    0.184325] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 0003)
[    0.184333] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
[    0.184389] pci 0000:00:1f.1: reg 10 io port: [0x20e8-0x20ef]
[    0.184397] pci 0000:00:1f.1: reg 14 io port: [0x2104-0x2107]
[    0.184406] pci 0000:00:1f.1: reg 18 io port: [0x20e0-0x20e7]
[    0.184415] pci 0000:00:1f.1: reg 1c io port: [0x2100-0x2103]
[    0.184423] pci 0000:00:1f.1: reg 20 io port: [0x20c0-0x20cf]
[    0.184480] pci 0000:00:1f.2: reg 10 io port: [0x20d8-0x20df]
[    0.184489] pci 0000:00:1f.2: reg 14 io port: [0x20fc-0x20ff]
[    0.184497] pci 0000:00:1f.2: reg 18 io port: [0x20d0-0x20d7]
[    0.184506] pci 0000:00:1f.2: reg 1c io port: [0x20f8-0x20fb]
[    0.184514] pci 0000:00:1f.2: reg 20 io port: [0x2020-0x202f]
[    0.184523] pci 0000:00:1f.2: reg 24 32bit mmio: [0x90445000-0x904453ff]
[    0.184553] pci 0000:00:1f.2: PME# supported from D3hot
[    0.184560] pci 0000:00:1f.2: PME# disabled
[    0.184624] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.184736] pci 0000:01:00.0: reg 10 64bit mmio: [0x90200000-0x90203fff]
[    0.184747] pci 0000:01:00.0: reg 18 io port: [0x1000-0x10ff]
[    0.184782] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfffe0000-0xffffffff]
[    0.184837] pci 0000:01:00.0: supports D1 D2
[    0.184840] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.184849] pci 0000:01:00.0: PME# disabled
[    0.184886] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.184994] pci 0000:00:1c.0: bridge io port: [0x1000-0x1fff]
[    0.184999] pci 0000:00:1c.0: bridge 32bit mmio: [0x90200000-0x902fffff]
[    0.185076] pci 0000:02:00.0: reg 10 64bit mmio: [0x90100000-0x9010ffff]
[    0.185206] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.185307] pci 0000:00:1c.1: bridge 32bit mmio: [0x90100000-0x901fffff]
[    0.185362] pci 0000:03:03.0: reg 10 32bit mmio: [0x90000000-0x90000fff]
[    0.185423] pci 0000:03:03.0: supports D1 D2
[    0.185426] pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
[    0.185434] pci 0000:03:03.0: PME# disabled
[    0.185497] pci 0000:00:1e.0: transparent bridge
[    0.185508] pci 0000:00:1e.0: bridge 32bit mmio: [0x90000000-0x900fffff]
[    0.185535] pci_bus 0000:00: on NUMA node 0
[    0.185540] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.185766] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.185851] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.185953] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.192396] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.192396] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.192396] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.192419] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.192524] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.192634] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.192741] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.192847] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.192903] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.192903] vgaarb: loaded
[    0.192903] SCSI subsystem initialized
[    0.192903] libata version 3.00 loaded.
[    0.192903] usbcore: registered new interface driver usbfs
[    0.192903] usbcore: registered new interface driver hub
[    0.192903] usbcore: registered new device driver usb
[    0.192903] PCI: Using ACPI for IRQ routing
[    0.200010] Switching to clocksource tsc
[    0.211886] pnp: PnP ACPI init
[    0.211914] ACPI: bus type pnp registered
[    0.213781] pnp 00:08: io resource (0x1640-0x164f) overlaps 0000:00:1c.0 BAR 7 (0x1000-0x1fff), disabling
[    0.213984] pnp: PnP ACPI: found 10 devices
[    0.213989] ACPI: ACPI bus type pnp unregistered
[    0.214004] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.214011] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.214017] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.214024] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.214031] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.214037] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.214048] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.214058] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.214064] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.214070] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.214076] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.214083] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.249225] pci 0000:01:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.249271] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.249278] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.249287] pci 0000:00:1c.0:   MEM window: 0x90200000-0x902fffff
[    0.249295] pci 0000:00:1c.0:   PREFETCH window: 0x90500000-0x906fffff
[    0.249304] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
[    0.249310] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
[    0.249319] pci 0000:00:1c.1:   MEM window: 0x90100000-0x901fffff
[    0.249327] pci 0000:00:1c.1:   PREFETCH window: 0x00000090700000-0x000000908fffff
[    0.249340] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.249344] pci 0000:00:1e.0:   IO window: disabled
[    0.249353] pci 0000:00:1e.0:   MEM window: 0x90000000-0x900fffff
[    0.249360] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.249382] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.249391] pci 0000:00:1c.0: setting latency timer to 64
[    0.249403] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.249411] pci 0000:00:1c.1: setting latency timer to 64
[    0.249475] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.249485] pci 0000:00:1e.0: setting latency timer to 64
[    0.249490] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.249494] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.249497] pci_bus 0000:01: resource 0 io:  [0x1000-0x1fff]
[    0.249501] pci_bus 0000:01: resource 1 mem: [0x90200000-0x902fffff]
[    0.249504] pci_bus 0000:01: resource 2 pref mem [0x90500000-0x906fffff]
[    0.249507] pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
[    0.249510] pci_bus 0000:02: resource 1 mem: [0x90100000-0x901fffff]
[    0.249514] pci_bus 0000:02: resource 2 pref mem [0x90700000-0x908fffff]
[    0.249517] pci_bus 0000:03: resource 1 mem: [0x90000000-0x900fffff]
[    0.249521] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.249524] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffff]
[    0.249561] NET: Registered protocol family 2
[    0.249652] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.249981] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.251079] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.251611] TCP: Hash tables configured (established 131072 bind 65536)
[    0.251617] TCP reno registered
[    0.251714] NET: Registered protocol family 1
[    0.251738] pci 0000:00:02.0: Boot video device
[    0.251752] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x1010
[    0.251755] pci 0000:00:1d.0: Performing full reset
[    0.251774] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.251777] pci 0000:00:1d.1: Performing full reset
[    0.251795] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.251798] pci 0000:00:1d.2: Performing full reset
[    0.251817] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
[    0.251819] pci 0000:00:1d.3: Performing full reset
[    0.253792] cpu0(2) debug files 133
[    0.254359] cpu1(2) debug files 133
[    0.254674] Scanning for low memory corruption every 60 seconds
[    0.255070] highmem bounce pool size: 64 pages
[    0.255078] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.259128] msgmni has been set to 1728
[    0.259513] alg: No test for stdrng (krng)
[    0.259638] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.259645] io scheduler noop registered
[    0.259650] io scheduler anticipatory registered
[    0.259654] io scheduler deadline registered
[    0.259727] io scheduler cfq registered (default)
[    0.259973] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.259985] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.260234] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.260245] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.260660] vesafb: framebuffer at 0x80000000, mapped to 0xf8080000, using 1536k, total 16064k
[    0.260668] vesafb: mode is 1024x768x8, linelength=1024, pages=19
[    0.260673] vesafb: scrolling: redraw
[    0.260679] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    0.268863] Console: switching to colour frame buffer device 128x48
[    0.278615] fb0: VESA VGA frame buffer device
[    0.278909] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.279033] ACPI: Power Button [PWRB]
[    0.279184] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.279293] ACPI: Power Button [PWRF]
[    0.279851] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    0.279993] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.280596] ACPI: SSDT 7eebac90 0022A (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
[    0.281036] ACPI: SSDT 7eeb9e10 001BA (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
[    0.281440] Monitor-Mwait will be used to enter C-1 state
[    0.281468] Monitor-Mwait will be used to enter C-2 state
[    0.281477] Marking TSC unstable due to TSC halts in idle
[    0.281651] Switching to clocksource hpet
[    0.281754] processor LNXCPU:00: registered as cooling_device0
[    0.282232] ACPI: SSDT 7eebaf10 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
[    0.282620] ACPI: SSDT 7eeb8f10 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
[    0.283192] processor LNXCPU:01: registered as cooling_device1
[    0.289492] Real Time Clock Driver v1.12b
[    0.289613] Non-volatile memory driver v1.3
[    0.289677] Linux agpgart interface v0.103
[    0.292622] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    0.296376] agpgart-intel 0000:00:00.0: detected 16124K stolen memory
[    0.302215] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.305259] [drm] Initialized drm 1.1.0 20060810
[    0.308134] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.311060] i915 0000:00:02.0: setting latency timer to 64
[    0.314569] [drm] set up 15M of stolen space
[    1.380944] [drm] TV-10: set mode NTSC 480i 0
[    1.543067] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[    1.544104] fb1: inteldrmfb frame buffer device
[    1.544959] registered panic notifier
[    1.545822] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.549275] brd: module loaded
[    1.550136] Uniform Multi-Platform E-IDE driver
[    1.551220] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
[    1.552134] PIIX_IDE 0000:00:1f.1: power state changed by ACPI to D0
[    1.553015] PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.553905] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    1.554785]     ide0: BM-DMA at 0x20c0-0x20c7
[    1.555673]     ide1: BM-DMA at 0x20c8-0x20cf
[    1.556536] Probing IDE interface ide0...
[    2.292345] hda: MATSHITADVD-R UJ-846, ATAPI CD/DVD-ROM drive
[    2.628095] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.628360] hda: UDMA/66 mode selected
[    2.629487] Probing IDE interface ide1...
[    3.196097] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.196971] ide1 at 0x170-0x177,0x376 on irq 15
[    3.198062] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.198933] ide-cd driver 5.00
[    3.200874] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[    3.201766] Uniform CD-ROM driver Revision: 3.20
[    3.217041] ata_piix 0000:00:1f.2: version 2.13
[    3.217055] ata_piix 0000:00:1f.2: enabling device (0005 -> 0007)
[    3.217926] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.218786] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    3.372025] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.372092] scsi0 : ata_piix
[    3.373067] scsi1 : ata_piix
[    3.374960] ata1: SATA max UDMA/133 cmd 0x20d8 ctl 0x20fc bmdma 0x2020 irq 19
[    3.375800] ata2: SATA max UDMA/133 cmd 0x20d0 ctl 0x20f8 bmdma 0x2028 irq 19
[    3.376785] sky2 driver version 1.25
[    3.377625] sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.378461] sky2 0000:01:00.0: setting latency timer to 64
[    3.378486] sky2 0000:01:00.0: Yukon-2 EC chip revision 2
[    3.379410] sky2 0000:01:00.0: irq 26 for MSI/MSI-X
[    3.379739] sky2 eth0: addr 00:16:cb:97:b9:60
[    3.380620] tun: Universal TUN/TAP device driver, 1.6
[    3.381436] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.382330] netconsole: local port 6665
[    3.383151] netconsole: local IP 192.168.0.14
[    3.383967] netconsole: interface eth0
[    3.384786] netconsole: remote port 6666
[    3.385591] netconsole: remote IP 192.168.0.104
[    3.386385] netconsole: remote ethernet address 00:1f:29:ae:fc:95
[    3.387179] netconsole: device eth0 not up yet, forcing it
[    3.389984] sky2 eth0: enabling interface
[    3.556517] ata1.01: ATA-7: FUJITSU MHV2080BHPL, 0081702E, max UDMA/100
[    3.557309] ata1.01: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.572534] ata1.01: configured for UDMA/100
[    3.573409] scsi 0:0:1:0: Direct-Access     ATA      FUJITSU MHV2080B 0081 PQ: 0 ANSI: 5
[    3.574519] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    3.575356] sd 0:0:1:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    3.576189] sd 0:0:1:0: [sda] Write Protect is off
[    3.576971] sd 0:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    3.576998] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.577945]  sda: sda1 sda2 sda3
[    4.086443] sd 0:0:1:0: [sda] Attached SCSI disk
[    6.527639] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[    6.775220] console [netcon0] enabled
[    6.776014] netconsole: network logging started
[    6.776956] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.777781] ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
[    6.777811] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.778642] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.778646] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.779537] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.780377] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    6.780383] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    6.780409] ehci_hcd 0000:00:1d.7: debug port 1
[    6.781233] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.785131] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.785134] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    6.785149] ehci_hcd 0000:00:1d.7: irq 21, io mem 0x90445400
[    6.785949] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.789827] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    6.801015] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.801821] usb usb1: default language 0x0409
[    6.801830] usb usb1: udev 1, busnum 1, minor = 0
[    6.801833] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.802617] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.803398] usb usb1: Product: EHCI Host Controller
[    6.804174] usb usb1: Manufacturer: Linux 2.6.32-rc8-gkh-00011-ga8a8a66-dirty ehci_hcd
[    6.804965] usb usb1: SerialNumber: 0000:00:1d.7
[    6.805821] usb usb1: uevent
[    6.805870] usb usb1: usb_probe_device
[    6.805874] usb usb1: configuration #1 chosen from 1 choice
[    6.806683] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.806699] usb 1-0:1.0: uevent
[    6.806751] hub 1-0:1.0: usb_probe_interface
[    6.806754] hub 1-0:1.0: usb_probe_interface - got id
[    6.806757] hub 1-0:1.0: USB hub found
[    6.807553] hub 1-0:1.0: 8 ports detected
[    6.808344] hub 1-0:1.0: standalone hub
[    6.808346] hub 1-0:1.0: no power switching (usb 1.0)
[    6.808349] hub 1-0:1.0: individual port over-current protection
[    6.808352] hub 1-0:1.0: power on to power good time: 20ms
[    6.808357] hub 1-0:1.0: local power source is good
[    6.808360] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.808472] uhci_hcd: USB Universal Host Controller Interface driver
[    6.809312] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.810112] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.810116] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.810980] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.811783] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.812577] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.812580] uhci_hcd 0000:00:1d.0: Performing full reset
[    6.812596] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.812602] uhci_hcd 0000:00:1d.0: irq 21, io base 0x000020a0
[    6.813434] usb usb2: default language 0x0409
[    6.813442] usb usb2: udev 1, busnum 2, minor = 128
[    6.813445] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.814239] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.815040] usb usb2: Product: UHCI Host Controller
[    6.815844] usb usb2: Manufacturer: Linux 2.6.32-rc8-gkh-00011-ga8a8a66-dirty uhci_hcd
[    6.816668] usb usb2: SerialNumber: 0000:00:1d.0
[    6.817562] usb usb2: uevent
[    6.817613] usb usb2: usb_probe_device
[    6.817616] usb usb2: configuration #1 chosen from 1 choice
[    6.818456] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.818473] usb 2-0:1.0: uevent
[    6.818529] hub 2-0:1.0: usb_probe_interface
[    6.818531] hub 2-0:1.0: usb_probe_interface - got id
[    6.818534] hub 2-0:1.0: USB hub found
[    6.819369] hub 2-0:1.0: 2 ports detected
[    6.820191] hub 2-0:1.0: standalone hub
[    6.820194] hub 2-0:1.0: no power switching (usb 1.0)
[    6.820196] hub 2-0:1.0: individual port over-current protection
[    6.820199] hub 2-0:1.0: power on to power good time: 2ms
[    6.820203] hub 2-0:1.0: local power source is good
[    6.820206] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.820253] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.821103] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.821107] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.822012] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    6.822853] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.823674] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.823676] uhci_hcd 0000:00:1d.1: Performing full reset
[    6.823693] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    6.823700] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002080
[    6.824539] usb usb3: default language 0x0409
[    6.824547] usb usb3: udev 1, busnum 3, minor = 256
[    6.824550] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.825374] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.826178] usb usb3: Product: UHCI Host Controller
[    6.826969] usb usb3: Manufacturer: Linux 2.6.32-rc8-gkh-00011-ga8a8a66-dirty uhci_hcd
[    6.827754] usb usb3: SerialNumber: 0000:00:1d.1
[    6.828585] usb usb3: uevent
[    6.828637] usb usb3: usb_probe_device
[    6.828640] usb usb3: configuration #1 chosen from 1 choice
[    6.829433] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    6.829449] usb 3-0:1.0: uevent
[    6.829504] hub 3-0:1.0: usb_probe_interface
[    6.829506] hub 3-0:1.0: usb_probe_interface - got id
[    6.829509] hub 3-0:1.0: USB hub found
[    6.830278] hub 3-0:1.0: 2 ports detected
[    6.831039] hub 3-0:1.0: standalone hub
[    6.831042] hub 3-0:1.0: no power switching (usb 1.0)
[    6.831044] hub 3-0:1.0: individual port over-current protection
[    6.831047] hub 3-0:1.0: power on to power good time: 2ms
[    6.831051] hub 3-0:1.0: local power source is good
[    6.831054] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    6.831098] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.831878] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.831882] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.832728] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    6.833525] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.834295] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.834298] uhci_hcd 0000:00:1d.2: Performing full reset
[    6.834314] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    6.834328] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002060
[    6.835122] usb usb4: default language 0x0409
[    6.835130] usb usb4: udev 1, busnum 4, minor = 384
[    6.835133] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.835910] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.836690] usb usb4: Product: UHCI Host Controller
[    6.837472] usb usb4: Manufacturer: Linux 2.6.32-rc8-gkh-00011-ga8a8a66-dirty uhci_hcd
[    6.838258] usb usb4: SerialNumber: 0000:00:1d.2
[    6.839080] usb usb4: uevent
[    6.839130] usb usb4: usb_probe_device
[    6.839133] usb usb4: configuration #1 chosen from 1 choice
[    6.839915] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    6.839931] usb 4-0:1.0: uevent
[    6.839986] hub 4-0:1.0: usb_probe_interface
[    6.839989] hub 4-0:1.0: usb_probe_interface - got id
[    6.839991] hub 4-0:1.0: USB hub found
[    6.840763] hub 4-0:1.0: 2 ports detected
[    6.841539] hub 4-0:1.0: standalone hub
[    6.841542] hub 4-0:1.0: no power switching (usb 1.0)
[    6.841544] hub 4-0:1.0: individual port over-current protection
[    6.841547] hub 4-0:1.0: power on to power good time: 2ms
[    6.841552] hub 4-0:1.0: local power source is good
[    6.841555] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    6.841599] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    6.842379] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    6.842384] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    6.843242] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    6.844030] uhci_hcd 0000:00:1d.3: detected 2 ports
[    6.844806] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    6.844809] uhci_hcd 0000:00:1d.3: Performing full reset
[    6.844826] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    6.844832] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002040
[    6.845646] usb usb5: default language 0x0409
[    6.845654] usb usb5: udev 1, busnum 5, minor = 512
[    6.845657] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.846435] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.847212] usb usb5: Product: UHCI Host Controller
[    6.847991] usb usb5: Manufacturer: Linux 2.6.32-rc8-gkh-00011-ga8a8a66-dirty uhci_hcd
[    6.848778] usb usb5: SerialNumber: 0000:00:1d.3
[    6.849657] usb usb5: uevent
[    6.849706] usb usb5: usb_probe_device
[    6.849709] usb usb5: configuration #1 chosen from 1 choice
[    6.850500] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    6.850516] usb 5-0:1.0: uevent
[    6.850571] hub 5-0:1.0: usb_probe_interface
[    6.850574] hub 5-0:1.0: usb_probe_interface - got id
[    6.850576] hub 5-0:1.0: USB hub found
[    6.851357] hub 5-0:1.0: 2 ports detected
[    6.852120] hub 5-0:1.0: standalone hub
[    6.852122] hub 5-0:1.0: no power switching (usb 1.0)
[    6.852125] hub 5-0:1.0: individual port over-current protection
[    6.852127] hub 5-0:1.0: power on to power good time: 2ms
[    6.852132] hub 5-0:1.0: local power source is good
[    6.852135] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    6.852302] usbcore: registered new interface driver libusual
[    6.853299] PNP: No PS/2 controller found. Probing ports directly.
[    6.854952] i8042.c: No controller found.
[    6.855802] mice: PS/2 mouse device common for all mice
[    6.857314] cpuidle: using governor ladder
[    6.858679] cpuidle: using governor menu
[    6.861597] usbcore: registered new interface driver usbhid
[    6.862361] usbhid: v2.6:USB HID core driver
[    6.863211] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    6.864662] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.865510] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.905072] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
[    6.905079] hub 1-0:1.0: port 3: status 0501 change 0001
[    6.905098] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
[    6.905106] hub 1-0:1.0: port 5: status 0501 change 0001
[    6.905121] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[    6.905128] hub 1-0:1.0: port 6: status 0501 change 0001
[    6.905143] ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001803 POWER sig=j CSC CONNECT
[    6.905150] hub 1-0:1.0: port 7: status 0501 change 0001
[    6.905165] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
[    6.905173] hub 1-0:1.0: port 8: status 0501 change 0001
[    6.917063] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.928055] uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
[    6.928135] hda_codec: STAC922x, Apple subsys_id=106b0800
[    6.936733] input: HDA Intel Line In at Ext Rear Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    6.937739] input: HDA Intel HP Out at Ext Rear Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    6.940008] ALSA device list:
[    6.940809]   #0: HDA Intel at 0x90440000 irq 22
[    6.942008] TCP cubic registered
[    6.942805] Initializing XFRM netlink socket
[    6.943605] NET: Registered protocol family 17
[    6.944411] Using IPI No-Shortcut mode
[    6.945213] uhci_hcd 0000:00:1d.2: port 1 portsc 008a,00
[    6.945229] uhci_hcd 0000:00:1d.2: port 2 portsc 008a,00
[    6.945516] registered taskstats version 1
[    6.949064] uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
[    6.949086] uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
[    6.970296] kjournald starting.  Commit interval 5 seconds
[    6.971220] EXT3-fs: mounted filesystem with writeback data mode.
[    6.972029] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    6.997304] devtmpfs: mounted
[    6.998253] Freeing unused kernel memory: 352k freed
[    7.004070] hub 1-0:1.0: state 7 ports 8 chg 01e8 evt 0000
[    7.004084] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    7.004099] ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
[    7.060054] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[    7.060088] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    7.116241] ehci_hcd 0000:00:1d.7: port 5 full speed --> companion
[    7.116250] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003801 POWER OWNER sig=j CONNECT
[    7.116258] hub 1-0:1.0: port 5 not reset yet, waiting 50ms
[    7.172061] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    7.172091] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    7.228242] ehci_hcd 0000:00:1d.7: port 6 high speed
[    7.228251] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    7.284053] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    7.340248] ehci_hcd 0000:00:1d.7: port 6 high speed
[    7.340258] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    7.416408] usb 1-6: udev 4, busnum 1, minor = 3
[    7.416412] usb 1-6: New USB device found, idVendor=05ac, idProduct=9130
[    7.417215] usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.418077] usb 1-6: uevent
[    7.792630] usb 1-6: usb_probe_device
[    7.792638] usb 1-6: configuration #1 chosen from 1 choice
[    7.793676] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    7.793712] usb 1-6:1.0: uevent
[    7.793880] hub 1-6:1.0: usb_probe_interface
[    7.793886] hub 1-6:1.0: usb_probe_interface - got id
[    7.793890] hub 1-6:1.0: USB hub found
[    7.795036] hub 1-6:1.0: 3 ports detected
[    7.796146] hub 1-6:1.0: compound device; port removable status: RFR
[    7.796148] hub 1-6:1.0: ganged power switching
[    7.796151] hub 1-6:1.0: global over-current protection
[    7.796306] hub 1-6:1.0: TT per port
[    7.796311] hub 1-6:1.0: TT requires at most 8 FS bit times (666 ns)
[    7.796316] hub 1-6:1.0: power on to power good time: 100ms
[    7.796529] hub 1-6:1.0: local power source is good
[    7.796534] hub 1-6:1.0: no over-current condition exists
[    7.796538] hub 1-6:1.0: enabling power on all ports
[    7.796943] hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
[    7.840062] usb usb2: suspend_rh (auto-stop)
[    7.852266] ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
[    7.852276] ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003801 POWER OWNER sig=j CONNECT
[    7.852284] hub 1-0:1.0: port 7 not reset yet, waiting 50ms
[    7.896168] hub 1-6:1.0: port 1: status 0101 change 0001
[    7.896420] hub 1-6:1.0: port 2: status 0101 change 0001
[    7.908049] ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
[    7.908081] hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
[    7.964269] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[    7.964278] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
[    7.964286] hub 1-0:1.0: port 8 not reset yet, waiting 50ms
[    7.996047] usb 1-6: link qh256-0001/f72d0cc0 start 1 [1/0 us]
[    8.020047] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
[    8.020075] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
[    8.020086] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    8.020098] uhci_hcd 0000:00:1d.1: port 1 portsc 01a3,00
[    8.020109] hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    8.148050] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    8.260049] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    8.414621] usb 3-1: skipped 1 descriptor after interface
[    8.422612] usb 3-1: default language 0x0409
[    8.441611] usb 3-1: udev 2, busnum 3, minor = 257
[    8.441618] usb 3-1: New USB device found, idVendor=045e, idProduct=0023
[    8.442588] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.443418] usb 3-1: Product: Microsoft Trackball Optical®
[    8.444267] usb 3-1: Manufacturer: Microsoft
[    8.445204] usb 3-1: uevent
[    8.445385] usb 3-1: usb_probe_device
[    8.445389] usb 3-1: configuration #1 chosen from 1 choice
[    8.448618] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    8.448652] usb 3-1:1.0: uevent
[    8.448810] usbhid 3-1:1.0: usb_probe_interface
[    8.448815] usbhid 3-1:1.0: usb_probe_interface - got id
[    8.464230] input: Microsoft Microsoft Trackball Optical® as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input5
[    8.465867] generic-usb 0003:045E:0023.0001: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft Trackball Optical®] on usb-0000:00:1d.1-1/input0
[    8.467705] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    8.467716] uhci_hcd 0000:00:1d.2: port 1 portsc 0093,00
[    8.467724] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    8.596045] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    8.708047] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    8.844042] usb 4-1: ep0 maxpacket = 8
[    8.861219] usb 4-1: udev 2, busnum 4, minor = 385
[    8.861226] usb 4-1: New USB device found, idVendor=045e, idProduct=001c
[    8.862255] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.863209] usb 4-1: uevent
[    8.863378] usb 4-1: usb_probe_device
[    8.863382] usb 4-1: configuration #1 chosen from 1 choice
[    8.867213] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    8.867249] usb 4-1:1.0: uevent
[    8.867431] hub 4-1:1.0: usb_probe_interface
[    8.867436] hub 4-1:1.0: usb_probe_interface - got id
[    8.867441] hub 4-1:1.0: USB hub found
[    8.870207] hub 4-1:1.0: 3 ports detected
[    8.871142] hub 4-1:1.0: compound device; port removable status: FRR
[    8.871144] hub 4-1:1.0: individual port power switching
[    8.871147] hub 4-1:1.0: individual port over-current protection
[    8.871150] hub 4-1:1.0: power on to power good time: 100ms
[    8.872205] hub 4-1:1.0: hub controller current requirement: 64mA
[    8.872210] hub 4-1:1.0: 100mA bus power budget for each child
[    8.873205] hub 4-1:1.0: enabling power on all ports
[    8.876254] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    8.876267] uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
[    8.876281] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    8.977218] hub 4-1:1.0: port 1: status 0301 change 0001
[    9.004047] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    9.080122] uhci_hcd 0000:00:1d.2: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    9.116045] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    9.297757] usb 5-1: skipped 1 descriptor after interface
[    9.297766] usb 5-1: udev 2, busnum 5, minor = 513
[    9.297772] usb 5-1: New USB device found, idVendor=05ac, idProduct=1000
[    9.298826] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.299810] usb 5-1: uevent
[    9.299968] usb 5-1: usb_probe_device
[    9.299972] usb 5-1: configuration #1 chosen from 1 choice
[    9.304753] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    9.304802] usb 5-1:1.0: uevent
[    9.304990] usbhid 5-1:1.0: usb_probe_interface
[    9.304996] usbhid 5-1:1.0: usb_probe_interface - got id
[    9.305001] usbhid 5-1:1.0: couldn't find an input interrupt endpoint
[    9.306057] uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
[    9.306066] hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    9.432055] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    9.544047] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    9.680041] usb 5-2: ep0 maxpacket = 8
[    9.705765] usb 5-2: skipped 1 descriptor after interface
[    9.710759] usb 5-2: default language 0x0409
[    9.728770] usb 5-2: udev 3, busnum 5, minor = 514
[    9.728778] usb 5-2: New USB device found, idVendor=05ac, idProduct=8240
[    9.729860] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.730728] usb 5-2: Product: IR Receiver
[    9.731597] usb 5-2: Manufacturer: Apple Computer, Inc.
[    9.732555] usb 5-2: uevent
[    9.732694] usb 5-2: usb_probe_device
[    9.732699] usb 5-2: configuration #1 chosen from 1 choice
[    9.735804] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    9.735839] usb 5-2:1.0: uevent
[    9.736050] usbhid 5-2:1.0: usb_probe_interface
[    9.736053] usbhid 5-2:1.0: usb_probe_interface - got id
[    9.743895] generic-usb 0003:05AC:8240.0002: hidraw1: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
[    9.745783] hub 1-6:1.0: state 7 ports 3 chg 0006 evt 0000
[    9.745848] hub 1-6:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    9.816240] usb 1-6.1: new high speed USB device using ehci_hcd and address 7
[    9.832102] hub 1-6:1.0: port 1 not reset yet, waiting 10ms
[    9.925612] usb 1-6.1: udev 7, busnum 1, minor = 6
[    9.925619] usb 1-6.1: New USB device found, idVendor=050d, idProduct=0706
[    9.926829] usb 1-6.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.927867] usb 1-6.1: uevent
[    9.927970] usb 1-6.1: usb_probe_device
[    9.927974] usb 1-6.1: configuration #1 chosen from 1 choice
[    9.929229] usb 1-6.1: adding 1-6.1:1.0 (config #1, interface 0)
[    9.929254] usb 1-6.1:1.0: uevent
[    9.930439] hub 1-6.1:1.0: usb_probe_interface
[    9.930443] hub 1-6.1:1.0: usb_probe_interface - got id
[    9.930446] hub 1-6.1:1.0: USB hub found
[    9.931972] hub 1-6.1:1.0: 4 ports detected
[    9.932949] hub 1-6.1:1.0: standalone hub
[    9.932952] hub 1-6.1:1.0: ganged power switching
[    9.932954] hub 1-6.1:1.0: global over-current protection
[    9.932956] hub 1-6.1:1.0: Single TT
[    9.932959] hub 1-6.1:1.0: TT requires at most 32 FS bit times (2664 ns)
[    9.932962] hub 1-6.1:1.0: Port indicators are supported
[    9.932965] hub 1-6.1:1.0: power on to power good time: 100ms
[    9.933344] hub 1-6.1:1.0: local power source is good
[    9.933347] hub 1-6.1:1.0: no over-current condition exists
[    9.933350] hub 1-6.1:1.0: enabling power on all ports
[    9.934469] hub 1-6:1.0: port 2, status 0101, change 0000, 12 Mb/s
[   10.008127] usb 1-6.2: new full speed USB device using ehci_hcd and address 8
[   10.033115] hub 1-6.1:1.0: port 4: status 0101 change 0001
[   10.102200] usb 1-6.2: ep0 maxpacket = 8
[   10.104361] usb 1-6.2: skipped 1 descriptor after interface
[   10.104726] usb 1-6.2: default language 0x0409
[   10.108034] usb 1-6.2: udev 8, busnum 1, minor = 7
[   10.108038] usb 1-6.2: New USB device found, idVendor=05ac, idProduct=9222
[   10.109043] usb 1-6.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.109980] usb 1-6.2: Product: Apple Cinema Display
[   10.110937] usb 1-6.2: Manufacturer: Apple Computer, Inc.
[   10.116123] usb 1-6.2: uevent
[   10.117230] usb 1-6.2: usb_probe_device
[   10.117238] usb 1-6.2: configuration #1 chosen from 1 choice
[   10.118612] usb 1-6.2: adding 1-6.2:1.0 (config #1, interface 0)
[   10.118644] usb 1-6.2:1.0: uevent
[   10.118753] usbhid 1-6.2:1.0: usb_probe_interface
[   10.118757] usbhid 1-6.2:1.0: usb_probe_interface - got id
[   10.133936] usb 1-6.1: link qh256-0001/f6b78540 start 2 [1/0 us]
[   10.133950] generic-usb 0003:05AC:9222.0003: hidraw2: USB HID v1.11 Device [Apple Computer, Inc. Apple Cinema Display] on usb-0000:00:1d.7-6.2/input0
[   10.136058] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   10.136074] hub 4-1:1.0: state 7 ports 3 chg 0002 evt 0000
[   10.137927] hub 4-1:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[   10.209249] usb 4-1.1: new low speed USB device using uhci_hcd and address 3
[   10.329266] usb 4-1.1: skipped 1 descriptor after interface
[   10.329274] usb 4-1.1: skipped 1 descriptor after interface
[   10.337264] usb 4-1.1: default language 0x0409
[   10.349262] usb 4-1.1: udev 3, busnum 4, minor = 386
[   10.349268] usb 4-1.1: New USB device found, idVendor=045e, idProduct=001d
[   10.350396] usb 4-1.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   10.351352] usb 4-1.1: Product: Microsoft Natural Keyboard Pro
[   10.352405] usb 4-1.1: uevent
[   10.352565] usb 4-1.1: usb_probe_device
[   10.352570] usb 4-1.1: configuration #1 chosen from 1 choice
[   10.368257] usb 4-1.1: adding 4-1.1:1.0 (config #1, interface 0)
[   10.380268] usb 4-1.1:1.0: uevent
[   10.380450] usbhid 4-1.1:1.0: usb_probe_interface
[   10.380454] usbhid 4-1.1:1.0: usb_probe_interface - got id
[   10.393683] input: Microsoft Natural Keyboard Pro as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1.1/4-1.1:1.0/input/input6
[   10.394657] uhci_hcd 0000:00:1d.2: reserve dev 3 ep81-INT, period 8, phase 4, 118 us
[   10.397852] generic-usb 0003:045E:001D.0004: input,hidraw3: USB HID v1.10 Keyboard [Microsoft Natural Keyboard Pro] on usb-0000:00:1d.2-1.1/input0
[   10.399879] usb 4-1.1: adding 4-1.1:1.1 (config #1, interface 1)
[   10.411527] usb 4-1.1:1.1: uevent
[   10.412673] usbhid 4-1.1:1.1: usb_probe_interface
[   10.412678] usbhid 4-1.1:1.1: usb_probe_interface - got id
[   10.436628] input: Microsoft Natural Keyboard Pro as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1.1/4-1.1:1.1/input/input7
[   10.437707] uhci_hcd 0000:00:1d.2: reserve dev 3 ep82-INT, period 8, phase 4, 87 us
[   10.439723] generic-usb 0003:045E:001D.0005: input,hidraw4: USB HID v1.10 Device [Microsoft Natural Keyboard Pro] on usb-0000:00:1d.2-1.1/input1
[   10.441916] hub 4-1:1.0: 336mA power budget left
[   10.441921] hub 1-6:1.0: state 7 ports 3 chg 0000 evt 0002
[   10.442030] hub 1-6.1:1.0: state 7 ports 4 chg 0010 evt 0000
[   10.442360] hub 1-6.1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[   10.512386] usb 1-6.1.4: new high speed USB device using ehci_hcd and address 9
[   10.605633] usb 1-6.1.4: udev 9, busnum 1, minor = 8
[   10.605638] usb 1-6.1.4: New USB device found, idVendor=050d, idProduct=706a
[   10.606830] usb 1-6.1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   10.608182] usb 1-6.1.4: uevent
[   10.619173] usb 1-6.1.4: usb_probe_device
[   10.619179] usb 1-6.1.4: configuration #1 chosen from 1 choice
[   10.620631] usb 1-6.1.4: adding 1-6.1.4:1.0 (config #1, interface 0)
[   10.620667] usb 1-6.1.4:1.0: uevent
[   10.627674] hub 1-6.1.4:1.0: usb_probe_interface
[   10.627681] hub 1-6.1.4:1.0: usb_probe_interface - got id
[   10.627684] hub 1-6.1.4:1.0: USB hub found
[   10.629503] hub 1-6.1.4:1.0: 4 ports detected
[   10.630651] hub 1-6.1.4:1.0: standalone hub
[   10.630654] hub 1-6.1.4:1.0: ganged power switching
[   10.630657] hub 1-6.1.4:1.0: global over-current protection
[   10.630659] hub 1-6.1.4:1.0: Single TT
[   10.630662] hub 1-6.1.4:1.0: TT requires at most 32 FS bit times (2664 ns)
[   10.630665] hub 1-6.1.4:1.0: Port indicators are supported
[   10.630667] hub 1-6.1.4:1.0: power on to power good time: 100ms
[   10.631167] hub 1-6.1.4:1.0: local power source is good
[   10.631171] hub 1-6.1.4:1.0: no over-current condition exists
[   10.631174] hub 1-6.1.4:1.0: enabling power on all ports
[   10.733271] usb 1-6.1.4: link qh256-0001/f72d0800 start 3 [1/0 us]
[   10.733288] hub 1-6.1.4:1.0: state 7 ports 4 chg 0000 evt 0000
[   15.777149] udev: starting version 147
[   15.975683] usb usb2: uevent
[   15.975797] usb 2-0:1.0: uevent
[   15.976154] usb usb3: uevent
[   15.976266] usb 3-0:1.0: uevent
[   15.976366] usb 3-1: uevent
[   15.976470] usb 3-1:1.0: uevent
[   15.977445] usb usb4: uevent
[   15.977568] usb 4-0:1.0: uevent
[   15.977679] usb 4-1: uevent
[   15.981333] usb 4-1.1: uevent
[   15.981465] usb 4-1.1:1.0: uevent
[   15.982121] usb 4-1.1:1.1: uevent
[   15.982797] usb 4-1:1.0: uevent
[   15.983241] usb usb5: uevent
[   15.983384] usb 5-0:1.0: uevent
[   15.983513] usb 5-1: uevent
[   15.983648] usb 5-1:1.0: uevent
[   15.983778] usb 5-2: uevent
[   15.983910] usb 5-2:1.0: uevent
[   15.989700] usb usb1: uevent
[   15.993045] usb 1-0:1.0: uevent
[   15.993209] usb 1-6: uevent
[   15.993362] usb 1-6.1: uevent
[   15.993510] usb 1-6.1.4: uevent
[   15.993657] usb 1-6.1.4:1.0: uevent
[   15.993807] usb 1-6.1:1.0: uevent
[   15.997551] usb 1-6.2: uevent
[   15.997712] usb 1-6.2:1.0: uevent
[   15.998210] usb 1-6:1.0: uevent
[   16.158872] usb usb3: uevent
[   16.159860] usb usb1: uevent
[   16.160603] usb usb5: uevent
[   16.161307] usb usb4: uevent
[   16.161997] usb usb2: uevent
[   16.193996] usb 3-1: uevent
[   16.197656] usb 4-1: uevent
[   16.217870] usb 5-1: uevent
[   16.222472] usb 5-2: uevent
[   16.224039] usb 1-6: uevent
[   16.229889] usb 4-1.1: uevent
[   16.241657] usb 1-6.1: uevent
[   16.252559] usb 1-6.2: uevent
[   16.253786] usb 3-1:1.0: uevent
[   16.253907] usb 3-1: uevent
[   16.260636] usb 3-1:1.0: uevent
[   16.260750] usb 3-1: uevent
[   16.265585] usb 1-6.1.4: uevent
[   16.289707] usb 4-1.1:1.1: uevent
[   16.289836] usb 4-1.1: uevent
[   16.292748] usb 4-1.1:1.0: uevent
[   16.292894] usb 4-1.1: uevent
[   16.507527] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   16.564116] usb 5-1: uevent
[   16.575959] usb 5-1: uhci_result_common: failed with status 440000
[   16.575974] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
[   16.579134] usb 3-1:1.0: uevent
[   16.579760] usb 3-1:1.0: uevent
[   16.580799] usb 4-1.1:1.0: uevent
[   16.584670] usb 4-1.1:1.1: uevent
[   16.613036] hub 1-0:1.0: state 7 ports 8 chg 0000 evt ff80
[   16.613051] ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001803 POWER sig=j CSC CONNECT
[   16.613061] hub 1-0:1.0: port 7, status 0501, change 0001, 480 Mb/s
[   16.740024] hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x501
[   16.796179] ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
[   16.796186] ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003801 POWER OWNER sig=j CONNECT
[   16.796191] hub 1-0:1.0: port 7 not reset yet, waiting 50ms
[   16.852026] ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
[   16.852058] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   16.852068] uhci_hcd 0000:00:1d.3: port 1 portsc 009b,00
[   16.852078] hub 5-0:1.0: port 1, status 0101, change 0003, 12 Mb/s
[   16.852082] usb 5-1: USB disconnect, address 2
[   16.852085] usb 5-1: unregistering device
[   16.852087] usb 5-1: usb_disable_device nuking all URBs
[   16.852093] usb 5-1: unregistering interface 5-1:1.0
[   16.852119] usb 5-1:1.0: uevent
[   16.852212] usb 5-1: uevent
[   16.980028] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[   17.092022] usb 5-1: new full speed USB device using uhci_hcd and address 4
[   17.290017] usb 5-1: skipped 1 descriptor after interface
[   17.290026] usb 5-1: udev 4, busnum 5, minor = 515
[   17.290032] usb 5-1: New USB device found, idVendor=05ac, idProduct=8205
[   17.290038] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   17.290159] usb 5-1: uevent
[   17.290189] usb 5-1: usb_probe_device
[   17.290195] usb 5-1: configuration #1 chosen from 1 choice
[   17.291131] usb 5-1: uevent
[   17.294015] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[   17.294052] usb 5-1:1.0: uevent
[   17.294138] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[   17.294168] usb 5-1:1.1: uevent
[   17.294229] usb 5-1: adding 5-1:1.2 (config #1, interface 2)
[   17.294259] usb 5-1:1.2: uevent
[   17.294309] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
[   77.664124] EXT3 FS on sda3, internal journal
[   84.056928] Adding 1999992k swap on /swapfile.  Priority:-1 extents:507 across:2517020k 
[  348.143053] [drm] TMDS-8: set mode 1680x1050 1c
[  349.241305] [drm] TV-10: set mode NTSC 480i 0
[  349.420986] [drm] TV-10: set mode NTSC 480i 0
[  350.277940] [drm] TV-10: set mode NTSC 480i 0
[  350.458473] [drm] TV-10: set mode NTSC 480i 0
[  712.764232] SysRq : Show State
[  712.764248]   task                PC stack   pid father
[  712.764254] init          S 000000a4     0     1      0 0x00000000
[  712.764263]  f7023adc 00000086 f1402ba0 000000a4 00000000 f7023ae8 c2803dbc c15e0580
[  712.764276]  c15e0580 c15e0580 c15dba98 f7030000 f703028c c2808580 00000000 1b468e55
[  712.764289]  000000a6 f7023ae8 f72d8000 00000000 c2803a98 f703028c 00018ec3 ffffffff
[  712.764302] Call Trace:
[  712.764318]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.764327]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.764336]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.764343]  [<c10b0a65>] do_select+0x53a/0x593
[  712.764351]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.764359]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.764368]  [<c10c0aa2>] ? __find_get_block+0x141/0x14b
[  712.764376]  [<c10ea905>] ? ext3_get_blocks_handle+0x86/0x7c4
[  712.764384]  [<c10455b6>] ? wake_up_bit+0x5c/0x61
[  712.764393]  [<c10ffd38>] ? do_get_write_access+0x382/0x3ba
[  712.764410]  [<c1018dbe>] ? hpet_legacy_next_event+0xa/0xc
[  712.764416]  [<c104f550>] ? clockevents_program_event+0xd4/0xe3
[  712.764420]  [<c10503be>] ? tick_dev_program_event+0x28/0x95
[  712.764424]  [<c104fe4a>] ? tick_handle_oneshot_broadcast+0xd5/0xec
[  712.764430]  [<c1004eb1>] ? timer_interrupt+0x35/0x3c
[  712.764434]  [<c105d37b>] ? handle_IRQ_event+0x4d/0xfe
[  712.764439]  [<c105e87e>] ? handle_edge_irq+0xe5/0x106
[  712.764443]  [<c10b28b8>] ? __d_lookup+0xa4/0xd8
[  712.764448]  [<c10aab8d>] ? do_lookup+0x4f/0x14e
[  712.764452]  [<c10b2ceb>] ? dput+0x25/0x109
[  712.764456]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.764460]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.764465]  [<c10aaa4c>] ? path_put+0x20/0x23
[  712.764469]  [<c10ad292>] ? user_path_at+0x4a/0x67
[  712.764473]  [<c114b134>] ? copy_to_user+0x2c/0xfc
[  712.764477]  [<c10a61d4>] ? cp_new_stat64+0xe4/0xf6
[  712.764482]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.764486]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.764490]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.764493] kthreadd      S 00000012     0     2      0 0x00000000
[  712.764498]  f703bfc8 00000046 aaec7e3b 00000012 f70c2550 00000000 00800711 c15e0580
[  712.764505]  c15e0580 c15e0580 00000000 f7030c70 f7030efc c2a08580 00000001 aaecb4c3
[  712.764512]  00000012 f7289f24 f61601c0 00000000 00000000 f7030efc 0000007b 0000007b
[  712.764519] Call Trace:
[  712.764523]  [<c1003488>] ? kernel_thread_helper+0x0/0x10
[  712.764527]  [<c10452bf>] kthreadd+0x53/0xb8
[  712.764531]  [<c104526c>] ? kthreadd+0x0/0xb8
[  712.764535]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764537] migration/0   S 000000a4     0     3      2 0x00000000
[  712.764542]  f7041f90 00000046 e90ca63e 000000a4 c28085c0 00000000 00000000 c15e0580
[  712.764549]  c15e0580 c15e0580 c15dba98 f70318e0 f7031b6c c2808580 00000000 00000002
[  712.764556]  00000002 f7034aa0 f6412000 f6af3e30 c2803a98 f7031b6c 00018eb8 e26bbf54
[  712.764562] Call Trace:
[  712.764567]  [<c102c070>] migration_thread+0x160/0x21a
[  712.764571]  [<c102bf10>] ? migration_thread+0x0/0x21a
[  712.764575]  [<c1045385>] kthread+0x61/0x66
[  712.764579]  [<c1045324>] ? kthread+0x0/0x66
[  712.764583]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764585] ksoftirqd/0   S 000000a3     0     4      2 0x00000000
[  712.764590]  f7043fa0 00000046 43cb223e 000000a3 000000d0 f6a51430 f7043f68 c15e0580
[  712.764597]  c15e0580 c15e0580 c15dba98 f7032550 f70327dc c2808580 00000000 c1636b90
[  712.764604]  f7043f54 f7043f54 f6412540 00000001 c2803a98 f70327dc 000187d0 c15dbcac
[  712.764610] Call Trace:
[  712.764615]  [<c1034776>] ksoftirqd+0x2e/0xae
[  712.764619]  [<c1034748>] ? ksoftirqd+0x0/0xae
[  712.764623]  [<c1045385>] kthread+0x61/0x66
[  712.764626]  [<c1045324>] ? kthread+0x0/0x66
[  712.764630]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764633] migration/1   S 000000a3     0     5      2 0x00000000
[  712.764637]  f7045f90 00000046 ed26d93c 000000a3 c2a085c0 00000000 00000000 c15e0580
[  712.764644]  c15e0580 c15e0580 c15dba98 f70331c0 f703344c c2a08580 00000001 00000002
[  712.764651]  00000002 c15077a0 f6413a40 f6af3e30 c2a03a98 f703344c 00018a97 e268ff54
[  712.764658] Call Trace:
[  712.764662]  [<c102c070>] migration_thread+0x160/0x21a
[  712.764666]  [<c102bf10>] ? migration_thread+0x0/0x21a
[  712.764670]  [<c1045385>] kthread+0x61/0x66
[  712.764674]  [<c1045324>] ? kthread+0x0/0x66
[  712.764678]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764680] ksoftirqd/1   S 000000a4     0     6      2 0x00000000
[  712.764685]  f7047fa0 00000046 322af3c9 000000a4 f7047f2c c103a66f f7047f68 c15e0580
[  712.764692]  c15e0580 c15e0580 f70c2550 f7033e30 f70340bc c2a08580 00000001 322b035b
[  712.764698]  000000a4 f7047f54 f61a76c0 00000001 00000046 f70340bc c1034715 c15dbcac
[  712.764705] Call Trace:
[  712.764710]  [<c103a66f>] ? process_timeout+0x8/0xa
[  712.764714]  [<c1034715>] ? __do_softirq+0x13c/0x144
[  712.764718]  [<c1034776>] ksoftirqd+0x2e/0xae
[  712.764722]  [<c1034748>] ? ksoftirqd+0x0/0xae
[  712.764725]  [<c1045385>] kthread+0x61/0x66
[  712.764729]  [<c1045324>] ? kthread+0x0/0x66
[  712.764733]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764736] events/0      S 000000a5     0     7      2 0x00000000
[  712.764740]  f7079f74 00000046 f40c068f 000000a5 c15077a0 00000282 f7079f18 c15e0580
[  712.764747]  c15e0580 c15e0580 c15dba98 f7035710 f703599c c2808580 00000000 00000286
[  712.764754]  f6b6a2e8 00000000 f6412540 00000286 c2803a98 f703599c 00019318 c11a57e6
[  712.764761] Call Trace:
[  712.764766]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.764771]  [<c11a5fde>] ? flush_to_ldisc+0x15b/0x163
[  712.764776]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.764780]  [<c11a5e83>] ? flush_to_ldisc+0x0/0x163
[  712.764784]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.764789]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.764793]  [<c1045385>] kthread+0x61/0x66
[  712.764796]  [<c1045324>] ? kthread+0x0/0x66
[  712.764800]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764803] events/1      S 000000a5     0     8      2 0x00000000
[  712.764807]  f707df74 00000046 d5d3e889 000000a5 f7034aa0 00000286 f707df18 c15e0580
[  712.764814]  c15e0580 c15e0580 c15dba98 f7036380 f703660c c2a08580 00000001 00000282
[  712.764821]  f6b6a2e0 00000000 f6413180 00000282 c2a03a98 f703660c 00019299 c11a57e6
[  712.764828] Call Trace:
[  712.764832]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.764836]  [<c11a5fde>] ? flush_to_ldisc+0x15b/0x163
[  712.764841]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.764845]  [<c11a5e83>] ? flush_to_ldisc+0x0/0x163
[  712.764849]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.764853]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.764857]  [<c1045385>] kthread+0x61/0x66
[  712.764861]  [<c1045324>] ? kthread+0x0/0x66
[  712.764865]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764867] khelper       S 00000085     0     9      2 0x00000000
[  712.764872]  f707ff74 00000046 b61c29ab 00000085 f707ff64 c100172a 00000000 c15e0580
[  712.764879]  c15e0580 c15e0580 00000011 f7036ff0 f703727c c2808580 00000000 b61c823f
[  712.764885]  00000085 00000000 f64136c0 0000007b 000000d8 f703727c ffffffff c1003488
[  712.764892] Call Trace:
[  712.764896]  [<c100172a>] ? kernel_thread+0x7c/0x84
[  712.764900]  [<c1003488>] ? kernel_thread_helper+0x0/0x10
[  712.764904]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.764909]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.764913]  [<c1040ff4>] ? __call_usermodehelper+0x0/0x59
[  712.764917]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.764922]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.764925]  [<c1045385>] kthread+0x61/0x66
[  712.764929]  [<c1045324>] ? kthread+0x0/0x66
[  712.764933]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764936] async/mgr     S 00000000     0    14      2 0x00000000
[  712.764940]  f70bbf90 00000046 d50d912c 00000000 ffffffff 81207ab9 00000000 c15e0580
[  712.764947]  c15e0580 c15e0580 f70bbf58 f70c0000 f70c028c c2a08580 00000001 d50d9f33
[  712.764954]  00000000 f70c002c c15142e0 00000001 00000286 f70c028c c102ba7c 00004b9d
[  712.764961] Call Trace:
[  712.764965]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.764970]  [<c104a24c>] async_manager_thread+0x98/0xb8
[  712.764973]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.764977]  [<c104a1b4>] ? async_manager_thread+0x0/0xb8
[  712.764981]  [<c1045385>] kthread+0x61/0x66
[  712.764985]  [<c1045324>] ? kthread+0x0/0x66
[  712.764989]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.764992] pm            S 00000000     0    15      2 0x00000000
[  712.764996]  f70bdf74 00000046 0992219a 00000000 00000400 00000400 00000000 c15e0580
[  712.765003]  c15e0580 c15e0580 c15dba98 f70c0c70 f70c0efc c2a08580 00000001 c15142e0
[  712.765010]  f70c0c70 f70bdfb8 c15142e0 0992219a c2a03a98 f70c0efc fffedb31 c102ba7c
[  712.765017] Call Trace:
[  712.765021]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.765025]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765030]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765034]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765038]  [<c1045385>] kthread+0x61/0x66
[  712.765042]  [<c1045324>] ? kthread+0x0/0x66
[  712.765046]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765048] sync_supers   S 000000a5     0   169      2 0x00000000
[  712.765052]  f7285fa8 00000046 c6829527 000000a5 c15077a0 c13404ce 0a04177e c15e0580
[  712.765059]  c15e0580 c15e0580 c15dba98 f70c18e0 f70c1b6c c2808580 00000000 c682aae7
[  712.765066]  000000a5 c2a08580 f6412540 f7023f7c c2803a98 f70c1b6c 000173b7 f7285f9c
[  712.765073] Call Trace:
[  712.765077]  [<c13404ce>] ? schedule+0x905/0x9b2
[  712.765082]  [<c1088acb>] ? bdi_sync_supers+0x0/0x39
[  712.765086]  [<c1088af0>] bdi_sync_supers+0x25/0x39
[  712.765090]  [<c1045385>] kthread+0x61/0x66
[  712.765094]  [<c1045324>] ? kthread+0x0/0x66
[  712.765098]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765101] bdi-default   S 000000a5     0   171      2 0x00000000
[  712.765105]  f7289f08 00000046 5c2ce480 000000a5 f7034aa0 e416af37 00000000 c15e0580
[  712.765112]  c15e0580 c15e0580 c15dba98 f70c2550 f70c27dc c2a08580 00000001 08211381
[  712.765119]  000000a3 00000000 f6413180 00000286 c2a03a98 f70c27dc 00019093 ffffffff
[  712.765126] Call Trace:
[  712.765130]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.765135]  [<c13409fa>] schedule_timeout+0x1b8/0x1de
[  712.765139]  [<c103a667>] ? process_timeout+0x0/0xa
[  712.765144]  [<c10893c2>] bdi_forker_task+0x158/0x26b
[  712.765148]  [<c108926a>] ? bdi_forker_task+0x0/0x26b
[  712.765152]  [<c1045385>] kthread+0x61/0x66
[  712.765156]  [<c1045324>] ? kthread+0x0/0x66
[  712.765160]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765162] kintegrityd/0 S 00000000     0   172      2 0x00000000
[  712.765167]  f728bf74 00000046 0a04177e 00000000 00000400 00000400 00000000 c15e0580
[  712.765174]  c15e0580 c15e0580 c15dba98 f70c31c0 f70c344c c2808580 00000000 c15142e0
[  712.765180]  f70c31c0 f728bfb8 c15142e0 0a04177e c2803a98 f70c344c fffedb33 c102ba7c
[  712.765187] Call Trace:
[  712.765191]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.765196]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765200]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765204]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765208]  [<c1045385>] kthread+0x61/0x66
[  712.765212]  [<c1045324>] ? kthread+0x0/0x66
[  712.765216]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765219] kintegrityd/1 S 00000000     0   173      2 0x00000000
[  712.765223]  f7293f74 00000046 0a04177e 00000000 00000400 00000400 00000000 c15e0580
[  712.765230]  c15e0580 c15e0580 c15dba98 f70c3e30 f70c40bc c2a08580 00000001 c15142e0
[  712.765237]  f70c3e30 f7293fb8 c15142e0 0a04177e c2a03a98 f70c40bc fffedb32 c102ba7c
[  712.765244] Call Trace:
[  712.765247]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.765252]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765256]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765261]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765265]  [<c1045385>] kthread+0x61/0x66
[  712.765269]  [<c1045324>] ? kthread+0x0/0x66
[  712.765272]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765275] kblockd/0     S 000000a1     0   175      2 0x00000000
[  712.765279]  f7297f74 00000046 de20ad3f 000000a1 c15077a0 00000000 f716a400 c15e0580
[  712.765286]  c15e0580 c15e0580 c15dba98 f70c4aa0 f70c4d2c c2808580 00000000 c11ee2c6
[  712.765293]  f7297f54 c12090de f6412540 f733c4ac c2803a98 f70c4d2c 000181df 00000000
[  712.765300] Call Trace:
[  712.765305]  [<c11ee2c6>] ? put_device+0xf/0x11
[  712.765311]  [<c12090de>] ? scsi_request_fn+0x3d0/0x47d
[  712.765315]  [<c1131ade>] ? elv_queue_empty+0x20/0x22
[  712.765320]  [<c113817f>] ? __blk_run_queue+0x20/0x136
[  712.765324]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765329]  [<c11420ed>] ? cfq_kick_queue+0x0/0x2a
[  712.765333]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765337]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765341]  [<c1045385>] kthread+0x61/0x66
[  712.765345]  [<c1045324>] ? kthread+0x0/0x66
[  712.765349]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765352] kblockd/1     S 0000009e     0   176      2 0x00000000
[  712.765356]  f72a9f74 00000046 f4de6df5 0000009e c121fe43 00000000 f716a400 c15e0580
[  712.765363]  c15e0580 c15e0580 c15dba98 f70c5710 f70c599c c2a08580 00000001 c11ee2c6
[  712.765370]  f72a9f54 c12090de f6413a40 f733c4ac c2a03a98 f70c599c 000175b5 00000000
[  712.765377] Call Trace:
[  712.765382]  [<c121fe43>] ? ata_scsi_queuecmd+0x199/0x1a3
[  712.765386]  [<c11ee2c6>] ? put_device+0xf/0x11
[  712.765390]  [<c12090de>] ? scsi_request_fn+0x3d0/0x47d
[  712.765394]  [<c11381db>] ? __blk_run_queue+0x7c/0x136
[  712.765399]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765403]  [<c11420ed>] ? cfq_kick_queue+0x0/0x2a
[  712.765407]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765411]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765415]  [<c1045385>] kthread+0x61/0x66
[  712.765419]  [<c1045324>] ? kthread+0x0/0x66
[  712.765423]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765425] kacpid        S 00000000     0   178      2 0x00000000
[  712.765430]  f72adf74 00000046 0a0442f4 00000000 00000002 f72adf4c 00000000 c15e0580
[  712.765437]  c15e0580 c15e0580 c15dba98 f70c6380 f70c660c c2808580 00000000 c2a08580
[  712.765444]  f72adf30 c1340819 c15142e0 c102c40b c2803a98 f70c660c fffedb33 00000000
[  712.765450] Call Trace:
[  712.765455]  [<c1340819>] ? wait_for_completion+0x12/0x14
[  712.765459]  [<c102c40b>] ? set_cpus_allowed_ptr+0xd8/0xf7
[  712.765464]  [<c1171959>] ? bind_to_cpu0+0x1d/0x20
[  712.765468]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765472]  [<c117193c>] ? bind_to_cpu0+0x0/0x20
[  712.765477]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765481]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765485]  [<c1045385>] kthread+0x61/0x66
[  712.765489]  [<c1045324>] ? kthread+0x0/0x66
[  712.765492]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765495] kacpi_notify  S 00000000     0   179      2 0x00000000
[  712.765499]  f72aff74 00000046 0a0442f4 00000000 00000002 f72aff4c 00000000 c15e0580
[  712.765506]  c15e0580 c15e0580 c15dba98 f70c6ff0 f70c727c c2808580 00000000 c2a08580
[  712.765513]  f72aff30 c1340819 c15142e0 c102c40b c2803a98 f70c727c fffedb33 00000000
[  712.765520] Call Trace:
[  712.765524]  [<c1340819>] ? wait_for_completion+0x12/0x14
[  712.765528]  [<c102c40b>] ? set_cpus_allowed_ptr+0xd8/0xf7
[  712.765532]  [<c1171959>] ? bind_to_cpu0+0x1d/0x20
[  712.765537]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765541]  [<c117193c>] ? bind_to_cpu0+0x0/0x20
[  712.765545]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765549]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765553]  [<c1045385>] kthread+0x61/0x66
[  712.765557]  [<c1045324>] ? kthread+0x0/0x66
[  712.765561]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765563] kacpi_hotplug S 00000000     0   180      2 0x00000000
[  712.765568]  f72b9f74 00000046 0a448755 00000000 00000002 f72b9f4c 00000000 c15e0580
[  712.765575]  c15e0580 c15e0580 c15dba98 f72b0000 f72b028c c2808580 00000000 c2a08580
[  712.765582]  f72b9f30 c1340819 c15142e0 c102c40b c2803a98 f72b028c fffedb33 00000000
[  712.765588] Call Trace:
[  712.765592]  [<c1340819>] ? wait_for_completion+0x12/0x14
[  712.765596]  [<c102c40b>] ? set_cpus_allowed_ptr+0xd8/0xf7
[  712.765601]  [<c1171959>] ? bind_to_cpu0+0x1d/0x20
[  712.765605]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765609]  [<c117193c>] ? bind_to_cpu0+0x0/0x20
[  712.765613]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765618]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765621]  [<c1045385>] kthread+0x61/0x66
[  712.765625]  [<c1045324>] ? kthread+0x0/0x66
[  712.765629]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765632] ata/0         S 00000000     0   292      2 0x00000000
[  712.765636]  f7203f74 00000046 d4e899ac 00000000 00000202 000003e7 00000000 c15e0580
[  712.765643]  c15e0580 c15e0580 50000000 f72b0c70 f72b0efc c2808580 00000000 d4ed0df7
[  712.765650]  00000000 00000000 c15142e0 00000000 00000000 f72b0efc 00000282 0000000a
[  712.765657] Call Trace:
[  712.765661]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.765666]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765670]  [<c1226508>] ? ata_pio_task+0x0/0xcc
[  712.765675]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765679]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765683]  [<c1045385>] kthread+0x61/0x66
[  712.765686]  [<c1045324>] ? kthread+0x0/0x66
[  712.765690]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765693] ata/1         S 00000000     0   293      2 0x00000000
[  712.765697]  f7205f74 00000046 0b7f7951 00000000 00000400 00000400 00000000 c15e0580
[  712.765705]  c15e0580 c15e0580 c15dba98 f72b18e0 f72b1b6c c2a08580 00000001 c15142e0
[  712.765711]  f72b18e0 f7205fb8 c15142e0 00000000 c2a03a98 f72b1b6c fffedb39 00000400
[  712.765718] Call Trace:
[  712.765723]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765727]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765731]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765735]  [<c1045385>] kthread+0x61/0x66
[  712.765739]  [<c1045324>] ? kthread+0x0/0x66
[  712.765743]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765746] ata_aux       S 00000000     0   294      2 0x00000000
[  712.765750]  f7207f74 00000046 0b7f7951 00000000 00000400 00000400 00000000 c15e0580
[  712.765757]  c15e0580 c15e0580 c15dba98 f72b2550 f72b27dc c2a08580 00000001 c15142e0
[  712.765764]  f72b2550 f7207fb8 c15142e0 0b7f7951 c2a03a98 f72b27dc fffedb39 c102ba7c
[  712.765771] Call Trace:
[  712.765775]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.765779]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765784]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765788]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765792]  [<c1045385>] kthread+0x61/0x66
[  712.765795]  [<c1045324>] ? kthread+0x0/0x66
[  712.765799]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765802] ksuspend_usbd S 00000000     0   295      2 0x00000000
[  712.765807]  f7209f74 00000046 0b7f7951 00000000 00000400 00000400 00000000 c15e0580
[  712.765814]  c15e0580 c15e0580 c15dba98 f72b31c0 f72b344c c2a08580 00000001 c15142e0
[  712.765821]  f72b31c0 f7209fb8 c15142e0 0b7f7951 c2a03a98 f72b344c fffedb39 c102ba7c
[  712.765827] Call Trace:
[  712.765831]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.765836]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.765840]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765844]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.765848]  [<c1045385>] kthread+0x61/0x66
[  712.765852]  [<c1045324>] ? kthread+0x0/0x66
[  712.765856]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765859] khubd         S 00000004     0   299      2 0x00000000
[  712.765863]  f7211f00 00000046 06cd7393 00000004 c123f15d f7065500 00000004 c15e0580
[  712.765870]  c15e0580 c15e0580 00070004 f72b3e30 f72b40bc c2808580 00000000 06d26a9d
[  712.765877]  00000004 f73d9400 f6a42000 c1237d38 000000a3 f72b40bc 00000007 f731a5f8
[  712.765884] Call Trace:
[  712.765889]  [<c123f15d>] ? usb_control_msg+0xf9/0x103
[  712.765893]  [<c1237d38>] ? hub_port_status+0x5f/0xcf
[  712.765897]  [<c1237d9e>] ? hub_port_status+0xc5/0xcf
[  712.765901]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.765905]  [<c123b96d>] hub_thread+0xf4e/0xfd5
[  712.765910]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765914]  [<c123aa1f>] ? hub_thread+0x0/0xfd5
[  712.765917]  [<c1045385>] kthread+0x61/0x66
[  712.765921]  [<c1045324>] ? kthread+0x0/0x66
[  712.765925]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.765928] kseriod       S 00000001     0   302      2 0x00000000
[  712.765932]  f721df88 00000046 98b48e15 00000001 f7030000 c15142e0 f721df2c c15e0580
[  712.765939]  c15e0580 c15e0580 c15dba98 f72b4aa0 f72b4d2c c2a08580 00000001 98b49443
[  712.765946]  00000001 f721df70 c15142e0 c132fc57 c11f0538 f72b4d2c 00000000 f721df68
[  712.765953] Call Trace:
[  712.765958]  [<c132fc57>] ? klist_next+0x1b/0x8d
[  712.765962]  [<c11f0538>] ? klist_devices_put+0x0/0xd
[  712.765966]  [<c11f0da9>] ? bus_for_each_dev+0x5d/0x67
[  712.765970]  [<c1255a04>] ? serio_free_event+0x15/0x18
[  712.765974]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.765978]  [<c12560f2>] serio_thread+0x271/0x2d4
[  712.765982]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.765986]  [<c1255e81>] ? serio_thread+0x0/0x2d4
[  712.765990]  [<c1045385>] kthread+0x61/0x66
[  712.765994]  [<c1045324>] ? kthread+0x0/0x66
[  712.765998]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766001] kondemand/0   S 00000000     0   333      2 0x00000000
[  712.766005]  f70cbf74 00000046 0ccba630 00000000 f703002c f7030000 01428000 c15e0580
[  712.766012]  c15e0580 c15e0580 c15142e0 f72b6ff0 f72b727c c2808580 00000000 0ccbb4cc
[  712.766019]  00000000 f70cbfb8 c15142e0 0ccb8133 00000000 f72b727c f70cbf70 c102ba7c
[  712.766025] Call Trace:
[  712.766029]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766034]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.766038]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766042]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766047]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766050]  [<c1045385>] kthread+0x61/0x66
[  712.766054]  [<c1045324>] ? kthread+0x0/0x66
[  712.766058]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766061] kondemand/1   S 00000000     0   334      2 0x00000000
[  712.766065]  f70cdf74 00000046 0eda9c49 00000000 f703002c f7030000 01428000 c15e0580
[  712.766072]  c15e0580 c15e0580 c15142e0 f73b8000 f73b828c c2a08580 00000001 0edaa0a4
[  712.766079]  00000000 f70cdfb8 c15142e0 0ccbe832 00000000 f73b828c f70cdf70 c102ba7c
[  712.766086] Call Trace:
[  712.766090]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766094]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.766098]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766103]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766107]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766111]  [<c1045385>] kthread+0x61/0x66
[  712.766114]  [<c1045324>] ? kthread+0x0/0x66
[  712.766118]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766121] kswapd0       S 00000000     0   358      2 0x00000000
[  712.766126]  f72f5f08 00000046 0f350ff5 00000000 c2808580 f72f5ec4 c10496d1 c15e0580
[  712.766133]  c15e0580 c15e0580 c15dba98 f73b8c70 f73b8efc c2a08580 00000001 f72f5ed0
[  712.766140]  c10232b3 f73b8c70 c15142e0 c1586e28 c2a03a98 f73b8efc fffedb3b c1024bb9
[  712.766146] Call Trace:
[  712.766150]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.766156]  [<c10232b3>] ? task_rq_lock+0x31/0x5b
[  712.766160]  [<c1024bb9>] ? dequeue_task_fair+0x1dd/0x1e5
[  712.766165]  [<c10826e1>] kswapd+0xda/0x580
[  712.766170]  [<c1028dbc>] ? finish_task_switch+0x33/0x6e
[  712.766174]  [<c13404ce>] ? schedule+0x905/0x9b2
[  712.766178]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766183]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.766187]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766191]  [<c102317f>] ? complete+0x34/0x3e
[  712.766195]  [<c1082607>] ? kswapd+0x0/0x580
[  712.766199]  [<c1045385>] kthread+0x61/0x66
[  712.766203]  [<c1045324>] ? kthread+0x0/0x66
[  712.766207]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766209] aio/0         S 00000000     0   412      2 0x00000000
[  712.766214]  f73edf74 00000046 0f6507bd 00000000 f703002c f7030000 01428000 c15e0580
[  712.766221]  c15e0580 c15e0580 c15142e0 f73b98e0 f73b9b6c c2808580 00000000 0f651276
[  712.766228]  00000000 f73edfb8 c15142e0 0f64e7cb 00000000 f73b9b6c f73edf70 c102ba7c
[  712.766234] Call Trace:
[  712.766238]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766242]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.766247]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766251]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766256]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766259]  [<c1045385>] kthread+0x61/0x66
[  712.766263]  [<c1045324>] ? kthread+0x0/0x66
[  712.766267]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766270] aio/1         S 00000000     0   413      2 0x00000000
[  712.766274]  f73eff74 00000046 0f664cc6 00000000 f703002c f7030000 01428000 c15e0580
[  712.766281]  c15e0580 c15e0580 c15dba98 f73ba550 f73ba7dc c2a08580 00000001 c15142e0
[  712.766288]  f73ba550 f73effb8 c15142e0 0f653f8e c2a03a98 f73ba7dc fffedb3b c102ba7c
[  712.766295] Call Trace:
[  712.766299]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766303]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766307]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766312]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766316]  [<c1045385>] kthread+0x61/0x66
[  712.766319]  [<c1045324>] ? kthread+0x0/0x66
[  712.766323]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766326] crypto/0      S 00000000     0   427      2 0x00000000
[  712.766330]  f6939f74 00000046 0f743fe3 00000000 f703002c f7030000 01428000 c15e0580
[  712.766337]  c15e0580 c15e0580 c15dba98 f73bb1c0 f73bb44c c2808580 00000000 c15142e0
[  712.766344]  f73bb1c0 f6939fb8 c15142e0 0f74227e c2803a98 f73bb44c fffedb33 c102ba7c
[  712.766351] Call Trace:
[  712.766355]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766360]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766364]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766368]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766372]  [<c1045385>] kthread+0x61/0x66
[  712.766376]  [<c1045324>] ? kthread+0x0/0x66
[  712.766380]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766383] crypto/1      S 00000000     0   428      2 0x00000000
[  712.766387]  f693bf74 00000046 0f74c7b6 00000000 f703002c f7030000 01428000 c15e0580
[  712.766394]  c15e0580 c15e0580 c15dba98 f73bbe30 f73bc0bc c2a08580 00000001 c15142e0
[  712.766401]  f73bbe30 f693bfb8 c15142e0 0f747d28 c2a03a98 f73bc0bc fffedb3b c102ba7c
[  712.766408] Call Trace:
[  712.766412]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766416]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766420]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766425]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766429]  [<c1045385>] kthread+0x61/0x66
[  712.766432]  [<c1045324>] ? kthread+0x0/0x66
[  712.766436]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766439] i915/0        S 0000005b     0   557      2 0x00000000
[  712.766444]  f722bf74 00000046 fe092451 0000005b c15077a0 f62329e0 00000286 c15e0580
[  712.766451]  c15e0580 c15e0580 c15dba98 f7162550 f71627dc c2808580 00000000 f7144000
[  712.766457]  f62329e0 f722bf5c f72d8c40 f7236000 c2803a98 f71627dc 00005cd2 f7144000
[  712.766464] Call Trace:
[  712.766469]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766474]  [<c11d2f4f>] ? i915_gem_retire_work_handler+0x0/0x5d
[  712.766478]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766482]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766486]  [<c1045385>] kthread+0x61/0x66
[  712.766490]  [<c1045324>] ? kthread+0x0/0x66
[  712.766494]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766496] i915/1        S 000000a5     0   558      2 0x00000000
[  712.766501]  f73dff74 00000046 d39f659b 000000a5 f7034aa0 c12c9d92 000000f0 c15e0580
[  712.766508]  c15e0580 c15e0580 c15dba98 f71631c0 f716344c c2a08580 00000001 f7144000
[  712.766514]  f6232920 f73dff5c f6097a40 f7236000 c2a03a98 f716344c 0001925f f7144000
[  712.766521] Call Trace:
[  712.766526]  [<c12c9d92>] ? pci_write+0x1d/0x22
[  712.766531]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766535]  [<c11d2f4f>] ? i915_gem_retire_work_handler+0x0/0x5d
[  712.766539]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766544]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766548]  [<c1045385>] kthread+0x61/0x66
[  712.766551]  [<c1045324>] ? kthread+0x0/0x66
[  712.766555]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766558] scsi_eh_0     S 00000000     0   626      2 0x00000000
[  712.766562]  f70f7f64 00000046 d4f01032 00000000 00000000 00000003 f7339ef4 c15e0580
[  712.766569]  c15e0580 c15e0580 c15dba98 f71618e0 f7161b6c c2808580 00000000 00000003
[  712.766576]  00000246 0000001d c15142e0 f70f7f64 c2803a98 f7161b6c fffede7b f70f7f50
[  712.766583] Call Trace:
[  712.766587]  [<c1203e0e>] ? __scsi_iterate_devices+0x48/0x5f
[  712.766592]  [<c1207b20>] scsi_error_handler+0x6a/0x4aa
[  712.766596]  [<c102317f>] ? complete+0x34/0x3e
[  712.766600]  [<c1207ab6>] ? scsi_error_handler+0x0/0x4aa
[  712.766604]  [<c1045385>] kthread+0x61/0x66
[  712.766608]  [<c1045324>] ? kthread+0x0/0x66
[  712.766612]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766614] scsi_eh_1     S 00000000     0   629      2 0x00000000
[  712.766619]  f6901f64 00000046 d2495234 00000000 00000000 00000003 f7365ef4 c15e0580
[  712.766626]  c15e0580 c15e0580 00000086 f7163e30 f71640bc c2a08580 00000001 d2f291f6
[  712.766633]  00000000 0000001d c15142e0 f6901f64 00000003 f71640bc 00000246 f6901f50
[  712.766639] Call Trace:
[  712.766644]  [<c1203e0e>] ? __scsi_iterate_devices+0x48/0x5f
[  712.766648]  [<c1209806>] ? scsi_run_host_queues+0x1c/0x26
[  712.766653]  [<c1207b20>] scsi_error_handler+0x6a/0x4aa
[  712.766657]  [<c102317f>] ? complete+0x34/0x3e
[  712.766661]  [<c1207ab6>] ? scsi_error_handler+0x0/0x4aa
[  712.766665]  [<c1045385>] kthread+0x61/0x66
[  712.766669]  [<c1045324>] ? kthread+0x0/0x66
[  712.766673]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766675] kpsmoused     S 00000001     0   679      2 0x00000000
[  712.766680]  f727bf74 00000046 98b3b8b0 00000001 00000400 00000400 00000000 c15e0580
[  712.766687]  c15e0580 c15e0580 c15dba98 f7166ff0 f716727c c2808580 00000000 c15142e0
[  712.766694]  f7166ff0 f727bfb8 c15142e0 98b384b4 c2803a98 f716727c fffee1ba c102ba7c
[  712.766700] Call Trace:
[  712.766704]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766709]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766713]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766718]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766721]  [<c1045385>] kthread+0x61/0x66
[  712.766725]  [<c1045324>] ? kthread+0x0/0x66
[  712.766729]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766732] kconservative S 00000001     0   681      2 0x00000000
[  712.766736]  f727ff74 00000046 98b4fc63 00000001 00000400 00000400 00000000 c15e0580
[  712.766743]  c15e0580 c15e0580 c15dba98 f7160000 f716028c c2808580 00000000 c15142e0
[  712.766750]  f7160000 f727ffb8 c15142e0 98b4c81f c2803a98 f716028c fffee1ba c102ba7c
[  712.766757] Call Trace:
[  712.766760]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766765]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766769]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766774]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766778]  [<c1045385>] kthread+0x61/0x66
[  712.766781]  [<c1045324>] ? kthread+0x0/0x66
[  712.766785]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766788] kconservative S 00000001     0   682      2 0x00000000
[  712.766792]  f7101f74 00000046 98b5c01b 00000001 00000400 00000400 00000000 c15e0580
[  712.766799]  c15e0580 c15e0580 c15dba98 f7160c70 f7160efc c2a08580 00000001 c15142e0
[  712.766806]  f7160c70 f7101fb8 c15142e0 98b52bd7 c2a03a98 f7160efc fffee1ad c102ba7c
[  712.766813] Call Trace:
[  712.766817]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766821]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766826]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766830]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766834]  [<c1045385>] kthread+0x61/0x66
[  712.766838]  [<c1045324>] ? kthread+0x0/0x66
[  712.766842]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766844] usbhid_resume S 00000001     0   729      2 0x00000000
[  712.766849]  f69cbf74 00000046 98f97987 00000001 00000400 00000400 00000000 c15e0580
[  712.766856]  c15e0580 c15e0580 c15dba98 f7166380 f716660c c2808580 00000000 c15142e0
[  712.766862]  f7166380 f69cbfb8 c15142e0 98f92548 c2803a98 f716660c fffee1bb c102ba7c
[  712.766869] Call Trace:
[  712.766873]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.766878]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766882]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766886]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766890]  [<c1045385>] kthread+0x61/0x66
[  712.766894]  [<c1045324>] ? kthread+0x0/0x66
[  712.766898]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766900] hd-audio0     S 00000013     0   742      2 0x00000000
[  712.766905]  f69edf74 00000046 2f6ca204 00000013 c12aaae7 01170503 f720d474 c15e0580
[  712.766912]  c15e0580 c15e0580 c15dba98 f7164aa0 f7164d2c c2808580 00000000 c103a0a5
[  712.766919]  f69edf40 ffffffff f6160540 00000282 c2803a98 f7164d2c ffff2b61 f733fe68
[  712.766925] Call Trace:
[  712.766931]  [<c12aaae7>] ? codec_exec_verb+0x6f/0xa5
[  712.766936]  [<c103a0a5>] ? lock_timer_base+0x1f/0x3e
[  712.766940]  [<c12c6fbe>] ? azx_stop_chip+0x8d/0xc0
[  712.766944]  [<c1041fa5>] worker_thread+0x94/0x1ae
[  712.766949]  [<c12ab881>] ? hda_power_work+0x0/0x40
[  712.766953]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.766957]  [<c1041f11>] ? worker_thread+0x0/0x1ae
[  712.766961]  [<c1045385>] kthread+0x61/0x66
[  712.766965]  [<c1045324>] ? kthread+0x0/0x66
[  712.766969]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.766972] kjournald     S 000000a5     0   762      2 0x00000000
[  712.766976]  f69fdf70 00000046 4f5b9537 000000a5 f66b6f00 f69fe614 f69fe6c0 c15e0580
[  712.766983]  c15e0580 c15e0580 c15dba98 f7165710 f716599c c2808580 00000000 00000000
[  712.766990]  00000001 f69fe614 f6412540 f6963800 c2803a98 f716599c 0001902c f69fe654
[  712.766997] Call Trace:
[  712.767001]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.767006]  [<c1103907>] kjournald+0x162/0x1d2
[  712.767010]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.767014]  [<c11037a5>] ? kjournald+0x0/0x1d2
[  712.767018]  [<c1045385>] kthread+0x61/0x66
[  712.767021]  [<c1045324>] ? kthread+0x0/0x66
[  712.767025]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.767028] udevd         S 00000052     0  1281      1 0x00000000
[  712.767032]  f647fb68 00000086 5720339c 00000052 f7034aa0 f647fb0c 00000800 c15e0580
[  712.767039]  c15e0580 c15e0580 c15dba98 f6454aa0 f6454d2c c2a08580 00000001 a04c93ed
[  712.767046]  00000051 00000000 f6a42000 c134a314 c2a03a98 f6454d2c 0000345d 00000800
[  712.767053] Call Trace:
[  712.767058]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.767063]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.767066]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.767072]  [<c132a279>] ? unix_dgram_poll+0xab/0x14f
[  712.767076]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.767080]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.767084]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.767088]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767091]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767095]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767099]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767102]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767107]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.767111]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.767115]  [<c10927a5>] ? anon_vma_prepare+0x3a/0x99
[  712.767120]  [<c107fd48>] ? lru_cache_add_lru+0x27/0x29
[  712.767123]  [<c1092622>] ? page_add_new_anon_rmap+0x58/0x65
[  712.767128]  [<c108c2c1>] ? handle_mm_fault+0x1f3/0x54d
[  712.767132]  [<c108c2c1>] ? handle_mm_fault+0x1f3/0x54d
[  712.767136]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.767140]  [<c1019fb3>] ? do_page_fault+0x0/0x276
[  712.767145]  [<c1341f86>] ? error_code+0x66/0x6c
[  712.767150]  [<c1079270>] ? find_get_page+0x1d/0x81
[  712.767155]  [<c107ac20>] ? generic_file_aio_read+0x4dc/0x550
[  712.767159]  [<c107d85b>] ? __pagevec_free+0x55/0x60
[  712.767163]  [<c107fbc1>] ? release_pages+0x169/0x171
[  712.767168]  [<c1095151>] ? free_pages_and_swap_cache+0x69/0x82
[  712.767173]  [<c108eeb4>] ? remove_vma+0x46/0x4c
[  712.767177]  [<c108faef>] ? do_munmap+0x20a/0x225
[  712.767181]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.767185]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767188] udevd         D 00000003     0  1300   1281 0x00000004
[  712.767193]  f64ebe60 00000082 dc364c52 00000003 00000046 00000000 f72b5710 c15e0580
[  712.767200]  c15e0580 c15e0580 f64ebe04 f72b5710 f72b599c c2808580 00000000 dc7be540
[  712.767207]  00000003 c10032b6 f6ac3340 c2808580 f64ea000 f72b599c f72b5710 f64ebe60
[  712.767213] Call Trace:
[  712.767217]  [<c10032b6>] ? apic_timer_interrupt+0x2a/0x30
[  712.767222]  [<c10e007b>] ? rescan_partitions+0x18d/0x3a7
[  712.767227]  [<c101f19c>] ? mutex_spin_on_owner+0x3f/0x63
[  712.767231]  [<c1340dac>] __mutex_lock_slowpath+0xaa/0xe1
[  712.767235]  [<c1341066>] mutex_lock+0x1a/0x28
[  712.767239]  [<c10e08a2>] sysfs_permission+0x1e/0x54
[  712.767243]  [<c10aa801>] inode_permission+0x56/0x6c
[  712.767247]  [<c10aad84>] lookup_hash+0x16/0x2a
[  712.767252]  [<c10ad565>] do_filp_open+0x1c5/0x730
[  712.767256]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.767260]  [<c10abbfd>] ? getname+0x1a/0x94
[  712.767265]  [<c10b5809>] ? alloc_fd+0x55/0xbe
[  712.767269]  [<c10a0f7a>] do_sys_open+0x4a/0xe7
[  712.767273]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.767277]  [<c10a1059>] sys_open+0x1e/0x26
[  712.767281]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767284] flush-8:0     S 000000a5     0  1905      2 0x00000000
[  712.767289]  f6afff2c 00000046 5c2cad70 000000a5 c15077a0 f6afff08 f690db40 c15e0580
[  712.767295]  c15e0580 c15e0580 c15dba98 f6453e30 f64540bc c2808580 00000000 f6affedc
[  712.767302]  f6affedc 00000000 f6412540 f6afff6c c2803a98 f64540bc 00019092 0000000b
[  712.767309] Call Trace:
[  712.767314]  [<c13409fa>] schedule_timeout+0x1b8/0x1de
[  712.767318]  [<c103a667>] ? process_timeout+0x0/0xa
[  712.767323]  [<c1340a63>] schedule_timeout_interruptible+0x15/0x17
[  712.767327]  [<c10bc5cf>] bdi_writeback_task+0x66/0x85
[  712.767331]  [<c1089533>] bdi_start_fn+0x5e/0xab
[  712.767335]  [<c10894d5>] ? bdi_start_fn+0x0/0xab
[  712.767339]  [<c1045385>] kthread+0x61/0x66
[  712.767343]  [<c1045324>] ? kthread+0x0/0x66
[  712.767347]  [<c100348f>] kernel_thread_helper+0x7/0x10
[  712.767350] dbus-daemon   S 000000a5     0  2004      1 0x00000000
[  712.767354]  f67ffb68 00000086 754116c0 000000a5 f6442550 f67ffb74 00000000 c15e0580
[  712.767361]  c15e0580 c15e0580 c15dba98 f6433e30 f64340bc c2a08580 00000001 bc423989
[  712.767368]  00000085 c2803dbc f6160700 00000000 c2a03a98 f64340bc 000190f9 00000400
[  712.767374] Call Trace:
[  712.767379]  [<c104825d>] ? hrtimer_try_to_cancel+0x80/0x8a
[  712.767383]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.767388]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.767391]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.767395]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.767399]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.767403]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.767407]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767411]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767414]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767418]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767422]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767425]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767429]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767433]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767436]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767440]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767444]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767447]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767451]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.767455]  [<c1034715>] ? __do_softirq+0x13c/0x144
[  712.767460]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.767465]  [<c12d3207>] ? verify_iovec+0x40/0x71
[  712.767470]  [<c1039dcd>] ? run_timer_softirq+0x37/0x203
[  712.767475]  [<c104cc55>] ? getnstimeofday+0x52/0xd3
[  712.767479]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.767484]  [<c10336de>] ? sys_gettimeofday+0x2b/0x58
[  712.767488]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767491] syslog-ng     S 00000013     0  2020      1 0x00000000
[  712.767495]  f6679f20 00200086 fc48a9e0 00000013 f6679ef8 f6679ef8 f6679ec8 c15e0580
[  712.767502]  c15e0580 c15e0580 c15dba98 f64531c0 f645344c c2808580 00000000 00000000
[  712.767509]  00008001 f6679f58 f61a6700 b74195cd c2803a98 f645344c ffff2eb6 00000000
[  712.767516] Call Trace:
[  712.767521]  [<c105f8f9>] ? rcu_start_gp+0xe8/0xed
[  712.767525]  [<c1031d1e>] do_wait+0x18b/0x1e8
[  712.767529]  [<c1031e03>] sys_wait4+0x88/0x9b
[  712.767533]  [<c1030770>] ? child_wait_callback+0x0/0x64
[  712.767537]  [<c1031e29>] sys_waitpid+0x13/0x15
[  712.767541]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767544] syslog-ng     S 000000a3     0  2021   2020 0x00000000
[  712.767548]  f6757b68 00200086 ece2b2ec 000000a3 00000000 f6757b74 c2803dbc c15e0580
[  712.767555]  c15e0580 c15e0580 f6757b74 f6434aa0 f6434d2c c2808580 00000000 ece31568
[  712.767562]  000000a3 f6757b74 f6161dc0 00000000 f6757b40 f6434d2c 00000001 f6757b74
[  712.767569] Call Trace:
[  712.767573]  [<c1048579>] ? hrtimer_start_range_ns+0x10/0x12
[  712.767578]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.767582]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.767586]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.767590]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.767594]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.767598]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767601]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767605]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767609]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767612]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767616]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767620]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767623]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767627]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767630]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767634]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767638]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767642]  [<c12d0eaa>] ? skb_dequeue+0x45/0x4c
[  712.767647]  [<c132a94c>] ? unix_stream_recvmsg+0x3cd/0x44a
[  712.767652]  [<c11b077f>] ? do_con_write+0x1946/0x196f
[  712.767657]  [<c12cb474>] ? sock_aio_read+0xd1/0xdf
[  712.767662]  [<c10ca00e>] ? fsnotify_clear_marks_by_inode+0x1e/0xa5
[  712.767667]  [<c12cb24d>] ? sock_destroy_inode+0x10/0x12
[  712.767671]  [<c10b40a0>] ? destroy_inode+0x1f/0x30
[  712.767675]  [<c10b169a>] ? __d_free+0x3a/0x3d
[  712.767679]  [<c10b16c2>] ? d_free+0x25/0x37
[  712.767683]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.767687]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.767691]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767694] console-kit-d S 0000008c     0  2034      1 0x00000000
[  712.767698]  f67efb68 00000082 e3d6a075 0000008c c15077a0 f67efb74 c2803dbc c15e0580
[  712.767705]  c15e0580 c15e0580 c15dba98 f64331c0 f643344c c2808580 00000000 e3cb833b
[  712.767712]  0000008c f67efb74 f6161880 00000000 c2803a98 f643344c 000128d9 ffffffff
[  712.767719] Call Trace:
[  712.767723]  [<c104825d>] ? hrtimer_try_to_cancel+0x80/0x8a
[  712.767727]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.767732]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.767736]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.767740]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.767744]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.767748]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.767751]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767755]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767759]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767762]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.767766]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.767771]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.767775]  [<c10231c4>] ? __wake_up_sync_key+0x3b/0x45
[  712.767780]  [<c12ce155>] ? sock_def_readable+0x37/0x65
[  712.767784]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.767788]  [<c12cc1fd>] ? sock_sendmsg+0xca/0xe1
[  712.767793]  [<c105f8f9>] ? rcu_start_gp+0xe8/0xed
[  712.767797]  [<c105ff02>] ? call_rcu_sched+0xd/0xf
[  712.767801]  [<c105ff0c>] ? call_rcu+0x8/0xa
[  712.767805]  [<c10b16d1>] ? d_free+0x34/0x37
[  712.767808]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.767813]  [<c10aaa4c>] ? path_put+0x20/0x23
[  712.767817]  [<c10ac78c>] ? __link_path_walk+0xb15/0xb33
[  712.767821]  [<c10b37fa>] ? touch_atime+0xd1/0xe4
[  712.767825]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.767829]  [<c1144347>] ? cpumask_any_but+0x23/0x2f
[  712.767834]  [<c101d41b>] ? flush_tlb_page+0x45/0x5d
[  712.767838]  [<c101cc94>] ? ptep_set_access_flags+0x21/0x28
[  712.767842]  [<c108b1e3>] ? do_wp_page+0x265/0x57c
[  712.767846]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.767851]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.767855]  [<c104cc55>] ? getnstimeofday+0x52/0xd3
[  712.767859]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.767863]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767866] console-kit-d S 00000085     0  2038      1 0x00000000
[  712.767871]  f64e3d54 00000082 bc3ebec6 00000085 f64e3d24 c10e96c8 00001000 c15e0580
[  712.767878]  c15e0580 c15e0580 f6f30000 f73be380 f73be60c c2808580 00000000 bc3f7ac5
[  712.767885]  00000085 c135777c f6161880 00000001 00000292 f73be60c c102320c 00000000
[  712.767891] Call Trace:
[  712.767896]  [<c10e96c8>] ? __ext3_get_inode_loc+0xc5/0x283
[  712.767901]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.767905]  [<c105192e>] ? futex_wait_setup+0x8d/0x10b
[  712.767909]  [<c1051a44>] futex_wait_queue_me+0x98/0xac
[  712.767913]  [<c1051b56>] futex_wait+0xfe/0x21b
[  712.767917]  [<c10ec0f4>] ? ext3_writeback_write_end+0xcc/0xf5
[  712.767922]  [<c107a057>] ? generic_file_buffered_write+0x10f/0x1eb
[  712.767926]  [<c1053198>] do_futex+0x86/0xbcd
[  712.767931]  [<c10ac6c0>] ? __link_path_walk+0xa49/0xb33
[  712.767936]  [<c10a39f3>] ? file_move+0x17/0x37
[  712.767940]  [<c107a72f>] ? generic_file_aio_write+0x7e/0x93
[  712.767945]  [<c10a2a32>] ? do_sync_write+0xab/0xe9
[  712.767949]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.767954]  [<c10a3405>] ? vfs_write+0xff/0x13d
[  712.767958]  [<c1053dc8>] sys_futex+0xe9/0xff
[  712.767962]  [<c10a34f8>] ? sys_write+0x57/0x60
[  712.767966]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.767968] console-kit-d S 00000050     0  2039      1 0x00000000
[  712.767973]  f6521dc4 00000082 a5b58954 00000050 f710be30 1f0aa955 ffffffff c15e0580
[  712.767980]  c15e0580 c15e0580 00000bc7 f73beff0 f73bf27c c2a08580 00000001 a5b59066
[  712.767987]  00000050 f6521da8 f6161880 00000000 c2a08580 f73bf27c 00000005 00000001
[  712.767994] Call Trace:
[  712.767998]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768003]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768007]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768011]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768016]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768020]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768025]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768029]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768033]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768037]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768040]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768044]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2040      1 0x00000000
[  712.768046]  f65d5dc4 00000082 a5b50a59 00000050 f6012550 00000000 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6450000 f645028c c2808580 00000000 a5b51345
[  712.768046]  00000050 c134a3cc f6161880 c134a314 c2803a98 f645028c ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2041      1 0x00000000
[  712.768046]  f652fdc4 00000082 a5b601de 00000050 f710e380 1f0cf498 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000005f2 f6455710 f645599c c2a08580 00000001 a5b60884
[  712.768046]  00000050 f652fda8 f6161880 00000000 c2a08580 f645599c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2042      1 0x00000000
[  712.768046]  f6563dc4 00000082 a5b595bd 00000050 f6432550 1f08c61b ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000b19 f6452550 f64527dc c2a08580 00000001 a5b5b86a
[  712.768046]  00000050 f6563da8 f6161880 00000000 c2a08580 f64527dc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2043      1 0x00000000
[  712.768046]  f64dfdc4 00000082 a5b56a66 00000050 f6133e30 1f0bfae7 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000006b2 f72b6380 f72b660c c2a08580 00000001 a5b5730a
[  712.768046]  00000050 f64dfda8 f6161880 00000000 c2a08580 f72b660c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2045      1 0x00000000
[  712.768046]  f62cddc4 00000082 a5b4e506 00000050 f6013e30 00000000 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6435710 f643599c c2808580 00000000 a5b4ee0a
[  712.768046]  00000050 c134a3cc f6161880 c134a314 c2803a98 f643599c ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2046      1 0x00000000
[  712.768046]  f629bdc4 00000082 a5b59066 00000050 f73beff0 1f006165 00001c00 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6432550 f64327dc c2a08580 00000001 a5b595bd
[  712.768046]  00000050 f629bda8 f6161880 00000000 c2a03a98 f64327dc 00002d4b 00001dff
[  712.768046] Call Trace:
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c1025eaf>] ? enqueue_task_fair+0x3f5/0x3fd
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c1148355>] ? rwsem_wake+0x10e/0x119
[  712.768046]  [<c1341c3a>] ? call_rwsem_wake+0xa/0xc
[  712.768046]  [<c104874f>] ? up_read+0x11/0x13
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2047      1 0x00000000
[  712.768046]  f66dfdc4 00000082 a5b57a52 00000050 f710caa0 1f0b7fbe ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000006cb f6430000 f643028c c2a08580 00000001 a5b581a0
[  712.768046]  00000050 f66dfda8 f6161880 00000000 c2a08580 f643028c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2048      1 0x00000000
[  712.768046]  f6275dc4 00000082 a5b5e3e6 00000050 f710d710 1f0c7975 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000064c f6430c70 f6430efc c2a08580 00000001 a5b5f892
[  712.768046]  00000050 f6275da8 f6161880 00000000 c2a08580 f6430efc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2049      1 0x00000000
[  712.768046]  f61f9dc4 00000082 a5b60e53 00000050 f710eff0 1f0d65b0 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000068e f6436380 f643660c c2a08580 00000001 a5b61d97
[  712.768046]  00000050 f61f9da8 f6161880 00000000 c2a08580 f643660c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2050      1 0x00000000
[  712.768046]  f6297dc4 00000082 a5b525b8 00000050 f673b1c0 1f0e41bd 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f7108000 f710828c c2808580 00000000 a5b52fe7
[  712.768046]  00000050 f6297da8 f6161880 00000000 c2803a98 f710828c ffff2f57 000005ff
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2051      1 0x00000000
[  712.768046]  f601fdc4 00000082 a5b4f7d3 00000050 f60131c0 00000000 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f7108c70 f7108efc c2808580 00000000 a5b500ad
[  712.768046]  00000050 c134a3cc f6161880 c134a314 c2803a98 f7108efc ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2052      1 0x00000000
[  712.768046]  f627bdc4 00000082 a5b4d095 00000050 f6014aa0 00000000 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f71098e0 f7109b6c c2808580 00000000 a5b4d99f
[  712.768046]  00000050 c134a3cc f6161880 c134a314 c2803a98 f7109b6c ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2053      1 0x00000000
[  712.768046]  f61c1dc4 00000082 a5b4b178 00000050 f6016380 1f10a2b1 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000069a f710a550 f710a7dc c2a08580 00000001 a5b4bbde
[  712.768046]  00000050 f61c1da8 f6161880 00000000 c2a08580 f710a7dc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2054      1 0x00000000
[  712.768046]  f626fdc4 00000082 a5b48cd3 00000050 f6b9e380 1f11532b ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000665 f710b1c0 f710b44c c2a08580 00000001 a5b495cb
[  712.768046]  00000050 f626fda8 f6161880 00000000 c2a08580 f710b44c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2055      1 0x00000000
[  712.768046]  f6745dc4 00000082 a5b581a0 00000050 f6430000 1f0b3c85 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000007de f710be30 f710c0bc c2a08580 00000001 a5b58954
[  712.768046]  00000050 f6745da8 f6161880 00000000 c2a08580 f710c0bc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2056      1 0x00000000
[  712.768046]  f6703dc4 00000082 a5b5730a 00000050 f72b6380 1f0bbf26 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000659 f710caa0 f710cd2c c2a08580 00000001 a5b57a52
[  712.768046]  00000050 f6703da8 f6161880 00000000 c2a08580 f710cd2c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2057      1 0x00000000
[  712.768046]  f62ffdc4 00000082 a5b5dc91 00000050 f61331c0 1f0c3af1 00001000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f710d710 f710d99c c2a08580 00000001 a5b5e3e6
[  712.768046]  00000050 f62ffda8 f6161880 c134a314 c2a03a98 f710d99c 00002d4b 00000fff
[  712.768046] Call Trace:
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2058      1 0x00000000
[  712.768046]  f6b97dc4 00000082 a5b5f892 00000050 f6430c70 1f0cb3bd ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000611 f710e380 f710e60c c2a08580 00000001 a5b601de
[  712.768046]  00000050 f6b97da8 f6161880 00000000 c2a08580 f710e60c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c107fd1c>] ? __lru_cache_add+0x51/0x56
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2059      1 0x00000000
[  712.768046]  f61e3dc4 00000082 a5b60884 00000050 f6455710 1f0d2dd8 00000800 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f710eff0 f710f27c c2a08580 00000001 a5b60e53
[  712.768046]  00000050 f61e3da8 f6161880 c134a314 c2a03a98 f710f27c 00002d4b 000007ff
[  712.768046] Call Trace:
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2060      1 0x00000000
[  712.768046]  f677fdc4 00000082 a5b9f33e 00000050 f6436ff0 1f0d9a83 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000712 f6010000 f601028c c2808580 00000000 a5b9fd5c
[  712.768046]  00000050 f677fda8 f6161880 00000000 c2a08580 f601028c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2061      1 0x00000000
[  712.768046]  f60fbdc4 00000082 a5b52fe7 00000050 f7108000 1f0e08ef ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000718 f6010c70 f6010efc c2808580 00000000 a5b538fd
[  712.768046]  00000050 f60fbda8 f6161880 00000000 c2a08580 f6010efc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2062      1 0x00000000
[  712.768046]  f6711dc4 00000082 a5b51345 00000050 f6450000 1f0e84f0 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f60118e0 f6011b6c c2808580 00000000 a5b51ca2
[  712.768046]  00000050 f6711da8 f6161880 c134a314 c2803a98 f6011b6c ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2063      1 0x00000000
[  712.768046]  f6201dc4 00000082 a5b500ad 00000050 f7108c70 1f0ef3d4 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6012550 f60127dc c2808580 00000000 a5b50a59
[  712.768046]  00000050 f6201da8 f6161880 c134a314 c2803a98 f60127dc ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2064      1 0x00000000
[  712.768046]  f61ffdc4 00000082 a5b4ee0a 00000050 f6435710 1f0f5c4e 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f60131c0 f601344c c2808580 00000000 a5b4f7d3
[  712.768046]  00000050 f61ffda8 f6161880 c134a314 c2803a98 f601344c ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2065      1 0x00000000
[  712.768046]  f61a5dc4 00000082 a5b4d99f 00000050 f71098e0 1f0fc097 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6013e30 f60140bc c2808580 00000000 a5b4e506
[  712.768046]  00000050 f61a5da8 f6161880 c134a314 c2803a98 f60140bc ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c107fd1c>] ? __lru_cache_add+0x51/0x56
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2066      1 0x00000000
[  712.768046]  f60f1dc4 00000082 a5b4c696 00000050 f6b9a550 1f1024ce 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6014aa0 f6014d2c c2808580 00000000 a5b4d095
[  712.768046]  00000050 f60f1da8 f6161880 00000000 c2803a98 f6014d2c ffff2f57 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2067      1 0x00000000
[  712.768046]  f64f3dc4 00000082 a5b4bbde 00000050 f710a550 1f106be7 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000007ea f6015710 f601599c c2a08580 00000001 a5b4c68b
[  712.768046]  00000050 f64f3da8 f6161880 00000000 c2a08580 f601599c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2068      1 0x00000000
[  712.768046]  f6729dc4 00000082 a5b4a3f0 00000050 f6b9d710 1f10dd7c ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000005fe f6016380 f601660c c2a08580 00000001 a5b4b178
[  712.768046]  00000050 f6729da8 f6161880 00000000 c2a08580 f601660c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2069      1 0x00000000
[  712.768046]  f62f7dc4 00000082 a5b495cb 00000050 f710b1c0 1f1135ec ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000005fe f6016ff0 f601727c c2a08580 00000001 a5b49dc1
[  712.768046]  00000050 f62f7da8 f6161880 00000000 c2a08580 f601727c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2070      1 0x00000000
[  712.768046]  f67bfdc4 00000082 a5b5b86a 00000050 f6452550 1f0ad399 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000076c f6130000 f613028c c2a08580 00000001 a5b5bfd1
[  712.768046]  00000050 f67bfda8 f6161880 00000000 c2a08580 f613028c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c10927a5>] ? anon_vma_prepare+0x3a/0x99
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2071      1 0x00000000
[  712.768046]  f625ddc4 00000082 a5b5bfd1 00000050 f6130000 1f0b5ca4 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000007c0 f6130c70 f6130efc c2a08580 00000001 a5b5c7bb
[  712.768046]  00000050 f625dda8 f6161880 00000000 c2a08580 f6130efc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2072      1 0x00000000
[  712.768046]  f6165dc4 00000082 a5b5c7bb 00000050 f6130c70 1f0b9fa8 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000724 f61318e0 f6131b6c c2a08580 00000001 a5b5cf57
[  712.768046]  00000050 f6165da8 f6161880 00000000 c2a08580 f6131b6c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2073      1 0x00000000
[  712.768046]  f6231dc4 00000082 a5b5cf57 00000050 f61318e0 1f0bdbed ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000665 f6132550 f61327dc c2a08580 00000001 a5b5d651
[  712.768046]  00000050 f6231da8 f6161880 00000000 c2a08580 f61327dc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2074      1 0x00000000
[  712.768046]  f6785dc4 00000082 a5b5d651 00000050 f6132550 1f0c1712 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000005f9 f61331c0 f613344c c2a08580 00000001 a5b5dc91
[  712.768046]  00000050 f6785da8 f6161880 00000000 c2a08580 f613344c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c1053dc8>] ? sys_futex+0xe9/0xff
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2075      1 0x00000000
[  712.768046]  f6751dc4 00000082 a5b56426 00000050 f6134aa0 1f0c5a9f ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000635 f6133e30 f61340bc c2a08580 00000001 a5b56a66
[  712.768046]  00000050 f6751da8 f6161880 00000000 c2a08580 f61340bc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2076      1 0x00000000
[  712.768046]  f679ddc4 00000082 a5b55ab0 00000050 f6135710 1f0c9917 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000670 f6134aa0 f6134d2c c2a08580 00000001 a5b56426
[  712.768046]  00000050 f679dda8 f6161880 00000000 c2a08580 f6134d2c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2077      1 0x00000000
[  712.768046]  f6719dc4 00000082 a5b55440 00000050 f6136380 1f0cd760 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000063b f6135710 f613599c c2a08580 00000001 a5b55ab0
[  712.768046]  00000050 f6719da8 f6161880 00000000 c2a08580 f613599c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2078      1 0x00000000
[  712.768046]  f671bdc4 00000082 a5b54d5d 00000050 f6136ff0 1f0d1105 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000598 f6136380 f613660c c2a08580 00000001 a5b55440
[  712.768046]  00000050 f671bda8 f6161880 00000000 c2a08580 f613660c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2079      1 0x00000000
[  712.768046]  f6121dc4 00000082 a5b5437c 00000050 f6738000 1f0d4be3 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000623 f6136ff0 f613727c c2a08580 00000001 a5b54d5d
[  712.768046]  00000050 f6121da8 f6161880 00000000 c2a08580 f613727c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2080      1 0x00000000
[  712.768046]  f6123dc4 00000082 a5b53994 00000050 f6738c70 1f0d7f8a ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000005db f6738000 f673828c c2a08580 00000001 a5b5437c
[  712.768046]  00000050 f6123da8 f6161880 00000000 c2a08580 f673828c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2081      1 0x00000000
[  712.768046]  f60d5dc4 00000082 a5b52e4b 00000050 f67398e0 1f0db65a ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000670 f6738c70 f6738efc c2a08580 00000001 a5b53994
[  712.768046]  00000050 f60d5da8 f6161880 00000000 c2a08580 f6738efc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2082      1 0x00000000
[  712.768046]  f60d7dc4 00000082 a5b525ef 00000050 f673a550 1f0debed ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000068f f67398e0 f6739b6c c2a08580 00000001 a5b52e4b
[  712.768046]  00000050 f60d7da8 f6161880 00000000 c2a08580 f6739b6c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2083      1 0x00000000
[  712.768046]  f60b1dc4 00000082 a5b51c9d 00000050 f6b9eff0 1f0e23b9 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000005ab f673a550 f673a7dc c2a08580 00000001 a5b525ef
[  712.768046]  00000050 f60b1da8 f6161880 00000000 c2a08580 f673a7dc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2084      1 0x00000000
[  712.768046]  f60b3dc4 00000082 a5b51ca2 00000050 f60118e0 1f0e622b ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000098e f673b1c0 f673b44c c2808580 00000000 a5b525b8
[  712.768046]  00000050 f60b3da8 f6161880 00000000 c2a08580 f673b44c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2085      1 0x00000000
[  712.768046]  f607ddc4 00000082 a5b50a36 00000050 f673caa0 1f0e9a81 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f673be30 f673c0bc c2a08580 00000001 a5b51382
[  712.768046]  00000050 f607dda8 f6161880 00000000 c2a03a98 f673c0bc ffff2f5b 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2086      1 0x00000000
[  712.768046]  f607fdc4 00000082 a5b50186 00000050 f673d710 1f0ede3b ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000a65 f673caa0 f673cd2c c2a08580 00000001 a5b50a36
[  712.768046]  00000050 f607fda8 f6161880 00000000 c2a08580 f673cd2c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2087      1 0x00000000
[  712.768046]  f6071dc4 00000082 a5b4f876 00000050 f673e380 1f0f0897 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f673d710 f673d99c c2a08580 00000001 a5b50186
[  712.768046]  00000050 f6071da8 f6161880 00000000 c2a03a98 f673d99c ffff2f5b 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2088      1 0x00000000
[  712.768046]  f6073dc4 00000082 a5b4eed7 00000050 f673eff0 1f0f44fc ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 000008b6 f673e380 f673e60c c2a08580 00000001 a5b4f876
[  712.768046]  00000050 f6073da8 f6161880 00000000 c2a08580 f673e60c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2089      1 0x00000000
[  712.768046]  f6051dc4 00000082 a5b4e412 00000050 f6b98000 1f0f6e19 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f673eff0 f673f27c c2a08580 00000001 a5b4eed7
[  712.768046]  00000050 f6051da8 f6161880 00000000 c2a03a98 f673f27c ffff2f5b 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2090      1 0x00000000
[  712.768046]  f6053dc4 00000082 a5b4da42 00000050 f6b98c70 1f0faabe ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000820 f6b98000 f6b9828c c2a08580 00000001 a5b4e412
[  712.768046]  00000050 f6053da8 f6161880 00000000 c2a08580 f6b9828c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2091      1 0x00000000
[  712.768046]  f6041dc4 00000082 a5b4cfa7 00000050 f6b998e0 1f0fd3c4 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b98c70 f6b98efc c2a08580 00000001 a5b4da42
[  712.768046]  00000050 f6041da8 f6161880 00000000 c2a03a98 f6b98efc ffff2f5b 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2092      1 0x00000000
[  712.768046]  f6043dc4 00000082 a5b4c68b 00000050 f6015710 1f100f8e ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000928 f6b998e0 f6b99b6c c2a08580 00000001 a5b4cfa7
[  712.768046]  00000050 f6043da8 f6161880 00000000 c2a08580 f6b99b6c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2093      1 0x00000000
[  712.768046]  f603ddc4 00000082 a5b4bcfc 00000050 f6b9b1c0 1f103bdb ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000b8b f6b9a550 f6b9a7dc c2808580 00000000 a5b4c696
[  712.768046]  00000050 f603dda8 f6161880 00000000 c2a08580 f6b9a7dc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2094      1 0x00000000
[  712.768046]  f603fdc4 00000082 a5b4b2af 00000050 f6b9be30 1f1087ee ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000784 f6b9b1c0 f6b9b44c c2808580 00000000 a5b4bcfc
[  712.768046]  00000050 f603fda8 f6161880 00000000 c2a08580 f6b9b44c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2095      1 0x00000000
[  712.768046]  f6005dc4 00000082 a5b4a86d 00000050 f6b9caa0 1f10beee ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000074e f6b9be30 f6b9c0bc c2808580 00000000 a5b4b2af
[  712.768046]  00000050 f6005da8 f6161880 00000000 c2a08580 f6b9c0bc 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c107fd1c>] ? __lru_cache_add+0x51/0x56
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2096      1 0x00000000
[  712.768046]  f6007dc4 00000082 a5b49d5a 00000050 f7032550 1f10fb39 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 0000075a f6b9caa0 f6b9cd2c c2808580 00000000 a5b4a86d
[  712.768046]  00000050 f6007da8 f6161880 00000000 c2a08580 f6b9cd2c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2097      1 0x00000000
[  712.768046]  f6b49dc4 00000082 a5b49dc1 00000050 f6016ff0 1f1117b8 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 00000557 f6b9d710 f6b9d99c c2a08580 00000001 a5b4a3f0
[  712.768046]  00000050 f6b49da8 f6161880 00000000 c2a08580 f6b9d99c 00000005 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2098      1 0x00000000
[  712.768046]  f6b4bdc4 00000082 a5b361ea 00000050 f7034aa0 c16485e4 f6b4bdcc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b9e380 f6b9e60c c2a08580 00000001 a5b48cd3
[  712.768046]  00000050 00000000 f6161880 00000000 c2a03a98 f6b9e60c ffff2f5b 00000000
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2099      1 0x00000000
[  712.768046]  f66e5dc4 00000082 a5b51382 00000050 f673be30 00000000 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 00000000 f6b9eff0 f6b9f27c c2a08580 00000001 a5b51c9d
[  712.768046]  00000050 00000000 f6161880 00000000 00000000 f6b9f27c 00000000 00000000
[  712.768046] Call Trace:
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c1028dbc>] ? finish_task_switch+0x33/0x6e
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000085     0  2105      1 0x00000000
[  712.768046]  f66b3e40 00000082 bc3e9f42 00000085 00000082 00000005 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 f66b3e14 f6b63e30 f6b640bc c2808580 00000000 bc3ebec6
[  712.768046]  00000085 f64331c0 f6161880 00000000 00000000 f6b640bc f672bbf8 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c10a954b>] pipe_wait+0x4c/0x64
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a9c1f>] pipe_read+0x2a7/0x304
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c10a2a70>] ? do_sync_read+0x0/0xe9
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] console-kit-d S 00000050     0  2275      1 0x00000000
[  712.768046]  f606ddc4 00000082 a5bb8d12 00000050 00000001 00000001 f6915720 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f69de380 f69de60c c2808580 00000000 5bf5d62d
[  712.768046]  83b19932 00000002 f6161880 00000002 c2803a98 f69de60c 00002d48 f69db1f4
[  712.768046] Call Trace:
[  712.768046]  [<c1025eaf>] ? enqueue_task_fair+0x3f5/0x3fd
[  712.768046]  [<c11a7792>] vt_event_wait+0xa3/0xe7
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a77fb>] vt_waitactive+0x25/0x40
[  712.768046]  [<c11a8b81>] vt_ioctl+0x1124/0x181b
[  712.768046]  [<c1024bb9>] ? dequeue_task_fair+0x1dd/0x1e5
[  712.768046]  [<c10249d5>] ? pick_next_task_fair+0x8f/0x96
[  712.768046]  [<c11a7a5d>] ? vt_ioctl+0x0/0x181b
[  712.768046]  [<c11a125b>] tty_ioctl+0x692/0x6fd
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c10aedaf>] vfs_ioctl+0x22/0x69
[  712.768046]  [<c10af304>] do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c1037587>] ? exit_ptrace+0x1f/0x100
[  712.768046]  [<c10487ac>] ? switch_task_namespaces+0xf/0x3a
[  712.768046]  [<c10324c7>] ? do_exit+0x56c/0x57a
[  712.768046]  [<c10af36a>] sys_ioctl+0x2c/0x45
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] hald          S 0000004e     0  2113      1 0x00000000
[  712.768046]  f601be40 00000086 6f079ef9 0000004e 00000246 ffffffff 00000001 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6683e30 f66840bc c2a08580 00000001 c107de32
[  712.768046]  c15706c0 00000002 f6161500 c156fc40 c2a03a98 f66840bc 0000225b 00000002
[  712.768046] Call Trace:
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c10a954b>] pipe_wait+0x4c/0x64
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a9c1f>] pipe_read+0x2a7/0x304
[  712.768046]  [<c1144347>] ? cpumask_any_but+0x23/0x2f
[  712.768046]  [<c101d41b>] ? flush_tlb_page+0x45/0x5d
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c108b1e3>] ? do_wp_page+0x265/0x57c
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c10a2a70>] ? do_sync_read+0x0/0xe9
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] hald-runner   S 00000014     0  2114   2113 0x00000000
[  712.768046]  f602bb68 00000082 38976dae 00000014 00000046 00011220 c1506cc8 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f66831c0 f668344c c2808580 00000000 c107ae4d
[  712.768046]  f602bb50 c107b09a f61a6a80 00000000 c2803a98 f668344c ffff2fd0 f602bb4c
[  712.768046] Call Trace:
[  712.768046]  [<c107ae4d>] ? mempool_alloc_slab+0xe/0x10
[  712.768046]  [<c107b09a>] ? mempool_alloc+0x3d/0xd8
[  712.768046]  [<c1132611>] ? __elv_add_request+0x86/0x8b
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c119e7fe>] ? extract_buf+0x78/0xc8
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.768046]  [<c12ce130>] ? sock_def_readable+0x12/0x65
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12cc1fd>] ? sock_sendmsg+0xca/0xe1
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12cb396>] ? sock_aio_write+0xcd/0xda
[  712.768046]  [<c12cc44a>] ? sys_sendto+0xa4/0xc3
[  712.768046]  [<c114b134>] ? copy_to_user+0x2c/0xfc
[  712.768046]  [<c10a61d4>] ? cp_new_stat64+0xe4/0xf6
[  712.768046]  [<c10a66ea>] ? sys_fstat64+0x22/0x28
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c10ae72a>] ? sys_fcntl64+0x60/0x6a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] udevadm       D 00000014     0  2116   2113 0x00000000
[  712.768046]  f64fbdd8 00000082 509f7b85 00000014 00000001 00000046 f64fbd90 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6686ff0 f668727c c2808580 00000000 00000000
[  712.768046]  c156f700 f64fbd9c f6a42c40 c2803240 c2803a98 f668727c ffff303d c1014286
[  712.768046] Call Trace:
[  712.768046]  [<c1014286>] ? smp_apic_timer_interrupt+0x6f/0x7d
[  712.768046]  [<c10032b6>] ? apic_timer_interrupt+0x2a/0x30
[  712.768046]  [<c1340dac>] __mutex_lock_slowpath+0xaa/0xe1
[  712.768046]  [<c1341066>] mutex_lock+0x1a/0x28
[  712.768046]  [<c10e08a2>] sysfs_permission+0x1e/0x54
[  712.768046]  [<c10abcdc>] __link_path_walk+0x65/0xb33
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c10ac966>] path_walk+0x50/0xa5
[  712.768046]  [<c10aca68>] do_path_lookup+0x21/0x42
[  712.768046]  [<c10ad284>] user_path_at+0x3c/0x67
[  712.768046]  [<c107d897>] ? free_hot_page+0x31/0x35
[  712.768046]  [<c10e21c8>] ? sysfs_put_link+0x0/0x1a
[  712.768046]  [<c107d90b>] ? free_pages+0x1d/0x1f
[  712.768046]  [<c10e21e0>] ? sysfs_put_link+0x18/0x1a
[  712.768046]  [<c10aaf07>] ? generic_readlink+0x64/0x6f
[  712.768046]  [<c10a63f2>] vfs_fstatat+0x2d/0x54
[  712.768046]  [<c10a64c2>] vfs_stat+0x13/0x15
[  712.768046]  [<c10a64d8>] sys_stat64+0x14/0x28
[  712.768046]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.768046]  [<c10aaa4c>] ? path_put+0x20/0x23
[  712.768046]  [<c10a63a6>] ? sys_readlinkat+0x67/0x71
[  712.768046]  [<c10a63c3>] ? sys_readlink+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] dhclient      S 0000004f     0  2193      1 0x00000000
[  712.768046]  f66e7adc 00000086 e36ab66a 0000004f 00000000 f66e7ae8 c2a03dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6684aa0 f6684d2c c2a08580 00000001 29414c1e
[  712.768046]  000011e9 f66e7ae8 f6a42700 00000000 c2a03a98 f6684d2c 000029cc ffffffff
[  712.768046] Call Trace:
[  712.768046]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10e96c8>] ? __ext3_get_inode_loc+0xc5/0x283
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10c0aa2>] ? __find_get_block+0x141/0x14b
[  712.768046]  [<c10455b6>] ? wake_up_bit+0x5c/0x61
[  712.768046]  [<c10ffd38>] ? do_get_write_access+0x382/0x3ba
[  712.768046]  [<c10e96c8>] ? __ext3_get_inode_loc+0xc5/0x283
[  712.768046]  [<c1146d6e>] ? __prop_inc_single+0x30/0x38
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c10ff59d>] ? journal_stop+0x219/0x224
[  712.768046]  [<c10e9dd7>] ? ext3_dirty_inode+0x5f/0x67
[  712.768046]  [<c10ec0f4>] ? ext3_writeback_write_end+0xcc/0xf5
[  712.768046]  [<c107a057>] ? generic_file_buffered_write+0x10f/0x1eb
[  712.768046]  [<c107a0ac>] ? generic_file_buffered_write+0x164/0x1eb
[  712.768046]  [<c1033530>] ? current_fs_time+0x16/0x19
[  712.768046]  [<c107a679>] ? __generic_file_aio_write+0x3be/0x3f6
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c1079270>] ? find_get_page+0x1d/0x81
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gdm           S 00000053     0  2259      1 0x00000000
[  712.768046]  f65d3b68 00000086 cd2f29bf 00000053 f6436ff0 000000dc f69c3a00 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f69d98e0 f69d9b6c c2808580 00000000 cd2f6029
[  712.768046]  00000053 f6ddf600 f6ac2e00 c10ffd38 c2803a98 f69d9b6c 00003a03 f69c3a00
[  712.768046] Call Trace:
[  712.768046]  [<c10ffd38>] ? do_get_write_access+0x382/0x3ba
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c10f41a1>] ? __ext3_journal_dirty_metadata+0x19/0x3c
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10eaf87>] ? ext3_get_blocks_handle+0x708/0x7c4
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.768046]  [<c12ce130>] ? sock_def_readable+0x12/0x65
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12d17f3>] ? skb_release_data+0x8e/0x92
[  712.768046]  [<c132a8f8>] ? unix_stream_recvmsg+0x379/0x44a
[  712.768046]  [<c12d15d1>] ? __kfree_skb+0x6e/0x71
[  712.768046]  [<c12d0eaa>] ? skb_dequeue+0x45/0x4c
[  712.768046]  [<c132a94c>] ? unix_stream_recvmsg+0x3cd/0x44a
[  712.768046]  [<c10aaa4c>] ? path_put+0x20/0x23
[  712.768046]  [<c12cb474>] ? sock_aio_read+0xd1/0xdf
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c10ca00e>] ? fsnotify_clear_marks_by_inode+0x1e/0xa5
[  712.768046]  [<c12cb24d>] ? sock_destroy_inode+0x10/0x12
[  712.768046]  [<c10b40a0>] ? destroy_inode+0x1f/0x30
[  712.768046]  [<c10b169a>] ? __d_free+0x3a/0x3d
[  712.768046]  [<c10b16c2>] ? d_free+0x25/0x37
[  712.768046]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.768046]  [<c10a3cc3>] ? __fput+0x175/0x17d
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gdm           S 00000055     0  2263   2259 0x00000000
[  712.768046]  f6273e40 00000086 b2dee509 00000055 f69d8c70 f6273df4 f6ac2034 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f69d8000 f69d828c c2a08580 00000001 b2df18fe
[  712.768046]  00000055 c107d9c2 f6ac2000 00000246 c2a03a98 f69d828c 00004270 00000002
[  712.768046] Call Trace:
[  712.768046]  [<c107d9c2>] ? get_page_from_freelist+0x86/0x361
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c10a954b>] pipe_wait+0x4c/0x64
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a9c1f>] pipe_read+0x2a7/0x304
[  712.768046]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a2a70>] ? do_sync_read+0x0/0xe9
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] X             S 000000a5     0  2273   2263 0x00400000
[  712.768046]  f6573adc 00203086 dfa865cd 000000a5 00000000 f6573ae8 c2a03dbc c15e0580
[  712.768046]  c15e0580 c15e0580 f6573ae8 f69d8c70 f69d8efc c2a08580 00000001 dfaa9b43
[  712.768046]  000000a5 f6573ae8 f72d8700 00000000 f6573ab4 f69d8efc 00000001 f6573ae8
[  712.768046] Call Trace:
[  712.768046]  [<c1048579>] ? hrtimer_start_range_ns+0x10/0x12
[  712.768046]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c102ba91>] ? default_wake_function+0xb/0xd
[  712.768046]  [<c10b1014>] ? pollwake+0x5a/0x66
[  712.768046]  [<c103a0a5>] ? lock_timer_base+0x1f/0x3e
[  712.768046]  [<c103a379>] ? mod_timer+0x166/0x171
[  712.768046]  [<c11d2849>] ? i915_add_request+0x35/0x241
[  712.768046]  [<c11d2930>] ? i915_add_request+0x11c/0x241
[  712.768046]  [<c11d2a2c>] ? i915_add_request+0x218/0x241
[  712.768046]  [<c12c88b1>] ? pci_conf1_write+0xb3/0xc1
[  712.768046]  [<c12c9d48>] ? raw_pci_write+0x4d/0x58
[  712.768046]  [<c12c9d92>] ? pci_write+0x1d/0x22
[  712.768046]  [<c1151ea0>] ? pci_bus_write_config_word+0x51/0x5d
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c11bdddf>] ? drm_ioctl+0x23b/0x286
[  712.768046]  [<c11d31c3>] ? i915_gem_throttle_ioctl+0x0/0x64
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c1047b24>] ? enqueue_hrtimer+0x7c/0x87
[  712.768046]  [<c10aede4>] ? vfs_ioctl+0x57/0x69
[  712.768046]  [<c10af304>] ? do_vfs_ioctl+0x46a/0x4a4
[  712.768046]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] cupsd         S 000000a5     0  2277      1 0x00000000
[  712.768046]  f6aa3f10 00000082 b0d04a94 000000a5 f7034aa0 00000000 f64f0668 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6442550 f64427dc c2a08580 00000001 754116c0
[  712.768046]  000000a5 c10a2b1b f72d9880 00000286 c2a03a98 f64427dc 000191fa ffffffff
[  712.768046] Call Trace:
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c103a667>] ? process_timeout+0x0/0xa
[  712.768046]  [<c10cc8ee>] sys_epoll_wait+0x145/0x1dd
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] foomatic-rip  S 00000055     0  2283   2277 0x00000000
[  712.768046]  f622fe40 00000082 50844b78 00000055 f6bd3160 f6ac2540 00000134 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6682550 f66827dc c2808580 00000000 000200da
[  712.768046]  f622fe60 00000082 f6ac2540 c10cc792 c2803a98 f66827dc 000040ac 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c10cc792>] ? ep_poll_callback+0x8d/0xa4
[  712.768046]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.768046]  [<c10a954b>] pipe_wait+0x4c/0x64
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a9c1f>] pipe_read+0x2a7/0x304
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c10a2a70>] ? do_sync_read+0x0/0xe9
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] usb           S 000000a5     0  2284   2277 0x00000000
[  712.768046]  f610df10 00000086 753577a2 000000a5 00000000 f610df44 c2803dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6685710 f668599c c2808580 00000000 9f45e9c5
[  712.768046]  000000a6 f610df44 f72d8fc0 00000000 c2803a98 f668599c 000190f8 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c13411cb>] do_nanosleep+0x5e/0x9b
[  712.768046]  [<c10485fd>] hrtimer_nanosleep+0x82/0xe1
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c104869e>] sys_nanosleep+0x42/0x53
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] kerneloops    S 000000a3     0  2300      1 0x00000000
[  712.768046]  f65d1b68 00000082 f14b24ce 000000a3 00000000 f65d1b74 c2803dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b60c70 f6b60efc c2808580 00000000 44bb8cc5
[  712.768046]  000000a6 f65d1b74 f72d8c40 00000000 c2803a98 f6b60efc 00018a96 ffffffff
[  712.768046] Call Trace:
[  712.768046]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.768046]  [<c1047841>] ? hrtimer_forward+0xf4/0x10a
[  712.768046]  [<c1013972>] ? lapic_next_event+0x16/0x1a
[  712.768046]  [<c104f550>] ? clockevents_program_event+0xd4/0xe3
[  712.768046]  [<c1144379>] ? cpumask_next_and+0x26/0x37
[  712.768046]  [<c1026f25>] ? find_busiest_group+0x38f/0x8f0
[  712.768046]  [<c1144379>] ? cpumask_next_and+0x26/0x37
[  712.768046]  [<c1026f25>] ? find_busiest_group+0x38f/0x8f0
[  712.768046]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.768046]  [<c101325d>] ? native_smp_send_reschedule+0x43/0x45
[  712.768046]  [<c101df64>] ? resched_task+0x5b/0x5e
[  712.768046]  [<c1047841>] ? hrtimer_forward+0xf4/0x10a
[  712.768046]  [<c1013972>] ? lapic_next_event+0x16/0x1a
[  712.768046]  [<c104f550>] ? clockevents_program_event+0xd4/0xe3
[  712.768046]  [<c1039dcd>] ? run_timer_softirq+0x37/0x203
[  712.768046]  [<c10503be>] ? tick_dev_program_event+0x28/0x95
[  712.768046]  [<c1034715>] ? __do_softirq+0x13c/0x144
[  712.768046]  [<c103482f>] ? irq_exit+0x39/0x5c
[  712.768046]  [<c1014286>] ? smp_apic_timer_interrupt+0x6f/0x7d
[  712.768046]  [<c10032b6>] ? apic_timer_interrupt+0x2a/0x30
[  712.768046]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 00000085     0  2318      1 0x00000000
[  712.768046]  f64f9adc 00000082 bb661c8f 00000085 f6af0000 000000d2 f69c3a00 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f64431c0 f644344c c2808580 00000000 bb665102
[  712.768046]  00000085 f6f25d00 f72d8540 c10ffd38 c2803a98 f644344c 0001084b 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c10ffd38>] ? do_get_write_access+0x382/0x3ba
[  712.768046]  [<c10c0aa2>] ? __find_get_block+0x141/0x14b
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10e96c8>] ? __ext3_get_inode_loc+0xc5/0x283
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10c0aa2>] ? __find_get_block+0x141/0x14b
[  712.768046]  [<c10455b6>] ? wake_up_bit+0x5c/0x61
[  712.768046]  [<c10ffd38>] ? do_get_write_access+0x382/0x3ba
[  712.768046]  [<c10e96c8>] ? __ext3_get_inode_loc+0xc5/0x283
[  712.768046]  [<c1146d6e>] ? __prop_inc_single+0x30/0x38
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c101dc06>] ? kmap_atomic_prot+0xae/0xb0
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.768046]  [<c107d9c2>] ? get_page_from_freelist+0x86/0x361
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c107fcbd>] ? ____pagevec_lru_add+0xf4/0x102
[  712.768046]  [<c107fd1c>] ? __lru_cache_add+0x51/0x56
[  712.768046]  [<c107fd48>] ? lru_cache_add_lru+0x27/0x29
[  712.768046]  [<c10ca00e>] ? fsnotify_clear_marks_by_inode+0x1e/0xa5
[  712.768046]  [<c10b40ae>] ? destroy_inode+0x2d/0x30
[  712.768046]  [<c10b169a>] ? __d_free+0x3a/0x3d
[  712.768046]  [<c10b16c2>] ? d_free+0x25/0x37
[  712.768046]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] foomatic-rip  S 00000055     0  2351   2283 0x00000000
[  712.768046]  f6693f20 00000082 50825516 00000055 f61a7b98 f6693ebc c101d41b c15e0580
[  712.768046]  c15e0580 c15e0580 f6693ed0 f69db1c0 f69db44c c2808580 00000000 50844b78
[  712.768046]  00000055 f6693f58 f61a7a40 c25c56a0 087a34f0 f69db44c f61a7a40 00000000
[  712.768046] Call Trace:
[  712.768046]  [<c101d41b>] ? flush_tlb_page+0x45/0x5d
[  712.768046]  [<c1031d1e>] do_wait+0x18b/0x1e8
[  712.768046]  [<c1031e03>] sys_wait4+0x88/0x9b
[  712.768046]  [<c1030770>] ? child_wait_callback+0x0/0x64
[  712.768046]  [<c1031e29>] sys_waitpid+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] foomatic-rip  S 00000055     0  2352   2351 0x00000000
[  712.768046]  f7277e3c 00000086 4e46e039 00000055 00000055 f6440000 ffffffff c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6446ff0 f644727c c2a08580 00000001 00000001
[  712.768046]  c107de32 c15706c0 f72d81c0 f72d81c0 c2a03a98 f644727c 000040cb 000040cb
[  712.768046] Call Trace:
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c10a954b>] pipe_wait+0x4c/0x64
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a9917>] pipe_write+0x3b4/0x415
[  712.768046]  [<c10a2a32>] do_sync_write+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c10a2987>] ? do_sync_write+0x0/0xe9
[  712.768046]  [<c10a3390>] vfs_write+0x8a/0x13d
[  712.768046]  [<c10a34dc>] sys_write+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] cron          S 0000009e     0  2357      1 0x00000000
[  712.768046]  f6abbf10 00000082 f7288e4b 0000009e 00000000 f6abbf44 c2803dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f69dd710 f69dd99c c2808580 00000000 ef703d52
[  712.768046]  000000ac f6abbf44 f61a7180 00000000 c2803a98 f69dd99c 000175b4 00000000
[  712.768046] Call Trace:
[  712.768046]  [<c13411cb>] do_nanosleep+0x5e/0x9b
[  712.768046]  [<c10485fd>] hrtimer_nanosleep+0x82/0xe1
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c104869e>] sys_nanosleep+0x42/0x53
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] agetty        S 00000052     0  2373      1 0x00000000
[  712.768046]  f6afbe78 00000086 e9c8ceff 00000052 00000000 00000000 000004bf c15e0580
[  712.768046]  c15e0580 c15e0580 1a131100 f6450c70 f6450efc c2808580 00000000 e9cc1884
[  712.768046]  00000052 00000004 f72d9500 00000020 00000700 f6450efc f6afbe54 c1048cfc
[  712.768046] Call Trace:
[  712.768046]  [<c1048cfc>] ? atomic_notifier_call_chain+0xf/0x11
[  712.768046]  [<c11b077f>] ? do_con_write+0x1946/0x196f
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10427f7>] ? flush_work+0x10/0x6b
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2f06>] n_tty_read+0x37d/0x5c9
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c119f635>] tty_read+0x62/0x99
[  712.768046]  [<c119f5d3>] ? tty_read+0x0/0x99
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] agetty        S 00000052     0  2374      1 0x00000000
[  712.768046]  f6199e78 00000086 e9d87ee9 00000052 00000000 00000001 00000086 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f64518e0 f6451b6c c2808580 00000000 c1048bb4
[  712.768046]  f6199eac 00000004 f6ac2fc0 00000020 c2803a98 f6451b6c 000036c7 c1048cfc
[  712.768046] Call Trace:
[  712.768046]  [<c1048bb4>] ? up+0x2b/0x2f
[  712.768046]  [<c1048cfc>] ? atomic_notifier_call_chain+0xf/0x11
[  712.768046]  [<c11b077f>] ? do_con_write+0x1946/0x196f
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10427f7>] ? flush_work+0x10/0x6b
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2f06>] n_tty_read+0x37d/0x5c9
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c119f635>] tty_read+0x62/0x99
[  712.768046]  [<c119f5d3>] ? tty_read+0x0/0x99
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] agetty        S 00000052     0  2375      1 0x00000000
[  712.768046]  f619be78 00000082 e9cc1884 00000052 00000000 00000000 000004bf c15e0580
[  712.768046]  c15e0580 c15e0580 1a131100 f6456380 f645660c c2808580 00000000 e9ce9978
[  712.768046]  00000052 00000004 f6a42a80 00000020 00000700 f645660c f619be54 c1048cfc
[  712.768046] Call Trace:
[  712.768046]  [<c1048cfc>] ? atomic_notifier_call_chain+0xf/0x11
[  712.768046]  [<c11b077f>] ? do_con_write+0x1946/0x196f
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10427f7>] ? flush_work+0x10/0x6b
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2f06>] n_tty_read+0x37d/0x5c9
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c119f635>] tty_read+0x62/0x99
[  712.768046]  [<c119f5d3>] ? tty_read+0x0/0x99
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] agetty        S 00000052     0  2376      1 0x00000000
[  712.768046]  f6249e78 00000082 e9d52f4e 00000052 f6249e4c c1025e76 000079a2 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6456ff0 f645727c c2808580 00000000 00000001
[  712.768046]  05bdb127 00000003 f6a43180 ffffffff c2803a98 f645727c 000036c7 00000001
[  712.768046] Call Trace:
[  712.768046]  [<c1025e76>] ? enqueue_task_fair+0x3bc/0x3fd
[  712.768046]  [<c101325d>] ? native_smp_send_reschedule+0x43/0x45
[  712.768046]  [<c101df64>] ? resched_task+0x5b/0x5e
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10427f7>] ? flush_work+0x10/0x6b
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2f06>] n_tty_read+0x37d/0x5c9
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c119f635>] tty_read+0x62/0x99
[  712.768046]  [<c119f5d3>] ? tty_read+0x0/0x99
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] agetty        S 00000052     0  2377      1 0x00000000
[  712.768046]  f624be78 00000082 e9d862c2 00000052 f624be4c c1025e76 00000e6d c15e0580
[  712.768046]  c15e0580 c15e0580 ffffffff f6680c70 f6680efc c2a08580 00000001 e9d87ec3
[  712.768046]  00000052 00000002 f6a43880 ffffffff 00000000 f6680efc f64518e0 c2808580
[  712.768046] Call Trace:
[  712.768046]  [<c1025e76>] ? enqueue_task_fair+0x3bc/0x3fd
[  712.768046]  [<c101e98a>] ? enqueue_task+0x62/0x6e
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10427f7>] ? flush_work+0x10/0x6b
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2f06>] n_tty_read+0x37d/0x5c9
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c119f635>] tty_read+0x62/0x99
[  712.768046]  [<c119f5d3>] ? tty_read+0x0/0x99
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] agetty        S 00000052     0  2378      1 0x00000000
[  712.768046]  f6205e78 00000086 e9d87ec3 00000052 00000000 00000000 000004bf c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6686380 f668660c c2a08580 00000001 c1048bb4
[  712.768046]  f6205eac 00000004 f72d96c0 00000020 c2a03a98 f668660c 000036cb c1048cfc
[  712.768046] Call Trace:
[  712.768046]  [<c1048bb4>] ? up+0x2b/0x2f
[  712.768046]  [<c1048cfc>] ? atomic_notifier_call_chain+0xf/0x11
[  712.768046]  [<c11b077f>] ? do_con_write+0x1946/0x196f
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10427f7>] ? flush_work+0x10/0x6b
[  712.768046]  [<c103a571>] ? try_to_del_timer_sync+0x7d/0x85
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2f06>] n_tty_read+0x37d/0x5c9
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c119f635>] tty_read+0x62/0x99
[  712.768046]  [<c119f5d3>] ? tty_read+0x0/0x99
[  712.768046]  [<c10a3588>] vfs_read+0x87/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gdmgreeter    S 000000a5     0  2384   2263 0x00000000
[  712.768046]  f6093b68 00000086 dfaa9b43 000000a5 00000000 f6093b74 c2a03dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6436ff0 f643727c c2a08580 00000001 f770979c
[  712.768046]  000000a5 f6093b74 f61a76c0 00000000 c2a03a98 f643727c 0001929d f6093b74
[  712.768046] Call Trace:
[  712.768046]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10237a1>] ? check_preempt_wakeup+0x178/0x1ec
[  712.768046]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.768046]  [<c102ba91>] ? default_wake_function+0xb/0xd
[  712.768046]  [<c10b1014>] ? pollwake+0x5a/0x66
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.768046]  [<c10231c4>] ? __wake_up_sync_key+0x3b/0x45
[  712.768046]  [<c12ce155>] ? sock_def_readable+0x37/0x65
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12d0eaa>] ? skb_dequeue+0x45/0x4c
[  712.768046]  [<c132a94c>] ? unix_stream_recvmsg+0x3cd/0x44a
[  712.768046]  [<c12cb474>] ? sock_aio_read+0xd1/0xdf
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 00000054     0  2385   2318 0x00000000
[  712.768046]  f66c3d8c 00000086 3cae2cfa 00000054 f6b64aa0 f66c3d18 f66c3d18 c15e0580
[  712.768046]  c15e0580 c15e0580 f66c3eec f64318e0 f6431b6c c2808580 00000000 3cae30bf
[  712.768046]  00000054 f6097180 f6160e00 00000001 00000001 f6431b6c 00000040 00000951
[  712.768046] Call Trace:
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c132a780>] unix_stream_recvmsg+0x201/0x44a
[  712.768046]  [<c10b28b8>] ? __d_lookup+0xa4/0xd8
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c12cb474>] sock_aio_read+0xd1/0xdf
[  712.768046]  [<c10a11eb>] ? __dentry_open+0x175/0x249
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a0df0>] ? fd_install+0x24/0x46
[  712.768046]  [<c10a3599>] vfs_read+0x98/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 00000054     0  2398      1 0x00000000
[  712.768046]  f6027b68 00000082 752fe4fd 00000054 00000000 00000000 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 00000000 f6440c70 f6440efc c2808580 00000000 753551d9
[  712.768046]  00000054 c16e6924 f61a7340 00bc2850 f6dcc32c f6440efc f5cee080 00bc2850
[  712.768046] Call Trace:
[  712.768046]  [<c10c06a5>] ? __find_get_block_slow+0xe3/0xed
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.768046]  [<c12ce130>] ? sock_def_readable+0x12/0x65
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12cc1fd>] ? sock_sendmsg+0xca/0xe1
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10b1014>] ? pollwake+0x5a/0x66
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 00000054     0  2399      1 0x00000000
[  712.768046]  f6059eac 00000082 753551d9 00000054 f6440c70 c28085c0 f6059e78 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b66380 f6b6660c c2808580 00000000 75356542
[  712.768046]  00000054 f73c83bd f61a7340 f6206cc8 c2803a98 f6b6660c 00003c07 f6dd7cf8
[  712.768046] Call Trace:
[  712.768046]  [<c1144347>] ? cpumask_any_but+0x23/0x2f
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c101cc94>] ? ptep_set_access_flags+0x21/0x28
[  712.768046]  [<c103ac39>] ? recalc_sigpending+0x12/0x32
[  712.768046]  [<c103dc52>] ? dequeue_signal+0x9d/0x10b
[  712.768046]  [<c1340a63>] schedule_timeout_interruptible+0x15/0x17
[  712.768046]  [<c103dde3>] sys_rt_sigtimedwait+0x123/0x1d8
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c10324c7>] ? do_exit+0x56c/0x57a
[  712.768046]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 00000054     0  2403      1 0x00000000
[  712.768046]  f605dd54 00000082 4f9d8daf 00000054 000004d0 00000190 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b62550 f6b627dc c2a08580 00000001 00000000
[  712.768046]  c1506cc8 f6a42fc0 f61a7340 00000000 c2a03a98 f6b627dc 00003c8c 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c1051a44>] futex_wait_queue_me+0x98/0xac
[  712.768046]  [<c1051b56>] futex_wait+0xfe/0x21b
[  712.768046]  [<c12cc1fd>] ? sock_sendmsg+0xca/0xe1
[  712.768046]  [<c1053198>] do_futex+0x86/0xbcd
[  712.768046]  [<c102340e>] ? update_curr+0x8f/0x19d
[  712.768046]  [<c1079270>] ? find_get_page+0x1d/0x81
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c1053dc8>] sys_futex+0xe9/0xff
[  712.768046]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 00000058     0  2400   2385 0x00000000
[  712.768046]  f60b9adc 00000082 c5d29859 00000058 f7035710 00000000 c15e0580 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b64aa0 f6b64d2c c2808580 00000000 9886e4db
[  712.768046]  00000058 c14f6a1c f6097340 0000000a c2803a98 f6b64d2c 00004f4a 00000000
[  712.768046] Call Trace:
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2638>] ? n_tty_poll+0x0/0x121
[  712.768046]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c12f4b8d>] ? ip_output+0x86/0x8b
[  712.768046]  [<c12f3e2d>] ? ip_local_out+0x18/0x1b
[  712.768046]  [<c12f45a1>] ? ip_queue_xmit+0x2c0/0x303
[  712.768046]  [<c1025eaf>] ? enqueue_task_fair+0x3f5/0x3fd
[  712.768046]  [<c103a0a5>] ? lock_timer_base+0x1f/0x3e
[  712.768046]  [<c103a379>] ? mod_timer+0x166/0x171
[  712.768046]  [<c12ce1b2>] ? sk_reset_timer+0xf/0x1d
[  712.768046]  [<c1302e32>] ? tcp_event_new_data_sent+0xa0/0xc8
[  712.768046]  [<c13055b4>] ? tcp_write_xmit+0x79b/0x85a
[  712.768046]  [<c114b134>] ? copy_to_user+0x2c/0xfc
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c1341e62>] ? _spin_unlock_bh+0xd/0xf
[  712.768046]  [<c12cde0e>] ? release_sock+0x7f/0x87
[  712.768046]  [<c12fb2c9>] ? tcp_sendmsg+0x7b8/0x88e
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c10a2a32>] ? do_sync_write+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c10a34dc>] ? sys_write+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] bash          S 00000058     0  2401   2400 0x00000000
[  712.768046]  f6025f20 00000086 c595a165 00000058 06f17f3f 00000000 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b65710 f6b6599c c2808580 00000000 c119f2fe
[  712.768046]  c11a0bc9 f6025f58 f60976c0 c11a0fb2 c2803a98 f6b6599c 00004f4a f7150000
[  712.768046] Call Trace:
[  712.768046]  [<c119f2fe>] ? tty_get_pgrp+0x27/0x2d
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c11a0fb2>] ? tty_ioctl+0x3e9/0x6fd
[  712.768046]  [<c1031d1e>] do_wait+0x18b/0x1e8
[  712.768046]  [<c1031e03>] sys_wait4+0x88/0x9b
[  712.768046]  [<c1030770>] ? child_wait_callback+0x0/0x64
[  712.768046]  [<c1031e29>] sys_waitpid+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] ssh-agent     S 00000085     0  2438      1 0x00000000
[  712.768046]  f669badc 00000086 c5be115e 00000085 f69da550 574752f0 3e2efb5b c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f69dcaa0 f69dcd2c c2a08580 00000001 c5be4619
[  712.768046]  00000085 f6b6257c f60968c0 01228000 c2803a98 f69dcd2c 00004577 f6b6257c
[  712.768046] Call Trace:
[  712.768046]  [<c10249d5>] ? pick_next_task_fair+0x8f/0x96
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c131eab5>] ? bictcp_cong_avoid+0x72/0x2b9
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c13019ed>] ? tcp_rcv_established+0x61b/0x7b8
[  712.768046]  [<c1025eaf>] ? enqueue_task_fair+0x3f5/0x3fd
[  712.768046]  [<c1025eaf>] ? enqueue_task_fair+0x3f5/0x3fd
[  712.768046]  [<c109d16b>] ? __kmalloc_track_caller+0xdb/0x143
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d0eaa>] ? skb_dequeue+0x45/0x4c
[  712.768046]  [<c132a94c>] ? unix_stream_recvmsg+0x3cd/0x44a
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c114b134>] ? copy_to_user+0x2c/0xfc
[  712.768046]  [<c12cf01d>] ? sock_getsockopt+0x340/0x35c
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c10ca00e>] ? fsnotify_clear_marks_by_inode+0x1e/0xa5
[  712.768046]  [<c12cb24d>] ? sock_destroy_inode+0x10/0x12
[  712.768046]  [<c10b40a0>] ? destroy_inode+0x1f/0x30
[  712.768046]  [<c10b169a>] ? __d_free+0x3a/0x3d
[  712.768046]  [<c10b16c2>] ? d_free+0x25/0x37
[  712.768046]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gpg-agent     S 000000a5     0  2463      1 0x00000000
[  712.768046]  f6aa7adc 00000082 cda9ac28 000000a5 00000000 f6aa7ae8 c2a03dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6445710 f644599c c2a08580 00000001 804eb4b3
[  712.768046]  000000a6 f6aa7ae8 f6097a40 00000000 c2a03a98 f644599c 0001925f ffffffff
[  712.768046] Call Trace:
[  712.768046]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c1144379>] ? cpumask_next_and+0x26/0x37
[  712.768046]  [<c1026f25>] ? find_busiest_group+0x38f/0x8f0
[  712.768046]  [<c1148ce2>] ? put_dec+0x2a/0xff
[  712.768046]  [<c1148ed5>] ? number+0x11e/0x1d8
[  712.768046]  [<c1079270>] ? find_get_page+0x1d/0x81
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] ls            D 00000058     0  2521   2401 0x00000000
[  712.768046]  f605bdd8 00000086 c5a3063d 00000058 00000009 ffffffea f605be14 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6af2550 f6af27dc c2808580 00000000 f6deea74
[  712.768046]  f605bdb4 c10b28b8 f61a6fc0 f6c085d8 c2803a98 f6af27dc 00004f4a f6eaedd0
[  712.768046] Call Trace:
[  712.768046]  [<c10b28b8>] ? __d_lookup+0xa4/0xd8
[  712.768046]  [<c10aab8d>] ? do_lookup+0x4f/0x14e
[  712.768046]  [<c1340dac>] __mutex_lock_slowpath+0xaa/0xe1
[  712.768046]  [<c1341066>] mutex_lock+0x1a/0x28
[  712.768046]  [<c10e08a2>] sysfs_permission+0x1e/0x54
[  712.768046]  [<c10abcdc>] __link_path_walk+0x65/0xb33
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c10ac966>] path_walk+0x50/0xa5
[  712.768046]  [<c10aca68>] do_path_lookup+0x21/0x42
[  712.768046]  [<c10ad284>] user_path_at+0x3c/0x67
[  712.768046]  [<c107d897>] ? free_hot_page+0x31/0x35
[  712.768046]  [<c10e21c8>] ? sysfs_put_link+0x0/0x1a
[  712.768046]  [<c107d90b>] ? free_pages+0x1d/0x1f
[  712.768046]  [<c10e21e0>] ? sysfs_put_link+0x18/0x1a
[  712.768046]  [<c10aaf07>] ? generic_readlink+0x64/0x6f
[  712.768046]  [<c10a63f2>] vfs_fstatat+0x2d/0x54
[  712.768046]  [<c10a64c2>] vfs_stat+0x13/0x15
[  712.768046]  [<c10a64d8>] sys_stat64+0x14/0x28
[  712.768046]  [<c10b702a>] ? mntput_no_expire+0x19/0xac
[  712.768046]  [<c10aaa4c>] ? path_put+0x20/0x23
[  712.768046]  [<c10a63a6>] ? sys_readlinkat+0x67/0x71
[  712.768046]  [<c10a63c3>] ? sys_readlink+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 0000005a     0  2522   2318 0x00000000
[  712.768046]  f6a99d8c 00000082 dfd6a4d2 0000005a f64418e0 f6a99d18 f6a99d18 c15e0580
[  712.768046]  c15e0580 c15e0580 f6a99eec f6af18e0 f6af1b6c c2808580 00000000 dfd6a891
[  712.768046]  0000005a f6096e00 f72d9340 00000001 00000001 f6af1b6c 00000040 000009da
[  712.768046] Call Trace:
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c132a780>] unix_stream_recvmsg+0x201/0x44a
[  712.768046]  [<c10b28b8>] ? __d_lookup+0xa4/0xd8
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c12cb474>] sock_aio_read+0xd1/0xdf
[  712.768046]  [<c10a11eb>] ? __dentry_open+0x175/0x249
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a0df0>] ? fd_install+0x24/0x46
[  712.768046]  [<c10a3599>] vfs_read+0x98/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 0000005a     0  2535      1 0x00000000
[  712.768046]  f6415b68 00000082 dfce41b9 0000005a eeeeeeee eeeeeeee eeeeeeee c15e0580
[  712.768046]  c15e0580 c15e0580 eeeeeeee f6b66ff0 f6b6727c c2808580 00000000 dfd2fca8
[  712.768046]  0000005a eeeeeeee f6096380 eeeeeeee eeeeeeee f6b6727c eeeeeeee eeeeeeee
[  712.768046] Call Trace:
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c109cb44>] ? kmem_cache_alloc+0x64/0xda
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.768046]  [<c12ce130>] ? sock_def_readable+0x12/0x65
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12cc1fd>] ? sock_sendmsg+0xca/0xe1
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10b1014>] ? pollwake+0x5a/0x66
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 0000005a     0  2536      1 0x00000000
[  712.768046]  f6417eac 00000082 dfd64be2 0000005a f6af18e0 f7001a80 f6e38188 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6af6ff0 f6af727c c2a08580 00000001 f6af4aa0
[  712.768046]  01428000 28cc6416 f6096380 f6291ac8 c2a03a98 f6af727c 00005830 f6dd7d00
[  712.768046] Call Trace:
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c103ac39>] ? recalc_sigpending+0x12/0x32
[  712.768046]  [<c103dc52>] ? dequeue_signal+0x9d/0x10b
[  712.768046]  [<c1340a63>] schedule_timeout_interruptible+0x15/0x17
[  712.768046]  [<c103dde3>] sys_rt_sigtimedwait+0x123/0x1d8
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c10324c7>] ? do_exit+0x56c/0x57a
[  712.768046]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 0000005a     0  2537      1 0x00000000
[  712.768046]  f6ac9d54 00000082 dfba539d 0000005a 00000000 00000000 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6af31c0 f6af344c c2a08580 00000001 dfbab8e8
[  712.768046]  0000005a 00000000 f6096380 c134a314 c2a03a98 f6af344c 0000582f 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c1051a44>] futex_wait_queue_me+0x98/0xac
[  712.768046]  [<c1051b56>] futex_wait+0xfe/0x21b
[  712.768046]  [<c1053198>] do_futex+0x86/0xbcd
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c1079270>] ? find_get_page+0x1d/0x81
[  712.768046]  [<c1144347>] ? cpumask_any_but+0x23/0x2f
[  712.768046]  [<c101d41b>] ? flush_tlb_page+0x45/0x5d
[  712.768046]  [<c101cc94>] ? ptep_set_access_flags+0x21/0x28
[  712.768046]  [<c108b1e3>] ? do_wp_page+0x265/0x57c
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c1053dc8>] sys_futex+0xe9/0xff
[  712.768046]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 00000084     0  2538   2522 0x00000000
[  712.768046]  f6acbadc 00000086 6245282b 00000084 c15077a0 c2808b10 00000001 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f64418e0 f6441b6c c2808580 00000000 d6427b39
[  712.768046]  0000006f 00000002 f6097500 f6acbae8 c2803a98 f6441b6c 0001064b c102ba86
[  712.768046] Call Trace:
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2638>] ? n_tty_poll+0x0/0x121
[  712.768046]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c12f4b8d>] ? ip_output+0x86/0x8b
[  712.768046]  [<c12f3e2d>] ? ip_local_out+0x18/0x1b
[  712.768046]  [<c12f45a1>] ? ip_queue_xmit+0x2c0/0x303
[  712.768046]  [<c12f4acc>] ? ip_finish_output+0x1e6/0x221
[  712.768046]  [<c12f4b8d>] ? ip_output+0x86/0x8b
[  712.768046]  [<c103a0a5>] ? lock_timer_base+0x1f/0x3e
[  712.768046]  [<c103a379>] ? mod_timer+0x166/0x171
[  712.768046]  [<c12ce1b2>] ? sk_reset_timer+0xf/0x1d
[  712.768046]  [<c1302e32>] ? tcp_event_new_data_sent+0xa0/0xc8
[  712.768046]  [<c13055b4>] ? tcp_write_xmit+0x79b/0x85a
[  712.768046]  [<c114b134>] ? copy_to_user+0x2c/0xfc
[  712.768046]  [<c12d31a3>] ? memcpy_toiovec+0x2c/0x50
[  712.768046]  [<c12d3982>] ? skb_copy_datagram_iovec+0x6b/0x19d
[  712.768046]  [<c1341e62>] ? _spin_unlock_bh+0xd/0xf
[  712.768046]  [<c12cde0e>] ? release_sock+0x7f/0x87
[  712.768046]  [<c12fa638>] ? tcp_recvmsg+0x5c2/0x6c3
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c10a2b1b>] ? do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c11a2b89>] ? n_tty_read+0x0/0x5c9
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c10a36d4>] ? sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] bash          S 00000066     0  2540   2538 0x00000000
[  712.768046]  f653df20 00000086 79acdc70 00000066 07a2c0ce 00000000 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6af0c70 f6af0efc c2808580 00000000 c119f2fe
[  712.768046]  c11a0bc9 f653df58 f6412700 c11a0fb2 c2803a98 f6af0efc 000088d9 f6975000
[  712.768046] Call Trace:
[  712.768046]  [<c119f2fe>] ? tty_get_pgrp+0x27/0x2d
[  712.768046]  [<c11a0bc9>] ? tty_ioctl+0x0/0x6fd
[  712.768046]  [<c11a0fb2>] ? tty_ioctl+0x3e9/0x6fd
[  712.768046]  [<c1031d1e>] do_wait+0x18b/0x1e8
[  712.768046]  [<c1031e03>] sys_wait4+0x88/0x9b
[  712.768046]  [<c1030770>] ? child_wait_callback+0x0/0x64
[  712.768046]  [<c1031e29>] sys_waitpid+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] mutt          S 00000084     0  3468   2540 0x00000000
[  712.768046]  f6185b68 00000086 620f29f6 00000084 00000000 f6185b74 c2803dbc c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6af4aa0 f6af4d2c c2808580 00000000 14ee1261
[  712.768046]  00000110 f6185b74 f6412e00 00000000 c2803a98 f6af4d2c 0001064a f69c3a00
[  712.768046] Call Trace:
[  712.768046]  [<c1341138>] schedule_hrtimeout_range+0xc4/0xeb
[  712.768046]  [<c1047bb9>] ? hrtimer_wakeup+0x0/0x1c
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c10455b6>] ? wake_up_bit+0x5c/0x61
[  712.768046]  [<c107de32>] ? __alloc_pages_nodemask+0xdd/0x47b
[  712.768046]  [<c10927a5>] ? anon_vma_prepare+0x3a/0x99
[  712.768046]  [<c107fd48>] ? lru_cache_add_lru+0x27/0x29
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.768046]  [<c11a4d0d>] ? set_termios+0x376/0x38a
[  712.768046]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.768046]  [<c102366c>] ? check_preempt_wakeup+0x43/0x1ec
[  712.768046]  [<c10232b3>] ? task_rq_lock+0x31/0x5b
[  712.768046]  [<c102ba7c>] ? try_to_wake_up+0x2a5/0x2af
[  712.768046]  [<c102ba91>] ? default_wake_function+0xb/0xd
[  712.768046]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c11a0a63>] ? tty_wakeup+0x46/0x4e
[  712.768046]  [<c10457a4>] ? remove_wait_queue+0x30/0x34
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.768046]  [<c103bef1>] ? do_sigaction+0x6e/0x150
[  712.768046]  [<c104cb2e>] ? ktime_get_ts+0xd0/0xda
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 00000085     0  3470   2318 0x00000000
[  712.768046]  e2623d8c 00000086 bcc0f1c5 00000085 f6b631c0 e2623d18 e2623d18 c15e0580
[  712.768046]  c15e0580 c15e0580 e2623eec f6af0000 f6af028c c2808580 00000000 bcc0f51e
[  712.768046]  00000085 f6412a80 f64136c0 00000001 00000001 f6af028c 00000040 00000d8e
[  712.768046] Call Trace:
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c104576f>] ? prepare_to_wait+0x43/0x48
[  712.768046]  [<c132a780>] unix_stream_recvmsg+0x201/0x44a
[  712.768046]  [<c10b28b8>] ? __d_lookup+0xa4/0xd8
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c12cb474>] sock_aio_read+0xd1/0xdf
[  712.768046]  [<c10a11eb>] ? __dentry_open+0x175/0x249
[  712.768046]  [<c10a2b1b>] do_sync_read+0xab/0xe9
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10a0df0>] ? fd_install+0x24/0x46
[  712.768046]  [<c10a3599>] vfs_read+0x98/0x13a
[  712.768046]  [<c10a36d4>] sys_read+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 00000085     0  3483      1 0x00000000
[  712.768046]  e264bb68 00000086 bcc4c963 00000085 30203832 37323a39 2030353a c15e0580
[  712.768046]  c15e0580 c15e0580 37343737 f6b60000 f6b6028c c2a08580 00000001 bcc96067
[  712.768046]  00000085 72705f62 f64128c0 65746e69 63616672 f6b6028c 20746f67 410a6469
[  712.768046] Call Trace:
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c104580b>] ? add_wait_queue+0x2f/0x34
[  712.768046]  [<c10b0fb4>] ? __pollwait+0xa6/0xac
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b02c8>] do_sys_poll+0x336/0x3c7
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c12d2136>] ? __alloc_skb+0x49/0x11a
[  712.768046]  [<c12ce454>] ? sock_alloc_send_pskb+0x8e/0x24e
[  712.768046]  [<c114b021>] ? copy_from_user+0x2a/0x111
[  712.768046]  [<c12ce130>] ? sock_def_readable+0x12/0x65
[  712.768046]  [<c132abe3>] ? unix_stream_sendmsg+0x21a/0x2c7
[  712.768046]  [<c12cc1fd>] ? sock_sendmsg+0xca/0xe1
[  712.768046]  [<c10455bb>] ? autoremove_wake_function+0x0/0x33
[  712.768046]  [<c10b1014>] ? pollwake+0x5a/0x66
[  712.768046]  [<c102ba86>] ? default_wake_function+0x0/0xd
[  712.768046]  [<c107dc1c>] ? get_page_from_freelist+0x2e0/0x361
[  712.768046]  [<c1079a24>] ? filemap_fault+0xae/0x2ea
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c108ad8d>] ? __do_fault+0x316/0x347
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c10b049e>] sys_poll+0x40/0x8a
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 00000085     0  3484      1 0x00000000
[  712.768046]  e264deac 00000086 bcc96067 00000085 f6b60000 00000000 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6282550 f62827dc c2a08580 00000001 f6b631c0
[  712.768046]  01428000 7da0fa59 f64128c0 00000000 c2a03a98 f62827dc 00010bf3 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c134085a>] schedule_timeout+0x18/0x1de
[  712.768046]  [<c1079574>] ? unlock_page+0x3e/0x41
[  712.768046]  [<c103ac39>] ? recalc_sigpending+0x12/0x32
[  712.768046]  [<c103dc52>] ? dequeue_signal+0x9d/0x10b
[  712.768046]  [<c1340a63>] schedule_timeout_interruptible+0x15/0x17
[  712.768046]  [<c103dde3>] sys_rt_sigtimedwait+0x123/0x1d8
[  712.768046]  [<c108c333>] ? handle_mm_fault+0x265/0x54d
[  712.768046]  [<c10324c7>] ? do_exit+0x56c/0x57a
[  712.768046]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] gnome-keyring S 00000085     0  3485      1 0x00000000
[  712.768046]  e264fd54 00000086 bcb2728b 00000085 ffffffff 00000001 00000400 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f62831c0 f628344c c2808580 00000000 bcb2dcdf
[  712.768046]  00000085 00000041 f64128c0 c134a314 c2803a98 f628344c 00010bf7 00000400
[  712.768046] Call Trace:
[  712.768046]  [<c1051a44>] futex_wait_queue_me+0x98/0xac
[  712.768046]  [<c1051b56>] futex_wait+0xfe/0x21b
[  712.768046]  [<c1144379>] ? cpumask_next_and+0x26/0x37
[  712.768046]  [<c1053198>] do_futex+0x86/0xbcd
[  712.768046]  [<c1079270>] ? find_get_page+0x1d/0x81
[  712.768046]  [<c1144347>] ? cpumask_any_but+0x23/0x2f
[  712.768046]  [<c101d41b>] ? flush_tlb_page+0x45/0x5d
[  712.768046]  [<c101cc94>] ? ptep_set_access_flags+0x21/0x28
[  712.768046]  [<c108b1e3>] ? do_wp_page+0x265/0x57c
[  712.768046]  [<c108c5c7>] ? handle_mm_fault+0x4f9/0x54d
[  712.768046]  [<c1053dc8>] sys_futex+0xe9/0xff
[  712.768046]  [<c101a1fc>] ? do_page_fault+0x249/0x276
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] sshd          S 000000a5     0  3486   3470 0x00000000
[  712.768046]  e2651adc 00000082 f3d40e83 000000a5 c15077a0 000180c5 00000001 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f6b631c0 f6b6344c c2808580 00000000 ed035f6c
[  712.768046]  000000a3 00000202 f6412540 c106005c c2803a98 f6b6344c 0001929c 00000046
[  712.768046] Call Trace:
[  712.768046]  [<c106005c>] ? __rcu_process_callbacks+0xea/0x246
[  712.768046]  [<c13410a7>] schedule_hrtimeout_range+0x33/0xeb
[  712.768046]  [<c1042998>] ? flush_delayed_work+0x40/0x43
[  712.768046]  [<c11a2638>] ? n_tty_poll+0x0/0x121
[  712.768046]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.768046]  [<c10afeff>] poll_schedule_timeout+0x28/0x41
[  712.768046]  [<c10b0a65>] do_select+0x53a/0x593
[  712.768046]  [<c10b0f0e>] ? __pollwait+0x0/0xac
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c10b0fba>] ? pollwake+0x0/0x66
[  712.768046]  [<c12f4b8d>] ? ip_output+0x86/0x8b
[  712.768046]  [<c12f3e2d>] ? ip_local_out+0x18/0x1b
[  712.768046]  [<c12f45a1>] ? ip_queue_xmit+0x2c0/0x303
[  712.768046]  [<c12d17f3>] ? skb_release_data+0x8e/0x92
[  712.768046]  [<c12d1575>] ? __kfree_skb+0x12/0x71
[  712.768046]  [<c12d15ff>] ? consume_skb+0x2b/0x2d
[  712.768046]  [<c103a0a5>] ? lock_timer_base+0x1f/0x3e
[  712.768046]  [<c103a379>] ? mod_timer+0x166/0x171
[  712.768046]  [<c12ce1b2>] ? sk_reset_timer+0xf/0x1d
[  712.768046]  [<c1302e32>] ? tcp_event_new_data_sent+0xa0/0xc8
[  712.768046]  [<c13055b4>] ? tcp_write_xmit+0x79b/0x85a
[  712.768046]  [<c114b134>] ? copy_to_user+0x2c/0xfc
[  712.768046]  [<c12d31a3>] ? memcpy_toiovec+0x2c/0x50
[  712.768046]  [<c12d3982>] ? skb_copy_datagram_iovec+0x6b/0x19d
[  712.768046]  [<c1341e62>] ? _spin_unlock_bh+0xd/0xf
[  712.768046]  [<c10496d1>] ? sched_clock_local+0x17/0x104
[  712.768046]  [<c10b0c7b>] core_sys_select+0x1bd/0x27b
[  712.768046]  [<c102ba91>] ? default_wake_function+0xb/0xd
[  712.768046]  [<c101f1f5>] ? __wake_up_common+0x35/0x5b
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c11a0a63>] ? tty_wakeup+0x46/0x4e
[  712.768046]  [<c10457a4>] ? remove_wait_queue+0x30/0x34
[  712.768046]  [<c102320c>] ? __wake_up+0x31/0x3b
[  712.768046]  [<c11a57e6>] ? tty_ldisc_deref+0x8/0xa
[  712.768046]  [<c10b0ef0>] sys_select+0x6e/0x8c
[  712.768046]  [<c10a34dc>] ? sys_write+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] bash          S 000000a3     0  3488   3486 0x00000000
[  712.768046]  e2655f20 00000082 97e53cb8 000000a3 0822c25f 00000000 00000001 c15e0580
[  712.768046]  c15e0580 c15e0580 e263818c f69deff0 f69df27c c2a08580 00000001 97f0cc89
[  712.768046]  000000a3 e2655f58 f6187180 c11a0fb2 bfb5ee90 f69df27c e2637280 f73c3000
[  712.768046] Call Trace:
[  712.768046]  [<c11a0fb2>] ? tty_ioctl+0x3e9/0x6fd
[  712.768046]  [<c1031d1e>] do_wait+0x18b/0x1e8
[  712.768046]  [<c1031e03>] sys_wait4+0x88/0x9b
[  712.768046]  [<c1030770>] ? child_wait_callback+0x0/0x64
[  712.768046]  [<c1031e29>] sys_waitpid+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] su            S 000000a3     0  3604   3488 0x00000000
[  712.768046]  e2649f20 00000086 ece31568 000000a3 ece466bd c1042e53 00000000 c15e0580
[  712.768046]  c15e0580 c15e0580 c15dba98 f62818e0 f6281b6c c2808580 00000000 e26659f8
[  712.768046]  e2644ef4 e2649f58 f6412fc0 c1df0f60 c2803a98 f6281b6c 00018a96 01000000
[  712.768046] Call Trace:
[  712.768046]  [<c1042e53>] ? alloc_pid+0x19/0x309
[  712.768046]  [<c1031d1e>] do_wait+0x18b/0x1e8
[  712.768046]  [<c1031e03>] sys_wait4+0x88/0x9b
[  712.768046]  [<c1030770>] ? child_wait_callback+0x0/0x64
[  712.768046]  [<c1031e29>] sys_waitpid+0x13/0x15
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] bash          R running      0  3605   3604 0x00000000
[  712.768046]  c1635e75 00000006 00000046 e2657e08 c1048bb4 0003ed16 00000046 e2657e28
[  712.768046]  c102f543 00000046 fffd1302 0003ed5f 00000000 c1635e5d 00000009 e2657e8c
[  712.768046]  00000046 00000034 e2657e5d 00000004 00000046 00000001 f44946d4 00000009
[  712.768046] Call Trace:
[  712.768046]  [<c10564cd>] ? __module_text_address+0xb/0x48
[  712.768046]  [<c10564cd>] ? __module_text_address+0xb/0x48
[  712.768046]  [<c1056512>] ? is_module_text_address+0x8/0xf
[  712.768046]  [<c104354e>] ? __kernel_text_address+0x55/0x5b
[  712.768046]  [<c1005ab5>] ? print_trace_address+0x0/0x40
[  712.768046]  [<c1005b78>] ? print_context_stack+0x83/0x97
[  712.768046]  [<c1004e4d>] ? dump_trace+0x78/0xa7
[  712.768046]  [<c1005a96>] show_trace_log_lvl+0x33/0x3e
[  712.768046]  [<c1004c68>] show_stack_log_lvl+0x8c/0x97
[  712.768046]  [<c1005a5f>] show_stack+0x13/0x17
[  712.768046]  [<c1028a6f>] sched_show_task+0x8f/0x99
[  712.768046]  [<c1028ab5>] show_state_filter+0x3c/0x7a
[  712.768046]  [<c11b13cf>] sysrq_handle_showstate+0xa/0xc
[  712.768046]  [<c11b12de>] __handle_sysrq+0x9b/0x112
[  712.768046]  [<c11b1355>] ? write_sysrq_trigger+0x0/0x36
[  712.768046]  [<c11b1383>] write_sysrq_trigger+0x2e/0x36
[  712.768046]  [<c10d7f2e>] proc_reg_write+0x58/0x6c
[  712.768046]  [<c10d7ed6>] ? proc_reg_write+0x0/0x6c
[  712.768046]  [<c10a3390>] vfs_write+0x8a/0x13d
[  712.768046]  [<c10a34dc>] sys_write+0x3b/0x60
[  712.768046]  [<c1002988>] sysenter_do_call+0x12/0x26
[  712.768046] Sched Debug Version: v0.09, 2.6.32-rc8-gkh-00011-ga8a8a66-dirty #1885
[  712.768046] now at 712778.246892 msecs
[  712.768046]   .jiffies                                 : 103191
[  712.768046]   .sysctl_sched_latency                    : 10.000000
[  712.768046]   .sysctl_sched_min_granularity            : 2.000000
[  712.768046]   .sysctl_sched_wakeup_granularity         : 2.000000
[  712.768046]   .sysctl_sched_child_runs_first           : 0.000000
[  712.768046]   .sysctl_sched_features                   : 15834235
[  712.768046] 
[  712.768046] cpu#0, 1833.151 MHz
[  712.768046]   .nr_running                    : 0
[  712.768046]   .load                          : 0
[  712.768046]   .nr_switches                   : 63449
[  712.768046]   .nr_load_updates               : 15254
[  712.768046]   .nr_uninterruptible            : 4294967294
[  712.768046]   .next_balance                  : 0.103192
[  712.768046]   .curr->pid                     : 0
[  712.768046]   .clock                         : 712764.037858
[  712.768046]   .cpu_load[0]                   : 0
[  712.768046]   .cpu_load[1]                   : 0
[  712.768046]   .cpu_load[2]                   : 0
[  712.768046]   .cpu_load[3]                   : 0
[  712.768046]   .cpu_load[4]                   : 0
[  712.768046]   .yld_count                     : 29
[  712.768046]   .sched_switch                  : 0
[  712.768046]   .sched_count                   : 63988
[  712.768046]   .sched_goidle                  : 24370
[  712.768046]   .ttwu_count                    : 32728
[  712.768046]   .ttwu_local                    : 31382
[  712.768046]   .bkl_count                     : 529
[  712.768046] 
[  712.768046] cfs_rq[0]:
[  712.768046]   .exec_clock                    : 19585.104997
[  712.768046]   .MIN_vruntime                  : 0.000001
[  712.768046]   .min_vruntime                  : 21318.291299
[  712.768046]   .max_vruntime                  : 0.000001
[  712.768046]   .spread                        : 0.000000
[  712.768046]   .spread0                       : 0.000000
[  712.768046]   .nr_running                    : 0
[  712.768046]   .load                          : 0
[  712.768046]   .nr_spread_over                : 18
[  712.768046] 
[  712.768046] rt_rq[0]:
[  712.768046]   .rt_nr_running                 : 0
[  712.768046]   .rt_throttled                  : 0
[  712.768046]   .rt_time                       : 0.000000
[  712.768046]   .rt_runtime                    : 950.000000
[  712.768046] 
[  712.768046] runnable tasks:
[  712.768046]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  712.768046] ----------------------------------------------------------------------------------------------------------
[  712.768046] 
[  712.768046] cpu#1, 1833.151 MHz
[  712.768046]   .nr_running                    : 1
[  712.768046]   .load                          : 1024
[  712.768046]   .nr_switches                   : 31871
[  712.768046]   .nr_load_updates               : 19183
[  712.768046]   .nr_uninterruptible            : 5
[  712.768046]   .next_balance                  : 0.103107
[  712.768046]   .curr->pid                     : 3605
[  712.768046]   .clock                         : 712764.065496
[  712.768046]   .cpu_load[0]                   : 0
[  712.768046]   .cpu_load[1]                   : 0
[  712.768046]   .cpu_load[2]                   : 2
[  712.768046]   .cpu_load[3]                   : 30
[  712.768046]   .cpu_load[4]                   : 60
[  712.768046]   .yld_count                     : 10
[  712.768046]   .sched_switch                  : 0
[  712.768046]   .sched_count                   : 34037
[  712.768046]   .sched_goidle                  : 12531
[  712.768046]   .ttwu_count                    : 14962
[  712.768046]   .ttwu_local                    : 12487
[  712.768046]   .bkl_count                     : 1018
[  712.768046] 
[  712.768046] cfs_rq[1]:
[  712.768046]   .exec_clock                    : 10934.769199
[  712.768046]   .MIN_vruntime                  : 0.000001
[  712.768046]   .min_vruntime                  : 20172.615781
[  712.768046]   .max_vruntime                  : 0.000001
[  712.768046]   .spread                        : 0.000000
[  712.768046]   .spread0                       : -1145.675518
[  712.768046]   .nr_running                    : 1
[  712.768046]   .load                          : 1024
[  712.768046]   .nr_spread_over                : 10
[  712.768046] 
[  712.768046] rt_rq[1]:
[  712.768046]   .rt_nr_running                 : 0
[  712.768046]   .rt_throttled                  : 0
[  712.768046]   .rt_time                       : 0.000000
[  712.768046]   .rt_runtime                    : 950.000000
[  712.768046] 
[  712.768046] runnable tasks:
[  712.768046]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  712.768046] ----------------------------------------------------------------------------------------------------------
[  712.768046] R           bash  3605     20172.049161        71   140     20172.049161         8.075942      8702.343489
[  712.768046] 

--bg08WKrSYDhXBjb5--
