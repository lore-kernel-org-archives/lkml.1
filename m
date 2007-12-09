Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbXLIRAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbXLIRAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXLIRAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:00:08 -0500
Received: from echo836.server4you.de ([85.25.140.112]:39249 "EHLO
	mail.pianoinflames.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXLIQ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:59:59 -0500
Message-ID: <475C1F06.4080508@pianoinflames.de>
Date: Sun, 09 Dec 2007 17:59:50 +0100
From: Marco Gatti <marco@pianoinflames.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
References: <4755BEA1.4090604@pianoinflames.de> <20071206162500.1f76a234.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712061631510.13796@woody.linux-foundation.org> <475B0AD7.10500@pianoinflames.de> <alpine.LFD.0.9999.0712081644560.12046@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712081644560.12046@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds schrieb:
> Was there a dmesg out there somewhere?
> 
> With 4G of RAM, you probably have some of it above the 4GB mark (because 
> of RAM remapping etc, and the PCI decode hole in the low 4GB). It does 
> sound like this is a DMA problem, and your controller cannot correctly DMA 
> to the upper 4GB.
> 
> So what controller/driver, what's the dmesg, and let's see if we can fix 
> it by adding a DMA mask to it to limit it to the low 32 bits.

Controller / drivers:
it's a board with intel Q35 chipset. The southbridge has an ICH9
Intel Gigabit 82566DM-2 => e1000
Intel matrix storage SATA => ahci.c
Intel graphics media accelerator => not added to kernel
Intel Audio => Intel HD Audio AC97

I just got "EXT3-fs error Allocating block in system zone" in dmesg with 
4 or more GBs of RAM. I listed boot up dmesg to get an idea of dma 
config with different amount of RAM.

Thanks for your help.

dmesg with 2GB:

Linux version 2.6.23.9 (root@adira) (gcc version 4.1.2 (Gentoo 4.1.2 
p1.0.2)) #3 SMP Wed Dec 5 20:00:29 CET 2007
Command line: root=/dev/sdb3 udev
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
  BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007e5c0000 (usable)
  BIOS-e820: 000000007e5c0000 - 000000007e5c8000 (ACPI data)
  BIOS-e820: 000000007e5c8000 - 000000007e5cb000 (ACPI NVS)
  BIOS-e820: 000000007e5cb000 - 000000007e700000 (reserved)
  BIOS-e820: 000000007e800000 - 0000000080000000 (reserved)
  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 517568) 1 entries of 3200 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F7240, 0014 (r0 PTLTD )
ACPI: RSDT 7E5C2D9F, 0058 (r1 PTLTD    RSDT      60000  LTP        0)
ACPI: FACP 7E5C7AF3, 0074 (r1 FSC                60000         F4240)
ACPI: DSDT 7E5C2DF7, 4CFC (r1 FSC    D2587/A1    60000 MSFT  3000001)
ACPI: FACS 7E5CAFC0, 0040
ACPI: TCPA 7E5C7B67, 0032 (r1 Phoeni  x          60000  TL         0)
ACPI: _MAR 7E5C7B99, 0030 (r1 Intel  OEMDMAR     60000 LOHR        1)
ACPI: SSDT 7E5C7BC9, 007A (r1 FSC    CST_CPU0    60000  CSF        1)
ACPI: SSDT 7E5C7C43, 007A (r1 FSC    CST_CPU1    60000  CSF        1)
ACPI: SSDT 7E5C7CBD, 00B6 (r1 FSC    PST_CPU0    60000  CSF        1)
ACPI: SSDT 7E5C7D73, 00B6 (r1 FSC    PST_CPU1    60000  CSF        1)
ACPI: SPCR 7E5C7E29, 0050 (r1 PTLTD  $UCRTBL$    60000 PTL         1)
ACPI: MCFG 7E5C7E79, 003C (r1 PTLTD    MCFG      60000  LTP        0)
ACPI: HPET 7E5C7EB5, 0038 (r1 PTLTD  HPETTBL     60000  LTP        1)
ACPI: APIC 7E5C7EED, 0068 (r1 PTLTD  	 APIC      60000  LTP        0)
ACPI: BOOT 7E5C7F55, 0028 (r1 PTLTD  $SBFTBL$    60000  LTP        1)
ACPI: ASF! 7E5C7F7D, 0083 (r16   CETP     CETP    60000 PTL         1)
No NUMA configuration found
Faking a node at 0000000000000000-000000007e5c0000
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 517568) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007e5c0000
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0:        0 ->      156
     0:      256 ->   517568
