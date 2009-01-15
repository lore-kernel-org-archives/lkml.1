Return-Path: <linux-kernel-owner+w=401wt.eu-S1764931AbZAOOM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764931AbZAOOM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZAOOMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:12:20 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:60121 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZAOOML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:12:11 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 09:12:08 EST
From: Ionut Leonte <ionut.leonte@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: b44 - swapper: page allocation failure
Date: Thu, 15 Jan 2009 16:05:21 +0200
User-Agent: KMail/1.9.9
References: <20090115111537.GA994@gondor.apana.org.au>
In-Reply-To: <20090115111537.GA994@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hK0bJCdd8y8RyOc"
Message-Id: <200901151605.21231.ionut.leonte@gmail.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.23180
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.7.20.59198, large file, total: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hK0bJCdd8y8RyOc
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 15 January 2009 13:15:37 you wrote:
> You missed the all important order line before the stack trace.
> If it's order 0, then you're just out of memory, if it's greater
> than order 0, then either you're using jumbo frames or b44 is
> broken.

This is the test I've done: boot the system with 2.6.28 (config is copied from 
2.6.27 which works ok); from another system attempt to scp a 45MB file to 
this system; the scp stalls (and finally fails) at around 60%. This is 100% 
reproducible in this way. Attached is the full dmesg output and the config.

The output of 'free' during all this:
             total       used       free     shared    buffers     cached
Mem:       3083944     114304    2969640          0       4160      61096
-/+ buffers/cache:      49048    3034896
Swap:      2104472          0    2104472

--Boundary-00=_hK0bJCdd8y8RyOc
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-report"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-report"

