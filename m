Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYA1Utx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYA1Utx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYA1Uto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:49:44 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24812 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbYA1Utl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:49:41 -0500
Date: Mon, 28 Jan 2008 21:49:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080128204935.GI15220@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
connecting my cf usb storage device yields and endless stream of:

Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
ANSI: 0
sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg1 type 0
scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
ANSI: 0
usb 5-1: reset high speed USB device using ehci_hcd and address 2
usb 5-1: reset high speed USB device using ehci_hcd and address 2
usb 5-1: reset high speed USB device using ehci_hcd and address 2
usb 5-1: reset high speed USB device using ehci_hcd and address 2
usb 5-1: reset high speed USB device using ehci_hcd and address 2
usb 5-1: reset high speed USB device using ehci_hcd and address 2
usb 5-1: reset high speed USB device using ehci_hcd and address 2
[...]

until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
I'm attaching boot messages and my .config.

-- 
Jens Axboe


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="boot.msg"

Linux version 2.6.24 (axboe@carl) (gcc version 4.2.1 (SUSE Linux)) #72 SMP Mon Jan 28 14:14:38 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
2038MB LOWMEM available.
found SMP MP-table at 000f67f0
Entering add_active_range(0, 0, 521936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   521936
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   521936
On node 0 totalpages: 521936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 4045 pages used for memmap
  Normal zone: 513795 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F67C0, 0024 (r2 LENOVO)
ACPI: XSDT 7F6D191C, 0084 (r1 LENOVO TP-7B        2140  LTP        0)
ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2140 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7F6D1D90, CFB9 (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: FACS 7F6F4000, 0040
ACPI: SSDT 7F6D1BB4, 01DC (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: ECDT 7F6DED49, 0052 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: TCPA 7F6DED9B, 0032 (r2 LENOVO TP-7B        2140 LNVO        1)
ACPI: APIC 7F6DEDCD, 0068 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: MCFG 7F6DEE35, 003C (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: HPET 7F6DEE71, 0038 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: BOOT 7F6DEFD8, 0028 (r1 LENOVO TP-7B        2140  LTP        1)
ACPI: SSDT 7F6F2645, 025F (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F28A4, 00A6 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F294A, 04F7 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F2E41, 01D8 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517859
Kernel command line: root=/dev/sda2 vga=ext resume=/dev/sda5 acpi_sleep=s3_bios
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=7840c000 soft=7840a000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.775 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1200 bytes
Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Memory: 2057604k/2087744k available (1922k kernel code, 29480k reserved, 951k data, 208k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb4000 - 0xfffff000   ( 300 kB)
    vmalloc : 0xf8000000 - 0xfffb2000   ( 127 MB)
    lowmem  : 0x78000000 - 0xf76d0000   (2038 MB)
      .init : 0x783d3000 - 0x78407000   ( 208 kB)
      .data : 0x782e0941 - 0x783ce694   ( 951 kB)
      .text : 0x78100000 - 0x782e0941   (1922 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet clockevent registered
Calibrating delay using timer specific routine.. 3663.03 BogoMIPS (lpj=1831518)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=7840d000 soft=7840b000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.61 BogoMIPS (lpj=1828806)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Total of 2 processors activated (7320.64 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 579029 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 76 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnpacpi: exceeded the max number of mem resources: 12
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:00: iomem range 0xcc000-0xcffff has been reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0xdc000-0xdffff has been reserved
system 00:00: iomem range 0xe0000-0xe3fff has been reserved
system 00:00: iomem range 0xe4000-0xe7fff has been reserved
system 00:00: iomem range 0xe8000-0xebfff has been reserved
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x165f could not be reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: ee000000-ee0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-4fff
  MEM window: ec000000-edffffff
  PREFETCH window: e4000000-e40fffff
PCI: Bridge: 0000:00:1c.2
  IO window: 5000-6fff
  MEM window: e8000000-e9ffffff
  PREFETCH window: e4100000-e41fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 7000-8fff
  MEM window: ea000000-ebffffff
  PREFETCH window: e4200000-e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00009000-000090ff
  IO window: 00009400-000094ff
  PREFETCH window: e0000000-e3ffffff
  MEM window: 88000000-8bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-cfff
  MEM window: e4300000-e7ffffff
  PREFETCH window: e0000000-e3ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 5959k freed
Simple Boot Flag at 0x35 set to 0x1
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input2
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 208k freed
Write protecting the kernel read-only data: 779k
ACPI: SSDT 7F6F1D26, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7F6F1FEB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7F6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (46 C)
ACPI: Thermal Zone [THM1] (46 C)
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
ahci 0000:00:1f.2: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0xf
Clocksource tsc unstable (delta = -469895959 ns)
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 219
ata2: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444580 irq 219
ata3: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444600 irq 219
ata4: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444680 irq 219
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HTS721010G9SA00, MCZOC10H, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9SA00  MCZO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata6: port disabled. ignoring.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001820
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001840
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001860
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: Sleep Button (CM) [SLPB]
e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:d3:31:39:4d
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [AC] (off-line)
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:201c]
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
hda_intel: probe_mask set to 0x1 for device 17aa:2010
PCI: Setting latency timer of device 0000:00:1b.0 to 64
Yenta: ISA IRQ mask 0x0cb8, PCI irq 20
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
ALSA sound/pci/hda/hda_intel.c:576: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x005b8000
Adding 2096472k swap on /dev/sda5.  Priority:-1 extents:1 across:2096472k
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.9)

--mYCpIKhGyMATD0i+
Content-Type: application/x-config
Content-Disposition: attachment; filename=".config"
Content-Transfer-Encoding: quoted-printable

#=0A# Automatically generated make config: don't edit=0A# Linux kernel vers=
ion: 2.6.24=0A# Mon Jan 28 14:08:42 2008=0A#=0A# CONFIG_64BIT is not set=0A=
CONFIG_X86_32=3Dy=0A# CONFIG_X86_64 is not set=0ACONFIG_X86=3Dy=0ACONFIG_GE=
NERIC_TIME=3Dy=0ACONFIG_GENERIC_CMOS_UPDATE=3Dy=0ACONFIG_CLOCKSOURCE_WATCHD=
OG=3Dy=0ACONFIG_GENERIC_CLOCKEVENTS=3Dy=0ACONFIG_GENERIC_CLOCKEVENTS_BROADC=
AST=3Dy=0ACONFIG_LOCKDEP_SUPPORT=3Dy=0ACONFIG_STACKTRACE_SUPPORT=3Dy=0ACONF=
IG_SEMAPHORE_SLEEPERS=3Dy=0ACONFIG_MMU=3Dy=0ACONFIG_ZONE_DMA=3Dy=0ACONFIG_Q=
UICKLIST=3Dy=0ACONFIG_GENERIC_ISA_DMA=3Dy=0ACONFIG_GENERIC_IOMAP=3Dy=0ACONF=
IG_GENERIC_BUG=3Dy=0ACONFIG_GENERIC_HWEIGHT=3Dy=0ACONFIG_ARCH_MAY_HAVE_PC_F=
DC=3Dy=0ACONFIG_DMI=3Dy=0A# CONFIG_RWSEM_GENERIC_SPINLOCK is not set=0ACONF=
IG_RWSEM_XCHGADD_ALGORITHM=3Dy=0A# CONFIG_ARCH_HAS_ILOG2_U32 is not set=0A#=
 CONFIG_ARCH_HAS_ILOG2_U64 is not set=0ACONFIG_GENERIC_CALIBRATE_DELAY=3Dy=
=0A# CONFIG_GENERIC_TIME_VSYSCALL is not set=0ACONFIG_ARCH_SUPPORTS_OPROFIL=
E=3Dy=0A# CONFIG_ZONE_DMA32 is not set=0ACONFIG_ARCH_POPULATES_NODE_MAP=3Dy=
=0A# CONFIG_AUDIT_ARCH is not set=0ACONFIG_GENERIC_HARDIRQS=3Dy=0ACONFIG_GE=
NERIC_IRQ_PROBE=3Dy=0ACONFIG_GENERIC_PENDING_IRQ=3Dy=0ACONFIG_X86_SMP=3Dy=
=0ACONFIG_X86_HT=3Dy=0ACONFIG_X86_BIOS_REBOOT=3Dy=0ACONFIG_X86_TRAMPOLINE=
=3Dy=0ACONFIG_KTIME_SCALAR=3Dy=0ACONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNA=
ME_RELEASE/.config"=0A=0A#=0A# General setup=0A#=0ACONFIG_EXPERIMENTAL=3Dy=
=0ACONFIG_LOCK_KERNEL=3Dy=0ACONFIG_INIT_ENV_ARG_LIMIT=3D32=0ACONFIG_LOCALVE=
RSION=3D""=0A# CONFIG_LOCALVERSION_AUTO is not set=0ACONFIG_SWAP=3Dy=0ACONF=
IG_SYSVIPC=3Dy=0ACONFIG_SYSVIPC_SYSCTL=3Dy=0ACONFIG_POSIX_MQUEUE=3Dy=0ACONF=
IG_BSD_PROCESS_ACCT=3Dy=0ACONFIG_BSD_PROCESS_ACCT_V3=3Dy=0A# CONFIG_TASKSTA=
TS is not set=0A# CONFIG_USER_NS is not set=0A# CONFIG_PID_NS is not set=0A=
# CONFIG_AUDIT is not set=0ACONFIG_IKCONFIG=3Dy=0ACONFIG_IKCONFIG_PROC=3Dy=
=0ACONFIG_LOG_BUF_SHIFT=3D17=0A# CONFIG_CGROUPS is not set=0A# CONFIG_FAIR_=
GROUP_SCHED is not set=0ACONFIG_SYSFS_DEPRECATED=3Dy=0ACONFIG_RELAY=3Dy=0AC=
ONFIG_BLK_DEV_INITRD=3Dy=0ACONFIG_INITRAMFS_SOURCE=3D""=0A# CONFIG_CC_OPTIM=
IZE_FOR_SIZE is not set=0ACONFIG_SYSCTL=3Dy=0ACONFIG_EMBEDDED=3Dy=0ACONFIG_=
UID16=3Dy=0ACONFIG_SYSCTL_SYSCALL=3Dy=0ACONFIG_KALLSYMS=3Dy=0ACONFIG_KALLSY=
MS_ALL=3Dy=0A# CONFIG_KALLSYMS_EXTRA_PASS is not set=0ACONFIG_HOTPLUG=3Dy=
=0ACONFIG_PRINTK=3Dy=0ACONFIG_BUG=3Dy=0ACONFIG_ELF_CORE=3Dy=0ACONFIG_BASE_F=
ULL=3Dy=0ACONFIG_FUTEX=3Dy=0ACONFIG_ANON_INODES=3Dy=0ACONFIG_EPOLL=3Dy=0ACO=
NFIG_SIGNALFD=3Dy=0ACONFIG_EVENTFD=3Dy=0ACONFIG_SHMEM=3Dy=0ACONFIG_VM_EVENT=
_COUNTERS=3Dy=0ACONFIG_SLAB=3Dy=0A# CONFIG_SLUB is not set=0A# CONFIG_SLOB =
is not set=0ACONFIG_SLABINFO=3Dy=0ACONFIG_RT_MUTEXES=3Dy=0A# CONFIG_TINY_SH=
MEM is not set=0ACONFIG_BASE_SMALL=3D0=0ACONFIG_MODULES=3Dy=0ACONFIG_MODULE=
_UNLOAD=3Dy=0A# CONFIG_MODULE_FORCE_UNLOAD is not set=0ACONFIG_MODVERSIONS=
=3Dy=0ACONFIG_MODULE_SRCVERSION_ALL=3Dy=0ACONFIG_KMOD=3Dy=0ACONFIG_STOP_MAC=
HINE=3Dy=0ACONFIG_BLOCK=3Dy=0A# CONFIG_LBD is not set=0ACONFIG_BLK_DEV_IO_T=
RACE=3Dy=0A# CONFIG_LSF is not set=0A# CONFIG_BLK_DEV_BSG is not set=0A=0A#=
=0A# IO Schedulers=0A#=0ACONFIG_IOSCHED_NOOP=3Dy=0ACONFIG_IOSCHED_AS=3Dm=0A=
CONFIG_IOSCHED_DEADLINE=3Dm=0ACONFIG_IOSCHED_CFQ=3Dy=0A# CONFIG_DEFAULT_AS =
is not set=0A# CONFIG_DEFAULT_DEADLINE is not set=0ACONFIG_DEFAULT_CFQ=3Dy=
=0A# CONFIG_DEFAULT_NOOP is not set=0ACONFIG_DEFAULT_IOSCHED=3D"cfq"=0ACONF=
IG_CLASSIC_RCU=3Dy=0A# CONFIG_PREEMPT_RCU is not set=0A=0A#=0A# Processor t=
ype and features=0A#=0ACONFIG_TICK_ONESHOT=3Dy=0ACONFIG_NO_HZ=3Dy=0ACONFIG_=
HIGH_RES_TIMERS=3Dy=0ACONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy=0ACONFIG_SMP=3Dy=
=0ACONFIG_X86_PC=3Dy=0A# CONFIG_X86_ELAN is not set=0A# CONFIG_X86_VOYAGER =
is not set=0A# CONFIG_X86_NUMAQ is not set=0A# CONFIG_X86_SUMMIT is not set=
=0A# CONFIG_X86_BIGSMP is not set=0A# CONFIG_X86_VISWS is not set=0A# CONFI=
G_X86_GENERICARCH is not set=0A# CONFIG_X86_ES7000 is not set=0A# CONFIG_X8=
6_VSMP is not set=0ACONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=3Dy=0ACONFIG_PARA=
VIRT=3Dy=0ACONFIG_PARAVIRT_GUEST=3Dy=0A# CONFIG_XEN is not set=0A# CONFIG_V=
MI is not set=0ACONFIG_LGUEST_GUEST=3Dy=0A# CONFIG_M386 is not set=0A# CONF=
IG_M486 is not set=0A# CONFIG_M586 is not set=0A# CONFIG_M586TSC is not set=
=0A# CONFIG_M586MMX is not set=0A# CONFIG_M686 is not set=0A# CONFIG_MPENTI=
UMII is not set=0A# CONFIG_MPENTIUMIII is not set=0A# CONFIG_MPENTIUMM is n=
ot set=0A# CONFIG_MPENTIUM4 is not set=0A# CONFIG_MK6 is not set=0A# CONFIG=
_MK7 is not set=0A# CONFIG_MK8 is not set=0A# CONFIG_MCRUSOE is not set=0A#=
 CONFIG_MEFFICEON is not set=0A# CONFIG_MWINCHIPC6 is not set=0A# CONFIG_MW=
INCHIP2 is not set=0A# CONFIG_MWINCHIP3D is not set=0A# CONFIG_MGEODEGX1 is=
 not set=0A# CONFIG_MGEODE_LX is not set=0A# CONFIG_MCYRIXIII is not set=0A=
# CONFIG_MVIAC3_2 is not set=0A# CONFIG_MVIAC7 is not set=0A# CONFIG_MPSC i=
s not set=0ACONFIG_MCORE2=3Dy=0A# CONFIG_GENERIC_CPU is not set=0A# CONFIG_=
X86_GENERIC is not set=0ACONFIG_X86_CMPXCHG=3Dy=0ACONFIG_X86_L1_CACHE_SHIFT=
=3D6=0ACONFIG_X86_XADD=3Dy=0ACONFIG_X86_WP_WORKS_OK=3Dy=0ACONFIG_X86_INVLPG=
=3Dy=0ACONFIG_X86_BSWAP=3Dy=0ACONFIG_X86_POPAD_OK=3Dy=0ACONFIG_X86_GOOD_API=
C=3Dy=0ACONFIG_X86_INTEL_USERCOPY=3Dy=0ACONFIG_X86_USE_PPRO_CHECKSUM=3Dy=0A=
CONFIG_X86_TSC=3Dy=0ACONFIG_X86_MINIMUM_CPU_FAMILY=3D4=0ACONFIG_HPET_TIMER=
=3Dy=0ACONFIG_HPET_EMULATE_RTC=3Dy=0ACONFIG_NR_CPUS=3D2=0A# CONFIG_SCHED_SM=
T is not set=0A# CONFIG_SCHED_MC is not set=0A# CONFIG_PREEMPT_NONE is not =
set=0ACONFIG_PREEMPT_VOLUNTARY=3Dy=0A# CONFIG_PREEMPT is not set=0ACONFIG_R=
CU_TRACE=3Dy=0ACONFIG_X86_LOCAL_APIC=3Dy=0ACONFIG_X86_IO_APIC=3Dy=0A# CONFI=
G_X86_MCE is not set=0ACONFIG_VM86=3Dy=0A# CONFIG_TOSHIBA is not set=0A# CO=
NFIG_I8K is not set=0A# CONFIG_X86_REBOOTFIXUPS is not set=0A# CONFIG_MICRO=
CODE is not set=0ACONFIG_X86_MSR=3Dy=0ACONFIG_X86_CPUID=3Dy=0ACONFIG_NOHIGH=
MEM=3Dy=0A# CONFIG_HIGHMEM4G is not set=0A# CONFIG_HIGHMEM64G is not set=0A=
# CONFIG_VMSPLIT_3G is not set=0A# CONFIG_VMSPLIT_3G_OPT is not set=0A# CON=
FIG_VMSPLIT_2G is not set=0ACONFIG_VMSPLIT_2G_OPT=3Dy=0A# CONFIG_VMSPLIT_1G=
 is not set=0ACONFIG_PAGE_OFFSET=3D0x78000000=0A# CONFIG_X86_PAE is not set=
=0ACONFIG_ARCH_FLATMEM_ENABLE=3Dy=0ACONFIG_ARCH_SPARSEMEM_ENABLE=3Dy=0ACONF=
IG_ARCH_SELECT_MEMORY_MODEL=3Dy=0ACONFIG_SELECT_MEMORY_MODEL=3Dy=0ACONFIG_F=
LATMEM_MANUAL=3Dy=0A# CONFIG_DISCONTIGMEM_MANUAL is not set=0A# CONFIG_SPAR=
SEMEM_MANUAL is not set=0ACONFIG_FLATMEM=3Dy=0ACONFIG_FLAT_NODE_MEM_MAP=3Dy=
=0ACONFIG_SPARSEMEM_STATIC=3Dy=0A# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not s=
et=0ACONFIG_SPLIT_PTLOCK_CPUS=3D4=0A# CONFIG_RESOURCES_64BIT is not set=0AC=
ONFIG_ZONE_DMA_FLAG=3D1=0ACONFIG_BOUNCE=3Dy=0ACONFIG_NR_QUICK=3D1=0ACONFIG_=
VIRT_TO_BUS=3Dy=0A# CONFIG_MATH_EMULATION is not set=0ACONFIG_MTRR=3Dy=0A# =
CONFIG_EFI is not set=0A# CONFIG_IRQBALANCE is not set=0A# CONFIG_SECCOMP i=
s not set=0A# CONFIG_HZ_100 is not set=0A# CONFIG_HZ_250 is not set=0A# CON=
FIG_HZ_300 is not set=0ACONFIG_HZ_1000=3Dy=0ACONFIG_HZ=3D1000=0ACONFIG_SCHE=
D_HRTICK=3Dy=0ACONFIG_KEXEC=3Dy=0ACONFIG_PHYSICAL_START=3D0x100000=0A# CONF=
IG_RELOCATABLE is not set=0ACONFIG_PHYSICAL_ALIGN=3D0x100000=0ACONFIG_HOTPL=
UG_CPU=3Dy=0ACONFIG_COMPAT_VDSO=3Dy=0A=0A#=0A# Power management options=0A#=
=0ACONFIG_PM=3Dy=0ACONFIG_PM_LEGACY=3Dy=0A# CONFIG_PM_DEBUG is not set=0ACO=
NFIG_PM_SLEEP_SMP=3Dy=0ACONFIG_PM_SLEEP=3Dy=0ACONFIG_SUSPEND_SMP_POSSIBLE=
=3Dy=0ACONFIG_SUSPEND=3Dy=0ACONFIG_HIBERNATION_SMP_POSSIBLE=3Dy=0A# CONFIG_=
HIBERNATION is not set=0ACONFIG_ACPI=3Dy=0ACONFIG_ACPI_SLEEP=3Dy=0ACONFIG_A=
CPI_PROCFS=3Dy=0ACONFIG_ACPI_PROCFS_POWER=3Dy=0ACONFIG_ACPI_SYSFS_POWER=3Dy=
=0ACONFIG_ACPI_PROC_EVENT=3Dy=0ACONFIG_ACPI_AC=3Dm=0ACONFIG_ACPI_BATTERY=3D=
m=0ACONFIG_ACPI_BUTTON=3Dm=0ACONFIG_ACPI_FAN=3Dm=0ACONFIG_ACPI_DOCK=3Dm=0A#=
 CONFIG_ACPI_BAY is not set=0ACONFIG_ACPI_PROCESSOR=3Dm=0ACONFIG_ACPI_HOTPL=
UG_CPU=3Dy=0ACONFIG_ACPI_THERMAL=3Dm=0A# CONFIG_ACPI_ASUS is not set=0A# CO=
NFIG_ACPI_TOSHIBA is not set=0A# CONFIG_ACPI_CUSTOM_DSDT is not set=0ACONFI=
G_ACPI_BLACKLIST_YEAR=3D2001=0A# CONFIG_ACPI_DEBUG is not set=0ACONFIG_ACPI=
_EC=3Dy=0ACONFIG_ACPI_POWER=3Dy=0ACONFIG_ACPI_SYSTEM=3Dy=0ACONFIG_X86_PM_TI=
MER=3Dy=0ACONFIG_ACPI_CONTAINER=3Dm=0A# CONFIG_ACPI_SBS is not set=0A# CONF=
IG_APM is not set=0A=0A#=0A# CPU Frequency scaling=0A#=0ACONFIG_CPU_FREQ=3D=
y=0ACONFIG_CPU_FREQ_TABLE=3Dy=0A# CONFIG_CPU_FREQ_DEBUG is not set=0ACONFIG=
_CPU_FREQ_STAT=3Dm=0ACONFIG_CPU_FREQ_STAT_DETAILS=3Dy=0A# CONFIG_CPU_FREQ_D=
EFAULT_GOV_PERFORMANCE is not set=0A# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=
 is not set=0ACONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy=0A# CONFIG_CPU_FREQ_=
DEFAULT_GOV_CONSERVATIVE is not set=0ACONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy=
=0ACONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm=0ACONFIG_CPU_FREQ_GOV_USERSPACE=3Dm=0A=
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy=0A# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is no=
t set=0A=0A#=0A# CPUFreq processor drivers=0A#=0ACONFIG_X86_ACPI_CPUFREQ=3D=
m=0A# CONFIG_X86_POWERNOW_K6 is not set=0A# CONFIG_X86_POWERNOW_K7 is not s=
et=0A# CONFIG_X86_POWERNOW_K8 is not set=0A# CONFIG_X86_GX_SUSPMOD is not s=
et=0ACONFIG_X86_SPEEDSTEP_CENTRINO=3Dm=0ACONFIG_X86_SPEEDSTEP_CENTRINO_TABL=
E=3Dy=0A# CONFIG_X86_SPEEDSTEP_ICH is not set=0A# CONFIG_X86_SPEEDSTEP_SMI =
is not set=0A# CONFIG_X86_P4_CLOCKMOD is not set=0A# CONFIG_X86_CPUFREQ_NFO=
RCE2 is not set=0A# CONFIG_X86_LONGRUN is not set=0A# CONFIG_X86_LONGHAUL i=
s not set=0A# CONFIG_X86_E_POWERSAVER is not set=0A=0A#=0A# shared options=
=0A#=0A# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set=0A# CONFIG_X86_SPEEDS=
TEP_LIB is not set=0ACONFIG_CPU_IDLE=3Dy=0ACONFIG_CPU_IDLE_GOV_LADDER=3Dy=
=0ACONFIG_CPU_IDLE_GOV_MENU=3Dy=0A=0A#=0A# Bus options (PCI etc.)=0A#=0ACON=
FIG_PCI=3Dy=0A# CONFIG_PCI_GOBIOS is not set=0A# CONFIG_PCI_GOMMCONFIG is n=
ot set=0A# CONFIG_PCI_GODIRECT is not set=0ACONFIG_PCI_GOANY=3Dy=0ACONFIG_P=
CI_BIOS=3Dy=0ACONFIG_PCI_DIRECT=3Dy=0ACONFIG_PCI_MMCONFIG=3Dy=0ACONFIG_PCI_=
DOMAINS=3Dy=0ACONFIG_PCIEPORTBUS=3Dy=0A# CONFIG_HOTPLUG_PCI_PCIE is not set=
=0A# CONFIG_PCIEAER is not set=0ACONFIG_ARCH_SUPPORTS_MSI=3Dy=0ACONFIG_PCI_=
MSI=3Dy=0A# CONFIG_PCI_LEGACY is not set=0A# CONFIG_PCI_DEBUG is not set=0A=
# CONFIG_HT_IRQ is not set=0ACONFIG_ISA_DMA_API=3Dy=0A# CONFIG_ISA is not s=
et=0A# CONFIG_MCA is not set=0A# CONFIG_SCx200 is not set=0ACONFIG_PCCARD=
=3Dm=0A# CONFIG_PCMCIA_DEBUG is not set=0ACONFIG_PCMCIA=3Dm=0ACONFIG_PCMCIA=
_LOAD_CIS=3Dy=0ACONFIG_PCMCIA_IOCTL=3Dy=0ACONFIG_CARDBUS=3Dy=0A=0A#=0A# PC-=
card bridges=0A#=0ACONFIG_YENTA=3Dm=0ACONFIG_YENTA_O2=3Dy=0ACONFIG_YENTA_RI=
COH=3Dy=0ACONFIG_YENTA_TI=3Dy=0ACONFIG_YENTA_ENE_TUNE=3Dy=0ACONFIG_YENTA_TO=
SHIBA=3Dy=0A# CONFIG_PD6729 is not set=0A# CONFIG_I82092 is not set=0ACONFI=
G_PCCARD_NONSTATIC=3Dm=0ACONFIG_HOTPLUG_PCI=3Dy=0A# CONFIG_HOTPLUG_PCI_FAKE=
 is not set=0ACONFIG_HOTPLUG_PCI_ACPI=3Dm=0ACONFIG_HOTPLUG_PCI_ACPI_IBM=3Dm=
=0A# CONFIG_HOTPLUG_PCI_CPCI is not set=0A# CONFIG_HOTPLUG_PCI_SHPC is not =
set=0A=0A#=0A# Executable file formats / Emulations=0A#=0ACONFIG_BINFMT_ELF=
=3Dy=0ACONFIG_BINFMT_AOUT=3Dm=0ACONFIG_BINFMT_MISC=3Dm=0A=0A#=0A# Networkin=
g=0A#=0ACONFIG_NET=3Dy=0A=0A#=0A# Networking options=0A#=0ACONFIG_PACKET=3D=
m=0ACONFIG_PACKET_MMAP=3Dy=0ACONFIG_UNIX=3Dy=0A# CONFIG_NET_KEY is not set=
=0ACONFIG_INET=3Dy=0A# CONFIG_IP_MULTICAST is not set=0A# CONFIG_IP_ADVANCE=
D_ROUTER is not set=0ACONFIG_IP_FIB_HASH=3Dy=0A# CONFIG_IP_PNP is not set=
=0A# CONFIG_NET_IPIP is not set=0A# CONFIG_NET_IPGRE is not set=0A# CONFIG_=
ARPD is not set=0ACONFIG_SYN_COOKIES=3Dy=0A# CONFIG_INET_AH is not set=0A# =
CONFIG_INET_ESP is not set=0A# CONFIG_INET_IPCOMP is not set=0A# CONFIG_INE=
T_XFRM_TUNNEL is not set=0A# CONFIG_INET_TUNNEL is not set=0A# CONFIG_INET_=
XFRM_MODE_TRANSPORT is not set=0A# CONFIG_INET_XFRM_MODE_TUNNEL is not set=
=0A# CONFIG_INET_XFRM_MODE_BEET is not set=0A# CONFIG_INET_LRO is not set=
=0A# CONFIG_INET_DIAG is not set=0A# CONFIG_TCP_CONG_ADVANCED is not set=0A=
CONFIG_TCP_CONG_CUBIC=3Dy=0ACONFIG_DEFAULT_TCP_CONG=3D"cubic"=0A# CONFIG_TC=
P_MD5SIG is not set=0A# CONFIG_IPV6 is not set=0A# CONFIG_INET6_XFRM_TUNNEL=
 is not set=0A# CONFIG_INET6_TUNNEL is not set=0A# CONFIG_NETWORK_SECMARK i=
s not set=0A# CONFIG_NETFILTER is not set=0A# CONFIG_IP_DCCP is not set=0A#=
 CONFIG_IP_SCTP is not set=0A# CONFIG_TIPC is not set=0A# CONFIG_ATM is not=
 set=0A# CONFIG_BRIDGE is not set=0A# CONFIG_VLAN_8021Q is not set=0A# CONF=
IG_DECNET is not set=0A# CONFIG_LLC2 is not set=0A# CONFIG_IPX is not set=
=0A# CONFIG_ATALK is not set=0A# CONFIG_X25 is not set=0A# CONFIG_LAPB is n=
ot set=0A# CONFIG_ECONET is not set=0A# CONFIG_WAN_ROUTER is not set=0A# CO=
NFIG_NET_SCHED is not set=0ACONFIG_NET_SCH_FIFO=3Dy=0A=0A#=0A# Network test=
ing=0A#=0A# CONFIG_NET_PKTGEN is not set=0A# CONFIG_HAMRADIO is not set=0A#=
 CONFIG_IRDA is not set=0ACONFIG_BT=3Dm=0ACONFIG_BT_L2CAP=3Dm=0ACONFIG_BT_S=
CO=3Dm=0ACONFIG_BT_RFCOMM=3Dm=0ACONFIG_BT_RFCOMM_TTY=3Dy=0ACONFIG_BT_BNEP=
=3Dm=0ACONFIG_BT_BNEP_MC_FILTER=3Dy=0ACONFIG_BT_BNEP_PROTO_FILTER=3Dy=0ACON=
FIG_BT_HIDP=3Dm=0A=0A#=0A# Bluetooth device drivers=0A#=0ACONFIG_BT_HCIUSB=
=3Dm=0ACONFIG_BT_HCIUSB_SCO=3Dy=0ACONFIG_BT_HCIUART=3Dm=0ACONFIG_BT_HCIUART=
_H4=3Dy=0ACONFIG_BT_HCIUART_BCSP=3Dy=0A# CONFIG_BT_HCIUART_LL is not set=0A=
# CONFIG_BT_HCIBCM203X is not set=0A# CONFIG_BT_HCIBPA10X is not set=0A# CO=
NFIG_BT_HCIBFUSB is not set=0A# CONFIG_BT_HCIDTL1 is not set=0A# CONFIG_BT_=
HCIBT3C is not set=0A# CONFIG_BT_HCIBLUECARD is not set=0A# CONFIG_BT_HCIBT=
UART is not set=0A# CONFIG_BT_HCIVHCI is not set=0A# CONFIG_AF_RXRPC is not=
 set=0A=0A#=0A# Wireless=0A#=0ACONFIG_CFG80211=3Dm=0ACONFIG_NL80211=3Dy=0AC=
ONFIG_WIRELESS_EXT=3Dy=0ACONFIG_MAC80211=3Dm=0ACONFIG_MAC80211_RCSIMPLE=3Dy=
=0ACONFIG_MAC80211_DEBUGFS=3Dy=0A# CONFIG_MAC80211_DEBUG is not set=0ACONFI=
G_IEEE80211=3Dm=0A# CONFIG_IEEE80211_DEBUG is not set=0ACONFIG_IEEE80211_CR=
YPT_WEP=3Dm=0ACONFIG_IEEE80211_CRYPT_CCMP=3Dm=0A# CONFIG_IEEE80211_CRYPT_TK=
IP is not set=0A# CONFIG_IEEE80211_SOFTMAC is not set=0A# CONFIG_RFKILL is =
not set=0A# CONFIG_NET_9P is not set=0A=0A#=0A# Device Drivers=0A#=0A=0A#=
=0A# Generic Driver Options=0A#=0ACONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplu=
g"=0A# CONFIG_STANDALONE is not set=0ACONFIG_PREVENT_FIRMWARE_BUILD=3Dy=0AC=
ONFIG_FW_LOADER=3Dy=0A# CONFIG_DEBUG_DRIVER is not set=0A# CONFIG_DEBUG_DEV=
RES is not set=0A# CONFIG_SYS_HYPERVISOR is not set=0A# CONFIG_CONNECTOR is=
 not set=0A# CONFIG_MTD is not set=0A# CONFIG_PARPORT is not set=0ACONFIG_P=
NP=3Dy=0A# CONFIG_PNP_DEBUG is not set=0A=0A#=0A# Protocols=0A#=0ACONFIG_PN=
PACPI=3Dy=0ACONFIG_BLK_DEV=3Dy=0A# CONFIG_BLK_DEV_FD is not set=0A# CONFIG_=
BLK_CPQ_DA is not set=0A# CONFIG_BLK_CPQ_CISS_DA is not set=0A# CONFIG_BLK_=
DEV_DAC960 is not set=0A# CONFIG_BLK_DEV_UMEM is not set=0A# CONFIG_BLK_DEV=
_COW_COMMON is not set=0ACONFIG_BLK_DEV_LOOP=3Dm=0A# CONFIG_BLK_DEV_CRYPTOL=
OOP is not set=0A# CONFIG_BLK_DEV_NBD is not set=0A# CONFIG_BLK_DEV_SX8 is =
not set=0A# CONFIG_BLK_DEV_UB is not set=0A# CONFIG_BLK_DEV_RAM is not set=
=0A# CONFIG_CDROM_PKTCDVD is not set=0A# CONFIG_ATA_OVER_ETH is not set=0AC=
ONFIG_VIRTIO_BLK=3Dy=0ACONFIG_MISC_DEVICES=3Dy=0A# CONFIG_IBM_ASM is not se=
t=0A# CONFIG_PHANTOM is not set=0A# CONFIG_EEPROM_93CX6 is not set=0A# CONF=
IG_SGI_IOC4 is not set=0A# CONFIG_TIFM_CORE is not set=0A# CONFIG_SONY_LAPT=
OP is not set=0A# CONFIG_THINKPAD_ACPI is not set=0A# CONFIG_IDE is not set=
=0A=0A#=0A# SCSI device support=0A#=0A# CONFIG_RAID_ATTRS is not set=0ACONF=
IG_SCSI=3Dy=0ACONFIG_SCSI_DMA=3Dy=0A# CONFIG_SCSI_TGT is not set=0A# CONFIG=
_SCSI_NETLINK is not set=0ACONFIG_SCSI_PROC_FS=3Dy=0A=0A#=0A# SCSI support =
type (disk, tape, CD-ROM)=0A#=0ACONFIG_BLK_DEV_SD=3Dy=0A# CONFIG_CHR_DEV_ST=
 is not set=0A# CONFIG_CHR_DEV_OSST is not set=0ACONFIG_BLK_DEV_SR=3Dm=0A# =
CONFIG_BLK_DEV_SR_VENDOR is not set=0ACONFIG_CHR_DEV_SG=3Dm=0A# CONFIG_CHR_=
DEV_SCH is not set=0A=0A#=0A# Some SCSI devices (e.g. CD jukebox) support m=
ultiple LUNs=0A#=0ACONFIG_SCSI_MULTI_LUN=3Dy=0ACONFIG_SCSI_CONSTANTS=3Dy=0A=
CONFIG_SCSI_LOGGING=3Dy=0A# CONFIG_SCSI_SCAN_ASYNC is not set=0ACONFIG_SCSI=
_WAIT_SCAN=3Dm=0A=0A#=0A# SCSI Transports=0A#=0A# CONFIG_SCSI_SPI_ATTRS is =
not set=0A# CONFIG_SCSI_FC_ATTRS is not set=0A# CONFIG_SCSI_ISCSI_ATTRS is =
not set=0A# CONFIG_SCSI_SAS_LIBSAS is not set=0A# CONFIG_SCSI_SRP_ATTRS is =
not set=0ACONFIG_SCSI_LOWLEVEL=3Dy=0A# CONFIG_ISCSI_TCP is not set=0A# CONF=
IG_BLK_DEV_3W_XXXX_RAID is not set=0A# CONFIG_SCSI_3W_9XXX is not set=0A# C=
ONFIG_SCSI_ACARD is not set=0A# CONFIG_SCSI_AACRAID is not set=0A# CONFIG_S=
CSI_AIC7XXX is not set=0A# CONFIG_SCSI_AIC7XXX_OLD is not set=0A# CONFIG_SC=
SI_AIC79XX is not set=0A# CONFIG_SCSI_AIC94XX is not set=0A# CONFIG_SCSI_DP=
T_I2O is not set=0A# CONFIG_SCSI_ADVANSYS is not set=0A# CONFIG_SCSI_ARCMSR=
 is not set=0A# CONFIG_MEGARAID_NEWGEN is not set=0A# CONFIG_MEGARAID_LEGAC=
Y is not set=0A# CONFIG_MEGARAID_SAS is not set=0A# CONFIG_SCSI_HPTIOP is n=
ot set=0A# CONFIG_SCSI_BUSLOGIC is not set=0A# CONFIG_SCSI_DMX3191D is not =
set=0A# CONFIG_SCSI_EATA is not set=0A# CONFIG_SCSI_FUTURE_DOMAIN is not se=
t=0A# CONFIG_SCSI_IPS is not set=0A# CONFIG_SCSI_INITIO is not set=0A# CONF=
IG_SCSI_INIA100 is not set=0A# CONFIG_SCSI_STEX is not set=0A# CONFIG_SCSI_=
SYM53C8XX_2 is not set=0A# CONFIG_SCSI_IPR is not set=0A# CONFIG_SCSI_QLOGI=
C_1280 is not set=0A# CONFIG_SCSI_QLA_FC is not set=0A# CONFIG_SCSI_QLA_ISC=
SI is not set=0A# CONFIG_SCSI_LPFC is not set=0A# CONFIG_SCSI_DC395x is not=
 set=0A# CONFIG_SCSI_DC390T is not set=0A# CONFIG_SCSI_NSP32 is not set=0AC=
ONFIG_SCSI_DEBUG=3Dm=0A# CONFIG_SCSI_SRP is not set=0A# CONFIG_SCSI_LOWLEVE=
L_PCMCIA is not set=0ACONFIG_ATA=3Dy=0A# CONFIG_ATA_NONSTANDARD is not set=
=0ACONFIG_ATA_ACPI=3Dy=0ACONFIG_SATA_AHCI=3Dm=0A# CONFIG_SATA_SVW is not se=
t=0ACONFIG_ATA_PIIX=3Dm=0A# CONFIG_SATA_MV is not set=0A# CONFIG_SATA_NV is=
 not set=0A# CONFIG_PDC_ADMA is not set=0A# CONFIG_SATA_QSTOR is not set=0A=
# CONFIG_SATA_PROMISE is not set=0A# CONFIG_SATA_SX4 is not set=0A# CONFIG_=
SATA_SIL is not set=0A# CONFIG_SATA_SIL24 is not set=0A# CONFIG_SATA_SIS is=
 not set=0A# CONFIG_SATA_ULI is not set=0A# CONFIG_SATA_VIA is not set=0A# =
CONFIG_SATA_VITESSE is not set=0A# CONFIG_SATA_INIC162X is not set=0A# CONF=
IG_PATA_ACPI is not set=0A# CONFIG_PATA_ALI is not set=0A# CONFIG_PATA_AMD =
is not set=0A# CONFIG_PATA_ARTOP is not set=0A# CONFIG_PATA_ATIIXP is not s=
et=0A# CONFIG_PATA_CMD640_PCI is not set=0A# CONFIG_PATA_CMD64X is not set=
=0A# CONFIG_PATA_CS5520 is not set=0A# CONFIG_PATA_CS5530 is not set=0A# CO=
NFIG_PATA_CS5535 is not set=0A# CONFIG_PATA_CS5536 is not set=0A# CONFIG_PA=
TA_CYPRESS is not set=0A# CONFIG_PATA_EFAR is not set=0A# CONFIG_ATA_GENERI=
C is not set=0A# CONFIG_PATA_HPT366 is not set=0A# CONFIG_PATA_HPT37X is no=
t set=0A# CONFIG_PATA_HPT3X2N is not set=0A# CONFIG_PATA_HPT3X3 is not set=
=0A# CONFIG_PATA_IT821X is not set=0A# CONFIG_PATA_IT8213 is not set=0A# CO=
NFIG_PATA_JMICRON is not set=0A# CONFIG_PATA_TRIFLEX is not set=0A# CONFIG_=
PATA_MARVELL is not set=0A# CONFIG_PATA_MPIIX is not set=0A# CONFIG_PATA_OL=
DPIIX is not set=0A# CONFIG_PATA_NETCELL is not set=0A# CONFIG_PATA_NINJA32=
 is not set=0A# CONFIG_PATA_NS87410 is not set=0A# CONFIG_PATA_NS87415 is n=
ot set=0A# CONFIG_PATA_OPTI is not set=0A# CONFIG_PATA_OPTIDMA is not set=
=0A# CONFIG_PATA_PCMCIA is not set=0A# CONFIG_PATA_PDC_OLD is not set=0A# C=
ONFIG_PATA_RADISYS is not set=0A# CONFIG_PATA_RZ1000 is not set=0A# CONFIG_=
PATA_SC1200 is not set=0A# CONFIG_PATA_SERVERWORKS is not set=0A# CONFIG_PA=
TA_PDC2027X is not set=0A# CONFIG_PATA_SIL680 is not set=0A# CONFIG_PATA_SI=
S is not set=0A# CONFIG_PATA_VIA is not set=0A# CONFIG_PATA_WINBOND is not =
set=0A# CONFIG_PATA_PLATFORM is not set=0A# CONFIG_MD is not set=0A# CONFIG=
_FUSION is not set=0A=0A#=0A# IEEE 1394 (FireWire) support=0A#=0A# CONFIG_F=
IREWIRE is not set=0A# CONFIG_IEEE1394 is not set=0A# CONFIG_I2O is not set=
=0A# CONFIG_MACINTOSH_DRIVERS is not set=0ACONFIG_NETDEVICES=3Dy=0A# CONFIG=
_NETDEVICES_MULTIQUEUE is not set=0ACONFIG_DUMMY=3Dm=0A# CONFIG_BONDING is =
not set=0A# CONFIG_MACVLAN is not set=0A# CONFIG_EQUALIZER is not set=0ACON=
FIG_TUN=3Dm=0A# CONFIG_VETH is not set=0A# CONFIG_NET_SB1000 is not set=0A#=
 CONFIG_ARCNET is not set=0A# CONFIG_NET_ETHERNET is not set=0ACONFIG_NETDE=
V_1000=3Dy=0A# CONFIG_ACENIC is not set=0A# CONFIG_DL2K is not set=0ACONFIG=
_E1000=3Dm=0ACONFIG_E1000_NAPI=3Dy=0A# CONFIG_E1000_DISABLE_PACKET_SPLIT is=
 not set=0A# CONFIG_E1000E is not set=0A# CONFIG_IP1000 is not set=0A# CONF=
IG_NS83820 is not set=0A# CONFIG_HAMACHI is not set=0A# CONFIG_YELLOWFIN is=
 not set=0A# CONFIG_R8169 is not set=0A# CONFIG_SIS190 is not set=0A# CONFI=
G_SKGE is not set=0A# CONFIG_SKY2 is not set=0A# CONFIG_SK98LIN is not set=
=0A# CONFIG_VIA_VELOCITY is not set=0A# CONFIG_TIGON3 is not set=0A# CONFIG=
_BNX2 is not set=0A# CONFIG_QLA3XXX is not set=0A# CONFIG_ATL1 is not set=
=0A# CONFIG_NETDEV_10000 is not set=0A# CONFIG_TR is not set=0A=0A#=0A# Wir=
eless LAN=0A#=0A# CONFIG_WLAN_PRE80211 is not set=0ACONFIG_WLAN_80211=3Dy=
=0A# CONFIG_PCMCIA_RAYCS is not set=0A# CONFIG_IPW2100 is not set=0A# CONFI=
G_IPW2200 is not set=0A# CONFIG_LIBERTAS is not set=0A# CONFIG_AIRO is not =
set=0A# CONFIG_HERMES is not set=0A# CONFIG_ATMEL is not set=0A# CONFIG_AIR=
O_CS is not set=0A# CONFIG_PCMCIA_WL3501 is not set=0A# CONFIG_PRISM54 is n=
ot set=0A# CONFIG_USB_ZD1201 is not set=0A# CONFIG_RTL8187 is not set=0A# C=
ONFIG_ADM8211 is not set=0A# CONFIG_P54_COMMON is not set=0ACONFIG_IWLWIFI=
=3Dy=0A# CONFIG_IWLWIFI_DEBUG is not set=0ACONFIG_IWLWIFI_SENSITIVITY=3Dy=
=0ACONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=3Dy=0ACONFIG_IWLWIFI_QOS=3Dy=0A# CON=
FIG_IWL4965 is not set=0ACONFIG_IWL3945=3Dm=0A# CONFIG_HOSTAP is not set=0A=
# CONFIG_B43 is not set=0A# CONFIG_B43LEGACY is not set=0A# CONFIG_RT2X00 i=
s not set=0A=0A#=0A# USB Network Adapters=0A#=0A# CONFIG_USB_CATC is not se=
t=0A# CONFIG_USB_KAWETH is not set=0A# CONFIG_USB_PEGASUS is not set=0A# CO=
NFIG_USB_RTL8150 is not set=0A# CONFIG_USB_USBNET is not set=0A# CONFIG_NET=
_PCMCIA is not set=0A# CONFIG_WAN is not set=0A# CONFIG_FDDI is not set=0A#=
 CONFIG_HIPPI is not set=0A# CONFIG_PPP is not set=0A# CONFIG_SLIP is not s=
et=0A# CONFIG_NET_FC is not set=0A# CONFIG_SHAPER is not set=0A# CONFIG_NET=
CONSOLE is not set=0A# CONFIG_NETPOLL is not set=0A# CONFIG_NET_POLL_CONTRO=
LLER is not set=0A# CONFIG_VIRTIO_NET is not set=0A# CONFIG_ISDN is not set=
=0A# CONFIG_PHONE is not set=0A=0A#=0A# Input device support=0A#=0ACONFIG_I=
NPUT=3Dy=0A# CONFIG_INPUT_FF_MEMLESS is not set=0A# CONFIG_INPUT_POLLDEV is=
 not set=0A=0A#=0A# Userland interfaces=0A#=0ACONFIG_INPUT_MOUSEDEV=3Dy=0AC=
ONFIG_INPUT_MOUSEDEV_PSAUX=3Dy=0ACONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024=0ACO=
NFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768=0A# CONFIG_INPUT_JOYDEV is not set=0ACON=
FIG_INPUT_EVDEV=3Dy=0A# CONFIG_INPUT_EVBUG is not set=0A=0A#=0A# Input Devi=
ce Drivers=0A#=0ACONFIG_INPUT_KEYBOARD=3Dy=0ACONFIG_KEYBOARD_ATKBD=3Dy=0A# =
CONFIG_KEYBOARD_SUNKBD is not set=0A# CONFIG_KEYBOARD_LKKBD is not set=0A# =
CONFIG_KEYBOARD_XTKBD is not set=0A# CONFIG_KEYBOARD_NEWTON is not set=0A# =
CONFIG_KEYBOARD_STOWAWAY is not set=0ACONFIG_INPUT_MOUSE=3Dy=0ACONFIG_MOUSE=
_PS2=3Dy=0ACONFIG_MOUSE_PS2_ALPS=3Dy=0ACONFIG_MOUSE_PS2_LOGIPS2PP=3Dy=0ACON=
FIG_MOUSE_PS2_SYNAPTICS=3Dy=0ACONFIG_MOUSE_PS2_LIFEBOOK=3Dy=0ACONFIG_MOUSE_=
PS2_TRACKPOINT=3Dy=0A# CONFIG_MOUSE_PS2_TOUCHKIT is not set=0A# CONFIG_MOUS=
E_SERIAL is not set=0A# CONFIG_MOUSE_APPLETOUCH is not set=0A# CONFIG_MOUSE=
_VSXXXAA is not set=0A# CONFIG_INPUT_JOYSTICK is not set=0A# CONFIG_INPUT_T=
ABLET is not set=0A# CONFIG_INPUT_TOUCHSCREEN is not set=0ACONFIG_INPUT_MIS=
C=3Dy=0ACONFIG_INPUT_PCSPKR=3Dy=0A# CONFIG_INPUT_WISTRON_BTNS is not set=0A=
# CONFIG_INPUT_ATLAS_BTNS is not set=0A# CONFIG_INPUT_ATI_REMOTE is not set=
=0A# CONFIG_INPUT_ATI_REMOTE2 is not set=0A# CONFIG_INPUT_KEYSPAN_REMOTE is=
 not set=0A# CONFIG_INPUT_POWERMATE is not set=0A# CONFIG_INPUT_YEALINK is =
not set=0ACONFIG_INPUT_UINPUT=3Dm=0A=0A#=0A# Hardware I/O ports=0A#=0ACONFI=
G_SERIO=3Dy=0ACONFIG_SERIO_I8042=3Dy=0A# CONFIG_SERIO_SERPORT is not set=0A=
# CONFIG_SERIO_CT82C710 is not set=0A# CONFIG_SERIO_PCIPS2 is not set=0ACON=
FIG_SERIO_LIBPS2=3Dy=0A# CONFIG_SERIO_RAW is not set=0A# CONFIG_GAMEPORT is=
 not set=0A=0A#=0A# Character devices=0A#=0ACONFIG_VT=3Dy=0ACONFIG_VT_CONSO=
LE=3Dy=0ACONFIG_HW_CONSOLE=3Dy=0ACONFIG_VT_HW_CONSOLE_BINDING=3Dy=0A# CONFI=
G_SERIAL_NONSTANDARD is not set=0A# CONFIG_NOZOMI is not set=0A=0A#=0A# Ser=
ial drivers=0A#=0A# CONFIG_SERIAL_8250 is not set=0ACONFIG_FIX_EARLYCON_MEM=
=3Dy=0A=0A#=0A# Non-8250 serial port support=0A#=0A# CONFIG_SERIAL_JSM is n=
ot set=0ACONFIG_UNIX98_PTYS=3Dy=0A# CONFIG_LEGACY_PTYS is not set=0ACONFIG_=
HVC_DRIVER=3Dy=0ACONFIG_VIRTIO_CONSOLE=3Dy=0A# CONFIG_IPMI_HANDLER is not s=
et=0A# CONFIG_HW_RANDOM is not set=0A# CONFIG_NVRAM is not set=0ACONFIG_RTC=
=3Dy=0A# CONFIG_R3964 is not set=0A# CONFIG_APPLICOM is not set=0A# CONFIG_=
SONYPI is not set=0A=0A#=0A# PCMCIA character devices=0A#=0A# CONFIG_SYNCLI=
NK_CS is not set=0A# CONFIG_CARDMAN_4000 is not set=0A# CONFIG_CARDMAN_4040=
 is not set=0A# CONFIG_MWAVE is not set=0A# CONFIG_PC8736x_GPIO is not set=
=0A# CONFIG_NSC_GPIO is not set=0A# CONFIG_CS5535_GPIO is not set=0A# CONFI=
G_RAW_DRIVER is not set=0ACONFIG_HPET=3Dy=0A# CONFIG_HPET_RTC_IRQ is not se=
t=0ACONFIG_HPET_MMAP=3Dy=0A# CONFIG_HANGCHECK_TIMER is not set=0A# CONFIG_T=
CG_TPM is not set=0A# CONFIG_TELCLOCK is not set=0ACONFIG_DEVPORT=3Dy=0A# C=
ONFIG_I2C is not set=0A=0A#=0A# SPI support=0A#=0A# CONFIG_SPI is not set=
=0A# CONFIG_SPI_MASTER is not set=0A# CONFIG_W1 is not set=0ACONFIG_POWER_S=
UPPLY=3Dy=0A# CONFIG_POWER_SUPPLY_DEBUG is not set=0A# CONFIG_PDA_POWER is =
not set=0A# CONFIG_BATTERY_DS2760 is not set=0A# CONFIG_HWMON is not set=0A=
# CONFIG_WATCHDOG is not set=0A=0A#=0A# Sonics Silicon Backplane=0A#=0ACONF=
IG_SSB_POSSIBLE=3Dy=0A# CONFIG_SSB is not set=0A=0A#=0A# Multifunction devi=
ce drivers=0A#=0A# CONFIG_MFD_SM501 is not set=0A=0A#=0A# Multimedia device=
s=0A#=0A# CONFIG_VIDEO_DEV is not set=0A# CONFIG_DVB_CORE is not set=0A# CO=
NFIG_DAB is not set=0A=0A#=0A# Graphics support=0A#=0ACONFIG_AGP=3Dy=0A# CO=
NFIG_AGP_ALI is not set=0A# CONFIG_AGP_ATI is not set=0A# CONFIG_AGP_AMD is=
 not set=0A# CONFIG_AGP_AMD64 is not set=0ACONFIG_AGP_INTEL=3Dy=0A# CONFIG_=
AGP_NVIDIA is not set=0A# CONFIG_AGP_SIS is not set=0A# CONFIG_AGP_SWORKS i=
s not set=0A# CONFIG_AGP_VIA is not set=0A# CONFIG_AGP_EFFICEON is not set=
=0ACONFIG_DRM=3Dm=0A# CONFIG_DRM_TDFX is not set=0A# CONFIG_DRM_R128 is not=
 set=0A# CONFIG_DRM_RADEON is not set=0A# CONFIG_DRM_I810 is not set=0A# CO=
NFIG_DRM_I830 is not set=0ACONFIG_DRM_I915=3Dm=0A# CONFIG_DRM_MGA is not se=
t=0A# CONFIG_DRM_SIS is not set=0A# CONFIG_DRM_VIA is not set=0A# CONFIG_DR=
M_SAVAGE is not set=0A# CONFIG_VGASTATE is not set=0ACONFIG_VIDEO_OUTPUT_CO=
NTROL=3Dm=0A# CONFIG_FB is not set=0A# CONFIG_BACKLIGHT_LCD_SUPPORT is not =
set=0A=0A#=0A# Display device support=0A#=0A# CONFIG_DISPLAY_SUPPORT is not=
 set=0A=0A#=0A# Console display driver support=0A#=0ACONFIG_VGA_CONSOLE=3Dy=
=0A# CONFIG_VGACON_SOFT_SCROLLBACK is not set=0ACONFIG_VIDEO_SELECT=3Dy=0AC=
ONFIG_DUMMY_CONSOLE=3Dy=0A=0A#=0A# Sound=0A#=0ACONFIG_SOUND=3Dm=0A=0A#=0A# =
Advanced Linux Sound Architecture=0A#=0ACONFIG_SND=3Dm=0ACONFIG_SND_TIMER=
=3Dm=0ACONFIG_SND_PCM=3Dm=0ACONFIG_SND_HWDEP=3Dm=0A# CONFIG_SND_SEQUENCER i=
s not set=0ACONFIG_SND_OSSEMUL=3Dy=0ACONFIG_SND_MIXER_OSS=3Dm=0ACONFIG_SND_=
PCM_OSS=3Dm=0ACONFIG_SND_PCM_OSS_PLUGINS=3Dy=0A# CONFIG_SND_RTCTIMER is not=
 set=0A# CONFIG_SND_DYNAMIC_MINORS is not set=0ACONFIG_SND_SUPPORT_OLD_API=
=3Dy=0ACONFIG_SND_VERBOSE_PROCFS=3Dy=0ACONFIG_SND_VERBOSE_PRINTK=3Dy=0A# CO=
NFIG_SND_DEBUG is not set=0A=0A#=0A# Generic devices=0A#=0A# CONFIG_SND_DUM=
MY is not set=0A# CONFIG_SND_MTPAV is not set=0A# CONFIG_SND_SERIAL_U16550 =
is not set=0A# CONFIG_SND_MPU401 is not set=0A=0A#=0A# PCI devices=0A#=0A# =
CONFIG_SND_AD1889 is not set=0A# CONFIG_SND_ALS300 is not set=0A# CONFIG_SN=
D_ALS4000 is not set=0A# CONFIG_SND_ALI5451 is not set=0A# CONFIG_SND_ATIIX=
P is not set=0A# CONFIG_SND_ATIIXP_MODEM is not set=0A# CONFIG_SND_AU8810 i=
s not set=0A# CONFIG_SND_AU8820 is not set=0A# CONFIG_SND_AU8830 is not set=
=0A# CONFIG_SND_AZT3328 is not set=0A# CONFIG_SND_BT87X is not set=0A# CONF=
IG_SND_CA0106 is not set=0A# CONFIG_SND_CMIPCI is not set=0A# CONFIG_SND_CS=
4281 is not set=0A# CONFIG_SND_CS46XX is not set=0A# CONFIG_SND_CS5530 is n=
ot set=0A# CONFIG_SND_CS5535AUDIO is not set=0A# CONFIG_SND_DARLA20 is not =
set=0A# CONFIG_SND_GINA20 is not set=0A# CONFIG_SND_LAYLA20 is not set=0A# =
CONFIG_SND_DARLA24 is not set=0A# CONFIG_SND_GINA24 is not set=0A# CONFIG_S=
ND_LAYLA24 is not set=0A# CONFIG_SND_MONA is not set=0A# CONFIG_SND_MIA is =
not set=0A# CONFIG_SND_ECHO3G is not set=0A# CONFIG_SND_INDIGO is not set=
=0A# CONFIG_SND_INDIGOIO is not set=0A# CONFIG_SND_INDIGODJ is not set=0A# =
CONFIG_SND_EMU10K1 is not set=0A# CONFIG_SND_EMU10K1X is not set=0A# CONFIG=
_SND_ENS1370 is not set=0A# CONFIG_SND_ENS1371 is not set=0A# CONFIG_SND_ES=
1938 is not set=0A# CONFIG_SND_ES1968 is not set=0A# CONFIG_SND_FM801 is no=
t set=0ACONFIG_SND_HDA_INTEL=3Dm=0ACONFIG_SND_HDA_HWDEP=3Dy=0ACONFIG_SND_HD=
A_CODEC_REALTEK=3Dy=0ACONFIG_SND_HDA_CODEC_ANALOG=3Dy=0ACONFIG_SND_HDA_CODE=
C_SIGMATEL=3Dy=0ACONFIG_SND_HDA_CODEC_VIA=3Dy=0ACONFIG_SND_HDA_CODEC_ATIHDM=
I=3Dy=0ACONFIG_SND_HDA_CODEC_CONEXANT=3Dy=0ACONFIG_SND_HDA_CODEC_CMEDIA=3Dy=
=0ACONFIG_SND_HDA_CODEC_SI3054=3Dy=0ACONFIG_SND_HDA_GENERIC=3Dy=0ACONFIG_SN=
D_HDA_POWER_SAVE=3Dy=0ACONFIG_SND_HDA_POWER_SAVE_DEFAULT=3D5=0A# CONFIG_SND=
_HDSP is not set=0A# CONFIG_SND_HDSPM is not set=0A# CONFIG_SND_ICE1712 is =
not set=0A# CONFIG_SND_ICE1724 is not set=0A# CONFIG_SND_INTEL8X0 is not se=
t=0A# CONFIG_SND_INTEL8X0M is not set=0A# CONFIG_SND_KORG1212 is not set=0A=
# CONFIG_SND_MAESTRO3 is not set=0A# CONFIG_SND_MIXART is not set=0A# CONFI=
G_SND_NM256 is not set=0A# CONFIG_SND_PCXHR is not set=0A# CONFIG_SND_RIPTI=
DE is not set=0A# CONFIG_SND_RME32 is not set=0A# CONFIG_SND_RME96 is not s=
et=0A# CONFIG_SND_RME9652 is not set=0A# CONFIG_SND_SONICVIBES is not set=
=0A# CONFIG_SND_TRIDENT is not set=0A# CONFIG_SND_VIA82XX is not set=0A# CO=
NFIG_SND_VIA82XX_MODEM is not set=0A# CONFIG_SND_VX222 is not set=0A# CONFI=
G_SND_YMFPCI is not set=0A=0A#=0A# USB devices=0A#=0A# CONFIG_SND_USB_AUDIO=
 is not set=0A# CONFIG_SND_USB_USX2Y is not set=0A# CONFIG_SND_USB_CAIAQ is=
 not set=0A=0A#=0A# PCMCIA devices=0A#=0A# CONFIG_SND_VXPOCKET is not set=
=0A# CONFIG_SND_PDAUDIOCF is not set=0A=0A#=0A# System on Chip audio suppor=
t=0A#=0A# CONFIG_SND_SOC is not set=0A=0A#=0A# SoC Audio support for SuperH=
=0A#=0A=0A#=0A# Open Sound System=0A#=0A# CONFIG_SOUND_PRIME is not set=0AC=
ONFIG_HID_SUPPORT=3Dy=0ACONFIG_HID=3Dy=0A# CONFIG_HID_DEBUG is not set=0A# =
CONFIG_HIDRAW is not set=0A=0A#=0A# USB Input Devices=0A#=0ACONFIG_USB_HID=
=3Dm=0A# CONFIG_USB_HIDINPUT_POWERBOOK is not set=0A# CONFIG_HID_FF is not =
set=0ACONFIG_USB_HIDDEV=3Dy=0A=0A#=0A# USB HID Boot Protocol drivers=0A#=0A=
# CONFIG_USB_KBD is not set=0A# CONFIG_USB_MOUSE is not set=0ACONFIG_USB_SU=
PPORT=3Dy=0ACONFIG_USB_ARCH_HAS_HCD=3Dy=0ACONFIG_USB_ARCH_HAS_OHCI=3Dy=0ACO=
NFIG_USB_ARCH_HAS_EHCI=3Dy=0ACONFIG_USB=3Dm=0A# CONFIG_USB_DEBUG is not set=
=0A=0A#=0A# Miscellaneous USB options=0A#=0ACONFIG_USB_DEVICEFS=3Dy=0A# CON=
FIG_USB_DEVICE_CLASS is not set=0A# CONFIG_USB_DYNAMIC_MINORS is not set=0A=
CONFIG_USB_SUSPEND=3Dy=0A# CONFIG_USB_PERSIST is not set=0A# CONFIG_USB_OTG=
 is not set=0A=0A#=0A# USB Host Controller Drivers=0A#=0ACONFIG_USB_EHCI_HC=
D=3Dm=0ACONFIG_USB_EHCI_SPLIT_ISO=3Dy=0ACONFIG_USB_EHCI_ROOT_HUB_TT=3Dy=0A#=
 CONFIG_USB_EHCI_TT_NEWSCHED is not set=0A# CONFIG_USB_ISP116X_HCD is not s=
et=0A# CONFIG_USB_OHCI_HCD is not set=0ACONFIG_USB_UHCI_HCD=3Dm=0A# CONFIG_=
USB_SL811_HCD is not set=0A# CONFIG_USB_R8A66597_HCD is not set=0A=0A#=0A# =
USB Device Class drivers=0A#=0A# CONFIG_USB_ACM is not set=0A# CONFIG_USB_P=
RINTER is not set=0A=0A#=0A# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk=
 support'=0A#=0A=0A#=0A# may also be needed; see USB_STORAGE Help for more =
information=0A#=0ACONFIG_USB_STORAGE=3Dm=0A# CONFIG_USB_STORAGE_DEBUG is no=
t set=0A# CONFIG_USB_STORAGE_DATAFAB is not set=0A# CONFIG_USB_STORAGE_FREE=
COM is not set=0A# CONFIG_USB_STORAGE_ISD200 is not set=0A# CONFIG_USB_STOR=
AGE_DPCM is not set=0A# CONFIG_USB_STORAGE_USBAT is not set=0A# CONFIG_USB_=
STORAGE_SDDR09 is not set=0A# CONFIG_USB_STORAGE_SDDR55 is not set=0A# CONF=
IG_USB_STORAGE_JUMPSHOT is not set=0A# CONFIG_USB_STORAGE_ALAUDA is not set=
=0A# CONFIG_USB_STORAGE_KARMA is not set=0A# CONFIG_USB_LIBUSUAL is not set=
=0A=0A#=0A# USB Imaging devices=0A#=0A# CONFIG_USB_MDC800 is not set=0A# CO=
NFIG_USB_MICROTEK is not set=0ACONFIG_USB_MON=3Dy=0A=0A#=0A# USB port drive=
rs=0A#=0A=0A#=0A# USB Serial Converter support=0A#=0A# CONFIG_USB_SERIAL is=
 not set=0A=0A#=0A# USB Miscellaneous drivers=0A#=0A# CONFIG_USB_EMI62 is n=
ot set=0A# CONFIG_USB_EMI26 is not set=0A# CONFIG_USB_ADUTUX is not set=0A#=
 CONFIG_USB_AUERSWALD is not set=0A# CONFIG_USB_RIO500 is not set=0A# CONFI=
G_USB_LEGOTOWER is not set=0A# CONFIG_USB_LCD is not set=0A# CONFIG_USB_BER=
RY_CHARGE is not set=0A# CONFIG_USB_LED is not set=0A# CONFIG_USB_CYPRESS_C=
Y7C63 is not set=0A# CONFIG_USB_CYTHERM is not set=0A# CONFIG_USB_PHIDGET i=
s not set=0A# CONFIG_USB_IDMOUSE is not set=0A# CONFIG_USB_FTDI_ELAN is not=
 set=0A# CONFIG_USB_APPLEDISPLAY is not set=0A# CONFIG_USB_SISUSBVGA is not=
 set=0A# CONFIG_USB_LD is not set=0A# CONFIG_USB_TRANCEVIBRATOR is not set=
=0A# CONFIG_USB_IOWARRIOR is not set=0A# CONFIG_USB_TEST is not set=0A=0A#=
=0A# USB DSL modem support=0A#=0A=0A#=0A# USB Gadget Support=0A#=0A# CONFIG=
_USB_GADGET is not set=0A# CONFIG_MMC is not set=0A# CONFIG_NEW_LEDS is not=
 set=0A# CONFIG_INFINIBAND is not set=0A# CONFIG_EDAC is not set=0A# CONFIG=
_RTC_CLASS is not set=0A# CONFIG_DMADEVICES is not set=0ACONFIG_VIRTUALIZAT=
ION=3Dy=0A# CONFIG_KVM is not set=0ACONFIG_LGUEST=3Dm=0A=0A#=0A# Userspace =
I/O=0A#=0A# CONFIG_UIO is not set=0ACONFIG_VIRTIO=3Dy=0ACONFIG_VIRTIO_RING=
=3Dy=0A=0A#=0A# Firmware Drivers=0A#=0A# CONFIG_EDD is not set=0A# CONFIG_D=
ELL_RBU is not set=0A# CONFIG_DCDBAS is not set=0ACONFIG_DMIID=3Dy=0A=0A#=
=0A# File systems=0A#=0ACONFIG_EXT2_FS=3Dy=0A# CONFIG_EXT2_FS_XATTR is not =
set=0A# CONFIG_EXT2_FS_XIP is not set=0ACONFIG_EXT3_FS=3Dm=0A# CONFIG_EXT3_=
FS_XATTR is not set=0A# CONFIG_EXT4DEV_FS is not set=0ACONFIG_JBD=3Dm=0A# C=
ONFIG_JBD_DEBUG is not set=0A# CONFIG_REISERFS_FS is not set=0A# CONFIG_JFS=
_FS is not set=0ACONFIG_FS_POSIX_ACL=3Dy=0ACONFIG_XFS_FS=3Dm=0A# CONFIG_XFS=
_QUOTA is not set=0A# CONFIG_XFS_SECURITY is not set=0A# CONFIG_XFS_POSIX_A=
CL is not set=0A# CONFIG_XFS_RT is not set=0A# CONFIG_GFS2_FS is not set=0A=
# CONFIG_OCFS2_FS is not set=0A# CONFIG_MINIX_FS is not set=0A# CONFIG_ROMF=
S_FS is not set=0ACONFIG_INOTIFY=3Dy=0ACONFIG_INOTIFY_USER=3Dy=0A# CONFIG_Q=
UOTA is not set=0ACONFIG_DNOTIFY=3Dy=0A# CONFIG_AUTOFS_FS is not set=0A# CO=
NFIG_AUTOFS4_FS is not set=0ACONFIG_FUSE_FS=3Dm=0A=0A#=0A# CD-ROM/DVD Files=
ystems=0A#=0ACONFIG_ISO9660_FS=3Dm=0ACONFIG_JOLIET=3Dy=0ACONFIG_ZISOFS=3Dy=
=0ACONFIG_UDF_FS=3Dm=0ACONFIG_UDF_NLS=3Dy=0A=0A#=0A# DOS/FAT/NT Filesystems=
=0A#=0ACONFIG_FAT_FS=3Dm=0ACONFIG_MSDOS_FS=3Dm=0ACONFIG_VFAT_FS=3Dm=0ACONFI=
G_FAT_DEFAULT_CODEPAGE=3D437=0ACONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"=
=0A# CONFIG_NTFS_FS is not set=0A=0A#=0A# Pseudo filesystems=0A#=0ACONFIG_P=
ROC_FS=3Dy=0ACONFIG_PROC_KCORE=3Dy=0ACONFIG_PROC_SYSCTL=3Dy=0ACONFIG_SYSFS=
=3Dy=0ACONFIG_TMPFS=3Dy=0A# CONFIG_TMPFS_POSIX_ACL is not set=0A# CONFIG_HU=
GETLBFS is not set=0A# CONFIG_HUGETLB_PAGE is not set=0A# CONFIG_CONFIGFS_F=
S is not set=0A=0A#=0A# Miscellaneous filesystems=0A#=0A# CONFIG_ADFS_FS is=
 not set=0A# CONFIG_AFFS_FS is not set=0A# CONFIG_HFS_FS is not set=0A# CON=
FIG_HFSPLUS_FS is not set=0A# CONFIG_BEFS_FS is not set=0A# CONFIG_BFS_FS i=
s not set=0A# CONFIG_EFS_FS is not set=0A# CONFIG_CRAMFS is not set=0A# CON=
FIG_VXFS_FS is not set=0A# CONFIG_HPFS_FS is not set=0A# CONFIG_QNX4FS_FS i=
s not set=0A# CONFIG_SYSV_FS is not set=0A# CONFIG_UFS_FS is not set=0ACONF=
IG_NETWORK_FILESYSTEMS=3Dy=0ACONFIG_NFS_FS=3Dm=0ACONFIG_NFS_V3=3Dy=0ACONFIG=
_NFS_V3_ACL=3Dy=0ACONFIG_NFS_V4=3Dy=0ACONFIG_NFS_DIRECTIO=3Dy=0A# CONFIG_NF=
SD is not set=0ACONFIG_LOCKD=3Dm=0ACONFIG_LOCKD_V4=3Dy=0ACONFIG_NFS_ACL_SUP=
PORT=3Dm=0ACONFIG_NFS_COMMON=3Dy=0ACONFIG_SUNRPC=3Dm=0ACONFIG_SUNRPC_GSS=3D=
m=0A# CONFIG_SUNRPC_BIND34 is not set=0ACONFIG_RPCSEC_GSS_KRB5=3Dm=0A# CONF=
IG_RPCSEC_GSS_SPKM3 is not set=0A# CONFIG_SMB_FS is not set=0A# CONFIG_CIFS=
 is not set=0A# CONFIG_NCP_FS is not set=0A# CONFIG_CODA_FS is not set=0A# =
CONFIG_AFS_FS is not set=0A=0A#=0A# Partition Types=0A#=0A# CONFIG_PARTITIO=
N_ADVANCED is not set=0ACONFIG_MSDOS_PARTITION=3Dy=0ACONFIG_NLS=3Dy=0ACONFI=
G_NLS_DEFAULT=3D"utf8"=0ACONFIG_NLS_CODEPAGE_437=3Dm=0ACONFIG_NLS_CODEPAGE_=
737=3Dm=0ACONFIG_NLS_CODEPAGE_775=3Dm=0ACONFIG_NLS_CODEPAGE_850=3Dm=0ACONFI=
G_NLS_CODEPAGE_852=3Dm=0ACONFIG_NLS_CODEPAGE_855=3Dm=0ACONFIG_NLS_CODEPAGE_=
857=3Dm=0ACONFIG_NLS_CODEPAGE_860=3Dm=0ACONFIG_NLS_CODEPAGE_861=3Dm=0ACONFI=
G_NLS_CODEPAGE_862=3Dm=0ACONFIG_NLS_CODEPAGE_863=3Dm=0ACONFIG_NLS_CODEPAGE_=
864=3Dm=0ACONFIG_NLS_CODEPAGE_865=3Dm=0ACONFIG_NLS_CODEPAGE_866=3Dm=0ACONFI=
G_NLS_CODEPAGE_869=3Dm=0ACONFIG_NLS_CODEPAGE_936=3Dm=0ACONFIG_NLS_CODEPAGE_=
950=3Dm=0ACONFIG_NLS_CODEPAGE_932=3Dm=0ACONFIG_NLS_CODEPAGE_949=3Dm=0ACONFI=
G_NLS_CODEPAGE_874=3Dm=0ACONFIG_NLS_ISO8859_8=3Dm=0ACONFIG_NLS_CODEPAGE_125=
0=3Dm=0ACONFIG_NLS_CODEPAGE_1251=3Dm=0ACONFIG_NLS_ASCII=3Dm=0ACONFIG_NLS_IS=
O8859_1=3Dm=0ACONFIG_NLS_ISO8859_2=3Dm=0ACONFIG_NLS_ISO8859_3=3Dm=0ACONFIG_=
NLS_ISO8859_4=3Dm=0ACONFIG_NLS_ISO8859_5=3Dm=0ACONFIG_NLS_ISO8859_6=3Dm=0AC=
ONFIG_NLS_ISO8859_7=3Dm=0ACONFIG_NLS_ISO8859_9=3Dm=0ACONFIG_NLS_ISO8859_13=
=3Dm=0ACONFIG_NLS_ISO8859_14=3Dm=0ACONFIG_NLS_ISO8859_15=3Dm=0ACONFIG_NLS_K=
OI8_R=3Dm=0ACONFIG_NLS_KOI8_U=3Dm=0ACONFIG_NLS_UTF8=3Dm=0A# CONFIG_DLM is n=
ot set=0ACONFIG_INSTRUMENTATION=3Dy=0ACONFIG_PROFILING=3Dy=0ACONFIG_OPROFIL=
E=3Dm=0A# CONFIG_KPROBES is not set=0A# CONFIG_MARKERS is not set=0A=0A#=0A=
# Kernel hacking=0A#=0ACONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy=0A# CONFIG_PRINTK_=
TIME is not set=0A# CONFIG_ENABLE_WARN_DEPRECATED is not set=0A# CONFIG_ENA=
BLE_MUST_CHECK is not set=0ACONFIG_MAGIC_SYSRQ=3Dy=0ACONFIG_UNUSED_SYMBOLS=
=3Dy=0ACONFIG_DEBUG_FS=3Dy=0A# CONFIG_HEADERS_CHECK is not set=0ACONFIG_DEB=
UG_KERNEL=3Dy=0A# CONFIG_DEBUG_SHIRQ is not set=0A# CONFIG_DETECT_SOFTLOCKU=
P is not set=0ACONFIG_SCHED_DEBUG=3Dy=0ACONFIG_SCHEDSTATS=3Dy=0ACONFIG_TIME=
R_STATS=3Dy=0A# CONFIG_DEBUG_SLAB is not set=0A# CONFIG_DEBUG_RT_MUTEXES is=
 not set=0A# CONFIG_RT_MUTEX_TESTER is not set=0ACONFIG_DEBUG_SPINLOCK=3Dy=
=0ACONFIG_DEBUG_MUTEXES=3Dy=0ACONFIG_DEBUG_LOCK_ALLOC=3Dy=0ACONFIG_PROVE_LO=
CKING=3Dy=0ACONFIG_LOCKDEP=3Dy=0A# CONFIG_LOCK_STAT is not set=0A# CONFIG_D=
EBUG_LOCKDEP is not set=0ACONFIG_TRACE_IRQFLAGS=3Dy=0ACONFIG_DEBUG_SPINLOCK=
_SLEEP=3Dy=0A# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set=0ACONFIG_STACK=
TRACE=3Dy=0A# CONFIG_DEBUG_KOBJECT is not set=0A# CONFIG_DEBUG_BUGVERBOSE i=
s not set=0ACONFIG_DEBUG_INFO=3Dy=0A# CONFIG_DEBUG_VM is not set=0A# CONFIG=
_DEBUG_LIST is not set=0A# CONFIG_DEBUG_SG is not set=0ACONFIG_FRAME_POINTE=
R=3Dy=0ACONFIG_FORCED_INLINING=3Dy=0A# CONFIG_BOOT_PRINTK_DELAY is not set=
=0A# CONFIG_RCU_TORTURE_TEST is not set=0A# CONFIG_FAULT_INJECTION is not s=
et=0ACONFIG_LATENCYTOP=3Dy=0A# CONFIG_SAMPLES is not set=0ACONFIG_EARLY_PRI=
NTK=3Dy=0ACONFIG_DEBUG_STACKOVERFLOW=3Dy=0A# CONFIG_DEBUG_STACK_USAGE is no=
t set=0A# CONFIG_DEBUG_PAGEALLOC is not set=0ACONFIG_DEBUG_RODATA=3Dy=0ACON=
FIG_4KSTACKS=3Dy=0ACONFIG_X86_FIND_SMP_CONFIG=3Dy=0ACONFIG_X86_MPPARSE=3Dy=
=0ACONFIG_DOUBLEFAULT=3Dy=0A=0A#=0A# Security options=0A#=0A# CONFIG_KEYS i=
s not set=0A# CONFIG_SECURITY is not set=0A# CONFIG_SECURITY_FILE_CAPABILIT=
IES is not set=0ACONFIG_CRYPTO=3Dy=0ACONFIG_CRYPTO_ALGAPI=3Dy=0ACONFIG_CRYP=
TO_BLKCIPHER=3Dy=0A# CONFIG_CRYPTO_SEQIV is not set=0ACONFIG_CRYPTO_MANAGER=
=3Dy=0A# CONFIG_CRYPTO_HMAC is not set=0A# CONFIG_CRYPTO_XCBC is not set=0A=
# CONFIG_CRYPTO_NULL is not set=0A# CONFIG_CRYPTO_MD4 is not set=0ACONFIG_C=
RYPTO_MD5=3Dy=0ACONFIG_CRYPTO_SHA1=3Dm=0ACONFIG_CRYPTO_SHA256=3Dm=0A# CONFI=
G_CRYPTO_SHA512 is not set=0A# CONFIG_CRYPTO_WP512 is not set=0A# CONFIG_CR=
YPTO_TGR192 is not set=0A# CONFIG_CRYPTO_GF128MUL is not set=0ACONFIG_CRYPT=
O_ECB=3Dm=0ACONFIG_CRYPTO_CBC=3Dy=0A# CONFIG_CRYPTO_PCBC is not set=0A# CON=
FIG_CRYPTO_LRW is not set=0A# CONFIG_CRYPTO_XTS is not set=0A# CONFIG_CRYPT=
O_CTR is not set=0A# CONFIG_CRYPTO_GCM is not set=0A# CONFIG_CRYPTO_CCM is =
not set=0A# CONFIG_CRYPTO_CRYPTD is not set=0ACONFIG_CRYPTO_DES=3Dy=0A# CON=
FIG_CRYPTO_FCRYPT is not set=0A# CONFIG_CRYPTO_BLOWFISH is not set=0A# CONF=
IG_CRYPTO_TWOFISH is not set=0A# CONFIG_CRYPTO_TWOFISH_586 is not set=0A# C=
ONFIG_CRYPTO_SERPENT is not set=0ACONFIG_CRYPTO_AES=3Dm=0A# CONFIG_CRYPTO_A=
ES_586 is not set=0A# CONFIG_CRYPTO_CAST5 is not set=0A# CONFIG_CRYPTO_CAST=
6 is not set=0A# CONFIG_CRYPTO_TEA is not set=0ACONFIG_CRYPTO_ARC4=3Dm=0A# =
CONFIG_CRYPTO_KHAZAD is not set=0A# CONFIG_CRYPTO_ANUBIS is not set=0A# CON=
FIG_CRYPTO_SEED is not set=0A# CONFIG_CRYPTO_SALSA20 is not set=0A# CONFIG_=
CRYPTO_SALSA20_586 is not set=0A# CONFIG_CRYPTO_DEFLATE is not set=0A# CONF=
IG_CRYPTO_MICHAEL_MIC is not set=0ACONFIG_CRYPTO_CRC32C=3Dy=0A# CONFIG_CRYP=
TO_CAMELLIA is not set=0A# CONFIG_CRYPTO_TEST is not set=0A# CONFIG_CRYPTO_=
AUTHENC is not set=0A# CONFIG_CRYPTO_LZO is not set=0ACONFIG_CRYPTO_HW=3Dy=
=0A# CONFIG_CRYPTO_DEV_PADLOCK is not set=0A# CONFIG_CRYPTO_DEV_GEODE is no=
t set=0A# CONFIG_CRYPTO_DEV_HIFN_795X is not set=0A=0A#=0A# Library routine=
s=0A#=0ACONFIG_BITREVERSE=3Dy=0A# CONFIG_CRC_CCITT is not set=0A# CONFIG_CR=
C16 is not set=0A# CONFIG_CRC_ITU_T is not set=0ACONFIG_CRC32=3Dy=0A# CONFI=
G_CRC7 is not set=0ACONFIG_LIBCRC32C=3Dy=0ACONFIG_ZLIB_INFLATE=3Dm=0ACONFIG=
_PLIST=3Dy=0ACONFIG_HAS_IOMEM=3Dy=0ACONFIG_HAS_IOPORT=3Dy=0ACONFIG_HAS_DMA=
=3Dy=0A
--mYCpIKhGyMATD0i+--
