Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYGQIlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYGQIlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYGQIlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:41:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:59602 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754134AbYGQIlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:41:06 -0400
X-Authenticated: #23500402
X-Provags-ID: V01U2FsdGVkX1+W12ccSuWWb0Oou5uEnZdhwCUNWp94tfbJ2vgx9h
	8/z5G/ynGR4Dal
Date: Thu, 17 Jul 2008 10:41:02 +0200
From: Andre Prendel <andre_prendel@gmx.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andre Prendel <andre_prendel@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       kernel-testers@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: ACPI Error under 2.6.26-rc*
Message-ID: <20080717084102.GA4597@linux.int.dgn.ag>
References: <20080709083829.GA5748@linux.int.dgn.ag> <200807102255.23090.rjw@sisk.pl> <1215739210.1617.28.camel@rzhang-dt> <1215739682.1617.32.camel@rzhang-dt> <20080714080914.GA4965@linux.int.dgn.ag> <1216026701.1617.82.camel@rzhang-dt> <20080715074130.GA4724@linux.int.dgn.ag> <1216111260.1617.131.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1216111260.1617.131.camel@rzhang-dt>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 04:41:00PM +0800, Zhang Rui wrote:
> > > It seems that OS failed to get the correct RSDT address
> > (0x1fff0000),
> > > although the RSDP is found correctly. (﻿ACPI: RSDP 000FA340, 0014)
> > >
> > > please run "./acpidump --addr 0xFA340 --length 0x14 > rsdp_xxx",
> > > and attach the rsdp for all of the three cases (good, ACPI Error,
> > ACPI
> > > Exception).
> > Hello Rui,
> > 
> > here is the output of the three cases. The dump files are attached
> > too.
> > 
> > ----
> > good
> > ----
> > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump rsdp_good
> > 0000000 5352 2044 5450 2052 418c 494d 2020 0020
> > 0000010 0000 1fff                             
> > 0000014
> > 
> > -----
> > error
> > -----
> > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump rsdp_error
> > 0000000 5352 2044 5450 2052 418a 494d 2020 0020
> > 0000010 0000 21ff                             
> > 0000014
> > 
> > ---------
> > exception
> > ---------
> > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> > rsdp_exception
> > 0000000 5352 2044 5450 2052 417c 494d 2020 0020
> > 0000010 0000 2fff                             
> > 0000014
> 
> Weird.
> The dmesg shows that the memory map gotten from e820 table is changed.
> And the file attached shows that rsdp points to different rsdt address.
> > 
> > Now I see the ACPI Error under the 2.6.25.10 kernel sometimes too, but
> > power off works well. So I also attach the two configs. Maybe the
> > different config is the reason why power off works under 2.6.25.10.
> so you may get different e820 table when running 2.6.25.10 as well?
> could you please attach the dmesg output of a 2.6.25.10 kernel which has
> the ACPI error?

Attached. Yes, the e820 table differs, but power off still works.