BIOS EBDA/lowmem at: 0009f000/0009f000
Linux version 2.6.28-gentoo (root@ileonte-l) (gcc version 4.3.2 (Gentoo 4.3.2-r2 p1.5, pie-10.1.5) ) #1 SMP PREEMPT Wed Jan 14 02:47:24 EET 2009
Command line: root=/dev/sda4 vga=0x31B
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfe6d800 (usable)
 BIOS-e820: 00000000bfe6d800 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0xbfe6d max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-00000000bfe6d000
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bfe6d000 page 4k
kernel direct mapping tables up to bfe6d000 @ 8000-d000
last_map_addr: bfe6d000 end: bfe6d000
ACPI: RSDP 000FBBF0, 0024 (r2 DELL  )
ACPI: XSDT BFE6F200, 0054 (r1 DELL    M08     27D80203 ASL        61)
ACPI: FACP BFE6F09C, 00F4 (r4 DELL    M08     27D80203 ASL        61)
ACPI: DSDT BFE6F800, 5658 (r2 INT430 SYSFexxx     1001 INTL 20050624)
ACPI: FACS BFE7E000, 0040
ACPI: HPET BFE6F300, 0038 (r1 DELL    M08            1 ASL        61)
ACPI: APIC BFE6F400, 0068 (r1 DELL    M08     27D80203 ASL        47)
ACPI: MCFG BFE6F3C0, 003E (r16 DELL    M08     27D80203 ASL        61)
ACPI: BOOT BFE6EFC0, 0028 (r1 DELL    M08     27D80203 ASL        61)
ACPI: SSDT BFE6D976, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
(5 early reservations) ==> bootmem [0000000000 - 00bfe6d000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000c833f0]    TEXT DATA BSS ==> [0000200000 - 0000c833f0]
  #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #4 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
 [ffffe20000000000-ffffe200029fffff] PMD -> [ffff880001200000-ffff880003bfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000bfe6d
On node 0 totalpages: 785932
  DMA zone: 56 pages used for memmap
  DMA zone: 2794 pages reserved
  DMA zone: 1149 pages, LIFO batch:0
  DMA32 zone: 10691 pages used for memmap
  DMA32 zone: 771242 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
Allocating PCI resources starting at c4000000 (gap: c0000000:34000000)
PERCPU: Allocating 53248 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 772391
Kernel command line: root=/dev/sda4 vga=0x31B
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2493.785 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3083076k/3144116k available (6456k kernel code, 388k absent, 60228k reserved, 2838k data, 444k init)
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 4987.57 BogoMIPS (lpj=2493785)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz stepping 06
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4987.23 BogoMIPS (lpj=2493618)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (9974.80 BogoMIPS).
net_namespace: 1280 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f4000000 segment 0 buses 0 - 63
PCI: MCFG area at f4000000 reserved in E820
PCI: Using MMCONFIG at f4000000 - f7ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x6f20-0x6f3f]
pci 0000:00:1a.1: reg 20 io port: [0x6f00-0x6f1f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfebfc000-0xfebfffff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x6f80-0x6f9f]
pci 0000:00:1d.1: reg 20 io port: [0x6f60-0x6f7f]
pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x1f0-0x1f7]
pci 0000:00:1f.1: reg 14 io port: [0x3f4-0x3f7]
pci 0000:00:1f.1: reg 18 io port: [0x170-0x177]
pci 0000:00:1f.1: reg 1c io port: [0x374-0x377]
pci 0000:00:1f.1: reg 20 io port: [0x6fa0-0x6faf]
pci 0000:00:1f.2: reg 10 io port: [0x6eb0-0x6eb7]
pci 0000:00:1f.2: reg 14 io port: [0x6eb8-0x6ebb]
pci 0000:00:1f.2: reg 18 io port: [0x6ec0-0x6ec7]
pci 0000:00:1f.2: reg 1c io port: [0x6ec8-0x6ecb]
pci 0000:00:1f.2: reg 20 io port: [0x6ee0-0x6eef]
pci 0000:00:1f.2: reg 24 io port: [0xeff0-0xefff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 32bit mmio: [0xfebfbf00-0xfebfbfff]
pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xfa000000-0xfbffffff]
pci 0000:01:00.0: reg 24 io port: [0xdf00-0xdf7f]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfea00000-0xfea1ffff]
pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfa000000-0xfeafffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:0c:00.0: reg 10 64bit mmio: [0xf9ffc000-0xf9ffffff]
pci 0000:0c:00.0: reg 18 64bit mmio: [0xf0000000-0xf00fffff]
pci 0000:0c:00.0: supports D1 D2
pci 0000:0c:00.0: PME# supported from D3hot D3cold
pci 0000:0c:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xf9f00000-0xf9ffffff]
pci 0000:00:1c.1: bridge 64bit mmio pref: [0xf0000000-0xf00fffff]
pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xf9c00000-0xf9efffff]
pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf0100000-0xf03fffff]
pci 0000:03:00.0: reg 10 32bit mmio: [0xf9bfe000-0xf9bfffff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:01.0: reg 10 32bit mmio: [0xf9bfd800-0xf9bfdfff]
pci 0000:03:01.0: supports D1 D2
pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.0: PME# disabled
pci 0000:03:01.1: reg 10 32bit mmio: [0xf9bfd400-0xf9bfd4ff]
pci 0000:03:01.1: supports D1 D2
pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.1: PME# disabled
pci 0000:03:01.2: reg 10 32bit mmio: [0xf9bfd500-0xf9bfd5ff]
pci 0000:03:01.2: supports D1 D2
pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.2: PME# disabled
pci 0000:03:01.3: reg 10 32bit mmio: [0xf9bfd600-0xf9bfd6ff]
pci 0000:03:01.3: supports D1 D2
pci 0000:03:01.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.3: PME# disabled
pci 0000:03:01.4: reg 10 32bit mmio: [0xf9bfd700-0xf9bfd7ff]
pci 0000:03:01.4: supports D1 D2
pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.4: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xf9b00000-0xf9bfffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *7
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *4
ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 9 10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: WMI: Mapper loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 23
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:09: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
pnp 00:09: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
pnp 00:0a: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
pnp 00:0a: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
pnp 00:0a: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
pnp 00:0a: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:05: ioport range 0xc80-0xcff could not be reserved
system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:09: ioport range 0x900-0x97f has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0xf400-0xf4fe has been reserved
system 00:0a: ioport range 0x1080-0x10bf has been reserved
system 00:0a: ioport range 0x10c0-0x10df has been reserved
system 00:0a: ioport range 0x809-0x809 has been reserved
system 00:0b: iomem range 0x0-0x9efff could not be reserved
system 00:0b: iomem range 0x9f000-0x9ffff could not be reserved
system 00:0b: iomem range 0xc0000-0xcffff has been reserved
system 00:0b: iomem range 0xe0000-0xfffff has been reserved
system 00:0b: iomem range 0x100000-0xbfe6d7ff could not be reserved
system 00:0b: iomem range 0xbfe6d800-0xbfefffff has been reserved
system 00:0b: iomem range 0xbff00000-0xbfffffff has been reserved
system 00:0b: iomem range 0xbff00000-0xc06fffff could not be reserved
system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0b: iomem range 0xffa00000-0xffafffff has been reserved
system 00:0b: iomem range 0xfec00000-0xfec0ffff has been reserved
system 00:0b: iomem range 0xfee00000-0xfee0ffff has been reserved
system 00:0b: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:0b: iomem range 0xfeda0000-0xfeda3fff has been reserved
system 00:0b: iomem range 0xfeda4000-0xfeda4fff has been reserved
system 00:0b: iomem range 0xfeda5000-0xfeda5fff has been reserved
system 00:0b: iomem range 0xfeda6000-0xfeda6fff has been reserved
system 00:0b: iomem range 0xfed18000-0xfed1bfff has been reserved
system 00:0b: iomem range 0xf4000000-0xf7ffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0xfa000000-0xfeafffff
pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xf9f00000-0xf9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f0000000-0x000000f00fffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0d
pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
pci 0000:00:1c.3:   MEM window: 0xf9c00000-0xf9efffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000f0100000-0x000000f03fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xf9b00000-0xf9bfffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 io port: [0xd000-0xdfff]
bus: 01 index 1 mmio: [0xfa000000-0xfeafffff]
bus: 01 index 2 mmio: [0xe0000000-0xefffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 0b index 0 mmio: [0x0-0x0]
bus: 0b index 1 mmio: [0x0-0x0]
bus: 0b index 2 mmio: [0x0-0x0]
bus: 0b index 3 mmio: [0x0-0x0]
bus: 0c index 0 mmio: [0x0-0x0]
bus: 0c index 1 mmio: [0xf9f00000-0xf9ffffff]
bus: 0c index 2 mmio: [0xf0000000-0xf00fffff]
bus: 0c index 3 mmio: [0x0-0x0]
bus: 0d index 0 io port: [0xc000-0xcfff]
bus: 0d index 1 mmio: [0xf9c00000-0xf9efffff]
bus: 0d index 2 mmio: [0xf0100000-0xf03fffff]
bus: 0d index 3 mmio: [0x0-0x0]
bus: 03 index 0 mmio: [0x0-0x0]
bus: 03 index 1 mmio: [0xf9b00000-0xf9bfffff]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 io port: [0x00-0xffff]
bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x79 set to 0x1
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 6022
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pcieport-driver 0000:00:01.0: irq 1279 for MSI/MSI-X
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie02: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 1278 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pcieport-driver 0000:00:1c.1: irq 1277 for MSI/MSI-X
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pcieport-driver 0000:00:1c.3: irq 1276 for MSI/MSI-X
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
Linux agpgart interface v0.103
vesafb: framebuffer at 0xfb000000, mapped to 0xffffc20004100000, using 10240k, total 14336k
vesafb: mode is 1280x1024x32, linelength=5120, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PBTN]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button (CM) [SBTN]
ACPI: SSDT BFE6E4AC, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT BFE6DE42, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BFE6E774, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT BFE6E427, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM] (50 C)
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
Floppy drive(s): fd0 is 1.44M
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
nbd: registered device at major 43
b44 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
b44.c:v2.0
eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:1d:09:d0:54:b7
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
usbcore: registered new interface driver irda-usb
USB IrDA support registered
usbcore: registered new interface driver stir4200
usbcore: registered new interface driver mcs7780
usbcore: registered new interface driver kingsun-sir
usbcore: registered new interface driver ksdazzle-sir
usbcore: registered new interface driver ks959-sir
Linux video capture interface: v2.00
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
ata1.00: ATAPI: PBDS DVD+/-RW DS-8W1P, BD1B, max UDMA/33
ata1.00: configured for UDMA/33
ata2: port disabled. ignoring.
isa bounce pool size: 16 pages
scsi 0:0:0:0: CD-ROM            PBDS     DVD+-RW DS-8W1P  BD1B PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
ata_piix 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x6eb0 ctl 0x6eb8 bmdma 0x6ee0 irq 17
ata4: SATA max UDMA/133 cmd 0x6ec0 ctl 0x6ec8 bmdma 0x6ee8 irq 17
ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.01: SATA link down (SStatus 0 SControl 300)
ata3.00: ATA-8: Hitachi HTS722020K9A300, DC4OCA1H, max UDMA/133
ata3.00: 390721968 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4.00: SATA link down (SStatus 0 SControl 300)
ata4.01: SATA link down (SStatus 0 SControl 0)
scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72202 DC4O PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 > sda4
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
ohci1394 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[f9bfd800-f9bfdfff]  Max Packet=[2048]  IR/IT contexts=[4/4]
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
usbmon: debugfs is not available
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
i2c-parport-light: adapter type unspecified
usbcore: registered new interface driver i2c-tiny-usb
Driver for 1-wire Dallas network protocol.
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
usb 2-6: new high speed USB device using ehci_hcd and address 3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Bluetooth: HCI USB driver ver 2.10
usbcore: registered new interface driver hci_usb
Bluetooth: Virtual HCI driver ver 1.2
Bluetooth: HCI UART driver ver 2.2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[384fc0001771d470]
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
Bluetooth: HCILL protocol initialized
Bluetooth: Broadcom Blutonium firmware driver ver 1.2
usbcore: registered new interface driver bcm203x
Bluetooth: Digianswer Bluetooth USB driver ver 0.10
usbcore: registered new interface driver bpa10x
Bluetooth: BlueFRITZ! USB driver ver 1.2
usbcore: registered new interface driver bfusb
usb 2-6: configuration #1 chosen from 1 choice
cpuidle: using governor ladder
Marking TSC unstable due to TSC halts in idle
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: setting latency timer to 64
usbcore: registered new interface driver snd-usb-audio
usbcore: registered new interface driver snd-usb-usx2y
usb 3-2: new full speed USB device using uhci_hcd and address 2
usbcore: registered new interface driver snd-usb-caiaq
ALSA device list:
  #0: HDA Intel at 0xfebfc000 irq 21
