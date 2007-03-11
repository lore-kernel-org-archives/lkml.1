Return-Path: <linux-kernel-owner+w=401wt.eu-S933985AbXCKSfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbXCKSfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933983AbXCKSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:35:34 -0400
Received: from tag.witbe.net ([81.88.96.48]:40973 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979AbXCKSfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:35:31 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'Tejun Heo'" <htejun@gmail.com>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sun, 11 Mar 2007 19:34:58 +0100
Organization: AS2917.net
Message-ID: <017f01c7640b$fbcafab0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0180_01C76414.5D8F62B0"
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <Pine.LNX.4.64.0703110931080.9690@woody.linux-foundation.org>
Thread-Index: Acdj/HF4LoR3SbeASZO6d4BenJXMGAADldzQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0180_01C76414.5D8F62B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

>  do I understand correctly that the *only* difference between 
> the working 
> setup is that you applied (by hand) the libata patch that 
> Jeff sent out?
> 
> So plain 2.6.21-rc2 works fine, but with the patch applied, 
> you get no 
> interrupts on the DVD drive?

Nope... I tried several patches from Tejun, and also some that Jeff posted
to linux-ide, but no luck. The only way to have this DVD-RW working is to
use irqpoll on the command line...

Sorry to have been unclear....

To complete, here are some more output from the machine : 
 - a dmesg without irqpoll,
 - a dmesg with irqpoll,
 - a copy of /proc/interrupts
6 [19:33] rol@riri:~> cat /proc/interrupts 
           CPU0       CPU1       
  0:     357022          0   IO-APIC-edge      timer
  1:          8          0   IO-APIC-edge      i8042
  4:         14          0   IO-APIC-edge      serial
  6:          5          0   IO-APIC-edge      floppy
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        129          0   IO-APIC-edge      i8042
 14:       7639          0   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 16:          0          0   IO-APIC-fasteoi   libata
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:        204          0   IO-APIC-fasteoi   uhci_hcd:usb5, HDA Intel
 20:        107          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:          3          0   IO-APIC-fasteoi   ohci1394
504:       8243          0   PCI-MSI-edge      libata
505:          1          0   PCI-MSI-edge      eth1
506:        386          0   PCI-MSI-edge      eth0
NMI:        771        531 
LOC:     569318     578684 
ERR:          0

Regards,
Paul

------=_NextPart_000_0180_01C76414.5D8F62B0
Content-Type: application/octet-stream;
	name="dmesg-2.6.21-rc2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-2.6.21-rc2"

Linux version 2.6.21-rc2 (root@riri.as2917.net) (gcc version 4.0.3 =
(Ubuntu 4.0.3-1ubuntu5)) #4 SMP PREEMPT Sun Mar 4 19:52:39 CET 2007=0A=
Command line: root=3D/dev/sde1 ro ata2=3Dnoprobe console=3DttyS0,9600 =
console=3Dtty0 vga=3Dextended=0A=
BIOS-provided physical RAM map:=0A=
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)=0A=
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)=0A=
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)=0A=
 BIOS-e820: 0000000000100000 - 00000000c7f80000 (usable)=0A=
 BIOS-e820: 00000000c7f80000 - 00000000c7f8e000 (ACPI data)=0A=
 BIOS-e820: 00000000c7f8e000 - 00000000c7fe0000 (ACPI NVS)=0A=
 BIOS-e820: 00000000c7fe0000 - 00000000c8000000 (reserved)=0A=
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)=0A=
Entering add_active_range(0, 0, 159) 0 entries of 256 used=0A=
Entering add_active_range(0, 256, 819072) 1 entries of 256 used=0A=
end_pfn_map =3D 1048576=0A=
DMI 2.4 present.=0A=
ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)=0A=
ACPI: XSDT C7F80100, 005C (r1 A_M_I_ OEMXSDT  12000608 MSFT       97)=0A=
ACPI: FACP C7F80290, 00F4 (r3 A_M_I_ OEMFACP  12000608 MSFT       97)=0A=
ACPI: DSDT C7F80410, 8FC4 (r1  A0543 A0543000        0 INTL 20060113)=0A=
ACPI: FACS C7F8E000, 0040=0A=
ACPI: APIC C7F80390, 0080 (r1 A_M_I_ OEMAPIC  12000608 MSFT       97)=0A=
ACPI: OEMB C7F8E040, 0066 (r1 A_M_I_ AMI_OEM  12000608 MSFT       97)=0A=
ACPI: HPET C7F893E0, 0038 (r1 A_M_I_ OEMHPET  12000608 MSFT       97)=0A=
ACPI: MCFG C7F89420, 003C (r1 A_M_I_ OEMMCFG  12000608 MSFT       97)=0A=
ACPI: SSDT C7F8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)=0A=
ACPI: SSDT C7F8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)=0A=
Entering add_active_range(0, 0, 159) 0 entries of 256 used=0A=
Entering add_active_range(0, 256, 819072) 1 entries of 256 used=0A=
Zone PFN ranges:=0A=
  DMA             0 ->     4096=0A=
  DMA32        4096 ->  1048576=0A=
  Normal    1048576 ->  1048576=0A=
early_node_map[2] active PFN ranges=0A=
    0:        0 ->      159=0A=
    0:      256 ->   819072=0A=
On node 0 totalpages: 818975=0A=
  DMA zone: 56 pages used for memmap=0A=
  DMA zone: 1986 pages reserved=0A=
  DMA zone: 1957 pages, LIFO batch:0=0A=
  DMA32 zone: 11142 pages used for memmap=0A=
  DMA32 zone: 803834 pages, LIFO batch:31=0A=
  Normal zone: 0 pages used for memmap=0A=
