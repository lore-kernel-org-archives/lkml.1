Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbYDYXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbYDYXwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYDYXwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:52:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbYDYXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:52:09 -0400
Date: Fri, 25 Apr 2008 16:51:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.25-git
In-Reply-To: <20080425045303.GA4906@suse.de>
Message-ID: <alpine.LFD.1.10.0804251645190.2813@woody.linux-foundation.org>
References: <20080425045303.GA4906@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, Greg KH wrote:
>
> Here is a set of USB patches against your current git tree.

Hmm. This seesm to have brought with it some new errors.

>From my dmesg:

	ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
	PCI: Setting latency timer of device 0000:00:1a.1 to 64
	uhci_hcd 0000:00:1a.1: UHCI Host Controller
	uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
	uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002080
	usb usb4: configuration #1 chosen from 1 choice
	hub 4-0:1.0: USB hub found
	hub 4-0:1.0: 2 ports detected
**	hub 1-0:1.0: unable to enumerate USB device on port 4
	usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
	usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
	usb usb4: Product: UHCI Host Controller
	usb usb4: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
	usb usb4: SerialNumber: 0000:00:1a.1

there's a few of them there, and they seem to be new (ie they don't show 
up in my previous message logs). dmesg | grep shows a total of four:

	hub 1-0:1.0: unable to enumerate USB device on port 4
	hub 2-0:1.0: unable to enumerate USB device on port 2
	hub 2-0:1.0: unable to enumerate USB device on port 3
	hub 2-0:1.0: unable to enumerate USB device on port 4

but things seem to work. Whether that is because I don't have anything 
*connected* at those ports or not, I don't know ;)

Full dmesg appended, in case it tells you something.

			Linus

---
Linux version 2.6.25-05086-g3dd7b71 (torvalds@woody.linux-foundation.org) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #121 SMP Fri Apr 25 15:51:55 PDT 2008
Command line: rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cf585000 (usable)
 BIOS-e820: 00000000cf585000 - 00000000cf591000 (reserved)
 BIOS-e820: 00000000cf591000 - 00000000cf62b000 (usable)
 BIOS-e820: 00000000cf62b000 - 00000000cf6a6000 (ACPI NVS)
 BIOS-e820: 00000000cf6a6000 - 00000000cf6a9000 (ACPI data)
 BIOS-e820: 00000000cf6a9000 - 00000000cf6f2000 (ACPI NVS)
 BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data)
 BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
 BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 849285) 1 entries of 256 used