oprofile: using NMI interrupt.
GACT probability on
Mirror/redirect action on
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ctnetlink v0.93: registering with nfnetlink.
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
usb 3-2: configuration #1 chosen from 1 choice
NET: Registered protocol family 15
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 3 ports detected
Bridge firewalling registered
NET: Registered protocol family 4
IrCOMM protocol (Dag Brattli)
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
rtc_cmos 00:03: setting system clock to 2009-01-15 15:30:43 UTC (1232033443)
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
usb 5-2: new low speed USB device using uhci_hcd and address 2
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
usb 5-2: configuration #1 chosen from 1 choice
input: Dell Premium USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input5
Clocksource tsc unstable (delta = -155900184 ns)
generic-usb 0003:413C:3016.0001: input: USB HID v1.11 Mouse [Dell Premium USB Optical Mouse] on usb-0000:00:1d.0-2/input0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 444k freed
usb 3-2.1: new full speed USB device using uhci_hcd and address 3
usb 3-2.1: configuration #1 chosen from 1 choice
usb 3-2.2: new full speed USB device using uhci_hcd and address 4
usb 3-2.2: configuration #1 chosen from 1 choice
input: Broadcom Corp as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2.2/3-2.2:1.0/input/input6
generic-usb 0003:0A5C:4502.0002: input: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1a.0-2.2/input0
usb 3-2.3: new full speed USB device using uhci_hcd and address 5
usb 3-2.3: configuration #1 chosen from 1 choice
input: Broadcom Corp as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2.3/3-2.3:1.0/input/input7
generic-usb 0003:0A5C:4503.0003: input: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1a.0-2.3/input0
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6:1.0/input/input8
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
nvidia: module license 'NVIDIA' taints kernel.
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.82  Tue Nov  4 16:50:05 PST 2008
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda4, internal journal
ndiswrapper version 1.53 loaded (smp=yes, preempt=yes)
ndiswrapper (link_pe_images:575): fixing KI_USER_SHARED_DATA address in the driver
ndiswrapper: driver bcmwl5 (Broadcom,09/20/2007, 4.170.25.12) loaded
ndiswrapper 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ndiswrapper 0000:0c:00.0: setting latency timer to 64
ndiswrapper: using IRQ 17
wlan0: ethernet device 00:1f:3a:7e:69:8b using NDIS driver: bcmwl5, version: 0x4aa190c, NDIS version: 0x501, vendor: 'NDIS Network Adapter', 14E4:4328.5.conf
wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK; AES/CCMP with WPA, WPA2, WPA2PSK
usbcore: registered new interface driver ndiswrapper
fuse init (API version 7.10)
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2104472k swap on /dev/sda5.  Priority:-1 extents:1 across:2104472k
hci_cmd_task: hci0 command tx timeout
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): wlan0: link is not ready
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8062fbe0>] menu_reflect+0x0/0x90
 [<ffffffff804a4029>] acpi_idle_enter_simple+0x1c7/0x237
 [<ffffffff804a401f>] acpi_idle_enter_simple+0x1bd/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  24
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742841 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971352kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 2*4kB 1*8kB 1*16kB 1*32kB 1*64kB 2*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971264kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12741 pages shared
19949 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff80620657>] hci_usb_rx_complete+0x67/0x160
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  24
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742841 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971352kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 2*4kB 1*8kB 1*16kB 1*32kB 1*64kB 2*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971264kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12718 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  50
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12718 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  50
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  45
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  45
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  45
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  45
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  45
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff804a4041>] acpi_idle_enter_simple+0x1df/0x237
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd:  45
Active_anon:2958 active_file:2836 inactive_anon:0
 inactive_file:10227 unevictable:0 dirty:4336 writeback:0 unstable:0
 free:742816 slab:6276 mapped:1976 pagetables:483 bounce:0
