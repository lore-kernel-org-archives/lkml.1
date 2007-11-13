Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbXKMRS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbXKMRS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXKMRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:18:48 -0500
Received: from moci.net4u.de ([217.7.64.195]:38823 "EHLO moci.net4u.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbXKMRSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:18:46 -0500
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 12:18:45 EST
From: Ernst Herzberg <list-lkml@net4u.de>
To: linux-kernel@vger.kernel.org
Subject: [BUG] pcmcia serial_cs no interrupts
Date: Tue, 13 Nov 2007 17:55:25 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: earny@net4u.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200711131755.25246.list-lkml@net4u.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This pcmcia-card (UMTS Modem) only works if it shares his interrupt with
another device, eg an usb mice. Moving the mice increases the connection
speed, unplugging hangs the connection.

Tested with 2.6.24-rc2, it is not a regression... 2.6.23/22 - same problem.

Hardware: Thinkpad R60

google found some similar reports about this problem without a resolution:

http://ubuntuforums.org/showpost.php?p=1537086&postcount=10
http://linux.derkeiler.com/Mailing-Lists/Fedora/2005-03/6705.html

At the moment this card is my only way to reach the internet, but here in
the hospital i have a lot time to test patches;)

<earny>


------------

Socket 0:
  5.0V 16-bit PC Card
  Subdevice 0 (function 0) bound to driver "serial_cs"
  Subdevice 1 (function 1) bound to driver "serial_cs"

------------

Socket 0:
  product info: "Novatel Wireless", "Merlin UMTS Modem", "U630", ""
  manfid: 0x00a4, 0x0276
  function: 2 (serial)

------------

           CPU0       CPU1       
  0:     687950          0   IO-APIC-edge      timer
  1:       4701          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc
  9:     318526          0   IO-APIC-fasteoi   acpi
 12:       4138          0   IO-APIC-edge      i8042
 14:     111586          0   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 16:      72808          0   IO-APIC-fasteoi   yenta, uhci_hcd:usb1, serial
 17:        267          0   IO-APIC-fasteoi   HDA Intel, uhci_hcd:usb2, firewire_ohci
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:         59          0   IO-APIC-fasteoi   uhci_hcd:usb4, ehci_hcd:usb5
313:        479          0   PCI-MSI-edge      iwl3945
314:      14316          0   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:      33699     282108   Local timer interrupts
RES:      13468      34114   Rescheduling interrupts
CAL:         59        169   function call interrupts
TLB:       1204       1565   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

------------

Linux version 2.6.24-rc2 (root@rico) (gcc version 4.2.2 (Gentoo 4.2.2 p1.0)) #1 SMP PREEMPT Tue Nov 13 14:39:58 CET 2007
Command line: root=/dev/sda1 video=vesafb:mtrr:3 vga=838
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fed0000 (usable)
 BIOS-e820: 000000003fed0000 - 000000003fedf000 (ACPI data)
 BIOS-e820: 000000003fedf000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 261840) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F67B0, 0024 (r2 LENOVO)
ACPI: XSDT 3FED1533, 0084 (r1 LENOVO TP-7C        2190  LTP        0)
ACPI: FACP 3FED1600, 00F4 (r3 LENOVO TP-7C        2190 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 3FED195E, D3D4 (r1 LENOVO TP-7C        2190 MSFT  100000E)
ACPI: FACS 3FEF4000, 0040
ACPI: SSDT 3FED17B4, 01AA (r1 LENOVO TP-7C        2190 MSFT  100000E)
ACPI: ECDT 3FEDED32, 0052 (r1 LENOVO TP-7C        2190 LNVO        1)
ACPI: TCPA 3FEDED84, 0032 (r2 LENOVO TP-7C        2190 LNVO        1)
ACPI: APIC 3FEDEDB6, 0068 (r1 LENOVO TP-7C        2190 LNVO        1)
ACPI: MCFG 3FEDEE1E, 003C (r1 LENOVO TP-7C        2190 LNVO        1)
ACPI: HPET 3FEDEE5A, 0038 (r1 LENOVO TP-7C        2190 LNVO        1)
ACPI: BOOT 3FEDEFD8, 0028 (r1 LENOVO TP-7C        2190  LTP        1)
ACPI: SSDT 3FEF2655, 025F (r1 LENOVO TP-7C        2190 INTL 20050513)
ACPI: SSDT 3FEF28B4, 00A6 (r1 LENOVO TP-7C        2190 INTL 20050513)
ACPI: SSDT 3FEF295A, 04F7 (r1 LENOVO TP-7C        2190 INTL 20050513)
ACPI: SSDT 3FEF2E51, 01D8 (r1 LENOVO TP-7C        2190 INTL 20050513)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 261840) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   261840
On node 0 totalpages: 261743
  DMA zone: 56 pages used for memmap
  DMA zone: 1182 pages reserved
  DMA zone: 2761 pages, LIFO batch:0
  DMA32 zone: 3523 pages used for memmap
  DMA32 zone: 254221 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 32496 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256982