Entering add_active_range(0, 849297, 849451) 2 entries of 256 used
Entering add_active_range(0, 849663, 849664) 3 entries of 256 used
Entering add_active_range(0, 1048576, 1228800) 4 entries of 256 used
max_pfn_mapped = 1228800
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT CF6FD038, 0050 (r1 INTEL  DQ965GF      116E       1000013)
ACPI: FACP CF6FC000, 0074 (r1 INTEL  DQ965GF      116E MSFT  1000013)
ACPI: DSDT CF6F8000, 3EE1 (r1 INTEL  DQ965GF      116E MSFT  1000013)
ACPI: FACS CF6A9000, 0040
ACPI: APIC CF6F7000, 0078 (r1 INTEL  DQ965GF      116E MSFT  1000013)
ACPI: WDDT CF6F6000, 0040 (r1 INTEL  DQ965GF      116E MSFT  1000013)
ACPI: MCFG CF6F5000, 003C (r1 INTEL  DQ965GF      116E MSFT  1000013)
ACPI: ASF! CF6F4000, 00A6 (r32 INTEL  DQ965GF      116E MSFT  1000013)
ACPI: SSDT CF6F3000, 01BC (r1 INTEL     CpuPm     116E MSFT  1000013)
ACPI: SSDT CF6F2000, 01B7 (r1 INTEL   Cpu0Ist     116E MSFT  1000013)
ACPI: SSDT CF6A8000, 01B7 (r1 INTEL   Cpu1Ist     116E MSFT  1000013)
ACPI: SSDT CF6A7000, 01B7 (r1 INTEL   Cpu2Ist     116E MSFT  1000013)
ACPI: SSDT CF6A6000, 01B7 (r1 INTEL   Cpu3Ist     116E MSFT  1000013)
ACPI: TCPA CF62B000, 0B84 (r1 INTEL  TIANO           2 MSFT  1000013)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 849285) 1 entries of 256 used
Entering add_active_range(0, 849297, 849451) 2 entries of 256 used
Entering add_active_range(0, 849663, 849664) 3 entries of 256 used
Entering add_active_range(0, 1048576, 1228800) 4 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] TRAMPOLINE
early res: 2 [200000-791d47] TEXT DATA BSS
early res: 3 [37c1c000-37feff7e] RAMDISK
early res: 4 [9fc00-fffff] BIOS reserved
early res: 5 [8000-dfff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff81000c200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff81000c600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff81000ca00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff81000ce00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff81000d200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff81000d600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff81000da00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff81000de00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff81000e200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff81000e600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff81000ea00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff81000ee00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff81000f200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff81000f600000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff81000fa00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff81000fe00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810010200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810010600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810010a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810010e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810011200000 on node 0
 [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810011600000 on node 0
 [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810011a00000 on node 0
 [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810011e00000 on node 0
 [ffffe20003000000-ffffe200031fffff] PMD ->ffff810012200000 on node 0
 [ffffe20003200000-ffffe200033fffff] PMD ->ffff810012600000 on node 0
 [ffffe20003400000-ffffe200035fffff] PMD ->ffff810012a00000 on node 0
 [ffffe20003600000-ffffe200037fffff] PMD ->ffff810012e00000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810013200000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810013600000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810013a00000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810013e00000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810014200000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810014600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1228800
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0:        0 ->      159
    0:      256 ->   849285
    0:   849297 ->   849451
    0:   849663 ->   849664
    0:  1048576 ->  1228800
On node 0 totalpages: 1029567
  DMA zone: 56 pages used for memmap
  DMA zone: 1532 pages reserved
  DMA zone: 2411 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 831064 pages, LIFO batch:31
  Normal zone: 2464 pages used for memmap
  Normal zone: 177760 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d4000000 (gap: d0000000:2fe00000)
PERCPU: Allocating 26872 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1011235
Kernel command line: rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2664.004 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1619000 - 0x5619000
Memory: 3965780k/4915200k available (3326k kernel code, 151772k reserved, 1567k data, 304k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5331.96 BogoMIPS (lpj=10663937)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Freeing SMP alternatives: 32k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 06
Using local APIC timer interrupts.
APIC timer calibration result 16650066
Detected 16.650 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5328.09 BogoMIPS (lpj=10656184)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (10660.06 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
net_namespace: 1176 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: WMI: Mapper loaded
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD northbridge found.
system 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff has been reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
system 00:07: iomem range 0xfed40000-0xfed44fff has been reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0xe0500000-0xe05fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 1000-1fff
  MEM window: 0xe0100000-0xe01fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: 0xe0600000-0xe06fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: 0xe0700000-0xe07fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: 0xe0800000-0xe08fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xe0000000-0xe00fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3919k freed
Total HugeTLB memory allocated, 0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: Detected an Intel 965Q Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
Overlap at 0xe0300000-0xe0380000
[drm] Initialized i915 1.6.0 20060119 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS1 at I/O 0x2150 (irq = 17) is a 16550A
brd: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
e1000e: Copyright (c) 1999-2008 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:c7:eb:fe
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
Intel(R) Gigabit Ethernet Network Driver - version 1.0.8-k2
Copyright (c) 2007 Intel Corporation.
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ide-floppy driver 1.00
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x2148 ctl 0x217c bmdma 0x2110 irq 19
ata2: SATA max UDMA/133 cmd 0x2140 ctl 0x2178 bmdma 0x2118 irq 19
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD5000YS-01MPB0, 07.02E07, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.01: NODEV after polling detection
ata2.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.04, max UDMA/66
ata2.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000YS-01M 07.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.04 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
PCI: Setting latency timer of device 0000:00:1f.5 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x2138 ctl 0x2174 bmdma 0x20f0 irq 19
ata4: SATA max UDMA/133 cmd 0x2130 ctl 0x2170 bmdma 0x20f8 irq 19
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0426400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-05086-g3dd7b71 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
Overlap at 0xe0426000-0xe0427000
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0426000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-05086-g3dd7b71 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020a0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002080
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 1-0:1.0: unable to enumerate USB device on port 4
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002060
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 2-0:1.0: unable to enumerate USB device on port 2
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002040
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002020
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 2-0:1.0: unable to enumerate USB device on port 3
hub 2-0:1.0: unable to enumerate USB device on port 4
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: New USB device found, idVendor=04f9, idProduct=0100
usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 5-2: new low speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: New USB device found, idVendor=046d, idProduct=c315
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Logitech USB Keyboard
usb 5-2: Manufacturer: Logitech
usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
hub 6-1:1.0: USB hub found
hub 6-1:1.0: 2 ports detected
usb 6-1: New USB device found, idVendor=0451, idProduct=2036
usb 6-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 6-1: Product: General Purpose USB Hub
usb 6-2: new low speed USB device using uhci_hcd and address 3
usb 6-2: configuration #1 chosen from 1 choice
usb 6-2: New USB device found, idVendor=046d, idProduct=c50e
usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-2: Product: USB Receiver
usb 6-2: Manufacturer: Logitech
usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04F9 pid 0x0100
usb 6-1.1: new low speed USB device using uhci_hcd and address 4
usb 6-1.1: configuration #1 chosen from 1 choice
usb 6-1.1: New USB device found, idVendor=046d, idProduct=c704
usb 6-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 6-1.1: Product: USB Receiver
usb 6-1.1: Manufacturer: Logitech
usb 6-1.1: SerialNumber: 08F3B6
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Apr 25 2008
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
input: Logitech Logitech USB Keyboard as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-2
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.1-2
input: Logitech USB Receiver as /class/input/input4
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.1-1.1
input: Logitech USB Receiver as /class/input/input5
input,hiddev96: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.1-1.1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16.
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA device list:
  #0: HDA Intel at 0xe0420000 irq 22
oprofile: using NMI interrupt.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Freeing unused kernel memory: 304k freed
Write protecting the kernel read-only data: 4344k
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
mtrr: no more MTRRs available
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
eth0: no IPv6 routers present
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xd0000000-0xd0020000
mtrr: no more MTRRs available
Overlap at 0xd0000000-0xe0000000
Overlap at 0xe0300000-0xe0400000
Overlap at 0xe0300000-0xe0380000