On node 0 totalpages: 517468
   DMA zone: 56 pages used for memmap
   DMA zone: 1454 pages reserved
   DMA zone: 2486 pages, LIFO batch:0
   DMA32 zone: 7020 pages used for memmap
   DMA32 zone: 506452 pages, LIFO batch:31
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
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009c000 - 000000000009d000
swsusp: Registered nosave memory region: 000000000009d000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000ce000
swsusp: Registered nosave memory region: 00000000000ce000 - 00000000000d0000
swsusp: Registered nosave memory region: 00000000000d0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:78000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30376 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 508938
Policy zone: DMA32
Kernel command line: root=/dev/sdb3 udev
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2327.499 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Memory: 2035320k/2070272k available (3107k kernel code, 34552k reserved, 
1751k data, 328k init)
Calibrating delay using timer specific routine.. 4750.72 BogoMIPS 
(lpj=2375362)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 20781235
Detected 20.781 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4654.94 BogoMIPS 
(lpj=2327472)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at f8000000 - f90fffff
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Device [LPT] status [00000008]: functional but not present; 
setting present
ACPI: Device [ECP] status [00000008]: functional but not present; 
setting present
ACPI: Device [COM2] status [00000008]: functional but not present; 
setting present
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 7 9 10 11 12 14 15) *5
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 7 9 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 7 of bridge 0000:00:01.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.4
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
pnp: 00:03: iomem range 0xfec00000-0xfecfffff could not be reserved
pnp: 00:03: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:03: iomem range 0xf8000000-0xfbffffff could not be reserved
pnp: 00:03: iomem range 0xfed19000-0xfed19fff has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Simple Boot Flag at 0x43 set to 0x1
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
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
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
Marking TSC unstable due to possible TSC halt in C2
Time: hpet clocksource has been installed.
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
tpm_tis 00:01: 1.2 TPM (device-id 0xB, rev-id 16)
tpm_tis 00:01: Unable to request irq: 8 for probe
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS1 at I/O 0x1c90 (irq = 17) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: nr_ports (6) and implemented port map (0xf) don't match
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20000334100 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata2: SATA max UDMA/133 cmd 0xffffc20000334180 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata3: SATA max UDMA/133 cmd 0xffffc20000334200 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata4: SATA max UDMA/133 cmd 0xffffc20000334280 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST380815AS, 3.AAA, max UDMA/133
ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD-ROM DDU1671S, 1.81, max UDMA/33
ata2.00: applying bridge limits
ata2.00: configured for UDMA/33
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD5000AAKS-65YGA0, 12.01C02, max UDMA/133
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST380815AS       3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            Optiarc  DVD-ROM DDU1671S 1.81 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 12.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:1a.7[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf03a3000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf03a3400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000018a0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000018c0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 4-1: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 21, io base 0x000018e0
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 4-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KEYB,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
coretemp coretemp.0: Using undocumented features, absolute temperature 
might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature 
might be wrong!
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.1-1
Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.1-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 328k freed
Intel(R) PRO/1000 Network Driver - version 7.6.12
Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 
00:19:99:13:ca:4f
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
EXT3 FS on sdb3, internal journal
Adding 2000084k swap on /dev/sdb2.  Priority:-1 extents:1 across:2000084k

dmesg with 4GB:
Linux version 2.6.23.9 (root@adira) (gcc version 4.1.2 (Gentoo 4.1.2 
p1.0.2)) #3 SMP Wed Dec 5 20:00:29 CET 2007
Command line: root=/dev/sdb3 udev
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
  BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000df5c0000 (usable)
  BIOS-e820: 00000000df5c0000 - 00000000df5c8000 (ACPI data)
  BIOS-e820: 00000000df5c8000 - 00000000df5cb000 (ACPI NVS)
  BIOS-e820: 00000000df5cb000 - 00000000df700000 (reserved)
  BIOS-e820: 00000000df800000 - 00000000e0100000 (reserved)
  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 000000011a000000 (usable)
  BIOS-e820: 000000011a000000 - 000000011c000000 (reserved)
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 914880) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1155072) 2 entries of 3200 used
end_pfn_map = 1163264
DMI present.
ACPI: RSDP 000F7240, 0014 (r0 PTLTD )
ACPI: RSDT DF5C2D9F, 0058 (r1 PTLTD    RSDT      60000  LTP        0)
ACPI: FACP DF5C7AF3, 0074 (r1 FSC                60000         F4240)
ACPI: DSDT DF5C2DF7, 4CFC (r1 FSC    D2587/A1    60000 MSFT  3000001)
ACPI: FACS DF5CAFC0, 0040
ACPI: TCPA DF5C7B67, 0032 (r1 Phoeni  x          60000  TL         0)
ACPI: _MAR DF5C7B99, 0030 (r1 Intel  OEMDMAR     60000 LOHR        1)
ACPI: SSDT DF5C7BC9, 007A (r1 FSC    CST_CPU0    60000  CSF        1)
ACPI: SSDT DF5C7C43, 007A (r1 FSC    CST_CPU1    60000  CSF        1)
ACPI: SSDT DF5C7CBD, 00B6 (r1 FSC    PST_CPU0    60000  CSF        1)
ACPI: SSDT DF5C7D73, 00B6 (r1 FSC    PST_CPU1    60000  CSF        1)
ACPI: SPCR DF5C7E29, 0050 (r1 PTLTD  $UCRTBL$    60000 PTL         1)
ACPI: MCFG DF5C7E79, 003C (r1 PTLTD    MCFG      60000  LTP        0)
ACPI: HPET DF5C7EB5, 0038 (r1 PTLTD  HPETTBL     60000  LTP        1)
ACPI: APIC DF5C7EED, 0068 (r1 PTLTD  	 APIC      60000  LTP        0)
ACPI: BOOT DF5C7F55, 0028 (r1 PTLTD  $SBFTBL$    60000  LTP        1)
ACPI: ASF! DF5C7F7D, 0083 (r16   CETP     CETP    60000 PTL         1)
No NUMA configuration found
Faking a node at 0000000000000000-000000011a000000
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 914880) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1155072) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000011a000000
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1155072
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
     0:        0 ->      156
     0:      256 ->   914880
     0:  1048576 ->  1155072
