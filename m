Return-Path: <linux-kernel-owner+w=401wt.eu-S965964AbXCPV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964AbXCPV3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965965AbXCPV3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:29:21 -0400
Received: from dorothy.movealong.org ([69.56.173.86]:1654 "EHLO
	dorothy.movealong.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965964AbXCPV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:29:19 -0400
X-Greylist: delayed 1739 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 17:29:19 EDT
Date: Fri, 16 Mar 2007 17:00:10 -0400
From: Nate Riffe <inkblot@movealong.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Nate Riffe <inkblot@movealong.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_inic162x: kill double region requests
Message-ID: <20070316210010.GA9451@movealong.org>
References: <20070310205636.GA14704@movealong.org> <45F4F483.9080302@gmail.com> <20070312220656.GA5457@movealong.org> <20070315165942.GC15600@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315165942.GC15600@htj.dyndns.org>
X-pw: reindeer flotilla
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo said this (probably recently):
> Regions are requested twice during initialization causing the second
> one to fail.  This is regression introduced during iomap conversion.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Nate, this should fix it.  But LBA48 support is broken on the
> controller.

It does indeed allow the driver to enable the card.  The two attached
drives do appear in /proc/scsi/scsi now, but they do not seem to be
bound to major/minor numbers.  If I read the discussion correctly, I
should at least be able to write garbage to the disk and read
(possibly different) garbage back, but that is not the case.

I've included the complete dmesg output from a kernel without the
extra region requests.... I'm not sure what other information would be
useful at this juncture.

-Nate

Linux version 2.6.21-rc3 (inkblot@toto) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Thu Mar 15 23:25:19 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009e800 end: 000000000009e800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009e800 size: 0000000000001800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e7000 size: 0000000000019000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fefdc00 end: 000000001fffdc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fffdc00 size: 0000000000002000 end: 000000001ffffc00 type: 3
copy_e820_map() start: 000000001ffffc00 size: 0000000000000400 end: 0000000020000000 type: 4
copy_e820_map() start: 00000000fffe7000 size: 0000000000019000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e7000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fffdc00 (usable)
 BIOS-e820: 000000001fffdc00 - 000000001ffffc00 (ACPI data)
 BIOS-e820: 000000001ffffc00 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fffe7000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Entering add_active_range(0, 0, 131069) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131069
  HighMem    131069 ->   131069
early_node_map[1] active PFN ranges
    0:        0 ->   131069
On node 0 totalpages: 131069
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125982 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI 2.1 present.
ACPI: RSDP 000F6B00, 0014 (r0 PTLTD )
ACPI: RSDT 1FFFDD5D, 0028 (r1 PTLTD    RSDT          0 PTL   1000000)
ACPI: FACP 1FFFFB8C, 0074 (r1 INTEL  SEATTLE2 19990830 PTL     F4240)
ACPI: DSDT 1FFFDD85, 1E07 (r1  Intel  S2440BX        0 MSFT  1000004)
ACPI: FACS 1FFFFFC0, 0040
ACPI: PM-Timer IO Port: 0x8008
Allocating PCI resources starting at 30000000 (gap: 20000000:dffe7000)
Built 1 zonelists.  Total pages: 130046
Kernel command line: root=/dev/hda1 ro 
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0140a000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 548.753 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514244k/524276k available (1547k kernel code, 9480k reserved, 588k data, 200k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfffd000   ( 511 MB)
      .init : 0xc031d000 - 0xc034f000   ( 200 kB)
      .data : 0xc0282c7d - 0xc0316014   ( 588 kB)
      .text : 0xc0100000 - 0xc0282c7d   (1547 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1098.41 BogoMIPS (lpj=2196828)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0387f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU serial number disabled.
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 8e00)
CPU0: Intel Pentium III (Katmai) stepping 03
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9b4, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
PCI quirk: region 8000-803f claimed by PIIX4 ACPI
PCI quirk: region 7000-700f claimed by PIIX4 SMB
PCI: Firmware left 0000:00:0e.0 e100 interrupts enabled, disabling
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 12) *15
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: Power Resource [PFAN] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:01: ioport range 0x7000-0x700f has been reserved
pnp: 00:01: ioport range 0x8000-0x803f has been reserved
pnp: 00:01: iomem range 0xfff80000-0xffffffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: f4200000-f5ffffff
  PREFETCH window: 30000000-300fffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 196608 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2322k freed
audit: initializing netlink socket (disabled)
audit(1174078326.036:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MICE] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 200k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Fan [FAN1] (on)
ACPI: CPU0 (power states: C1[C1] C2[C2])
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1c60-0x1c67, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
SCSI subsystem initialized
libata version 2.20 loaded.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
hda: DIAMOND 0000000, ATA DISK drive
Time: pit clocksource has been installed.
hdb: CREATIVE CD5230E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
sata_inic162x 0000:00:0d.0: version 0.1
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ata1: SATA max UDMA/133 cmd 0x00012400 ctl 0x00012002 bmdma 0x00000000 irq 11
ata2: SATA max UDMA/133 cmd 0x00011800 ctl 0x00011402 bmdma 0x00000000 irq 11
scsi0 : sata_inic162x
hda: max request size: 512KiB
hda: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(33)
hda: cache flushes supported
 hda: hda1 hda2 < hda5 >
hdb: ATAPI 52X CD-ROM drive, 128kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3320620NS, 3.AEG, max UDMA/133
ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi1 : sata_inic162x
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3320620NS, 3.AEG, max UDMA/133
ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3320620NS      3.AE PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      ST3320620NS      3.AE PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
e100: eth0: e100_probe: addr 0xf4009000, irq 10, MAC addr 00:90:27:BD:38:EF
md: raid1 personality registered for level 1
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  1098.000 MB/sec
raid5: using function: pIII_sse (1098.000 MB/sec)
raid6: int32x1    113 MB/s
raid6: int32x2    109 MB/s
raid6: int32x4    130 MB/s
raid6: int32x8    130 MB/s
raid6: mmxx1      297 MB/s
raid6: mmxx2      345 MB/s
raid6: sse1x1     257 MB/s
raid6: sse1x2     340 MB/s
raid6: using algorithm sse1x2 (340 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input1
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
Real Time Clock Driver v1.12ac
Adding 1510068k swap on /dev/hda5.  Priority:-1 extents:1 across:1510068k
EXT3 FS on hda1, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
eth0: no IPv6 routers present

-- 
--< ((\))< >----< inkblot@movealong.org >----< http://www.movealong.org/ >--
pub  1024D/05A058E0 2002-03-07 Nate Riffe (06-Mar-2002) <inkblot@movealong.org>
     Key fingerprint = 0DAC F5CB D182 3165 D757  C466 CD42 12A8 05A0 58E0
