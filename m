Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYISQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYISQLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYISQLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:11:22 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38141 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYISQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:11:18 -0400
X-Greylist: delayed 3513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2008 12:11:17 EDT
Message-ID: <48D3C168.4030900@candelatech.com>
Date: Fri, 19 Sep 2008 08:12:40 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: ext3 journal stop hang, FC8 2.6.25.14-69.fc8 kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed my mail-server wasn't working right this morning, and there 
are some errors in
dmesg that appear to be related to ext3.



Linux version 2.6.25.14-69.fc8 (mockbuild@x86-6) (gcc version 4.1.2 
20070925 (Red Hat 4.1.2-33)) #1 SMP Mon Aug 4 14:20:24 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
 BIOS-e820: 000000003fee0000 - 000000003fee9000 (ACPI data)
 BIOS-e820: 000000003fee9000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
126MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5ec0] 000f5ec0
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 261856) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261856
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   261856
On node 0 totalpages: 261856
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 253 pages used for memmap
  HighMem zone: 32227 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI present.
Using APIC driver default
ACPI: RSDP 000F5E40, 0014 (r0 PTLTD )
ACPI: RSDT 3FEE257A, 003C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3FEE8E51, 0074 (r1 INTEL            6040000 PTL         3)
ACPI: DSDT 3FEE39A2, 54AF (r1  INTEL GLENWOOD  6040000 MSFT  100000E)
ACPI: FACS 3FEE9FC0, 0040
ACPI: MCFG 3FEE8EC5, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: APIC 3FEE8F01, 0074 (r1 PTLTD      APIC    6040000  LTP        0)
ACPI: BOOT 3FEE8F75, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: ASF! 3FEE8F9D, 0063 (r32   CETP     CETP  6040000 PTL         1)
ACPI: SSDT 3FEE25B6, 13EC (r1  PmRef    CpuPm     3000 INTL 20050228)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:6 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:6 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec10000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ce000
PM: Registered nosave memory: 00000000000ce000 - 00000000000d0000
PM: Registered nosave memory: 00000000000d0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259811
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec10000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c07bd000 soft=c079d000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2992.715 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029344k/1047424k available (2233k kernel code, 17304k reserved, 
1144k data, 280k init, 129920k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc53000 - 0xfffff000   (3760 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0754000 - 0xc079a000   ( 280 kB)
      .data : 0xc062e7d0 - 0xc074ca28   (1144 kB)
      .text : 0xc0400000 - 0xc062e7d0   (2233 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5989.21 BogoMIPS 
(lpj=2994607)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 05
Booting processor 1/1 ip 4000
CPU 1 irqstacks, hard=c07be000 soft=c079e000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5984.24 BogoMIPS 
(lpj=2992121)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) D CPU 3.00GHz stepping 05
Total of 2 processors activated (11973.45 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 585 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
sizeof(vma)=84 bytes
sizeof(page)=32 bytes
sizeof(inode)=340 bytes
sizeof(dentry)=132 bytes
sizeof(ext3inode)=492 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=180 bytes
sizeof(task_struct)=3696 bytes
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
net_namespace: 548 bytes
Booting paravirtualized kernel on bare hardware
Time: 16:04:28  Date: 09/11/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:09:00.0: PXH quirk detected; SHPC device MSI disabled
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.DEV1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1.PXHA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 10 11 14 15) *5
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *10 11 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Switched to high resolution mode on CPU 0
system 00:01: ioport range 0x295-0x296 has been reserved
system 00:01: ioport range 0x800-0x83f has been reserved
system 00:01: ioport range 0x900-0x90f has been reserved
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1180-0x11bf has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0xfe00-0xfe00 has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed1bfff has been reserved
system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:01: iomem range 0xfef00000-0xfeffffff has been reserved
Switched to high resolution mode on CPU 1
PCI: Bridge: 0000:00:01.0
  IO window: 4000-4fff
  MEM window: 0xe0100000-0xe01fffff
  PREFETCH window: 0x00000000e2000000-0x00000000e3ffffff
PCI: Bridge: 0000:09:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0xe0200000-0xe02fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: 5000-5fff
  MEM window: 0xe0300000-0xe03fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.5
  IO window: 6000-6fff
  MEM window: 0xe0400000-0xe04fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 7000-7fff
  MEM window: 0xe0500000-0xe05fffff
  PREFETCH window: 0x00000000e8000000-0x00000000efffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:09:00.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3672k freed
Simple Boot Flag at 0x38 set to 0x1
apm: BIOS not found.
audit: initializing netlink socket (disabled)
type=2000 audit(1221149067.531:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key AE26465A6E728C89
- User ID: Red Hat, Inc. (Kernel Module GPG key)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:0f:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Allocate Port Service[0000:00:1c.5:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 8:55:85
Freeing unused kernel memory: 280k freed
Write protecting the kernel read-only data: 924k
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25.14-69.fc8 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25.14-69.fc8 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003020
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25.14-69.fc8 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25.14-69.fc8 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00003060
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25.14-69.fc8 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xe0101000, 
IRQ: 16.
3w-9xxx: scsi0: Firmware FE9X 3.06.00.003, BIOS BE9X 3.06.00.002, Ports: 4.
scsi 0:0:0:0: Direct-Access     AMCC     9650SE-4LP DISK  3.06 PQ: 0 ANSI: 5
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: 
dm-devel@redhat.com
sd 0:0:0:0: [sda] 1249955840 512-byte hardware sectors (639977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 1249955840 512-byte hardware sectors (639977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't 
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi1 : ata_piix
scsi2 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30a0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30a8 irq 15
ata1.01: ATAPI: SAMSUNG CD-ROM SN-124, q008, max UDMA/33, CDB intr
ata1.01: configured for UDMA/33
ata2: port disabled. ignoring.
scsi 1:0:1:0: CD-ROM            SAMSUNG  CD-ROM SN-124    q008 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:8192 avtab hash slots allocated. Num of rules:219562
SELinux:8192 avtab hash slots allocated. Num of rules:219562
security:  8 users, 12 roles, 2386 types, 116 bools, 1 sens, 1024 cats
security:  67 classes, 219562 rules
security:  class peer not defined in policy
security:  class capability2 not defined in policy
security:  permission recvfrom in class node not defined in policy
security:  permission sendto in class node not defined in policy
security:  permission ingress in class netif not defined in policy
security:  permission egress in class netif not defined in policy
security:  permission setfcap in class capability not defined in policy
security:  permission forward_in in class packet not defined in policy
security:  permission forward_out in class packet not defined in policy
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses 
genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: policy loaded with handle_unknown=allow
type=1403 audit(1221149074.551:2): policy loaded auid=4294967295 
ses=4294967295
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:1:0: Attached scsi CD-ROM sr0
EDAC MC: Ver: 2.1.0 Aug  4 2008
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:1:0: Attached scsi generic sg1 type 5
input: PC Speaker as /class/input/input1
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:0d:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:0d:00.0 to 64
iTCO_vendor_support: vendor-support=0
eth0: (PCI Express:2.5GB/s:Width x1) 00:30:48:8d:1e:50
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
EDAC MC0: Giving out device to 'i3000_edac' 'i3000': DEV 0000:00:00.0
EDAC PCI0: Giving out device to module 'i3000_edac' controller 'EDAC PCI 
controller': DEV '0000:00:00.0' (POLLED)
ACPI: PCI Interrupt 0000:0e:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:0e:00.0 to 64
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
eth1: (PCI Express:2.5GB/s:Width x1) 00:30:48:8d:1e:51
eth1: Intel(R) PRO/1000 Network Connection
eth1: MAC: 2, PHY: 2, PBA No: ffffff-0ff
intel_rng: FWH not detected
ACPI: Power Button (CM) [PWRB]
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 
extents:1 across:2031608k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses 
genfs_contexts
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
eth1: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
fuse init (API version 7.9)
SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
eth0: no IPv6 routers present
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
eth1: no IPv6 routers present
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
Clocksource tsc unstable (delta = 599888961399 ns)
INFO: task spamassassin:1999 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
spamassassin  D f889837d     0  1999   1998
       f713be7c 00000086 00000001 f889837d 00000000 f77aa714 f6de4000 
f6de4248
       c1815400 00000001 f713b000 288ee820 00000286 f713be7c ffffffff 
00000000
       00000000 00000000 f713be84 288fa1a1 f70b3400 f713bebc c0629e30 
e08c2e84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c546>] sys_fdatasync+0x10/0x12
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task sendmail:2005 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sendmail      D f889837d     0  2005   2287
       e08c2e7c 00000086 00000001 f889837d 00000000 edf6c524 f65c2e70 
f65c30b8
       c1815400 00000001 e08c2000 288ee820 00000286 e08c2e7c ffffffff 
00000000
       00000000 00000000 e08c2e84 288fa1a1 f70b3400 e08c2ebc c0629e30 
f6556e84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task sendmail:2006 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sendmail      D f889837d     0  2006   2287
       f6556e7c 00000086 00000001 f889837d 00000000 edf6c334 f6d56000 
f6d56248
       c1815400 00000001 f6556000 288ee820 00000286 f6556e7c ffffffff 
00000000
       00000000 00000000 f6556e84 288fa1a1 f70b3400 f6556ebc c0629e30 
f6ee3e84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task rsyslogd:31477 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsyslogd      D f889837d     0 31477      1
       f6ee3e7c 00200086 00000001 f889837d 96ebad05 0000b385 e09ce000 
e09ce248
       c1815400 00000001 f6ee3000 f6ee3e84 00000000 00000000 c042feb7 
288fa1a1
       00000000 00200286 f6ee3e84 288fa1a1 f70b3400 f6ee3ebc c0629e30 
e08ffe84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c042feb7>] ? __mod_timer+0x9c/0xa7
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task sendmail:1587 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sendmail      D f889837d     0  1587   2287
       e0aade7c 00000086 00000001 f889837d 00000000 eb11c144 e09d4000 
e09d4248
       c1815400 00000001 e0aad000 288ee820 00000286 e0aade7c ffffffff 
00000000
       00000000 00000000 e0aade84 288fa1a1 f70b3400 e0aadebc c0629e30 
e9681e84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task sendmail:2038 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sendmail      D f889837d     0  2038   2287
       e08ffe7c 00000086 00000001 f889837d 00000000 edf6ced4 f66b2000 
f66b2248
       c1815400 00000001 e08ff000 288ee820 00000286 e08ffe7c ffffffff 
00000000
       00000000 00000000 e08ffe84 288fa1a1 f70b3400 e08ffebc c0629e30 
e0aade84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task sendmail:2075 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sendmail      D f889837d     0  2075   2287
       e9681e7c 00000086 00000001 f889837d 00000000 f66ce904 e9796000 
e9796248
       c1815400 00000001 e9681000 288ee820 00000286 e9681e7c ffffffff 
00000000
       00000000 00000000 e9681e84 288fa1a1 f70b3400 e9681ebc c0629e30 
f6f83e84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
INFO: task auditd:1715 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
auditd        D f889837d     0  1715      1
       f6f83e7c 00200086 00000001 f889837d 96ebbfe3 0000b385 f7960e70 
f79610b8
       c1815400 00000001 f6f83000 f6f83e84 00000000 00000000 c042feb7 
288fa1a1
       00000000 00200286 f6f83e84 288fa1a1 f70b3400 f6f83ebc c0629e30 
f6dc9e84
Call Trace:
 [<f889837d>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
 [<c042feb7>] ? __mod_timer+0x9c/0xa7
 [<c0629e30>] schedule_timeout+0x6d/0x8b
 [<c042faa8>] ? process_timeout+0x0/0xa
 [<c0629e2b>] ? schedule_timeout+0x68/0x8b
 [<c0629e63>] schedule_timeout_uninterruptible+0x15/0x17
 [<f88603d3>] journal_stop+0x8a/0x169 [jbd]
 [<f8860bf7>] journal_force_commit+0x1d/0x1f [jbd]
 [<f88988a7>] ext3_force_commit+0x22/0x24 [ext3]
 [<f889366a>] ext3_write_inode+0x34/0x3a [ext3]
 [<c0499b04>] __writeback_single_inode+0x155/0x22a
 [<c0467580>] ? do_writepages+0x2c/0x34
 [<c04628a3>] ? __filemap_fdatawrite_range+0x5b/0x67
 [<c049a303>] sync_inode+0x1c/0x29
 [<f8890040>] ext3_sync_file+0x7c/0x90 [ext3]
 [<c049c4be>] do_fsync+0x49/0x92
 [<c049c527>] __do_fsync+0x20/0x2f
 [<c049c555>] sys_fsync+0xd/0xf
 [<c0405b7e>] syscall_call+0x7/0xb
 =======================
[root@ns3 ~]#


-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