Linux version 2.6.25.10-default (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #5 Tue Jul 8 21:21:58 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000002fff0000 - 000000002fff8000 (ACPI data)
 BIOS-e820: 000000002fff8000 - 0000000030000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[...]
 
> > Is it possible that it is a hardware related issue?
> Don't know. :(
> It looks like a hardware issue as BIOS export different e820 tables.
> But from your description, it seems to be a software regression.
> please try to revert c3965bd15118742d72b4bc1a290d37b3f081eb98 and see if
> it helps.

Reverting this comment did not help. So I am starting a bisect session
tonight. Maybe this gives us a clue.

> Please re-attach the kernel config files as attachments.
> 
> thanks,
> rui

Thanks,
Andre

---------------
dmesg 2.6.25.10
---------------
Linux version 2.6.25.10-default (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #5 Tue Jul 8 21:21:58 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000002fff0000 - 000000002fff8000 (ACPI data)
 BIOS-e820: 000000002fff8000 - 0000000030000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000FA340, 0014 (r0 AMI   )
ACPI:      2FFF0000, 0000 (r103                        0             0)
ACPI Error (tbutils-0472): Invalid length 0x0 in RSDT/XSDT [20070126]
Allocating PCI resources starting at 40000000 (gap: 30000000:cec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130033
Kernel command line: root=/dev/mapper/lvm--sdb-root ro
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01402000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1659.681 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511576k/524224k available (1639k kernel code, 12036k reserved, 753k data, 216k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa7000 - 0xfffff000   ( 352 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc035a000 - 0xc0390000   ( 216 kB)
      .data : 0xc0299fd4 - 0xc03566a0   ( 753 kB)
      .text : 0xc0100000 - 0xc0299fd4   (1639 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3320.82 BogoMIPS (lpj=6641648)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) XP 2000+ stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20070126]
ACPI: Unable to load the System Description Tables
net_namespace: 540 bytes
NET: Registered protocol family 16
No dock devices found.
PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:02.0: Enabling SiS 96x SMBus
PCI: Using IRQ router SIS [1039/0018] at 0000:00:02.0
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:02.1
PCI: Sharing IRQ 11 with 0000:00:13.1
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xcde00000-0xcfefffff
  PREFETCH window: 0x00000000c5c00000-0x00000000cdcfffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4484k freed
Machine check exception polling timer started.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
type=2000 audit(1216239018.596:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
NET: Registered protocol family 1
Using IPI Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 216k freed
fuse init (API version 7.9)
thermal: Unknown symbol acpi_processor_set_thermal_limit
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:02.2
ohci_hcd 0000:00:02.2: OHCI Host Controller
ohci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.2: irq 10, io mem 0xcfffe000
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
USB Universal Host Controller Interface driver v3.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
SIS5513: IDE controller (0x1039:0x5513 rev 0xd0) at  PCI slot 0000:00:02.5
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS735 ATA 100 (2nd gen) controller
    ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
input: ImPS/2 Logitech Wheel Mouse as /class/input/input1
hda: IC35L060AVV207-0, ATA DISK drive
hdb: IC35L060AVV207-0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: TSSTcorpCD-R/RW SH-R522C, ATAPI CD/DVD-ROM drive
hdd: TSSTcorpDVD-ROM TS-H352A, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
8139cp 0000:00:0d.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
8139cp 0000:00:0d.0: Try the "8139too" driver instead.
8139too Fast Ethernet driver 0.9.28
PCI: Found IRQ 10 for device 0000:00:0d.0
PCI: Sharing IRQ 10 with 0000:00:02.7
PCI: Sharing IRQ 10 with 0000:00:13.2
eth0: RealTek RTL8139 at 0xe084cf00, 00:10:b5:11:4a:b0, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139C'
PCI: Found IRQ 11 for device 0000:00:13.0
uhci_hcd 0000:00:13.0: UHCI Host Controller
uhci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:13.0: irq 11, io base 0x0000cc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PCI: Found IRQ 10 for device 0000:00:13.2
PCI: Sharing IRQ 10 with 0000:00:02.7
PCI: Sharing IRQ 10 with 0000:00:0d.0
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:13.2: irq 10, io mem 0xcfffde00
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
PCI: setting IRQ 5 as level-triggered
PCI: Found IRQ 5 for device 0000:00:02.3
ohci_hcd 0000:00:02.3: OHCI Host Controller
ohci_hcd 0000:00:02.3: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:02.3: irq 5, io mem 0xcffff000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
PCI: Found IRQ 11 for device 0000:00:13.1
PCI: Sharing IRQ 11 with 0000:00:02.1
uhci_hcd 0000:00:13.1: UHCI Host Controller
uhci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:13.1: irq 11, io base 0x0000d000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hda: max request size: 512KiB
hda: 120103200 sectors (61492 MB) w/1821KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 >
hdb: max request size: 512KiB
hdb: 120103200 sectors (61492 MB) w/1821KiB Cache, CHS=16383/255/63
hdb: cache flushes supported
 hdb: hdb1 hdb2
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X DVD-ROM drive, 512kB Cache
usb 3-1: new high speed USB device using ehci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
hub 3-0:1.0: unable to enumerate USB device on port 3
usb 5-1: new full speed USB device using uhci_hcd and address 2
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 5-1: configuration #1 chosen from 1 choice
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 0:0:0:0: Direct-Access     WDC WD40 0UE-22HCT0       0811 PQ: 0 ANSI: 0
usb-storage: device scan complete
eth0: link down
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
Linux agpgart interface v0.103
agpgart: Detected SiS chipset - id:1845
agpgart: AGP aperture is 64M @ 0xd0000000
sis630_smbus 0000:00:02.0: SIS630 comp. bus not detected, module not inserted.
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
PCI: Found IRQ 10 for device 0000:00:02.7
PCI: Sharing IRQ 10 with 0000:00:0d.0
PCI: Sharing IRQ 10 with 0000:00:13.2
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
intel8x0_measure_ac97_clock: measured 55871 usecs
intel8x0: clocking to 48000
loop: module loaded
IT8705 SuperIO detected.
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
lp0: using parport0 (polling).
Adding 1048568k swap on /dev/mapper/lvm--sdb-swap.  Priority:-1 extents:1 across:1048568k
EXT3 FS on dm-1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
powernow_k7: Unknown symbol acpi_processor_notify_smm
powernow_k7: Unknown symbol acpi_processor_unregister_performance
powernow_k7: Unknown symbol acpi_processor_register_performance
acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
acpi_cpufreq: Unknown symbol acpi_processor_unregister_performance
acpi_cpufreq: Unknown symbol acpi_processor_preregister_performance
acpi_cpufreq: Unknown symbol acpi_processor_register_performance
ppdev: user-space parallel port driver