ACPI: PM-Timer IO Port: 0x808=0A=
ACPI: Local APIC address 0xfee00000=0A=
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)=0A=
Processor #0 (Bootup-CPU)=0A=
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)=0A=
Processor #1=0A=
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)=0A=
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)=0A=
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])=0A=
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0A=
ACPI: IRQ0 used by override.=0A=
ACPI: IRQ2 used by override.=0A=
ACPI: IRQ9 used by override.=0A=
Setting APIC routing to flat=0A=
ACPI: HPET id: 0x8086a201 base: 0xfed00000=0A=
Using ACPI (MADT) for SMP configuration information=0A=
Nosave address range: 000000000009f000 - 00000000000a0000=0A=
Nosave address range: 00000000000a0000 - 00000000000e4000=0A=
Nosave address range: 00000000000e4000 - 0000000000100000=0A=
Allocating PCI resources starting at cc000000 (gap: c8000000:37b00000)=0A=
PERCPU: Allocating 34368 bytes of per cpu data=0A=
Built 1 zonelists.  Total pages: 805791=0A=
Kernel command line: root=3D/dev/sde1 ro ata2=3Dnoprobe =
console=3DttyS0,9600 console=3Dtty0 vga=3Dextended=0A=
Initializing CPU#0=0A=
PID hash table entries: 4096 (order: 12, 32768 bytes)=0A=
time.c: Detected 2400.083 MHz processor.=0A=
Console: colour VGA+ 80x50=0A=
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)=0A=
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)=0A=
Checking aperture...=0A=
Memory: 3216500k/3276288k available (4563k kernel code, 59172k reserved, =
2317k data, 296k init)=0A=
Calibrating delay using timer specific routine.. 4802.77 BogoMIPS =
(lpj=3D2401386)=0A=
Security Framework v1.0.0 initialized=0A=
Capability LSM initialized=0A=
Failure registering Root Plug module with the kernel=0A=
Failure registering Root Plug  module with primary security module.=0A=
Mount-cache hash table entries: 256=0A=
CPU: L1 I cache: 32K, L1 D cache: 32K=0A=
CPU: L2 cache: 4096K=0A=
using mwait in idle threads.=0A=
CPU: Physical Processor ID: 0=0A=
CPU: Processor Core ID: 0=0A=
CPU0: Thermal monitoring enabled (TM2)=0A=
Freeing SMP alternatives: 40k freed=0A=
ACPI: Core revision 20070126=0A=
Using local APIC timer interrupts.=0A=
result 10130463=0A=
Detected 10.130 MHz APIC timer.=0A=
Booting processor 1/2 APIC 0x1=0A=
Initializing CPU#1=0A=
Calibrating delay using timer specific routine.. 4800.35 BogoMIPS =
(lpj=3D2400179)=0A=
CPU: L1 I cache: 32K, L1 D cache: 32K=0A=
CPU: L2 cache: 4096K=0A=
CPU: Physical Processor ID: 0=0A=
CPU: Processor Core ID: 1=0A=
CPU1: Thermal monitoring enabled (TM2)=0A=
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06=0A=
checking TSC synchronization [CPU#0 -> CPU#1]: passed.=0A=
Brought up 2 CPUs=0A=
testing NMI watchdog ... OK.=0A=
migration_cost=3D21=0A=
NET: Registered protocol family 16=0A=
ACPI: bus type pci registered=0A=
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved=0A=
PCI: Not using MMCONFIG.=0A=
PCI: Using configuration type 1=0A=
ACPI: Interpreter enabled=0A=
ACPI: Using IOAPIC for interrupt routing=0A=
ACPI: PCI Root Bridge [PCI0] (0000:00)=0A=
PCI: Probing PCI hardware (bus 00)=0A=
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO=0A=
PCI quirk: region 0480-04bf claimed by ICH6 GPIO=0A=
Boot video device is 0000:06:00.0=0A=
PCI: Transparent bridge - 0000:00:1e.0=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]=0A=
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)=0A=
Linux Plug and Play Support v0.97 (c) Adam Belay=0A=
pnp: PnP ACPI init=0A=
pnp: PnP ACPI: found 16 devices=0A=
SCSI subsystem initialized=0A=
libata version 2.20 loaded.=0A=
usbcore: registered new interface driver usbfs=0A=
usbcore: registered new interface driver hub=0A=
usbcore: registered new device driver usb=0A=
PCI: Using ACPI for IRQ routing=0A=
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post =
a report=0A=
PCI: Cannot allocate resource region 2 of device 0000:02:00.0=0A=
PCI: Cannot allocate resource region 3 of device 0000:02:00.0=0A=
PCI-GART: No AMD northbridge found.=0A=
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0=0A=
hpet0: 3 64-bit timers, 14318180 Hz=0A=
pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved=0A=
pnp: 00:07: ioport range 0x290-0x297 has been reserved=0A=
pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved=0A=
pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved=0A=
pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved=0A=
pnp: 00:08: iomem range 0xffb00000-0xffbfffff has been reserved=0A=
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved=0A=
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved=0A=
pnp: 00:0e: iomem range 0xf0000000-0xf3ffffff has been reserved=0A=
pnp: 00:0f: iomem range 0x0-0x9ffff could not be reserved=0A=
pnp: 00:0f: iomem range 0xc0000-0xdffff has been reserved=0A=
pnp: 00:0f: iomem range 0xe0000-0xfffff could not be reserved=0A=
pnp: 00:0f: iomem range 0x100000-0xc7ffffff could not be reserved=0A=
ieee1394: Initialized config rom entry `ip1394'=0A=
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 21 (level, low) -> IRQ 21=0A=
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[21]  =
MMIO=3D[ff5ef800-ff5effff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]=0A=
PCI: Bridge: 0000:00:01.0=0A=
  IO window: c000-cfff=0A=
  MEM window: ff900000-ff9fffff=0A=
  PREFETCH window: cff00000-efefffff=0A=
PCI: Bridge: 0000:00:1c.0=0A=
  IO window: disabled.=0A=
  MEM window: disabled.=0A=
  PREFETCH window: cfe00000-cfefffff=0A=
PCI: Bridge: 0000:00:1c.3=0A=
  IO window: b000-bfff=0A=
  MEM window: ff800000-ff8fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.4=0A=
  IO window: a000-afff=0A=
  MEM window: ff700000-ff7fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.5=0A=
  IO window: 9000-9fff=0A=
  MEM window: ff600000-ff6fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1e.0=0A=
  IO window: 8000-8fff=0A=
  MEM window: ff500000-ff5fffff=0A=
  PREFETCH window: disabled.=0A=
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:00:01.0 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:00:1c.0 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1c.3 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:00:1c.4 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1c.5 to 64=0A=
PCI: Setting latency timer of device 0000:00:1e.0 to 64=0A=
NET: Registered protocol family 2=0A=
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)=0A=
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)=0A=
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000fefb23]=0A=
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)=0A=
TCP: Hash tables configured (established 131072 bind 65536)=0A=
TCP reno registered=0A=
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>=0A=
VFS: Disk quotas dquot_6.5.1=0A=
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)=0A=
NTFS driver 2.1.28 [Flags: R/W].=0A=
fuse init (API version 7.8)=0A=
io scheduler noop registered=0A=
io scheduler anticipatory registered (default)=0A=
io scheduler deadline registered=0A=
io scheduler cfq registered=0A=
PCI: Setting latency timer of device 0000:00:01.0 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:01.0:pcie00]=0A=
PCI: Setting latency timer of device 0000:00:1c.0 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.0:pcie00]=0A=
Allocate Port Service[0000:00:1c.0:pcie02]=0A=
PCI: Setting latency timer of device 0000:00:1c.3 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.3:pcie00]=0A=
PCI: Setting latency timer of device 0000:00:1c.4 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.4:pcie00]=0A=
PCI: Setting latency timer of device 0000:00:1c.5 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.5:pcie00]=0A=
input: Power Button (FF) as /class/input/input0=0A=
ACPI: Power Button (FF) [PWRF]=0A=
input: Power Button (CM) as /class/input/input1=0A=
ACPI: Power Button (CM) [PWRB]=0A=
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  78, =
should be 6F [20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU1._OSC] (Node ffff81000424cb30), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _OSC as Serialized=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU1._PDC] (Node ffff81000424cb50), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _PDC as Serialized=0A=
ACPI: Processor [CPU1] (supports 8 throttling states)=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU2._OSC] (Node ffff81000424ca10), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _OSC as Serialized=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU2._PDC] (Node ffff81000424ca30), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _PDC as Serialized=0A=
ACPI: Processor [CPU2] (supports 8 throttling states)=0A=
Real Time Clock Driver v1.12ac=0A=
hpet_resources: 0xfed00000 is busy=0A=
Non-volatile memory driver v1.2=0A=
intel_rng: FWH not detected=0A=
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)=0A=
iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=3D2, =
TCOBASE=3D0x0860)=0A=
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)=0A=
iTCO_vendor_support: vendor-support=3D0=0A=
Linux agpgart interface v0.102 (c) Dave Jones=0A=
[drm] Initialized drm 1.1.0 20060810=0A=
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin =
is 60 seconds).=0A=
Hangcheck: Using get_cycles().=0A=
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled=0A=
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0A=
00:0d: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0A=
Floppy drive(s): fd0 is 1.44M=0A=
FDC 0 is a post-1991 82077=0A=
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize=0A=
loop: loaded (max 8 devices)=0A=
nbd: registered device at major 43=0A=
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:04:00.0 to 64=0A=
sky2 0000:04:00.0: v1.13 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2=0A=
sky2 eth0: addr 00:18:f3:e0:5d:d4=0A=
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:03:00.0 to 64=0A=
sky2 0000:03:00.0: v1.13 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2=0A=
sky2 eth1: addr 00:18:f3:e0:36:fd=0A=
PPP generic driver version 2.4.2=0A=
PPP Deflate Compression module registered=0A=
PPP BSD Compression module registered=0A=
PPP MPPE Compression module registered=0A=
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller =
(davem@redhat.com)=0A=
tun: Universal TUN/TAP device driver, 1.6=0A=
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>=0A=
ahci 0000:00:1f.2: version 2.1=0A=
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23=0A=
PCI: Setting latency timer of device 0000:00:1f.2 to 64=0A=
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA =
mode=0A=
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part =0A=
ata1: SATA max UDMA/133 cmd 0xffffc2000008a900 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
ata2: SATA max UDMA/133 cmd 0xffffc2000008a980 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
ata3: SATA max UDMA/133 cmd 0xffffc2000008aa00 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
ata4: SATA max UDMA/133 cmd 0xffffc2000008aa80 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
scsi0 : ahci=0A=
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133=0A=
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata1.00: configured for UDMA/133=0A=
scsi1 : ahci=0A=
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A=
ata2.00: qc timeout (cmd 0xec)=0A=
ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x104)=0A=
ata2: port is slow to respond, please be patient (Status 0x80)=0A=
ata2: port failed to respond (30 secs, Status 0x80)=0A=
ata2: COMRESET failed (device not ready)=0A=
ata2: hardreset failed, retrying in 5 secs=0A=
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A=
ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133=0A=
ata2.00: 640 sectors, multi 1: LBA =0A=
ata2.00: configured for UDMA/133=0A=
scsi2 : ahci=0A=
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133=0A=
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata3.00: configured for UDMA/133=0A=
scsi3 : ahci=0A=
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A=
ata4.00: ATA-7: ST3500641AS, 3.AAB, max UDMA/133=0A=
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)=0A=
ata4.00: configured for UDMA/133=0A=
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 =
ANSI: 5=0A=
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sda: Write Protect is off=0A=
sda: Mode Sense: 00 3a 00 00=0A=
SCSI device sda: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sda: Write Protect is off=0A=
sda: Mode Sense: 00 3a 00 00=0A=
SCSI device sda: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sda: sda1 sda2 sda3=0A=
sd 0:0:0:0: Attached scsi disk sda=0A=
sd 0:0:0:0: Attached scsi generic sg0 type 0=0A=
scsi 1:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 =
ANSI: 5=0A=
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)=0A=
sdb: Write Protect is off=0A=
sdb: Mode Sense: 00 3a 00 00=0A=
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)=0A=
sdb: Write Protect is off=0A=
sdb: Mode Sense: 00 3a 00 00=0A=
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdb: unknown partition table=0A=
sd 1:0:0:0: Attached scsi disk sdb=0A=
sd 1:0:0:0: Attached scsi generic sg1 type 0=0A=
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 =
ANSI: 5=0A=
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sdc: Write Protect is off=0A=
sdc: Mode Sense: 00 3a 00 00=0A=
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sdc: Write Protect is off=0A=
sdc: Mode Sense: 00 3a 00 00=0A=
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdc: sdc1 sdc2=0A=
sd 2:0:0:0: Attached scsi disk sdc=0A=
sd 2:0:0:0: Attached scsi generic sg2 type 0=0A=
scsi 3:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 =
ANSI: 5=0A=
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)=0A=
sdd: Write Protect is off=0A=
sdd: Mode Sense: 00 3a 00 00=0A=
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)=0A=
sdd: Write Protect is off=0A=
sdd: Mode Sense: 00 3a 00 00=0A=
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdd: sdd1 sdd2 sdd3=0A=
sd 3:0:0:0: Attached scsi disk sdd=0A=
sd 3:0:0:0: Attached scsi generic sg3 type 0=0A=
PCI: Device 0000:02:00.0 not available because of resource collisions=0A=
ahci: probe of 0000:02:00.0 failed with error -22=0A=
ata_piix 0000:00:1f.1: version 2.10=0A=
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22=0A=
PCI: Setting latency timer of device 0000:00:1f.1 to 64=0A=
ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 =
bmdma 0x000000000001ffa0 irq 14=0A=
ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 =
bmdma 0x000000000001ffa8 irq 15=0A=
scsi4 : ata_piix=0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.00: ATA-7: Maxtor 6L200P0, BAH41E00, max UDMA/133=0A=
ata5.00: 398297088 sectors, multi 16: LBA48 =0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.01: ATAPI, max UDMA/33=0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.00: configured for UDMA/33=0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.01: configured for UDMA/33=0A=
scsi5 : ata_piix=0A=
ATA: abnormal status 0x7F on port 0x0000000000010177=0A=
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6L200P0   BAH4 PQ: 0 =
ANSI: 5=0A=
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)=0A=
sde: Write Protect is off=0A=
sde: Mode Sense: 00 3a 00 00=0A=
SCSI device sde: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)=0A=
sde: Write Protect is off=0A=
sde: Mode Sense: 00 3a 00 00=0A=
SCSI device sde: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sde: sde1 sde2 sde3 sde4 < sde5 sde6 >=0A=
sd 4:0:0:0: Attached scsi disk sde=0A=
sd 4:0:0:0: Attached scsi generic sg4 type 0=0A=
scsi 4:0:1:0: CD-ROM            ASUS     CRW-5232A3       1.00 PQ: 0 =
ANSI: 5=0A=
sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray=0A=
Uniform CD-ROM driver Revision: 3.20=0A=
sr 4:0:1:0: Attached scsi CD-ROM sr0=0A=
sr 4:0:1:0: Attached scsi generic sg5 type 5=0A=
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)=0A=
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:02:00.1 to 64=0A=
ata7: PATA max UDMA/100 cmd 0x0000000000019c00 ctl 0x0000000000019882 =
bmdma 0x0000000000019400 irq 16=0A=
ata8: PATA max UDMA/100 cmd 0x0000000000019800 ctl 0x0000000000019482 =
bmdma 0x0000000000019408 irq 16=0A=
scsi6 : pata_jmicron=0A=
ata7.00: ATAPI, max UDMA/66=0A=
ata7.00: qc timeout (cmd 0xef)=0A=
ata7.00: failed to set xfermode (err_mask=3D0x4)=0A=
ata7: failed to recover some devices, retrying in 5 secs=0A=
ata7.00: qc timeout (cmd 0xef)=0A=
ata7.00: failed to set xfermode (err_mask=3D0x4)=0A=
ata7.00: limiting speed to UDMA/66:PIO3=0A=
ata7: failed to recover some devices, retrying in 5 secs=0A=
ata7.00: qc timeout (cmd 0xef)=0A=
ata7.00: failed to set xfermode (err_mask=3D0x4)=0A=
ata7.00: disabled=0A=
scsi7 : pata_jmicron=0A=
ATA: abnormal status 0x7F on port 0x0000000000019807=0A=
video1394: Installed video1394 module=0A=
ieee1394: raw1394: /dev/raw1394 device initialized=0A=
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20=0A=
PCI: Setting latency timer of device 0000:00:1d.7 to 64=0A=
ehci_hcd 0000:00:1d.7: EHCI Host Controller=0A=
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1=0A=
ehci_hcd 0000:00:1d.7: debug port 1=0A=
PCI: cache line size of 32 is not supported by device 0000:00:1d.7=0A=
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffafbc00=0A=
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=0A=
usb usb1: configuration #1 chosen from 1 choice=0A=
hub 1-0:1.0: USB hub found=0A=
hub 1-0:1.0: 8 ports detected=0A=
USB Universal Host Controller Interface driver v3.0=0A=
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20=0A=
PCI: Setting latency timer of device 0000:00:1d.0 to 64=0A=
uhci_hcd 0000:00:1d.0: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2=0A=
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e480=0A=
usb usb2: configuration #1 chosen from 1 choice=0A=
hub 2-0:1.0: USB hub found=0A=
hub 2-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1d.1 to 64=0A=
uhci_hcd 0000:00:1d.1: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3=0A=
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e800=0A=
usb usb3: configuration #1 chosen from 1 choice=0A=
hub 3-0:1.0: USB hub found=0A=
hub 3-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:00:1d.2 to 64=0A=
uhci_hcd 0000:00:1d.2: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4=0A=
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e880=0A=
usb usb4: configuration #1 chosen from 1 choice=0A=
hub 4-0:1.0: USB hub found=0A=
hub 4-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1d.3 to 64=0A=
uhci_hcd 0000:00:1d.3: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5=0A=
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ec00=0A=
usb usb5: configuration #1 chosen from 1 choice=0A=
hub 5-0:1.0: USB hub found=0A=
hub 5-0:1.0: 2 ports detected=0A=
usb 1-7: new high speed USB device using ehci_hcd and address 3=0A=
usb 1-7: configuration #1 chosen from 1 choice=0A=
hub 1-7:1.0: USB hub found=0A=
hub 1-7:1.0: 4 ports detected=0A=
usb 2-2: new full speed USB device using uhci_hcd and address 2=0A=
usb 2-2: configuration #1 chosen from 1 choice=0A=
usb 1-7.3: new high speed USB device using ehci_hcd and address 4=0A=
usb 1-7.3: configuration #1 chosen from 1 choice=0A=
usbcore: registered new interface driver usblp=0A=
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver=0A=
Initializing USB Mass Storage driver...=0A=
usbcore: registered new interface driver usb-storage=0A=
USB Mass Storage support registered.=0A=
usbcore: registered new interface driver hiddev=0A=
usbcore: registered new interface driver usbhid=0A=
drivers/usb/input/hid-core.c: v2.6:USB HID core driver=0A=
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12=0A=
serio: i8042 KBD port at 0x60,0x64 irq 1=0A=
serio: i8042 AUX port at 0x60,0x64 irq 12=0A=
mice: PS/2 mouse device common for all mice=0A=
input: AT Translated Set 2 keyboard as /class/input/input2=0A=
input: PC Speaker as /class/input/input3=0A=
input: ImExPS/2 Logitech MX Mouse as /class/input/input4=0A=
I2O subsystem v1.325=0A=
i2o: max drivers =3D 8=0A=
I2O Configuration OSM v1.323=0A=
I2O Bus Adapter OSM v1.317=0A=
I2O Block Device OSM v1.325=0A=
I2O ProcFS OSM v1.316=0A=
i2c /dev entries driver=0A=
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23 (level, low) -> IRQ 23=0A=
md: linear personality registered for level -1=0A=
md: raid0 personality registered for level 0=0A=
md: raid1 personality registered for level 1=0A=
Advanced Linux Sound Architecture Driver Version 1.0.14rc2 (Wed Feb 14 =
07:42:13 2007 UTC).=0A=
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1b.0 to 64=0A=
ALSA device list:=0A=
  #0: HDA Intel at 0xffafc000 irq 19=0A=
netem: version 1.2=0A=
u32 classifier=0A=
    Performance counters on=0A=
    OLD policer on =0A=
Netfilter messages via NETLINK v0.30.=0A=
IPv4 over IPv4 tunneling driver=0A=
GRE over IPv4 tunneling driver=0A=
TCP cubic registered=0A=
Initializing XFRM netlink socket=0A=
NET: Registered protocol family 1=0A=
NET: Registered protocol family 10=0A=
lo: Disabled Privacy Extensions=0A=
IPv6: add_dev failed for eql=0A=
tunl0: Disabled Privacy Extensions=0A=
IPv6 over IPv4 tunneling driver=0A=
sit0: Disabled Privacy Extensions=0A=
NET: Registered protocol family 17=0A=
NET: Registered protocol family 15=0A=
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>=0A=
All bugs added by David S. Miller <davem@redhat.com>=0A=
ieee80211: 802.11 data/management/control stack, git-1.1.13=0A=
ieee80211: Copyright (C) 2004-2005 Intel Corporation =
<jketreno@linux.intel.com>=0A=
ieee80211_crypt: registered algorithm 'NULL'=0A=
ieee80211_crypt: registered algorithm 'WEP'=0A=
ieee80211_crypt: registered algorithm 'CCMP'=0A=
ieee80211_crypt: registered algorithm 'TKIP'=0A=
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)=0A=
Time: tsc clocksource has been installed.=0A=
md: Autodetecting RAID arrays.=0A=
md: autorun ...=0A=
md: ... autorun DONE.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
VFS: Mounted root (ext3 filesystem) readonly.=0A=
Freeing unused kernel memory: 296k freed=0A=
EXT3 FS on sde1, internal journal=0A=
sky2 eth0: enabling interface=0A=
sky2 eth0: ram buffer 48K=0A=
ADDRCONF(NETDEV_UP): eth0: link is not ready=0A=
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both=0A=
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on sde6, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on sde3, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
Adding 2096436k swap on /dev/sde5.  Priority:-1 extents:1 across:2096436k=0A=
Adding 4192956k swap on /dev/sda3.  Priority:-2 extents:1 across:4192956k=0A=
ata3.00: exception Emask 0x2 SAct 0xffff80 SErr 0x0 action 0x2 frozen=0A=
ata3.00: (spurious completion during NCQ issue=3D0x0 SAct=3D0xffff80 =
FIS=3D004040a1:00000040)=0A=
ata3.00: cmd 60/04:38:83:00:00/00:00:00:00:00/40 tag 7 cdb 0x0 data 2048 =
in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:40:87:00:00/00:00:00:00:00/40 tag 8 cdb 0x0 data 2048 =
in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:48:8b:00:00/00:00:00:00:00/40 tag 9 cdb 0x0 data 2048 =
in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:50:8f:00:00/00:00:00:00:00/40 tag 10 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:58:93:00:00/00:00:00:00:00/40 tag 11 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:60:97:00:00/00:00:00:00:00/40 tag 12 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:68:9b:00:00/00:00:00:00:00/40 tag 13 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:70:9f:00:00/00:00:00:00:00/40 tag 14 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:78:a3:00:00/00:00:00:00:00/40 tag 15 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:80:a7:00:00/00:00:00:00:00/40 tag 16 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:88:ab:00:00/00:00:00:00:00/40 tag 17 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:90:af:00:00/00:00:00:00:00/40 tag 18 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:98:b3:00:00/00:00:00:00:00/40 tag 19 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:a0:b7:00:00/00:00:00:00:00/40 tag 20 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:a8:bb:00:00/00:00:00:00:00/40 tag 21 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:b0:bf:00:00/00:00:00:00:00/40 tag 22 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3.00: cmd 60/04:b8:c3:00:00/00:00:00:00:00/40 tag 23 cdb 0x0 data =
2048 in=0A=
         res 40/00:b8:c3:00:00/00:00:00:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata3: soft resetting port=0A=
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata3.00: configured for UDMA/133=0A=
ata3: EH complete=0A=
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sdc: Write Protect is off=0A=
sdc: Mode Sense: 00 3a 00 00=0A=
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
ttyS1: LSR safety check engaged!=0A=
ttyS1: LSR safety check engaged!=0A=
eth0: no IPv6 routers present=0A=
ttyS1: LSR safety check engaged!=0A=

------=_NextPart_000_0180_01C76414.5D8F62B0
Content-Type: application/octet-stream;
	name="dmesg-2.6.21-rc2-irqpoll-dvd"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-2.6.21-rc2-irqpoll-dvd"

Linux version 2.6.21-rc2 (root@riri.as2917.net) (gcc version 4.0.3 =
(Ubuntu 4.0.3-1ubuntu5)) #4 SMP PREEMPT Sun Mar 4 19:52:39 CET 2007=0A=
Command line: root=3D/dev/sde1 ro ata2=3Dnoprobe console=3DttyS0,9600 =
console=3Dtty0 vga=3Dextended irqpoll=0A=
BIOS-provided physical RAM map:=0A=
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)=0A=
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)=0A=
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)=0A=
 BIOS-e820: 0000000000100000 - 00000000c7f80000 (usable)=0A=
 BIOS-e820: 00000000c7f80000 - 00000000c7f8e000 (ACPI data)=0A=
 BIOS-e820: 00000000c7f8e000 - 00000000c7fe0000 (ACPI NVS)=0A=
 BIOS-e820: 00000000c7fe0000 - 00000000c8000000 (reserved)=0A=
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)=0A=
Entering add_active_range(0, 0, 159) 0 entries of 256 used=0A=
Entering add_active_range(0, 256, 819072) 1 entries of 256 used=0A=
end_pfn_map =3D 1048576=0A=
DMI 2.4 present.=0A=
ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)=0A=
ACPI: XSDT C7F80100, 005C (r1 A_M_I_ OEMXSDT  12000608 MSFT       97)=0A=
ACPI: FACP C7F80290, 00F4 (r3 A_M_I_ OEMFACP  12000608 MSFT       97)=0A=
ACPI: DSDT C7F80410, 8FC4 (r1  A0543 A0543000        0 INTL 20060113)=0A=
ACPI: FACS C7F8E000, 0040=0A=
ACPI: APIC C7F80390, 0080 (r1 A_M_I_ OEMAPIC  12000608 MSFT       97)=0A=
ACPI: OEMB C7F8E040, 0066 (r1 A_M_I_ AMI_OEM  12000608 MSFT       97)=0A=
ACPI: HPET C7F893E0, 0038 (r1 A_M_I_ OEMHPET  12000608 MSFT       97)=0A=
ACPI: MCFG C7F89420, 003C (r1 A_M_I_ OEMMCFG  12000608 MSFT       97)=0A=
ACPI: SSDT C7F8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)=0A=
ACPI: SSDT C7F8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)=0A=
Entering add_active_range(0, 0, 159) 0 entries of 256 used=0A=
Entering add_active_range(0, 256, 819072) 1 entries of 256 used=0A=
Zone PFN ranges:=0A=
  DMA             0 ->     4096=0A=
  DMA32        4096 ->  1048576=0A=
  Normal    1048576 ->  1048576=0A=
early_node_map[2] active PFN ranges=0A=
    0:        0 ->      159=0A=
    0:      256 ->   819072=0A=
On node 0 totalpages: 818975=0A=
  DMA zone: 56 pages used for memmap=0A=
  DMA zone: 1986 pages reserved=0A=
  DMA zone: 1957 pages, LIFO batch:0=0A=
  DMA32 zone: 11142 pages used for memmap=0A=
  DMA32 zone: 803834 pages, LIFO batch:31=0A=
  Normal zone: 0 pages used for memmap=0A=
ACPI: PM-Timer IO Port: 0x808=0A=
ACPI: Local APIC address 0xfee00000=0A=
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)=0A=
Processor #0 (Bootup-CPU)=0A=
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)=0A=
Processor #1=0A=
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)=0A=
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)=0A=
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])=0A=
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0A=
ACPI: IRQ0 used by override.=0A=
ACPI: IRQ2 used by override.=0A=
ACPI: IRQ9 used by override.=0A=
Setting APIC routing to flat=0A=
ACPI: HPET id: 0x8086a201 base: 0xfed00000=0A=
Using ACPI (MADT) for SMP configuration information=0A=
Nosave address range: 000000000009f000 - 00000000000a0000=0A=
Nosave address range: 00000000000a0000 - 00000000000e4000=0A=
Nosave address range: 00000000000e4000 - 0000000000100000=0A=
Allocating PCI resources starting at cc000000 (gap: c8000000:37b00000)=0A=
PERCPU: Allocating 34368 bytes of per cpu data=0A=
Built 1 zonelists.  Total pages: 805791=0A=
Kernel command line: root=3D/dev/sde1 ro ata2=3Dnoprobe =
console=3DttyS0,9600 console=3Dtty0 vga=3Dextended irqpoll=0A=
Misrouted IRQ fixup and polling support enabled=0A=
This may significantly impact system performance=0A=
Initializing CPU#0=0A=
PID hash table entries: 4096 (order: 12, 32768 bytes)=0A=
time.c: Detected 2400.083 MHz processor.=0A=
Console: colour VGA+ 80x50=0A=
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)=0A=
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)=0A=
Checking aperture...=0A=
Memory: 3216500k/3276288k available (4563k kernel code, 59172k reserved, =
2317k data, 296k init)=0A=
Calibrating delay using timer specific routine.. 4817.98 BogoMIPS =
(lpj=3D2408991)=0A=
Security Framework v1.0.0 initialized=0A=
Capability LSM initialized=0A=
Failure registering Root Plug module with the kernel=0A=
Failure registering Root Plug  module with primary security module.=0A=
Mount-cache hash table entries: 256=0A=
CPU: L1 I cache: 32K, L1 D cache: 32K=0A=
CPU: L2 cache: 4096K=0A=
using mwait in idle threads.=0A=
CPU: Physical Processor ID: 0=0A=
CPU: Processor Core ID: 0=0A=
CPU0: Thermal monitoring enabled (TM2)=0A=
Freeing SMP alternatives: 40k freed=0A=
ACPI: Core revision 20070126=0A=
Using local APIC timer interrupts.=0A=
result 16667239=0A=
Detected 16.667 MHz APIC timer.=0A=
Booting processor 1/2 APIC 0x1=0A=
Initializing CPU#1=0A=
Calibrating delay using timer specific routine.. 4800.38 BogoMIPS =
(lpj=3D2400190)=0A=
CPU: L1 I cache: 32K, L1 D cache: 32K=0A=
CPU: L2 cache: 4096K=0A=
CPU: Physical Processor ID: 0=0A=
CPU: Processor Core ID: 1=0A=
CPU1: Thermal monitoring enabled (TM2)=0A=
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06=0A=
checking TSC synchronization [CPU#0 -> CPU#1]: passed.=0A=
Brought up 2 CPUs=0A=
testing NMI watchdog ... OK.=0A=
migration_cost=3D24=0A=
NET: Registered protocol family 16=0A=
ACPI: bus type pci registered=0A=
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved=0A=
PCI: Not using MMCONFIG.=0A=
PCI: Using configuration type 1=0A=
ACPI: Interpreter enabled=0A=
ACPI: Using IOAPIC for interrupt routing=0A=
ACPI: PCI Root Bridge [PCI0] (0000:00)=0A=
PCI: Probing PCI hardware (bus 00)=0A=
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO=0A=
PCI quirk: region 0480-04bf claimed by ICH6 GPIO=0A=
Boot video device is 0000:06:00.0=0A=
PCI: Transparent bridge - 0000:00:1e.0=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]=0A=
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]=0A=
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)=0A=
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)=0A=
Linux Plug and Play Support v0.97 (c) Adam Belay=0A=
pnp: PnP ACPI init=0A=
pnp: PnP ACPI: found 15 devices=0A=
SCSI subsystem initialized=0A=
libata version 2.20 loaded.=0A=
usbcore: registered new interface driver usbfs=0A=
usbcore: registered new interface driver hub=0A=
usbcore: registered new device driver usb=0A=
PCI: Using ACPI for IRQ routing=0A=
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post =
a report=0A=
PCI: Cannot allocate resource region 2 of device 0000:02:00.0=0A=
PCI: Cannot allocate resource region 3 of device 0000:02:00.0=0A=
PCI-GART: No AMD northbridge found.=0A=
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0=0A=
hpet0: 3 64-bit timers, 14318180 Hz=0A=
pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved=0A=
pnp: 00:07: ioport range 0x290-0x297 has been reserved=0A=
pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved=0A=
pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved=0A=
pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved=0A=
pnp: 00:08: iomem range 0xffb00000-0xffbfffff has been reserved=0A=
pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved=0A=
pnp: 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved=0A=
pnp: 00:0d: iomem range 0xf0000000-0xf3ffffff has been reserved=0A=
pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved=0A=
pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved=0A=
pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved=0A=
pnp: 00:0e: iomem range 0x100000-0xc7ffffff could not be reserved=0A=
ieee1394: Initialized config rom entry `ip1394'=0A=
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 21 (level, low) -> IRQ 21=0A=
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[21]  =
MMIO=3D[ff5ef800-ff5effff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]=0A=
PCI: Bridge: 0000:00:01.0=0A=
  IO window: c000-cfff=0A=
  MEM window: ff900000-ff9fffff=0A=
  PREFETCH window: cff00000-efefffff=0A=