On node 0 totalpages: 1021276
   DMA zone: 56 pages used for memmap
   DMA zone: 1456 pages reserved
   DMA zone: 2484 pages, LIFO batch:0
   DMA32 zone: 14280 pages used for memmap
   DMA32 zone: 896504 pages, LIFO batch:31
   Normal zone: 1456 pages used for memmap
   Normal zone: 105040 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009c000 - 000000000009d000
swsusp: Registered nosave memory region: 000000000009d000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000ce000
swsusp: Registered nosave memory region: 00000000000ce000 - 00000000000d0000
swsusp: Registered nosave memory region: 00000000000d0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
swsusp: Registered nosave memory region: 00000000df5c0000 - 00000000df5c8000
swsusp: Registered nosave memory region: 00000000df5c8000 - 00000000df5cb000
swsusp: Registered nosave memory region: 00000000df5cb000 - 00000000df700000
swsusp: Registered nosave memory region: 00000000df700000 - 00000000df800000
swsusp: Registered nosave memory region: 00000000df800000 - 00000000e0100000
swsusp: Registered nosave memory region: 00000000e0100000 - 00000000f8000000
swsusp: Registered nosave memory region: 00000000f8000000 - 00000000fc000000
swsusp: Registered nosave memory region: 00000000fc000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fec10000
swsusp: Registered nosave memory region: 00000000fec10000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000ffb00000
swsusp: Registered nosave memory region: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at e2000000 (gap: e0100000:17f00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30376 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 1004028
Policy zone: Normal
Kernel command line: root=/dev/sdb3 udev
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2327.500 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1076000 - 0x5076000
Memory: 3949672k/4620288k available (3107k kernel code, 135432k 
reserved, 1751k data, 328k init)
Calibrating delay using timer specific routine.. 4657.58 BogoMIPS 
(lpj=2328791)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 20781232
Detected 20.781 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4654.98 BogoMIPS 
(lpj=2327490)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at f8000000 - f90fffff
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Device [LPT] status [00000008]: functional but not present; 
setting present
ACPI: Device [ECP] status [00000008]: functional but not present; 
setting present
ACPI: Device [COM2] status [00000008]: functional but not present; 
setting present
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 7 9 10 11 12 14 15) *5
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 7 9 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 7 of bridge 0000:00:01.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.4
PCI: Cannot allocate resource region 2 of device 0000:00:02.0
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
pnp: 00:03: iomem range 0xfec00000-0xfecfffff could not be reserved
pnp: 00:03: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:03: iomem range 0xf8000000-0xfbffffff could not be reserved
pnp: 00:03: iomem range 0xfed19000-0xfed19fff has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Simple Boot Flag at 0x43 set to 0x1
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
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
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
Marking TSC unstable due to possible TSC halt in C2
Time: hpet clocksource has been installed.
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
tpm_tis 00:01: 1.2 TPM (device-id 0xB, rev-id 16)
tpm_tis 00:01: Unable to request irq: 8 for probe
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS1 at I/O 0x1c90 (irq = 17) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: nr_ports (6) and implemented port map (0xf) don't match
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc2000063a100 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata2: SATA max UDMA/133 cmd 0xffffc2000063a180 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata3: SATA max UDMA/133 cmd 0xffffc2000063a200 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata4: SATA max UDMA/133 cmd 0xffffc2000063a280 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST380815AS, 3.AAA, max UDMA/133
ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD-ROM DDU1671S, 1.81, max UDMA/33
ata2.00: applying bridge limits
ata2.00: configured for UDMA/33
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD5000AAKS-65YGA0, 12.01C02, max UDMA/133
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST380815AS       3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            Optiarc  DVD-ROM DDU1671S 1.81 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 12.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:1a.7[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf03a3000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf03a3400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000018a0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000018c0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 4-1: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 21, io base 0x000018e0
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 4-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KEYB,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
coretemp coretemp.0: Using undocumented features, absolute temperature 
might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature 
might be wrong!
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.1-1
Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.1-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 328k freed
Intel(R) PRO/1000 Network Driver - version 7.6.12
Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 
00:19:99:13:ca:4f
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
EXT3 FS on sdb3, internal journal
Adding 2000084k swap on /dev/sdb2.  Priority:-1 extents:1 across:2000084k

dmesg with 8 GB:
Linux version 2.6.23.9 (root@adira) (gcc version 4.1.2 (Gentoo 4.1.2 
p1.0.2)) #2 SMP Sat Dec 1 23:07:18 CET 2007
Command line: root=/dev/sdb3 udev pci=nommconf
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
  BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000df5c0000 (usable)
  BIOS-e820: 00000000df5c0000 - 00000000df5c8000 (ACPI data)
  BIOS-e820: 00000000df5c8000 - 00000000df5cb000 (ACPI NVS)
  BIOS-e820: 00000000df5cb000 - 00000000df700000 (reserved)
  BIOS-e820: 00000000df800000 - 00000000e0100000 (reserved)
  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 000000021a000000 (usable)
  BIOS-e820: 000000021a000000 - 000000021c000000 (reserved)
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 914880) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2203648) 2 entries of 3200 used
end_pfn_map = 2211840
DMI present.
ACPI: RSDP 000F7240, 0014 (r0 PTLTD )
ACPI: RSDT DF5C2D9F, 0058 (r1 PTLTD    RSDT      60000  LTP        0)
ACPI: FACP DF5C7AF3, 0074 (r1 FSC                60000         F4240)
ACPI: DSDT DF5C2DF7, 4CFC (r1 FSC    D2587/A1    60000 MSFT  3000001)
ACPI: FACS DF5CAFC0, 0040
ACPI: TCPA DF5C7B67, 0032 (r1 Phoeni  x          60000  TL         0)
ACPI: _MAR DF5C7B99, 0030 (r1 Intel  OEMDMAR     60000 LOHR        1)
ACPI: SSDT DF5C7BC9, 007A (r1 FSC    CST_CPU0    60000  CSF        1)
ACPI: SSDT DF5C7C43, 007A (r1 FSC    CST_CPU1    60000  CSF        1)
ACPI: SSDT DF5C7CBD, 00B6 (r1 FSC    PST_CPU0    60000  CSF        1)
ACPI: SSDT DF5C7D73, 00B6 (r1 FSC    PST_CPU1    60000  CSF        1)
ACPI: SPCR DF5C7E29, 0050 (r1 PTLTD  $UCRTBL$    60000 PTL         1)
ACPI: MCFG DF5C7E79, 003C (r1 PTLTD    MCFG      60000  LTP        0)
ACPI: HPET DF5C7EB5, 0038 (r1 PTLTD  HPETTBL     60000  LTP        1)
ACPI: APIC DF5C7EED, 0068 (r1 PTLTD  	 APIC      60000  LTP        0)
ACPI: BOOT DF5C7F55, 0028 (r1 PTLTD  $SBFTBL$    60000  LTP        1)
ACPI: ASF! DF5C7F7D, 0083 (r16   CETP     CETP    60000 PTL         1)
No NUMA configuration found
Faking a node at 0000000000000000-000000021a000000
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 914880) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2203648) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000021a000000
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  2203648
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
     0:        0 ->      156
     0:      256 ->   914880
     0:  1048576 ->  2203648