DMA free:12kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2971252kB min:7016kB low:8768kB high:10524kB active_anon:11832kB inactive_anon:0kB active_file:11344kB inactive_file:40908kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 3*256kB 1*512kB 0*1024kB 4*2048kB 723*4096kB = 2971140kB
13134 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12725 pages shared
19964 pages non-shared
__ratelimit: 50 callbacks suppressed
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 178
CPU    1: hi:  186, btch:  31 usd: 184
Active_anon:2382 active_file:2015 inactive_anon:604
 inactive_file:6822 unevictable:0 dirty:4319 writeback:0 unstable:0
 free:747938 slab:5151 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991748kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2416kB active_file:8060kB inactive_file:27288kB unevictable:0kB present:3084968kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 1057*4kB 596*8kB 248*16kB 125*32kB 39*64kB 5*128kB 2*256kB 1*512kB 1*1024kB 4*2048kB 723*4096kB = 2991748kB
8889 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12651 pages shared
14629 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 168
CPU    1: hi:  186, btch:  31 usd: 176
Active_anon:2382 active_file:2015 inactive_anon:608
 inactive_file:6822 unevictable:0 dirty:4319 writeback:0 unstable:0
 free:747820 slab:5278 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991276kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8060kB inactive_file:27288kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 1026*4kB 575*8kB 247*16kB 131*32kB 41*64kB 8*128kB 1*256kB 2*512kB 2*1024kB 3*2048kB 723*4096kB = 2991376kB
8889 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12653 pages shared
14739 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 168
CPU    1: hi:  186, btch:  31 usd: 176
Active_anon:2382 active_file:2015 inactive_anon:608
 inactive_file:6822 unevictable:0 dirty:4319 writeback:0 unstable:0
 free:747820 slab:5278 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991276kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8060kB inactive_file:27288kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 1026*4kB 575*8kB 247*16kB 131*32kB 41*64kB 8*128kB 1*256kB 2*512kB 2*1024kB 3*2048kB 723*4096kB = 2991376kB
8889 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12657 pages shared
14743 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 168
CPU    1: hi:  186, btch:  31 usd: 170
Active_anon:2382 active_file:2015 inactive_anon:608
 inactive_file:6822 unevictable:0 dirty:4319 writeback:0 unstable:0
 free:747820 slab:5278 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991276kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8060kB inactive_file:27288kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 1026*4kB 575*8kB 247*16kB 131*32kB 41*64kB 8*128kB 1*256kB 2*512kB 2*1024kB 3*2048kB 723*4096kB = 2991376kB
8889 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12659 pages shared
14743 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 168
CPU    1: hi:  186, btch:  31 usd: 169
Active_anon:2382 active_file:2015 inactive_anon:608
 inactive_file:6822 unevictable:0 dirty:4319 writeback:0 unstable:0
 free:747820 slab:5278 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991276kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8060kB inactive_file:27288kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 1026*4kB 575*8kB 247*16kB 131*32kB 41*64kB 8*128kB 1*256kB 2*512kB 2*1024kB 3*2048kB 723*4096kB = 2991376kB
8889 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12661 pages shared
14743 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
CPU    1: hi:  186, btch:  31 usd: 181
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4342 writeback:0 unstable:0
 free:747969 slab:5076 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8957 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12658 pages shared
14609 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
CPU    1: hi:  186, btch:  31 usd: 181
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4342 writeback:0 unstable:0
 free:747969 slab:5076 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8957 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12660 pages shared
14609 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
CPU    1: hi:  186, btch:  31 usd: 180
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4342 writeback:0 unstable:0
 free:747969 slab:5076 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8957 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12662 pages shared
14609 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
CPU    1: hi:  186, btch:  31 usd: 179
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4342 writeback:0 unstable:0
 free:747969 slab:5076 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8957 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12664 pages shared
14609 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8022c05b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
CPU    1: hi:  186, btch:  31 usd: 178
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4342 writeback:0 unstable:0
 free:747969 slab:5076 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8957 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12666 pages shared
14609 pages non-shared
__ratelimit: 2 callbacks suppressed
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff80620657>] hci_usb_rx_complete+0x67/0x160
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 177
CPU    1: hi:  186, btch:  31 usd: 183
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4342 writeback:0 unstable:0
 free:747969 slab:5062 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8957 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12666 pages shared
14589 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 179
CPU    1: hi:  186, btch:  31 usd: 178
Active_anon:2382 active_file:2042 inactive_anon:608
 inactive_file:6863 unevictable:0 dirty:4347 writeback:0 unstable:0
 free:747969 slab:5056 mapped:1976 pagetables:483 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991872kB min:7016kB low:8768kB high:10524kB active_anon:9528kB inactive_anon:2432kB active_file:8168kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 806*4kB 543*8kB 255*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991872kB
8964 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12672 pages shared
14589 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 157
CPU    1: hi:  186, btch:  31 usd: 154
Active_anon:2395 active_file:2051 inactive_anon:636
 inactive_file:6863 unevictable:0 dirty:4348 writeback:0 unstable:0
 free:747977 slab:5006 mapped:1977 pagetables:488 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991904kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2544kB active_file:8204kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8968 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12768 pages shared
14603 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 157
CPU    1: hi:  186, btch:  31 usd: 154
Active_anon:2395 active_file:2051 inactive_anon:636
 inactive_file:6863 unevictable:0 dirty:4348 writeback:0 unstable:0
 free:747977 slab:5006 mapped:1977 pagetables:488 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991904kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2544kB active_file:8204kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8968 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12768 pages shared
14603 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 157
CPU    1: hi:  186, btch:  31 usd: 154
Active_anon:2395 active_file:2051 inactive_anon:636
 inactive_file:6863 unevictable:0 dirty:4348 writeback:0 unstable:0
 free:747977 slab:5006 mapped:1977 pagetables:488 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991904kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2544kB active_file:8204kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8968 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12768 pages shared
14603 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 157
CPU    1: hi:  186, btch:  31 usd: 154
Active_anon:2395 active_file:2051 inactive_anon:636
 inactive_file:6863 unevictable:0 dirty:4348 writeback:0 unstable:0
 free:747977 slab:5006 mapped:1977 pagetables:488 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991904kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2544kB active_file:8204kB inactive_file:27452kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8968 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12768 pages shared
14603 pages non-shared
swapper: page allocation failure. order:0, mode:0x21
Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027adcc>] ktime_get+0xc/0x50
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804a3de1>] acpi_idle_enter_bm+0x2fb/0x37c
 [<ffffffff804a3dd7>] acpi_idle_enter_bm+0x2f1/0x37c
 [<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
 [<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 157
CPU    1: hi:  186, btch:  31 usd: 150
Active_anon:2395 active_file:2052 inactive_anon:640
 inactive_file:6864 unevictable:0 dirty:4352 writeback:0 unstable:0
 free:747998 slab:5007 mapped:1977 pagetables:491 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991988kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2560kB active_file:8208kB inactive_file:27456kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8972 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12778 pages shared
14603 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 161
CPU    1: hi:  186, btch:  31 usd: 152
Active_anon:2395 active_file:2052 inactive_anon:640
 inactive_file:6864 unevictable:0 dirty:4353 writeback:0 unstable:0
 free:747998 slab:5000 mapped:1977 pagetables:491 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991988kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2560kB active_file:8208kB inactive_file:27456kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8973 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12778 pages shared
14596 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff804d86e0>] b44_interrupt+0x60/0x130
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff80243725>] ack_apic_level+0x15/0x130
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 161
CPU    1: hi:  186, btch:  31 usd: 152
Active_anon:2395 active_file:2052 inactive_anon:640
 inactive_file:6864 unevictable:0 dirty:4353 writeback:0 unstable:0
 free:747998 slab:5000 mapped:1977 pagetables:491 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991988kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2560kB active_file:8208kB inactive_file:27456kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8973 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12778 pages shared
14596 pages non-shared
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff80240f26>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff8047e456>] soft_cursor+0x1b6/0x240
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 161
CPU    1: hi:  186, btch:  31 usd: 152
Active_anon:2395 active_file:2052 inactive_anon:640
 inactive_file:6864 unevictable:0 dirty:4353 writeback:0 unstable:0
 free:747998 slab:5000 mapped:1977 pagetables:491 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991988kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2560kB active_file:8208kB inactive_file:27456kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8973 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12778 pages shared