PCI: Bridge: 0000:00:1c.0=0A=
  IO window: disabled.=0A=
  MEM window: disabled.=0A=
  PREFETCH window: cfe00000-cfefffff=0A=
PCI: Bridge: 0000:00:1c.3=0A=
  IO window: b000-bfff=0A=
  MEM window: ff800000-ff8fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.4=0A=
  IO window: a000-afff=0A=
  MEM window: ff700000-ff7fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1c.5=0A=
  IO window: 9000-9fff=0A=
  MEM window: ff600000-ff6fffff=0A=
  PREFETCH window: disabled.=0A=
PCI: Bridge: 0000:00:1e.0=0A=
  IO window: 8000-8fff=0A=
  MEM window: ff500000-ff5fffff=0A=
  PREFETCH window: disabled.=0A=
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:00:01.0 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:00:1c.0 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1c.3 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:00:1c.4 to 64=0A=
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1c.5 to 64=0A=
PCI: Setting latency timer of device 0000:00:1e.0 to 64=0A=
NET: Registered protocol family 2=0A=
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)=0A=
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)=0A=
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000fefb23]=0A=
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)=0A=
TCP: Hash tables configured (established 131072 bind 65536)=0A=
TCP reno registered=0A=
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>=0A=
VFS: Disk quotas dquot_6.5.1=0A=
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)=0A=
NTFS driver 2.1.28 [Flags: R/W].=0A=
fuse init (API version 7.8)=0A=
io scheduler noop registered=0A=
io scheduler anticipatory registered (default)=0A=
io scheduler deadline registered=0A=
io scheduler cfq registered=0A=
PCI: Setting latency timer of device 0000:00:01.0 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:01.0:pcie00]=0A=
PCI: Setting latency timer of device 0000:00:1c.0 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.0:pcie00]=0A=
Allocate Port Service[0000:00:1c.0:pcie02]=0A=
PCI: Setting latency timer of device 0000:00:1c.3 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.3:pcie00]=0A=
PCI: Setting latency timer of device 0000:00:1c.4 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.4:pcie00]=0A=
PCI: Setting latency timer of device 0000:00:1c.5 to 64=0A=
assign_interrupt_mode Found MSI capability=0A=
Allocate Port Service[0000:00:1c.5:pcie00]=0A=
input: Power Button (FF) as /class/input/input0=0A=
ACPI: Power Button (FF) [PWRF]=0A=
input: Power Button (CM) as /class/input/input1=0A=
ACPI: Power Button (CM) [PWRB]=0A=
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  88, =
should be 7F [20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU1._OSC] (Node ffff81000424cb30), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _OSC as Serialized=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU1._PDC] (Node ffff81000424cb50), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _PDC as Serialized=0A=
ACPI: Processor [CPU1] (supports 8 throttling states)=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU2._OSC] (Node ffff81000424ca10), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _OSC as Serialized=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_PR_.CPU2._PDC] (Node ffff81000424ca30), AE_ALREADY_EXISTS=0A=
ACPI: Marking method _PDC as Serialized=0A=
ACPI: Processor [CPU2] (supports 8 throttling states)=0A=
Real Time Clock Driver v1.12ac=0A=
hpet_resources: 0xfed00000 is busy=0A=
Non-volatile memory driver v1.2=0A=
intel_rng: FWH not detected=0A=
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)=0A=
iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=3D2, =
TCOBASE=3D0x0860)=0A=
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)=0A=
iTCO_vendor_support: vendor-support=3D0=0A=
Linux agpgart interface v0.102 (c) Dave Jones=0A=
[drm] Initialized drm 1.1.0 20060810=0A=
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin =
is 60 seconds).=0A=
Hangcheck: Using get_cycles().=0A=
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled=0A=
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0A=
00:0c: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0A=
Floppy drive(s): fd0 is 1.44M=0A=
FDC 0 is a post-1991 82077=0A=
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize=0A=
loop: loaded (max 8 devices)=0A=
nbd: registered device at major 43=0A=
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:04:00.0 to 64=0A=
sky2 0000:04:00.0: v1.13 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2=0A=
sky2 eth0: addr 00:18:f3:e0:5d:d4=0A=
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:03:00.0 to 64=0A=
sky2 0000:03:00.0: v1.13 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2=0A=
sky2 eth1: addr 00:18:f3:e0:36:fd=0A=
PPP generic driver version 2.4.2=0A=
PPP Deflate Compression module registered=0A=
PPP BSD Compression module registered=0A=
PPP MPPE Compression module registered=0A=
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller =
(davem@redhat.com)=0A=
tun: Universal TUN/TAP device driver, 1.6=0A=
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>=0A=
ahci 0000:00:1f.2: version 2.1=0A=
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23=0A=
PCI: Setting latency timer of device 0000:00:1f.2 to 64=0A=
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA =
mode=0A=
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part =0A=
ata1: SATA max UDMA/133 cmd 0xffffc2000008a900 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
ata2: SATA max UDMA/133 cmd 0xffffc2000008a980 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
ata3: SATA max UDMA/133 cmd 0xffffc2000008aa00 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
ata4: SATA max UDMA/133 cmd 0xffffc2000008aa80 ctl 0x0000000000000000 =
bmdma 0x0000000000000000 irq 504=0A=
scsi0 : ahci=0A=
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133=0A=
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata1.00: configured for UDMA/133=0A=
scsi1 : ahci=0A=
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A=
ata2.00: qc timeout (cmd 0xec)=0A=
ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x104)=0A=
ata2: port is slow to respond, please be patient (Status 0x80)=0A=
ata2: port failed to respond (30 secs, Status 0x80)=0A=
ata2: COMRESET failed (device not ready)=0A=
ata2: hardreset failed, retrying in 5 secs=0A=
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A=
ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133=0A=
ata2.00: 640 sectors, multi 1: LBA =0A=
ata2.00: configured for UDMA/133=0A=
scsi2 : ahci=0A=
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133=0A=
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A=
ata3.00: configured for UDMA/133=0A=
scsi3 : ahci=0A=
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A=
ata4.00: ATA-7: ST3500641AS, 3.AAB, max UDMA/133=0A=
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)=0A=
ata4.00: configured for UDMA/133=0A=
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 =
ANSI: 5=0A=
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sda: Write Protect is off=0A=
sda: Mode Sense: 00 3a 00 00=0A=
SCSI device sda: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sda: Write Protect is off=0A=
sda: Mode Sense: 00 3a 00 00=0A=
SCSI device sda: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sda: sda1 sda2 sda3=0A=
sd 0:0:0:0: Attached scsi disk sda=0A=
sd 0:0:0:0: Attached scsi generic sg0 type 0=0A=
scsi 1:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 =
ANSI: 5=0A=
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)=0A=
sdb: Write Protect is off=0A=
sdb: Mode Sense: 00 3a 00 00=0A=
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)=0A=
sdb: Write Protect is off=0A=
sdb: Mode Sense: 00 3a 00 00=0A=
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdb: unknown partition table=0A=
sd 1:0:0:0: Attached scsi disk sdb=0A=
sd 1:0:0:0: Attached scsi generic sg1 type 0=0A=
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 =
ANSI: 5=0A=
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sdc: Write Protect is off=0A=
sdc: Mode Sense: 00 3a 00 00=0A=
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sdc: Write Protect is off=0A=
sdc: Mode Sense: 00 3a 00 00=0A=
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdc: sdc1 sdc2=0A=
sd 2:0:0:0: Attached scsi disk sdc=0A=
sd 2:0:0:0: Attached scsi generic sg2 type 0=0A=
scsi 3:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 =
ANSI: 5=0A=
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)=0A=
sdd: Write Protect is off=0A=
sdd: Mode Sense: 00 3a 00 00=0A=
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)=0A=
sdd: Write Protect is off=0A=
sdd: Mode Sense: 00 3a 00 00=0A=
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sdd: sdd1 sdd2 sdd3=0A=
sd 3:0:0:0: Attached scsi disk sdd=0A=
sd 3:0:0:0: Attached scsi generic sg3 type 0=0A=
PCI: Device 0000:02:00.0 not available because of resource collisions=0A=
ahci: probe of 0000:02:00.0 failed with error -22=0A=
ata_piix 0000:00:1f.1: version 2.10=0A=
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22=0A=
PCI: Setting latency timer of device 0000:00:1f.1 to 64=0A=
ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 =
bmdma 0x000000000001ffa0 irq 14=0A=
ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 =
bmdma 0x000000000001ffa8 irq 15=0A=
scsi4 : ata_piix=0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.00: ATA-7: Maxtor 6L200P0, BAH41E00, max UDMA/133=0A=
ata5.00: 398297088 sectors, multi 16: LBA48 =0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.01: ATAPI, max UDMA/33=0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.00: configured for UDMA/33=0A=
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero =
[20070126]=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.RATA] (Node ffff81000425c490), AE_AML_OPERAND_VALUE=0A=
ACPI Error (psparse-0537): Method parse/execution failed =
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff81000425c7f0), =
AE_AML_OPERAND_VALUE=0A=
ata5.01: configured for UDMA/33=0A=
scsi5 : ata_piix=0A=
ATA: abnormal status 0x7F on port 0x0000000000010177=0A=
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6L200P0   BAH4 PQ: 0 =
ANSI: 5=0A=
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)=0A=
sde: Write Protect is off=0A=
sde: Mode Sense: 00 3a 00 00=0A=
SCSI device sde: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)=0A=
sde: Write Protect is off=0A=
sde: Mode Sense: 00 3a 00 00=0A=
SCSI device sde: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
 sde: sde1 sde2 sde3 sde4 < sde5 sde6 >=0A=