On node 0 totalpages: 2069852
   DMA zone: 56 pages used for memmap
   DMA zone: 1460 pages reserved
   DMA zone: 2480 pages, LIFO batch:0
   DMA32 zone: 14280 pages used for memmap
   DMA32 zone: 896504 pages, LIFO batch:31
   Normal zone: 15792 pages used for memmap
   Normal zone: 1139280 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009c000 - 000000000009d000
swsusp: Registered nosave memory region: 000000000009d000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000ce000
swsusp: Registered nosave memory region: 00000000000ce000 - 00000000000d0000
swsusp: Registered nosave memory region: 00000000000d0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
swsusp: Registered nosave memory region: 00000000df5c0000 - 00000000df5c8000
swsusp: Registered nosave memory region: 00000000df5c8000 - 00000000df5cb000
swsusp: Registered nosave memory region: 00000000df5cb000 - 00000000df700000
swsusp: Registered nosave memory region: 00000000df700000 - 00000000df800000
swsusp: Registered nosave memory region: 00000000df800000 - 00000000e0100000
swsusp: Registered nosave memory region: 00000000e0100000 - 00000000f8000000
swsusp: Registered nosave memory region: 00000000f8000000 - 00000000fc000000
swsusp: Registered nosave memory region: 00000000fc000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fec10000
swsusp: Registered nosave memory region: 00000000fec10000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000ffb00000
swsusp: Registered nosave memory region: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at e2000000 (gap: e0100000:17f00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30376 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 2038264
Policy zone: Normal
Kernel command line: root=/dev/sdb3 udev pci=nommconf
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2327.498 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x108b000 - 0x508b000
Memory: 8086532k/8814592k available (3107k kernel code, 192876k 
reserved, 1751k data, 328k init)
Calibrating delay using timer specific routine.. 4657.58 BogoMIPS 
(lpj=2328790)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 20781223
Detected 20.781 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4654.98 BogoMIPS 
(lpj=2327491)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Device [LPT] status [00000008]: functional but not present; 
setting present
ACPI: Device [ECP] status [00000008]: functional but not present; 
setting present
ACPI: Device [COM2] status [00000008]: functional but not present; 
setting present
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 7 9 10 11 12 14 15) *5
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 7 9 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 7 of bridge 0000:00:01.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.4
PCI: Cannot allocate resource region 2 of device 0000:00:02.0
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
pnp: 00:03: iomem range 0xfec00000-0xfecfffff could not be reserved
pnp: 00:03: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:03: iomem range 0xf8000000-0xfbffffff could not be reserved
pnp: 00:03: iomem range 0xfed19000-0xfed19fff has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
Simple Boot Flag at 0x43 set to 0x1
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is 
not present [20070126]
Marking TSC unstable due to possible TSC halt in C2
Time: hpet clocksource has been installed.
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
tpm_tis 00:01: 1.2 TPM (device-id 0xB, rev-id 16)
tpm_tis 00:01: Unable to request irq: 8 for probe
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS1 at I/O 0x1c90 (irq = 17) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: nr_ports (6) and implemented port map (0xf) don't match
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc2000274e100 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata2: SATA max UDMA/133 cmd 0xffffc2000274e180 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata3: SATA max UDMA/133 cmd 0xffffc2000274e200 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata4: SATA max UDMA/133 cmd 0xffffc2000274e280 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 316
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST380815AS, 3.AAA, max UDMA/133
ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD-ROM DDU1671S, 1.81, max UDMA/33
ata2.00: applying bridge limits
ata2.00: configured for UDMA/33
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD5000AAKS-65YGA0, 12.01C02, max UDMA/133
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST380815AS       3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            Optiarc  DVD-ROM DDU1671S 1.81 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 4x/32x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 12.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:1a.7[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf03a3000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf03a3400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000018a0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000018c0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 4-1: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 21, io base 0x000018e0
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 4-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KEYB,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
coretemp coretemp.0: Using undocumented features, absolute temperature 
might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature 
might be wrong!
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.1-1
Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.1-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 328k freed
Intel(R) PRO/1000 Network Driver - version 7.6.12
Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 
00:19:99:13:ca:4f
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
EXT3 FS on sdb3, internal journal
VFS: Can't find ext3 filesystem on dev sdb4.
Adding 2000084k swap on /dev/sdb2.  Priority:-1 extents:1 across:2000084k
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex, 
Flow Control: RX
e1000: eth0: e1000_watchdog_task: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

lspci:

00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation PCI Express Root Port (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics 
Controller (rev 02)
00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
00:03.2 IDE interface: Intel Corporation PT IDER Controller (rev 02)
00:03.3 Serial controller: Intel Corporation Serial KT Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network 
Connection (rev 02)
00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation PCI Express Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller 
(rev 02)
00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)