Kernel command line: root=/dev/sda1 video=vesafb:mtrr:3 vga=838
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
hpet clockevent registered
TSC calibrated against HPET
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1828.750 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
Memory: 1026048k/1047360k available (2885k kernel code, 20740k reserved, 1180k data, 228k init)
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 3661.51 BogoMIPS (lpj=7323022)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 10390620
Detected 10.390 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.53 BogoMIPS (lpj=7315072)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Brought up 2 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver 
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
ACPI: bus type pci registered
PCI: Using MMCONFIG at f0000000 - f3ffffff
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
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
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
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
DMAR:No DMAR devices found
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff has been reserved
system 00:00: iomem range 0xc4000-0xc7fff has been reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: ee000000-ee0fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: ee100000-ee1fffff
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
  MEM window: 50000000-53ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-cfff
  MEM window: e4300000-e7ffffff
  PREFETCH window: e0000000-e3ffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
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
vesafb: framebuffer at 0xd8000000, mapped to 0xffffc20004100000, using 11550k, total 16384k
vesafb: mode is 1400x1050x32, linelength=5632, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 175x65
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/virtual/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /devices/virtual/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Video Bus as /devices/virtual/input/input3
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/virtual/input/input4
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
ACPI: SSDT 3FEF1D36, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 3FEF1FFB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3FEF1C6E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 3FEF1F76, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (59 C)
ACPI: Thermal Zone [THM1] (59 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
intel_rng: FWH not detected
Linux agpgart interface v0.102
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
thinkpad_acpi: ThinkPad ACPI Extras v0.16
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7CETC9WW (2.19 ), EC 7CHT22WW-1.10
thinkpad_acpi: Lenovo ThinkPad R60
thinkpad_acpi: radio switch found; radios are enabled
input: ThinkPad Extra Buttons as /devices/virtual/input/input5
tg3.c:v3.85 (October 18, 2007)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: Tigon3 [partno(BCM95751m) rev 4201 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:16:d3:30:a3:c3
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
console [netcon0] enabled
netconsole: network logging started
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0xf
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee404400 port 0xee404500 irq 314
ata2: SATA max UDMA/133 abar m1024@0xee404400 port 0xee404580 irq 314
ata3: SATA max UDMA/133 abar m1024@0xee404400 port 0xee404600 irq 314
ata4: SATA max UDMA/133 abar m1024@0xee404400 port 0xee404680 irq 314
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: TOSHIBA MK1034GSX, AH201E, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1034GS AH20 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
ata5.00: ATAPI: HL-DT-ST DVDRAM GMA-4082N, CX08, max UDMA/33
ata5.00: configured for UDMA/33
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4082N CX08 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:202f]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:15:00.0, mfunc 0x01001b22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 16
Socket status: 30000411
pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
rtc_cmos: probe of 00:07 failed with error -16
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 23
EDAC MC: Ver: 2.1.0 Nov 13 2007
cpuidle: using governor ladder
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff 0xe4e70000-0xe523ffff 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
pcmcia: registering new device pcmcia0.0
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x3f8 align 0x8
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x2f8 align 0x8
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x3e8 align 0x8
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x2e8 align 0x8
0.0: ttyS0 at I/O 0x9100 (irq = 16) is a 16550A
pcmcia: registering new device pcmcia0.1
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x2f8 align 0x8
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x3f8 align 0x8
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x2e8 align 0x8
pcmcia_resource: pcmcia_socket0: odd IO request: base 0x3e8 align 0x8
0.1: ttyS1 at I/O 0x9108 (irq = 0) is a 16550A
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
registered taskstats version 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Clocksource tsc unstable (delta = -368518838 ns)
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 228k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
hda_intel: probe_mask set to 0x1 for device 17aa:2010
PCI: Setting latency timer of device 0000:00:1b.0 to 64
USB Universal Host Controller Interface driver v3.0
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.1.17kds
iwl3945: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
usb 1-1: configuration #1 chosen from 1 choice
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
input: Microsoft Microsoft Wireless Optical Mouse® 1.00 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0/input/input9
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee404000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse® 1.00] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
PCI: Enabling device 0000:15:00.1 (0000 -> 0002)
ACPI: PCI Interrupt 0000:15:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:15:00.1 to 64
udev: renamed network interface wlan0 to ipw
firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI version 1.10
usb 1-1: USB disconnect, address 2
firewire_core: created new fw device fw0 (0 config rom retries, S400)
usb 1-1: new low speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
input: Microsoft Microsoft Wireless Optical Mouse® 1.00 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0/input/input10
input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse® 1.00] on usb-0000:00:1d.0-1
usb 4-2: USB disconnect, address 2
usb 4-2: new full speed USB device using uhci_hcd and address 3
usb 4-2: configuration #1 chosen from 1 choice
thinkpad_ec: thinkpad_ec 0.32 loaded.
tp_smapi 0.32 loading...
tp_smapi successfully loaded (smapi_port=0xb2).
Adding 4883752k swap on /dev/sda2.  Priority:-1 extents:1 across:4883752k
ipw: Initial auth_alg=0
ipw: authenticate with AP 00:18:84:18:7f:05
ipw: RX authentication from 00:18:84:18:7f:05 (alg=0 transaction=2 status=0)
ipw: authenticated
ipw: associate with AP 00:18:84:18:7f:05
ipw: RX AssocResp from 00:18:84:18:7f:05 (capab=0x421 status=0 aid=1)
ipw: associated
ipw: switched to short barker preamble (BSSID=00:18:84:18:7f:05)
ipw: WMM queue=2 aci=0 acm=0 aifs=2 cWmin=7 cWmax=1023 burst=20
ipw: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
ipw: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
ipw: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
ipw: Initial auth_alg=0
ipw: authenticate with AP 00:18:84:18:7f:05
ipw: RX authentication from 00:18:84:18:7f:05 (alg=0 transaction=2 status=0)
ipw: authenticated
ipw: associate with AP 00:18:84:18:7f:05
ipw: Initial auth_alg=0
ipw: authenticate with AP 00:18:84:18:7f:05
ipw: association frame received from 00:18:84:18:7f:05, but not in associate state - ignored
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
PPP generic driver version 2.4.2
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
PPP BSD Compression module registered
PPP Deflate Compression module registered