sd 4:0:0:0: Attached scsi disk sde=0A=
sd 4:0:0:0: Attached scsi generic sg4 type 0=0A=
scsi 4:0:1:0: CD-ROM            ASUS     CRW-5232A3       1.00 PQ: 0 =
ANSI: 5=0A=
sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray=0A=
Uniform CD-ROM driver Revision: 3.20=0A=
sr 4:0:1:0: Attached scsi CD-ROM sr0=0A=
sr 4:0:1:0: Attached scsi generic sg5 type 5=0A=
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)=0A=
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16=0A=
PCI: Setting latency timer of device 0000:02:00.1 to 64=0A=
ata7: PATA max UDMA/100 cmd 0x0000000000019c00 ctl 0x0000000000019882 =
bmdma 0x0000000000019400 irq 16=0A=
ata8: PATA max UDMA/100 cmd 0x0000000000019800 ctl 0x0000000000019482 =
bmdma 0x0000000000019408 irq 16=0A=
scsi6 : pata_jmicron=0A=
ata7.00: ATAPI, max UDMA/66=0A=
ata7.00: configured for UDMA/66=0A=
scsi7 : pata_jmicron=0A=
ATA: abnormal status 0x7F on port 0x0000000000019807=0A=
scsi 6:0:0:0: CD-ROM            ASUS     DRW-1608P        1.40 PQ: 0 =
ANSI: 5=0A=
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray=0A=
sr 6:0:0:0: Attached scsi CD-ROM sr1=0A=
sr 6:0:0:0: Attached scsi generic sg6 type 5=0A=
video1394: Installed video1394 module=0A=
ieee1394: raw1394: /dev/raw1394 device initialized=0A=
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20=0A=
PCI: Setting latency timer of device 0000:00:1d.7 to 64=0A=
ehci_hcd 0000:00:1d.7: EHCI Host Controller=0A=
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1=0A=
ehci_hcd 0000:00:1d.7: debug port 1=0A=
PCI: cache line size of 32 is not supported by device 0000:00:1d.7=0A=
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffafbc00=0A=
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=0A=
usb usb1: configuration #1 chosen from 1 choice=0A=
hub 1-0:1.0: USB hub found=0A=
hub 1-0:1.0: 8 ports detected=0A=
USB Universal Host Controller Interface driver v3.0=0A=
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20=0A=
PCI: Setting latency timer of device 0000:00:1d.0 to 64=0A=
uhci_hcd 0000:00:1d.0: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2=0A=
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e480=0A=
usb usb2: configuration #1 chosen from 1 choice=0A=
hub 2-0:1.0: USB hub found=0A=
hub 2-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17=0A=
PCI: Setting latency timer of device 0000:00:1d.1 to 64=0A=
uhci_hcd 0000:00:1d.1: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3=0A=
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e800=0A=
usb usb3: configuration #1 chosen from 1 choice=0A=
hub 3-0:1.0: USB hub found=0A=
hub 3-0:1.0: 2 ports detected=0A=
usb 1-7: new high speed USB device using ehci_hcd and address 2=0A=
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18=0A=
PCI: Setting latency timer of device 0000:00:1d.2 to 64=0A=
uhci_hcd 0000:00:1d.2: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4=0A=
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e880=0A=
usb usb4: configuration #1 chosen from 1 choice=0A=
hub 4-0:1.0: USB hub found=0A=
hub 4-0:1.0: 2 ports detected=0A=
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1d.3 to 64=0A=
uhci_hcd 0000:00:1d.3: UHCI Host Controller=0A=
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5=0A=
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ec00=0A=
usb usb5: configuration #1 chosen from 1 choice=0A=
hub 5-0:1.0: USB hub found=0A=
hub 5-0:1.0: 2 ports detected=0A=
usb 1-7: configuration #1 chosen from 1 choice=0A=
hub 1-7:1.0: USB hub found=0A=
hub 1-7:1.0: 4 ports detected=0A=
usb 1-7.3: new high speed USB device using ehci_hcd and address 3=0A=
usb 1-7.3: configuration #1 chosen from 1 choice=0A=
usbcore: registered new interface driver usblp=0A=
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver=0A=
Initializing USB Mass Storage driver...=0A=
usbcore: registered new interface driver usb-storage=0A=
USB Mass Storage support registered.=0A=
usbcore: registered new interface driver hiddev=0A=
usbcore: registered new interface driver usbhid=0A=
drivers/usb/input/hid-core.c: v2.6:USB HID core driver=0A=
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1=0A=
PNP: PS/2 controller doesn't have AUX irq; using default 12=0A=
serio: i8042 KBD port at 0x60,0x64 irq 1=0A=
serio: i8042 AUX port at 0x60,0x64 irq 12=0A=
mice: PS/2 mouse device common for all mice=0A=
input: AT Translated Set 2 keyboard as /class/input/input2=0A=
input: PC Speaker as /class/input/input3=0A=
I2O subsystem v1.325=0A=
i2o: max drivers =3D 8=0A=
I2O Configuration OSM v1.323=0A=
I2O Bus Adapter OSM v1.317=0A=
I2O Block Device OSM v1.325=0A=
I2O ProcFS OSM v1.316=0A=
i2c /dev entries driver=0A=
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23 (level, low) -> IRQ 23=0A=
md: linear personality registered for level -1=0A=
md: raid0 personality registered for level 0=0A=
md: raid1 personality registered for level 1=0A=
Advanced Linux Sound Architecture Driver Version 1.0.14rc2 (Wed Feb 14 =
07:42:13 2007 UTC).=0A=
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19 (level, low) -> IRQ 19=0A=
PCI: Setting latency timer of device 0000:00:1b.0 to 64=0A=
ALSA device list:=0A=
  #0: HDA Intel at 0xffafc000 irq 19=0A=