14596 pages non-shared
__ratelimit: 1 callbacks suppressed
dmesg: page allocation failure. order:0, mode:0x21
Pid: 5602, comm: dmesg Tainted: P           2.6.28-gentoo #1
Call Trace:
 <IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
 [<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
 [<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
 [<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
 [<ffffffff8027e458>] getnstimeofday+0x48/0xc0
 [<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
 [<ffffffff804d912d>] b44_poll+0x30d/0x620
 [<ffffffff806bffc3>] net_rx_action+0x83/0x150
 [<ffffffff80265e73>] __do_softirq+0x93/0x160
 [<ffffffff8022c60c>] call_softirq+0x1c/0x30
 [<ffffffff8022dfa5>] do_softirq+0x35/0x70
 [<ffffffff80265b1d>] irq_exit+0x9d/0xb0
 [<ffffffff8022e259>] do_IRQ+0xc9/0x110
 [<ffffffff8022b896>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804804a6>] cfb_imageblit+0x536/0x570
 [<ffffffff8047df19>] bit_putcs+0x3b9/0x630
 [<ffffffff802547c8>] set_next_entity+0x38/0x80
 [<ffffffff80848101>] schedule+0x2e1/0x2e2
 [<ffffffff8047db25>] bit_cursor+0x605/0x640
 [<ffffffff80477da3>] fbcon_putcs+0x1d3/0x310
 [<ffffffff8047db60>] bit_putcs+0x0/0x630
 [<ffffffff8047a3e4>] fbcon_redraw+0x164/0x1d0
 [<ffffffff8047a675>] fbcon_scroll+0x225/0xdc0
 [<ffffffff8045d140>] scrup+0x100/0x110
 [<ffffffff8045d2c5>] lf+0x65/0x70
 [<ffffffff8027bff9>] __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8046074b>] do_con_write+0x94b/0x1f70
 [<ffffffff80461da1>] con_put_char+0x31/0x40
 [<ffffffff8044beec>] tty_put_char+0x1c/0x50
 [<ffffffff8044fe58>] opost+0xb8/0x2a0
 [<ffffffff804508f3>] n_tty_write+0x1d3/0x3e0
 [<ffffffff8025bd30>] default_wake_function+0x0/0x10
 [<ffffffff8044e0f4>] tty_write+0x1b4/0x270
 [<ffffffff80450720>] n_tty_write+0x0/0x3e0
 [<ffffffff802cf23b>] vfs_write+0xcb/0x170
 [<ffffffff802cf3e3>] sys_write+0x53/0xa0
 [<ffffffff8022b38b>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 161
CPU    1: hi:  186, btch:  31 usd: 172
Active_anon:2395 active_file:2052 inactive_anon:640
 inactive_file:6864 unevictable:0 dirty:4360 writeback:0 unstable:0
 free:747998 slab:4974 mapped:1977 pagetables:491 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2991988kB min:7016kB low:8768kB high:10524kB active_anon:9580kB inactive_anon:2560kB active_file:8208kB inactive_file:27456kB unevictable:0kB present:3084968kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
DMA32: 839*4kB 539*8kB 256*16kB 134*32kB 47*64kB 10*128kB 2*256kB 3*512kB 2*1024kB 3*2048kB 723*4096kB = 2991988kB
8979 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
12790 pages shared
14570 pages non-shared

--Boundary-00=_hK0bJCdd8y8RyOc
Content-Type: text/plain;
  charset="utf-8";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-gentoo
# Wed Jan 14 02:40:59 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
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
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
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
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
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
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
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
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
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
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
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
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
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
CONFIG_PD6729=y
CONFIG_I82092=y
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
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_GRE=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NF_NAT_AMANDA=y
CONFIG_NF_NAT_PPTP=y
CONFIG_NF_NAT_H323=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
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
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
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
CONFIG_BT_HCIUSB=y
CONFIG_BT_HCIUSB_SCO=y
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
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
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_WMI is not set
# CONFIG_ICS932S401 is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
# CONFIG_C2PORT is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

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

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=4000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_BLK_DEV_DM_BBR is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VIDEO1394=y
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
# CONFIG_NET_PCI is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_PCMCIA_PCNET=y
CONFIG_PCMCIA_NMCLAN=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_PCMCIA_AXNET=y
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
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
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=y
CONFIG_SENSORS_PCF8574=y
CONFIG_PCF8575=y
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_MAX6875=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA7111=m
CONFIG_VIDEO_SAA7114=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_BT848_DVB is not set
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_SAA7134=m
# CONFIG_VIDEO_SAA7134_ALSA is not set
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
# CONFIG_VIDEO_CX88_ALSA is not set
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
# CONFIG_VIDEO_AU0828 is not set
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_FB_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_ALSA is not set
# CONFIG_VIDEO_EM28XX_DVB is not set
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_ZR364XX=m
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set
# CONFIG_USB_SI470X is not set
# CONFIG_USB_MR800 is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_SIANO_SMS1XXX is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
# CONFIG_DVB_BT8XX is not set

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=m
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=m
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TDA826X=m
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=m
# CONFIG_DVB_SI21XX is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=m
# CONFIG_DVB_DRX397XD is not set
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=m
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=m
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
# CONFIG_DVB_AU8522 is not set
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_LGS8GL5 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# CONFIG_DVB_AF9013 is not set
CONFIG_DAB=y
CONFIG_USB_DABUSB=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
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
CONFIG_FB_MODE_HELPERS=y
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
# CONFIG_FB_INTEL is not set
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
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
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
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FB_CON_DECOR is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
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
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
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
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
# CONFIG_SND_USB_CAIAQ_INPUT is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_BRIGHT=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DELL=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_THRUSTMASTER_FF is not set
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
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

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
# CONFIG_USB_PHIDGET is not set
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
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
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
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_V3020=y

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
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
# CONFIG_NTFS_FS is not set

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
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_ROOT_NFS=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_SUNRPC_REGISTER_V4 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=y
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
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
# CONFIG_NLS_CODEPAGE_1250 is not set
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
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_hK0bJCdd8y8RyOc--

