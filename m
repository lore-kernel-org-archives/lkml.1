Return-Path: <linux-kernel-owner+w=401wt.eu-S964889AbXFFBp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889AbXFFBp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932755AbXFFBpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:45:16 -0400
Received: from bay0-omc2-s30.bay0.hotmail.com ([65.54.246.166]:45888 "EHLO
	bay0-omc2-s30.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbXFFBpN (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:45:13 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Tue, 5 Jun 2007 21:45:14 -0400
From: Sean <seanlkml@sympatico.ca>
To: Linux-Kernel@vger.kernel.org
Subject: libata - wrong IDE cable detection with dvd burner
Message-Id: <20070605214514.d5f7e00a.seanlkml@sympatico.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 01:45:25.0265 (UTC) FILETIME=[5A47D810:01C7A7DC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,

Using 2.6.22-rc3 and finding it impossible to get the UDMA/66
connection advertised by a new dvd burner.   Substituting an old
hard drive in place of the DVD yields UDMA/100.  Yet with the
same cable, libata refuses to do more than /33 complaining that
it's a 40-wire cable.  I've already twiddled everything that
looks like it might be a factor in the bios.

This is an Intel D865GBF motherboard (dmesg below) with onboard
ide, however the exact same problem occurred when connecting this
dvd burner to the ide port on a promise sata pci board that also
lives in this system.

I found someone else having this problem here[1] but the patch
that worked in that situation appears to already be applied in
this kernel.  Not sure it makes a difference, but the kernel
is compiled without modules.  Any help would be appreciated; i'm
happy to do whatever is needed to diagnose the problem further.

Thanks,
Sean

[1] http://www.ussg.iu.edu/hypermail/linux/kernel/0703.3/0349.html

dmesg (ata1.00: limited to UDMA/33 due to 40-wire cable):

Linux version 2.6.22-rc3 (sean@home) (gcc version 4.1.2 (Gentoo 4.1.2)) #6 SMP PREEMPT Sun Jun 3 14:45:47 EDT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff2fc00 (usable)
 BIOS-e820: 000000007ff2fc00 - 000000007ff30000 (ACPI NVS)
 BIOS-e820: 000000007ff30000 - 000000007ff40000 (ACPI data)
 BIOS-e820: 000000007ff40000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 524079) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524079
early_node_map[1] active PFN ranges
    0:        0 ->   524079
On node 0 totalpages: 524079
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292401 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F61B0, 0014 (r0 ACPIAM)
ACPI: RSDT 7FF30000, 0038 (r1 INTEL  D865GBF  20040622 MSFT       97)
ACPI: FACP 7FF30200, 0081 (r2 INTEL  D865GBF  20040622 MSFT       97)
ACPI: DSDT 7FF30370, 4231 (r1 INTEL  D865GBF         1 MSFT  100000D)
ACPI: FACS 7FF40000, 0040
ACPI: APIC 7FF30300, 0068 (r1 INTEL  D865GBF  20040622 MSFT       97)
ACPI: ASF! 7FF345B0, 0099 (r16 LEGEND I865PASF        1 MSFT  100000D)
ACPI: TCPA 7FF34649, 0034 (r1 INTEL  TBLOEMID        1 MSFT       97)
ACPI: WDDT 7FF3467D, 0040 (r1 INTEL  OEMWDDT         1 MSFT  100000D)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ecf0000)
Built 1 zonelists.  Total pages: 519985
Kernel command line: root=/dev/sda3
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2793.325 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2071136k/2096316k available (3714k kernel code, 23980k reserved, 2314k data, 300k init, 1178812k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc06ea000 - 0xc0735000   ( 300 kB)
      .data : 0xc04a092c - 0xc06e3294   (2314 kB)
      .text : 0xc0100000 - 0xc04a092c   (3714 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5588.51 BogoMIPS (lpj=2794258)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 13k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5585.58 BogoMIPS (lpj=2792790)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
Total of 2 processors activated (11174.09 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
Generic PHY: Registered new driver
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:0c: ioport range 0x400-0x47f has been reserved
pnp: 00:0c: ioport range 0x680-0x6ff has been reserved
pnp: 00:0c: ioport range 0x500-0x53f has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0c: iomem range 0xfed20000-0xfed9ffff could not be reserved
pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0d: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: ff800000-ff8fffff
  PREFETCH window: ceb00000-eeafffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: ff900000-ff9fffff
  PREFETCH window: 88000000-880fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit: initializing netlink socket (disabled)
audit(1181092304.247:1): initialized
highmem bounce pool size: 64 pages
fuse init (API version 7.8)
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
intel_rng: Firmware space is locked read-only. <4>intel_rng: If you can't or
 don't want to <4>intel_rng: disable this in firmware setup, and <4>intel_rng: if
 you are certain that your <4>intel_rng: system has a functional
 RNG, try<4>intel_rng: using the 'no_fwh_detect' option.
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 865 Chipset.
agpgart: AGP aperture is 128M @ 0xf0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.27.0 20060524 on minor 0
ipmi message handler version 39.1
ipmi device interface
IPMI System Interface driver.
ipmi_si: Unable to find any System Interface(s)
IPMI Watchdog: driver initialized
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
loop: module loaded
Ethernet Channel Bonding Driver: v3.1.2 (January 20, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
eepro100.c:v1.09j-t 9/29/99 Donald Becker
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 20 (level, low) -> IRQ 17
eth0: 0000:02:08.0, 00:0C:F1:C6:86:77, IRQ 17.
  Board assembly 000000-000, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0xed626fe2).
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
LXT970: Registered new driver
LXT971: Registered new driver
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
netconsole: not configured, aborting
ata_piix 0000:00:1f.1: version 2.11
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1.00: ATAPI, max UDMA/66
ata1.00: limited to UDMA/33 due to 40-wire cable
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
ata1.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            DVDRW    18X18X12X        ZA32 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0001ec00 ctl 0x0001e802 bmdma 0x0001dc00 irq 0
ata4: SATA max UDMA/133 cmd 0x0001e400 ctl 0x0001e002 bmdma 0x0001dc08 irq 0
ATA: abnormal status 0x7F on port 0x0001ec07
ATA: abnormal status 0x7F on port 0x0001e407
sata_promise 0000:02:04.0: version 2.07
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 18 (level, low) -> IRQ 18
sata_promise 0000:02:04.0: PATA port found
scsi4 : sata_promise
scsi5 : sata_promise
scsi6 : sata_promise
ata5: SATA max UDMA/133 cmd 0xf8830200 ctl 0xf8830238 bmdma 0x00000000 irq 0
ata6: SATA max UDMA/133 cmd 0xf8830280 ctl 0xf88302b8 bmdma 0x00000000 irq 0
ata7: PATA max UDMA/133 cmd 0xf8830300 ctl 0xf8830338 bmdma 0x00000000 irq 0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ata_hpa_resize 1: sectors = 976773168, hpa_sectors = 976773168
ata5.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata5.00: ata_hpa_resize 1: sectors = 976773168, hpa_sectors = 976773168
ata5.00: configured for UDMA/133
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata6.00: ATA-7: WDC WD2500KS-00MJB0, 02.01C03, max UDMA/133
ata6.00: 488397168 sectors, multi 0: LBA48 
ata6.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata6.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 4:0:0:0: [sda] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 5:0:0:0: Direct-Access     ATA      WDC WD2500KS-00M 02.0 PQ: 0 ANSI: 5
sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 5:0:0:0: [sdb] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg2 type 0
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xffaffc00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000cc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver emi26 - firmware loader
usbcore: registered new interface driver emi62 - firmware loader
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
input: PC Speaker as /class/input/input3
input: ImExPS/2 Logitech MX Mouse as /class/input/input4
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 21
i2c-adapter i2c-0: Client creation failed at 0x50 (-5)
i2c-parport-light: adapter type unspecified
abituguru: no Abit uGuru found, data = 0xFF, cmd = 0xFF
i2c-adapter i2c-0: Unsupported chip (man_id=0x01, chip_id=0x62).
i2c-adapter i2c-0: detect fail: address match, 0x2e
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
pc87360: PC8736x not detected, module not inserted.
w83627ehf: unsupported chip ID: 0xf0d1
w83627ehf: unsupported chip ID: 0xffff
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.0.1 Jun  3 2007
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
usbcore: registered new interface driver hiddev
input: Logitech Logitech USB Headset as /class/input/input5
input: USB HID v1.00 Device [Logitech Logitech USB Headset] on usb-0000:00:1d.3-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14rc4 (Wed May 16 09:45:46 2007 UTC).
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1f.5 to 64
AC'97 0 analog subsections not ready
intel8x0_measure_ac97_clock: measured 50053 usecs
intel8x0: clocking to 48000
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: Intel ICH5 with AD1985 at irq 21
  #1: Logitech Logitech USB Headset at usb-0000:00:1d.3-1, full speed
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Starting balanced_irq
Using IPI Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 300k freed
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 787176k swap on /dev/sda2.  Priority:-1 extents:1 across:787176k
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs

