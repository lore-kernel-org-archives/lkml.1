Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYIBTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYIBTfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYIBTf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:35:29 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:41055 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYIBTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:35:24 -0400
Date: Tue, 2 Sep 2008 16:35:32 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: tglx@linutronix.de
Cc: herton@mandriva.com.br, linux-kernel@vger.kernel.org
Subject: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080902163532.436f8fbd@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/JKCR+cMFXQHTJ7hQR/N5_5d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/JKCR+cMFXQHTJ7hQR/N5_5d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


 Hi Thomas,

 I have a HP Pavilion dv6000 laptop here which doesn't boot with
latest Linus tree (2.6.27-rc5).

 The last lines I see on the screen are:

"""
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25 000000 Hz
"""

 Sometimes it also writes one more line:

"""
ACPI: rtc can wake from S4
"""

 By investigating this I have found that it:

 o boots with 2.6.26.3
 o doesn't boot with 2.6.27-rc1
 o 2.6.27-rc1 and current kernel boots if I pass hpet=disable at the
   command-line

 Then I bisected and git says that the culprit is:

"""
commit aa276e1cafb3ce9d01d1e837bcd67e92616013ac
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Jun 9 19:15:00 2008 +0200

    x86, clockevents: add C1E aware idle function
    
    C1E on AMD machines is like C3 but without control from the OS. Up to
    now we disabled the local apic timer for those machines as it stops
    when the CPU goes into C1E. This excludes those machines from high
    resolution timers / dynamic ticks, which hurts especially X2 based
    laptops

[...]
"""

 Now, what puzzles me though is that if you do:

$ git checkout -b bla aa276e1cafb3ce9d01d1e837bcd67e92616013ac

 and edit the Makefile you will see that it is a 2.6.26-rc4
kernel! When I saw this I thought 'wth? git bisect went backwards?'
(I specified 2.6.26 as good and 2.6.27-rc1 as bad).

 I don't know if this is known (it should be) but it seems that you
have changed the Makefile during the merge of that commit... But
I'm quite sure that this commit has been introduced in 2.6.27-rc1.

 I would try to revert it from current Linus' tree to see if it
really fix the problem but turns out that it will take some time
to work on the conflicts.

 I'm attaching the 2.6.26.3 (Mandriva kernel) and 2.6.27-rc5 (with
hpet=disable) dmesg files.

 Also, this _seems_ to be the same as reported in:

http://bugzilla.kernel.org/show_bug.cgi?id=11191

 But I'm still compiling the kernel with the appropriate config
options to confirm this.

 Please, let me know if there's anything else I can do to
help you debug this.

 Thanks.

-- 
Luiz Fernando N. Capitulino

--MP_/JKCR+cMFXQHTJ7hQR/N5_5d
Content-Type: text/plain; name=dmesg-2.6.26.3mdv.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg-2.6.26.3mdv.txt

Linux version 2.6.26.3-desktop-1mnb (lcapitulino@deborah.mandriva.com) (gcc version 4.3.1 20080626 (prerelease) (GCC) ) #1 SMP Thu Aug 21 20:05:48 CEST 2008
Command line: BOOT_IMAGE=desktop_2.6.26.3-1mnb root=UUID=4c906e0e-7507-11dd-8b10-0019bbeb0788 splash=silent vga=788
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bf00000 (usable)
 BIOS-e820: 000000003bf00000 - 000000003bf16000 (ACPI data)
 BIOS-e820: 000000003bf16000 - 000000003bf80000 (ACPI NVS)
 BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 245504) 1 entries of 3200 used
max_pfn_mapped = 1048576
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI present.
Compaq Presario V6000: using 0xed I/O delay port
ACPI: RSDP 000F88F0, 0014 (r0 HP    )
ACPI: RSDT 3BF0CE48, 003C (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 3BF15D10, 0074 (r1 HP     MCP51M    6040000 PTL_    F4240)
ACPI: DSDT 3BF0CE84, 8E8C (r1 HP       MCP51M  6040000 MSFT  3000000)
ACPI: FACS 3BF16FC0, 0040
ACPI: SSDT 3BF15D84, 0182 (r1 PTLTD  POWERNOW  6040000  LTP        1)
ACPI: MCFG 3BF15F06, 003C (r1 HP       MCFG    6040000  LTP        0)
ACPI: HPET 3BF15F42, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC 3BF15F7A, 005E (r1 HP     	 APIC    6040000  LTP        0)
ACPI: BOOT 3BF15FD8, 0028 (r1     HP $SBFTBL$  6040000  LTP        1)
ACPI: DMI detected: Hewlett-Packard
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003bf00000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 245504) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003bf00000
  NODE_DATA [000000000000b000 - 000000000000ffff]
  bootmap [0000000000010000 -  00000000000177df] pages 8
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-796ecb] TEXT DATA BSS
  early res: 3 [37bff000-37fef25d] RAMDISK
  early res: 4 [9dc00-fffff] BIOS reserved
  early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff810001200000-ffff810001ffffff] on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   245504
