Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbZLOVhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbZLOVhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932813AbZLOVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:37:10 -0500
Received: from smtp-out-135.synserver.de ([212.40.180.135]:1073 "HELO
	smtp-out-132.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1760816AbZLOVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:37:05 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 16:37:04 EST
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 9525
Date: Tue, 15 Dec 2009 22:30:21 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215213021.GA1735@arch.tripp.de>
References: <20091215115052.GA28252@kernel.dk>
 <4B277AB2.8030107@kernel.org>
 <20091215121436.GB28252@kernel.dk>
 <4B2781AC.8020301@kernel.org>
 <20091215123951.GD28252@kernel.dk>
 <4B278734.2040704@kernel.org>
 <20091215141105.GK28252@kernel.dk>
 <4B27D7E9.4030105@kernel.org>
 <20091215185941.GO28252@kernel.dk>
 <4B27DDD7.5040301@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <4B27DDD7.5040301@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 15, 2009 at 11:04:55AM -0800, Yinghai Lu wrote:
> Jens Axboe wrote:
> > On Tue, Dec 15 2009, Yinghai Lu wrote:
> >> [   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> >>
> >> [   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
> > 
> > On a "normal" non-kexec boot, I get:
> > 
> > [   12.173583] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> > [   12.184075] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
> > [   12.216874] PCI: Using configuration type 1 for base access
> > 
> 
> can you run following scripts in first kernel?
> 
> cd /sys/firmware/memmap
> for dir in * ; do
>   start=$(cat $dir/start)
>   end=$(cat $dir/end)
>   type=$(cat $dir/type)
>   printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type" >> /tmp/memmap.txt
> done
> 
> and send out /tmp/memmap.txt
> 
> what is your kexec tools version? could be too old?

I have the same symptoms on my machine, but the underlying cause must be
different. I once reverted all Radeon related changes since 2.6.32 and 
kexec started working again.

Full dmesg and the output of the script is attached.

kexec-tools 2.0.1 released 13th August 2009

-- 
Markus

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="memmap.txt"

0000000000000000-000000000009fc00 (System RAM)
000000000009fc00-00000000000a0000 (reserved)
00000000000e6000-0000000000100000 (reserved)
0000000000100000-00000000cbf90000 (System RAM)
00000000cbf90000-00000000cbfa8000 (ACPI Tables)
00000000cbfa8000-00000000cbfd0000 (ACPI Non-volatile Storage)
00000000cbfd0000-00000000cc000000 (reserved)
00000000fff00000-0000000100000000 (reserved)
0000000100000000-0000000130000000 (System RAM)

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.32-07500-g8bea867-dirty (markus@arch.tripp.de) (gcc version 4.4.2 (GCC) ) #5 SMP Tue Dec 15 21:55:00 CET 2009
Command line: BOOT_IMAGE=/boot/kernel root=/dev/sdb fbcon=rotate:3 quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cbf90000 (usable)
 BIOS-e820: 00000000cbf90000 - 00000000cbfa8000 (ACPI data)
 BIOS-e820: 00000000cbfa8000 - 00000000cbfd0000 (ACPI NVS)
 BIOS-e820: 00000000cbfd0000 - 00000000cc000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
NX (Execute Disable) protection: active
DMI present.
last_pfn = 0x130000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFF8000000 write-back
  3 base 0000C8000000 mask FFFFFC000000 write-back
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000130000000 aka 4864M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000cc000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcbf90 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000cbf90000
 0000000000 - 00c0000000 page 1G
 00c0000000 - 00cbe00000 page 2M
 00cbe00000 - 00cbf90000 page 4k
kernel direct mapping tables up to cbf90000 @ 8000-b000
init_memory_mapping: 0000000100000000-0000000130000000
 0100000000 - 0130000000 page 2M
kernel direct mapping tables up to 130000000 @ a000-c000
ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
ACPI: XSDT 00000000cbf90100 00054 (v01 102809 XSDT1549 20091028 MSFT 00000097)
ACPI: FACP 00000000cbf90290 000F4 (v03 102809 FACP1549 20091028 MSFT 00000097)
ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20091112/tbfadt-557)
ACPI: DSDT 00000000cbf90440 0E774 (v01  A1152 A1152000 00000000 INTL 20060113)
ACPI: FACS 00000000cbfa8000 00040
ACPI: APIC 00000000cbf90390 0006C (v01 102809 APIC1549 20091028 MSFT 00000097)
ACPI: MCFG 00000000cbf90400 0003C (v01 102809 OEMMCFG  20091028 MSFT 00000097)
ACPI: OEMB 00000000cbfa8040 00072 (v01 102809 OEMB1549 20091028 MSFT 00000097)
ACPI: HPET 00000000cbf9f440 00038 (v01 102809 OEMHPET  20091028 MSFT 00000097)
ACPI: SSDT 00000000cbf9f480 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 0130000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 000176e80c]    TEXT DATA BSS ==> [0001000000 - 000176e80c]
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #3 [000176f000 - 000176f290]              BRK ==> [000176f000 - 000176f290]
  #4 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #6 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
 [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00130000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000cbf90
    0: 0x00100000 -> 0x00130000
On node 0 totalpages: 1031983
  DMA zone: 56 pages used for memmap
  DMA zone: 102 pages reserved
  DMA zone: 3841 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 817096 pages, LIFO batch:31
  Normal zone: 2688 pages used for memmap
  Normal zone: 193920 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at cc000000 (gap: cc000000:33f00000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880028200000 s81432 r0 d20968 u524288
pcpu-alloc: s81432 r0 d20968 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1014857
Kernel command line: BOOT_IMAGE=/boot/kernel root=/dev/sdb fbcon=rotate:3 quiet
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 3987284k/4980736k available (3765k kernel code, 852804k absent, 139720k reserved, 2841k data, 416k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:384
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3210.336 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6420.66 BogoMIPS (lpj=3210332)
Mount-cache hash table entries: 256
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
Freeing SMP alternatives: 28k freed
ACPI: Core revision 20091112
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Booting Node   0, Processors  #1
System has AMD C1E enabled
Switch to broadcast mode on CPU1
 #2
Switch to broadcast mode on CPU2
 #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (25686.38 BogoMIPS).
Switch to broadcast mode on CPU3
Switch to broadcast mode on CPU0
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000d0000000 aka 3328M
Fam 10h mmconf [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
node 0 link 0: mmio [f0000000, fbcfffff]
node 0 link 0: mmio [fbd00000, fbefffff]
node 0 link 0: mmio [fbf00000, ffefffff]
TOM2: 0000000130000000 aka 4864M
bus: [00, 07] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [d0000000, dfffffff]
bus: 00 index 3 mmio: [f0000000, ffffffff]
bus: 00 index 4 mmio: [130000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning: Incorrect checksum in table [OEMB] - B2, should be AA (20091112/tbutils-314)
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xcc000000-0xdfffffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
pci 0000:00:11.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
pci 0000:00:11.0: set SATA to AHCI mode
pci 0000:00:12.0: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
pci 0000:00:12.1: reg 10: [mem 0xfbcfe000-0xfbcfefff]
pci 0000:00:12.2: reg 10: [mem 0xfbcff800-0xfbcff8ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
pci 0000:00:13.1: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
pci 0000:00:13.2: reg 10: [mem 0xfbcff400-0xfbcff4ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
pci 0000:00:14.5: reg 10: [mem 0xfbcfa000-0xfbcfafff]
pci 0000:01:05.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
pci 0000:01:05.0: reg 18: [mem 0xfbee0000-0xfbeeffff]
pci 0000:01:05.0: reg 24: [mem 0xfbd00000-0xfbdfffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: reg 10: [mem 0xfbefc000-0xfbefffff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:02:05.0: reg 10: [io  0xe800-0xe8ff]
pci 0000:02:05.0: reg 14: [mem 0xfbfffc00-0xfbfffcff]
pci 0000:02:05.0: reg 30: [mem 0xfbfc0000-0xfbfdffff pref]
pci 0000:02:05.0: supports D1 D2
pci 0000:02:05.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:02:05.0: PME# disabled
pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
pci 0000:00:14.4:   bridge window [mem 0xfbf00000-0xfbffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *4 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
HPET: 4 timers in total, 1 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
hpet: hpet2 irq 24 for MSI
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xcc000000-0xcfffffff] has been reserved
system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: [io  0x040b] has been reserved
system 00:08: [io  0x04d6] has been reserved
system 00:08: [io  0x0c00-0x0c01] has been reserved
system 00:08: [io  0x0c14] has been reserved
system 00:08: [io  0x0c50-0x0c51] has been reserved
system 00:08: [io  0x0c52] has been reserved
system 00:08: [io  0x0c6c] has been reserved
system 00:08: [io  0x0c6f] has been reserved
system 00:08: [io  0x0cd0-0x0cd1] has been reserved
system 00:08: [io  0x0cd2-0x0cd3] has been reserved
system 00:08: [io  0x0cd4-0x0cd5] has been reserved
system 00:08: [io  0x0cd6-0x0cd7] has been reserved
system 00:08: [io  0x0cd8-0x0cdf] has been reserved
system 00:08: [io  0x0b00-0x0b3f] has been reserved
system 00:08: [io  0x0800-0x089f] has been reserved
system 00:08: [io  0x0b00-0x0b0f] has been reserved
system 00:08: [io  0x0b20-0x0b3f] has been reserved
system 00:08: [io  0x0900-0x090f] has been reserved
system 00:08: [io  0x0910-0x091f] has been reserved
system 00:08: [io  0xfe00-0xfefe] has been reserved
system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:0a: [io  0x0230-0x023f] has been reserved
system 00:0a: [io  0x0290-0x029f] has been reserved
system 00:0a: [io  0x0f40-0x0f4f] has been reserved
system 00:0a: [io  0x0a30-0x0a3f] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0c: [mem 0x000c0000-0x000cffff] has been reserved
system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0c: [mem 0x00100000-0xcbffffff] could not be reserved
system 00:0c: [mem 0xfec00000-0xffffffff] could not be reserved
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 02-02]
pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
pci 0000:00:14.4:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4:   bridge window [mem pref disabled]
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
pci_bus 0000:02: resource 3 [io  0x0000-0xffff]
pci_bus 0000:02: resource 4 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88002c600000 - ffff880030600000
software IO TLB at phys 0x2c600000 - 0x30600000
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
msgmni has been set to 7789
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
processor LNXCPU:02: registered as cooling_device2
processor LNXCPU:03: registered as cooling_device3
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
radeon 0000:01:05.0: setting latency timer to 64
[drm] radeon: Initializing kernel modesetting.
[drm] register mmio base: 0xFBEE0000
[drm] register mmio size: 65536
ATOM BIOS: 113
[drm] Clocks initialized !
[drm] Detected VRAM RAM=192M, BAR=256M
[drm] RAM width 32bits DDR
[TTM] Zone  kernel: Available graphics memory: 1994122 kiB.
[drm] radeon: 192M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading RS780 Microcode
platform radeon_cp.0: firmware: using built-in firmware radeon/RS780_pfp.bin
platform radeon_cp.0: firmware: using built-in firmware radeon/RS780_me.bin
platform radeon_cp.0: firmware: using built-in firmware radeon/R600_rlc.bin
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Connector 1:
[drm]   DVI-D
[drm]   HPD3
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[drm] fb mappable at 0xD0141000
[drm] vram apper at 0xD0000000
[drm] size 7257600
[drm] fb depth is 24
[drm]    pitch is 6912
executing set pll
executing set crtc timing
[drm] TMDS-11: set mode 1680x1050 1d
Console: switching to colour frame buffer device 131x105
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.0.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_atiixp 0000:00:14.1: setting latency timer to 64
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
r8169 0000:02:05.0: no PCI Express capability
eth0: RTL8110s at 0xffffc90000454c00, 00:08:54:36:f2:2f, XID 04000000 IRQ 20
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
ata5.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
ata5.00: configured for UDMA/66
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.21.
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  No soundcards found.
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (3200 MHz)
powernow-k8:    1 : pstate 1 (2500 MHz)
powernow-k8:    2 : pstate 2 (2100 MHz)
powernow-k8:    3 : pstate 3 (800 MHz)
registered taskstats version 1
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata3.00: ATA-8: OCZ-VERTEX, 1.4, max UDMA/133
ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
usb 4-1: new full speed USB device using ohci_hcd and address 2
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.4  PQ: 0 ANSI: 5
 sda:
sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 2:0:0:0: [sdb] Attached SCSI disk
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
 sda1 sda2 sda3
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sd 0:0:0:0: [sda] Attached SCSI disk
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg2 type 5
EXT4-fs (sdb): INFO: recovery required on readonly filesystem
EXT4-fs (sdb): write access will be enabled during recovery
EXT4-fs (sdb): recovery complete
EXT4-fs (sdb): mounted filesystem with ordered data mode
VFS: Mounted root (ext4 filesystem) readonly on device 8:16.
Freeing unused kernel memory: 416k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 324k freed
Freeing unused kernel memory: 496k freed
input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input2
generic-usb 0003:0D8C:000C.0001: input: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
udev: starting version 146
usb 3-1: new full speed USB device using ohci_hcd and address 2
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input3
generic-usb 0003:046D:C526.0002: input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-1/input0
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.1/input/input4
generic-usb 0003:046D:C526.0003: input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-1/input1
usb 3-2: new low speed USB device using ohci_hcd and address 3
input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input5
generic-usb 0003:046A:0021.0004: input: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.0-2/input0
input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input6
generic-usb 0003:046A:0021.0005: input: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.0-2/input1
EXT4-fs (sda1): mounted filesystem with ordered data mode
EXT4-fs (sda2): mounted filesystem with ordered data mode
EXT4-fs (sda3): mounted filesystem with ordered data mode
Adding 255992k swap on /var/cache/swap/swapfile.  Priority:-1 extents:2 across:354296k 
r8169: eth0: link up
executing set pll
executing set crtc timing
[drm] TMDS-11: set mode 1680x1050 1d

--2fHTh5uZTiUOsy+g--