netem: version 1.2=0A=
u32 classifier=0A=
    Performance counters on=0A=
    OLD policer on =0A=
Netfilter messages via NETLINK v0.30.=0A=
IPv4 over IPv4 tunneling driver=0A=
GRE over IPv4 tunneling driver=0A=
TCP cubic registered=0A=
Initializing XFRM netlink socket=0A=
NET: Registered protocol family 1=0A=
NET: Registered protocol family 10=0A=
lo: Disabled Privacy Extensions=0A=
IPv6: add_dev failed for eql=0A=
tunl0: Disabled Privacy Extensions=0A=
IPv6 over IPv4 tunneling driver=0A=
sit0: Disabled Privacy Extensions=0A=
NET: Registered protocol family 17=0A=
NET: Registered protocol family 15=0A=
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>=0A=
All bugs added by David S. Miller <davem@redhat.com>=0A=
ieee80211: 802.11 data/management/control stack, git-1.1.13=0A=
ieee80211: Copyright (C) 2004-2005 Intel Corporation =
<jketreno@linux.intel.com>=0A=
ieee80211_crypt: registered algorithm 'NULL'=0A=
ieee80211_crypt: registered algorithm 'WEP'=0A=
ieee80211_crypt: registered algorithm 'CCMP'=0A=
ieee80211_crypt: registered algorithm 'TKIP'=0A=
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)=0A=
Time: tsc clocksource has been installed.=0A=
md: Autodetecting RAID arrays.=0A=
md: autorun ...=0A=
md: ... autorun DONE.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
VFS: Mounted root (ext3 filesystem) readonly.=0A=
Freeing unused kernel memory: 296k freed=0A=
sky2 eth0: enabling interface=0A=
sky2 eth0: ram buffer 48K=0A=
ADDRCONF(NETDEV_UP): eth0: link is not ready=0A=
ata1.00: exception Emask 0x2 SAct 0x7e000007 SErr 0x0 action 0x2 frozen=0A=
ata1.00: (spurious completion during NCQ issue=3D0x0 SAct=3D0x7e000007 =
FIS=3D004040a1:01000000)=0A=
ata1.00: cmd 60/08:00:88:e1:44/00:00:0f:00:00/40 tag 0 cdb 0x0 data 4096 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:08:3b:eb:ff/00:00:09:00:00/40 tag 1 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/57:10:3c:eb:ff/00:00:09:00:00/40 tag 2 cdb 0x0 data =
44544 in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:c8:35:eb:ff/00:00:09:00:00/40 tag 25 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:d0:36:eb:ff/00:00:09:00:00/40 tag 26 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:d8:37:eb:ff/00:00:09:00:00/40 tag 27 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:e0:38:eb:ff/00:00:09:00:00/40 tag 28 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:e8:39:eb:ff/00:00:09:00:00/40 tag 29 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1.00: cmd 60/01:f0:3a:eb:ff/00:00:09:00:00/40 tag 30 cdb 0x0 data 512 =
in=0A=
         res 40/00:10:3c:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM =
violation)=0A=
ata1: soft resetting port=0A=
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
ata1.00: configured for UDMA/133=0A=
ata1: EH complete=0A=
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)=0A=
sda: Write Protect is off=0A=
sda: Mode Sense: 00 3a 00 00=0A=
SCSI device sda: write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA=0A=
EXT3 FS on sde1, internal journal=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on sde6, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on sde3, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
Adding 2096436k swap on /dev/sde5.  Priority:-1 extents:1 across:2096436k=0A=
Adding 4192956k swap on /dev/sda3.  Priority:-2 extents:1 across:4192956k=0A=
ttyS1: LSR safety check engaged!=0A=
ttyS1: LSR safety check engaged!=0A=
ttyS1: LSR safety check engaged!=0A=
ISO 9660 Extensions: Microsoft Joliet Level 3=0A=
ISO 9660 Extensions: RRIP_1991A=0A=

------=_NextPart_000_0180_01C76414.5D8F62B0--