On node 0 totalpages: 245405
  DMA zone: 56 pages used for memmap
  DMA zone: 1536 pages reserved
  DMA zone: 2405 pages, LIFO batch:0
  DMA32 zone: 3301 pages used for memmap
  DMA32 zone: 238107 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 40752 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 240512
Policy zone: DMA32
Kernel command line: BOOT_IMAGE=desktop_2.6.26.3-1mnb root=UUID=4c906e0e-7507-11dd-8b10-0019bbeb0788 splash=silent vga=788
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1607.313 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @ 2840000000 size 32 MB
Aperture beyond 4GB. Ignoring.
No AGP bridge found
Memory: 957276k/982016k available (2979k kernel code, 24344k reserved, 1423k data, 428k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3216.98 BogoMIPS (lpj=1608492)
Security Framework initialized
AppArmor: AppArmor disabled by boottime parameter 
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Hook version: 2.6.26-1mnb2 2008/07/19
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Early unpacking initramfs... done
Freeing initrd memory: 4032k freed
ACPI: Core revision 20080321
ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557201
Detected 12.557 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3214.67 BogoMIPS (lpj=1607336)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
AMD C1E detected late. Force timer broadcast.
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6431.65 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
net_namespace: 1224 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fe0bffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [40000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 6
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e06fffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 7) *11
ACPI: PCI Interrupt Link [LNK3] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 18) *11
ACPI: PCI Interrupt Link [LK4E] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs *10)
ACPI: PCI Interrupt Link [LPMU] (IRQs 11) *10
ACPI: PCI Interrupt Link [LUS0] (IRQs 22) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 22) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *10
ACPI: PCI Interrupt Link [LAZA] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 23) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 20) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:parse DMAR table failure.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
ACPI: RTC can wake from S4
system 00:00: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:01: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:03: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:04: ioport range 0x1000-0x107f has been reserved
system 00:04: ioport range 0x1080-0x10ff has been reserved
system 00:04: ioport range 0x1400-0x147f has been reserved
system 00:04: ioport range 0x1480-0x14ff has been reserved
system 00:04: ioport range 0x1800-0x187f has been reserved
system 00:04: ioport range 0x1880-0x18ff has been reserved
system 00:04: ioport range 0x2000-0x203f has been reserved
system 00:05: ioport range 0x360-0x361 has been reserved
system 00:05: ioport range 0x380-0x383 has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: 4000-4fff
  MEM window: 0xb4000000-0xb7ffffff
  PREFETCH window: 0x00000000d0000000-0x00000000d01fffff
PCI: Bridge: 0000:00:03.0
  IO window: 5000-5fff
  MEM window: 0xb8000000-0xbbffffff
  PREFETCH window: 0x00000000d0200000-0x00000000d03fffff
PCI: Bridge: 0000:00:10.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1220381503.425:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1877
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:02.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Boot video device
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie03]
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20000c80000, using 1875k, total 65536k
vesafb: mode is 800x600x16, linelength=1600, pages=2
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
 lapic is not functional.
Could not switch to high resolution mode on CPU 1
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Freeing unused kernel memory: 428k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUS2] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 22, io mem 0xb0005000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26.3-desktop-1mnb ehci_hcd
usb usb1: SerialNumber: 0000:00:0b.1
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUS0] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 22, io mem 0xb0004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26.3-desktop-1mnb ohci_hcd
usb usb2: SerialNumber: 0000:00:0b.0
USB Universal Host Controller Interface driver v3.0
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
No dock devices found.
libata version 3.00 loaded.
sata_nv 0000:00:0e.0: version 3.5
sata_nv 0000:00:0e.0: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LTID] -> GSI 23 (level, high) -> IRQ 23
sata_nv 0000:00:0e.0: Using SWNCQ mode
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x30c0 ctl 0x30b4 bmdma 0x3090 irq 23
ata2: SATA max UDMA/133 cmd 0x30b8 ctl 0x30b0 bmdma 0x3098 irq 23
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input2
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HTS541010G9SA00, MBZOC60P, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: Drive reports diagnostics failure. This may indicate a drive
ata1.00: fault or invalid emulation. Contact drive vendor for information.
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
pata_amd 0000:00:0d.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:0d.0 to 64
scsi2 : pata_amd
scsi3 : pata_amd
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x3080 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x3088 irq 15
ata3.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.05, max MWDMA2
ata3: nv_mode_filter: 0x39f&0x39f->0x39f, BIOS=0x0 (0xc600) ACPI=0x39f (120:600:0x12)
ata3.00: configured for MWDMA2
ata4: port disabled. ignoring.
scsi 2:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.05 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
TomoyoLinux Mandatory Access Control disabled by default.
You need to install ccs-tools if you want to enable it.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 2:0:0:0: Attached scsi generic sg1 type 5
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 20 (level, high) -> IRQ 20
memory length for this resource is less than required
isp1760: probe of 0000:00:14.0 failed with error -12
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x3000
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
PCI: Setting latency timer of device 0000:00:14.0 to 64
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (59 C)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input5
rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
ACPI: AC Adapter [ACAD] (on-line)
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:bb:eb:07:88
forcedeth 0000:00:14.0: highdma pwrctl timirq lnktim desc-v3
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:10.1 to 64
ACPI: Battery Slot [BAT0] (battery present)
ACPI: device:24 is registered as cooling_device2
input: Video Bus as /class/input/input7
ACPI: Video Device [UVGA] (multi-head: yes  rom: no  post: no)
ACPI: WMI: Mapper loaded
ACPI: device:2a is registered as cooling_device3
input: Video Bus as /class/input/input8
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
Non-volatile memory driver v1.2
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-50 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
floppy0: no floppy controllers found
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
EXT3 FS on sda9, internal journal
loop: module loaded
Adding 257000k swap on /dev/sda1.  Priority:-1 extents:1 across:257000k
Clocksource tsc unstable (delta = -148386367 ns)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present
atkbd.c: Unknown key pressed (translated set 2, code 0xb1 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e031 <keycode>' to make it known.
atkbd.c: Unknown key released (translated set 2, code 0xb1 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e031 <keycode>' to make it known.

--MP_/JKCR+cMFXQHTJ7hQR/N5_5d
Content-Type: text/plain; name=dmesg-2.6.27-rc5.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg-2.6.27-rc5.txt

Linux version 2.6.27-rc5 (lcapitulino@build1.conectiva) (gcc version 4.3.2 (GCC) ) #43 SMP Tue Sep 2 16:25:20 BRT 2008
Command line: root=UUID=4c906e0e-7507-11dd-8b10-0019bbeb0788 hpet=disable
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bf00000 (usable)
 BIOS-e820: 000000003bf00000 - 000000003bf16000 (ACPI data)
 BIOS-e820: 000000003bf16000 - 000000003bf80000 (ACPI NVS)
 BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
last_pfn = 0x3bf00 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 003be00000 page 2M
 003be00000 - 003bf00000 page 4k
kernel direct mapping tables up to 3bf00000 @ 8000-b000
last_map_addr: 3bf00000 end: 3bf00000
RAMDISK: 37c00000 - 37feff45
DMI present.
Compaq Presario V6000: using 0xed I/O delay port
ACPI: RSDP 000F88F0, 0014 (r0 HP    )
ACPI: RSDT 3BF0CE48, 003C (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 3BF15D10, 0074 (r1 HP     MCP51M    6040000 PTL_    F4240)
ACPI: DSDT 3BF0CE84, 8E8C (r1 HP       MCP51M  6040000 MSFT  3000000)
ACPI: FACS 3BF16FC0, 0040
ACPI: SSDT 3BF15D84, 0182 (r1 PTLTD  POWERNOW  6040000  LTP        1)
ACPI: MCFG 3BF15F06, 003C (r1 HP       MCFG    6040000  LTP        0)
ACPI: HPET 3BF15F42, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC 3BF15F7A, 005E (r1 HP     	 APIC    6040000  LTP        0)
ACPI: BOOT 3BF15FD8, 0028 (r1     HP $SBFTBL$  6040000  LTP        1)
ACPI: DMI detected: Hewlett-Packard
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003bf00000
Bootmem setup node 0 0000000000000000-000000003bf00000
  NODE_DATA [0000000000001000 - 0000000000005fff]
  bootmap [0000000000009000 -  00000000000107df] pages 8
(6 early reservations) ==> bootmem [0000000000 - 003bf00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000d80350]    TEXT DATA BSS ==> [0000200000 - 0000d80350]
  #3 [0037c00000 - 0037feff45]          RAMDISK ==> [0037c00000 - 0037feff45]
  #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff8800000f8920] 000f8920
 [ffffe20000000000-ffffe200015fffff] PMD -> [ffff880001200000-ffff8800027fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0003bf00
On node 0 totalpages: 245405
  DMA zone: 861 pages, LIFO batch:0
  DMA32 zone: 236221 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 52384 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 237082
Policy zone: DMA32
Kernel command line: root=UUID=4c906e0e-7507-11dd-8b10-0019bbeb0788 hpet=disable
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 1607.315 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 3839 kB
 per task-struct memory footprint: 1920 bytes
Checking aperture...
No AGP bridge found
Node 0: aperture @ 3b40000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 942996k/982016k available (2720k kernel code, 38624k reserved, 1461k data, 472k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 3214.63 BogoMIPS (lpj=1607315)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 0/0 -> Node 0
tseg: 003bf80000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557224
Detected 12.557 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3214.68 BogoMIPS (lpj=1607340)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
System has C1E enabled
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6429.31 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
Switch to broadcast mode on CPU1
Switch to broadcast mode on CPU0
net_namespace: 696 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fe0bffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [40000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 6
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e06fffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:0a.1: PME# supported from D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0b.0: supports D1
pci 0000:00:0b.0: supports D2
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0b.1: supports D1
pci 0000:00:0b.1: supports D2
pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.1: PME# disabled
pci 0000:00:10.1: PME# supported from D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:14.0: supports D1
pci 0000:00:14.0: supports D2
pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:14.0: PME# disabled
PCI: bridge 0000:00:02.0 io port: [4000, 4fff]
PCI: bridge 0000:00:02.0 32bit mmio: [b4000000, b7ffffff]
PCI: bridge 0000:00:02.0 64bit mmio pref: [d0000000, d01fffff]
PCI: bridge 0000:00:03.0 io port: [5000, 5fff]
PCI: bridge 0000:00:03.0 32bit mmio: [b8000000, bbffffff]
PCI: bridge 0000:00:03.0 64bit mmio pref: [d0200000, d03fffff]
pci 0000:00:10.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 7) *11
ACPI: PCI Interrupt Link [LNK3] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 18) *11
ACPI: PCI Interrupt Link [LK4E] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs *10)
ACPI: PCI Interrupt Link [LPMU] (IRQs 11) *10
ACPI: PCI Interrupt Link [LUS0] (IRQs 22) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 22) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *10
ACPI: PCI Interrupt Link [LAZA] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 23) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 20) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
DMAR:parse DMAR table failure.
ACPI: RTC can wake from S4
system 00:00: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:01: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:03: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:04: ioport range 0x1000-0x107f has been reserved
system 00:04: ioport range 0x1080-0x10ff has been reserved
system 00:04: ioport range 0x1400-0x147f has been reserved
system 00:04: ioport range 0x1480-0x14ff has been reserved
system 00:04: ioport range 0x1800-0x187f has been reserved
system 00:04: ioport range 0x1880-0x18ff has been reserved
system 00:04: ioport range 0x2000-0x203f has been reserved
system 00:05: ioport range 0x360-0x361 has been reserved
system 00:05: ioport range 0x380-0x383 has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0x4000-0x4fff
pci 0000:00:02.0:   MEM window: 0xb4000000-0xb7ffffff
Switched to high resolution mode on CPU 0
pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000d01fffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
pci 0000:00:03.0:   IO window: 0x5000-0x5fff
pci 0000:00:03.0:   MEM window: 0xb8000000-0xbbffffff
pci 0000:00:03.0:   PREFETCH window: 0x000000d0200000-0x000000d03fffff
pci 0000:00:10.0: PCI bridge, secondary bus 0000:07
pci 0000:00:10.0:   IO window: disabled
pci 0000:00:10.0:   MEM window: disabled
pci 0000:00:10.0:   PREFETCH window: disabled
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:10.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [4000, 4fff]
bus: 01 index 1 mmio: [b4000000, b7ffffff]
bus: 01 index 2 mmio: [d0000000, d01fffff]
bus: 01 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [5000, 5fff]
bus: 03 index 1 mmio: [b8000000, bbffffff]
bus: 03 index 2 mmio: [d0200000, d03fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 07 index 0 mmio: [0, 0]
bus: 07 index 1 mmio: [0, 0]
bus: 07 index 2 mmio: [0, 0]
bus: 07 index 3 io port: [0, ffff]
bus: 07 index 4 mmio: [0, ffffffffffffffff]
NET: Registered protocol family 2
Switched to high resolution mode on CPU 1
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 4031k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1220383874.737:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1849
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:02.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Boot video device
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie03: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pci_express 0000:00:03.0:pcie03: allocate port service
hpet_acpi_add: no address or irqs in _CRS
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 472k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
ehci_hcd 0000:00:0b.1: PCI INT B -> Link[LUS2] -> GSI 22 (level, high) -> IRQ 22
ehci_hcd 0000:00:0b.1: setting latency timer to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
ehci_hcd 0000:00:0b.1: cache line size of 64 is not supported
ehci_hcd 0000:00:0b.1: irq 22, io mem 0xb0005000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-rc5 ehci_hcd
usb usb1: SerialNumber: 0000:00:0b.1
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ohci_hcd 0000:00:0b.0: PCI INT A -> Link[LUS0] -> GSI 22 (level, high) -> IRQ 22
ohci_hcd 0000:00:0b.0: setting latency timer to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 22, io mem 0xb0004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-rc5 ohci_hcd
usb usb2: SerialNumber: 0000:00:0b.0
USB Universal Host Controller Interface driver v3.0
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
No dock devices found.
libata version 3.00 loaded.
sata_nv 0000:00:0e.0: version 3.5
sata_nv 0000:00:0e.0: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
sata_nv 0000:00:0e.0: PCI INT A -> Link[LTID] -> GSI 23 (level, high) -> IRQ 23
sata_nv 0000:00:0e.0: Using SWNCQ mode
sata_nv 0000:00:0e.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x30c0 ctl 0x30b4 bmdma 0x3090 irq 23
ata2: SATA max UDMA/133 cmd 0x30b8 ctl 0x30b0 bmdma 0x3098 irq 23
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input1
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HTS541010G9SA00, MBZOC60P, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
pata_amd 0000:00:0d.0: version 0.3.10
pata_amd 0000:00:0d.0: setting latency timer to 64
scsi2 : pata_amd
scsi3 : pata_amd
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x3080 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x3088 irq 15
ata3.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.05, max MWDMA2
ata3: nv_mode_filter: 0x39f&0x39f->0x39f, BIOS=0x0 (0xc600) ACPI=0x39f (120:600:0x12)
ata3.00: configured for MWDMA2
ata4: port disabled. ignoring.
scsi 2:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.05 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (57 C)
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input4
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID]
ACPI: Battery Slot [BAT0] (battery present)
ACPI: WMI: Mapper loaded
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 2:0:0:0: Attached scsi generic sg1 type 5
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
isp1760 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 20 (level, high) -> IRQ 20
memory length for this resource is less than required
isp1760: probe of 0000:00:14.0 failed with error -12
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x3000
rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
forcedeth 0000:00:14.0: setting latency timer to 64
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:bb:eb:07:88
forcedeth 0000:00:14.0: highdma pwrctl timirq lnktim desc-v3
Non-volatile memory driver v1.2
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-50 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
floppy0: no floppy controllers found
EXT3 FS on sda9, internal journal
loop: module loaded
Adding 257000k swap on /dev/sda1.  Priority:-1 extents:1 across:257000k
Clocksource tsc unstable (delta = -140906693 ns)
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
NET: Registered protocol family 17
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
martian source 255.255.255.255 from 10.0.4.193, on dev eth0
ll header: ff:ff:ff:ff:ff:ff:00:11:2f:a8:02:be:08:00

--MP_/JKCR+cMFXQHTJ7hQR/N5_5d--
