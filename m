Return-Path: <linux-kernel-owner+w=401wt.eu-S1764577AbXHAR5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764577AbXHAR5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbXHAR5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:57:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:55496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbXHAR5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:57:20 -0400
Date: Wed, 1 Aug 2007 19:57:18 +0200
From: Olaf Hering <olh@suse.de>
To: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: 2.6.22: oops in sbp2_remove_device
Message-ID: <20070801175718.GA19589@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This happens when attaching a firewire disk (momobay) to a single cpu
G5. I suspect there are two bugs, one is the error handling and one is
the DMA mask setting.

ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00010410100036e0]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[000a95fffea65d66]
ReiserFS: sdb4: Using r5 hash to sort names
ieee1394: sbp2: failed to set 4GB DMA mask
Unable to handle kernel paging request for data at address 0x00000000
...
NIP [d0000000002b48dc] .sbp2_remove_device+0x78/0x498 [sbp2]
LR [d0000000002b48c8] .sbp2_remove_device+0x64/0x498 [sbp2]
Call Trace:
[c00000000f1a3670] [d0000000002b48c8] .sbp2_remove_device+0x64/0x498 [sbp2] (unreliable)
[c00000000f1a3730] [d0000000002b5f38] .sbp2_probe+0x77c/0x7d4 [sbp2]
[c00000000f1a37e0] [c0000000002ca2a0] .driver_probe_device+0x13c/0x200
[c00000000f1a3870] [c0000000002ca55c] .__driver_attach+0xb4/0x138
[c00000000f1a3900] [c0000000002c9174] .bus_for_each_dev+0x7c/0xd4
[c00000000f1a39c0] [c0000000002ca00c] .driver_attach+0x28/0x40
[c00000000f1a3a40] [c0000000002c9638] .bus_add_driver+0x90/0x1fc
[c00000000f1a3ae0] [c0000000002ca930] .driver_register+0x94/0xb0
[c00000000f1a3b60] [d000000000176838] .__hpsb_register_protocol+0x40/0xac [ieee1394]
[c00000000f1a3bf0] [d0000000002b602c] .sbp2_module_init+0x9c/0xe0 [sbp2]
[c00000000f1a3c80] [c0000000000a2200] .sys_init_module+0x1644/0x1804
[c00000000f1a3e30] [c0000000000086c8] syscall_exit+0x0/0x40

Using PowerMac machine description
Page orders: linear mapping = 24, virtual = 12, io = 12
Found initrd at 0xc000000001500000:0xc000000001761000
Found U3 memory controller & host bridge @ 0xf8000000 revision: 0x32
Mapped at 0xd000080080000000
Found a K2 mac-io controller, rev: 32, mapped at 0xd000080080041000
PowerMac motherboard: PowerMac G5
DART: table not allocated, using direct DMA
Starting Linux PPC64 #1 SMP 2007/08/01 11:54:17 UTC
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0x10000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc00000000f800000
htab_hash_mask                = 0x7fff
-----------------------------------------------------
Linux version 2.6.22.1-20070801_sbp2_test-ppc64 (geeko@buildhost) (gcc version 4.1.3 20070724 (prerelease) (SUSE Linux)) #1 SMP 2007/08/01 11:54:17 UTC
[boot]0012 Setup Arch
Top of RAM: 0x10000000, Total RAM: 0x10000000
Memory hole size: 0MB
Entering add_active_range(0, 0, 65536) 0 entries of 256 used
Found U3-AGP PCI host bridge.  Firmware bus number: 240->255
Can't get bus-range for /ht@0,f2000000, assume bus 0
Found U3-HT PCI host bridge.  Firmware bus number: 0->239
PCI Host 0, io start: 400000; io end: bfffff
PCI Host 1, io start: 0; io end: 3fffff
via-pmu: Server Mode is disabled
PMU driver v2 initialized for Core99, firmware: 0c
nvram: Checking bank 0...
nvram: gen0=493, gen1=492
nvram: Active bank is: 0
nvram: OF partition at 0x410
nvram: XP partition at 0x1020
nvram: NR partition at 0x1120
Zone PFN ranges:
  DMA             0 ->    65536
  Normal      65536 ->    65536
early_node_map[1] active PFN ranges
    0:        0 ->    65536
On node 0 totalpages: 65536
  DMA zone: 896 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 64640 pages, LIFO batch:15
  Normal zone: 0 pages used for memmap
[boot]0015 Setup Done
Built 1 zonelists.  Total pages: 64640
Kernel command line: root=/dev/disk/by-id/scsi-SATA_ST380013AS_3JV58BWX-part8  quiet sysrq=1 panic=42 
mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
mpic: ISU size: 120, shift: 7, mask: 7f
mpic: Initializing for 120 sources
mpic: Setting up MPIC " MPIC 2   " version 1.2 at f8040000, max 4 CPUs
mpic: ISU size: 120, shift: 7, mask: 7f
mpic: Initializing for 120 sources
PID hash table entries: 1024 (order: 10, 8192 bytes)
time_init: decrementer frequency = 33.333333 MHz
time_init: processor frequency   = 1600.000000 MHz
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
freeing bootmem node 0
Memory: 242784k/262144k available (5852k kernel code, 19360k reserved, 1376k data, 1099k bss, 292k init)
Calibrating delay loop... 66.56 BogoMIPS (lpj=332800)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
PowerMac SMP probe found 1 cpus
Brought up 1 CPUs
NET: Registered protocol family 16
KeyWest i2c @0xf8001003 irq 42 /u3@0,f8000000/i2c@f8001000
 channel 0 bus <multibus>
 channel 1 bus <multibus>
KeyWest i2c @0x80018000 irq 26 /ht@0,f2000000/pci@3/mac-io@7/i2c@18000
 channel 0 bus <multibus>
PMU i2c /ht@0,f2000000/pci@3/mac-io@7/via-pmu@16000/pmu-i2c
 channel 1 bus <multibus>
 channel 2 bus <multibus>
CPU Hotplug not supported by firmware - disabling.
PCI: Probing PCI hardware
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@2
mapping IO f0000000 -> d000080000400000, size: 800000
mapping IO f4000000 -> d000080000000000, size: 400000
PCI: Probing PCI hardware done
Registering pmac pic with sysfs...
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
TCP established hash table entries: 8192 (order: 5, 196608 bytes)
TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 2436k freed
nvram_init: Could not find nvram partition for nvram buffered error logging.
rtas_flash: no firmware flash support
IBM eBus Device Driver
Registering G5 CPU frequency driver
Frequency method: i2c/pfunc, Voltage method: i2c/pfunc
Low: 1301 Mhz, High: 1600 Mhz, Cur: 1600 MHz
audit: initializing netlink socket (disabled)
audit(1185990676.600:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
rpadlpar_io_init: partition not DLPAR capable
nvidiafb: Device ID: 10de0321 
nvidiafb: CRTC0 analog not found
nvidiafb: CRTC1 analog found
nvidiafb: EDID found from BUS1
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
nvidiafb: Found OF EDID for head 2
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 1appears to have a CRT attached
nvidiafb: Using CRT on CRTC 1
Trying to im_free nonexistent area (d0000800800c1000)
Console: switching to colour frame buffer device 160x64
nvidiafb: PCI nVidia NV32 framebuffer (64MB @ 0xA8000000)
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Generic RTC Driver v1.07
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
pmac_zilog: Error registering serial device, disabling pmac_zilog.
pmac_zilog: Did another serial driver already claim the minors?
Trying to im_free nonexistent area (d000080082152000)
Trying to im_free nonexistent area (d000080082154000)
MacIO PCI driver attached to K2 chipset
input: Macintosh mouse button emulation as /class/input/input0
PowerMac G5 Thermal control driver 1.3
Detected fan controls:
  0: PWM fan, id 1, location: BACKSIDE,SYS CTRLR FAN
  1: RPM fan, id 2, location: DRIVE BAY
  2: PWM fan, id 2, location: SLOT,PCI FAN
  3: RPM fan, id 3, location: CPU A INTAKE
  4: RPM fan, id 4, location: CPU A EXHAUST
  5: RPM fan, id 5, location: CPU B INTAKE
  6: RPM fan, id 6, location: CPU B EXHAUST
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PCI: Enabling device: (0001:03:0d.0), cmd 16
ide0: Found Apple K2 ATA-6 controller, bus ID 3, irq 39
Probing IDE interface ide0...
hda: PIONEER DVD-RW DVR-106D, ATAPI CD/DVD-ROM drive
hda: Enabling Ultra DMA 2
ide0 at 0xd00008008729a000-0xd00008008729a007,0xd00008008729a160 on irq 39
PCI: Enabling device: (0001:02:0b.2), cmd 6
ehci_hcd 0001:02:0b.2: EHCI Host Controller
ehci_hcd 0001:02:0b.2: new USB bus registered, assigned bus number 1
ehci_hcd 0001:02:0b.2: irq 63, io mem 0x80100000
ehci_hcd 0001:02:0b.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device: (0001:01:08.0), cmd 2
ohci_hcd 0001:01:08.0: OHCI Host Controller
ohci_hcd 0001:01:08.0: new USB bus registered, assigned bus number 2
ohci_hcd 0001:01:08.0: irq 27, io mem 0x80081000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PCI: Enabling device: (0001:01:09.0), cmd 2
ohci_hcd 0001:01:09.0: OHCI Host Controller
ohci_hcd 0001:01:09.0: new USB bus registered, assigned bus number 3
ohci_hcd 0001:01:09.0: irq 28, io mem 0x80080000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PCI: Enabling device: (0001:02:0b.0), cmd 2
ohci_hcd 0001:02:0b.0: OHCI Host Controller
ohci_hcd 0001:02:0b.0: new USB bus registered, assigned bus number 4
ohci_hcd 0001:02:0b.0: irq 63, io mem 0x80102000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
PCI: Enabling device: (0001:02:0b.1), cmd 2
ohci_hcd 0001:02:0b.1: OHCI Host Controller
ohci_hcd 0001:02:0b.1: new USB bus registered, assigned bus number 5
ohci_hcd 0001:02:0b.1: irq 63, io mem 0x80101000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
mice: PS/2 mouse device common for all mice
PowerMac i2c bus pmu 2 registered
PowerMac i2c bus pmu 1 registered
PowerMac i2c bus mac-io 0 registered
PowerMac i2c bus u3 1 registered
PowerMac i2c bus u3 0 registered
FCU Initialized, RPM fan shift is 3
usb 5-2: new full speed USB device using ohci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
hub 5-2:1.0: USB hub found
hub 5-2:1.0: 3 ports detected
usb 5-2.1: new low speed USB device using ohci_hcd and address 3
usb 5-2.1: configuration #1 chosen from 1 choice
usb 5-2.3: new full speed USB device using ohci_hcd and address 4
usb 5-2.3: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech Apple Optical USB Mouse as /class/input/input1
input: USB HID v1.10 Mouse [Logitech Apple Optical USB Mouse] on usb-0001:02:0b.1-2.1
input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input2
input: USB HID v1.10 Keyboard [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:02:0b.1-2.3
input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input3
input: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:02:0b.1-2.3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using ppc64/970 performance monitoring.
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
input: PMU as /class/input/input4
Registered led device: pmu-front-led
Freeing unused kernel memory: 292k freed
ioctl32(showconsole:459): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffaaca8c) on /dev/console
ioctl32(showconsole:463): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffc4ba9c) on /dev/console
SCSI subsystem initialized
libata version 2.21 loaded.
sata_svw 0001:05:0c.0: version 2.2
scsi0 : sata_svw
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
ata1: SATA max UDMA/133 cmd 0xd0000800872a1000 ctl 0xd0000800872a1020 bmdma 0xd0000800872a1030 irq 16
ata2: SATA max UDMA/133 cmd 0xd0000800872a1100 ctl 0xd0000800872a1120 bmdma 0xd0000800872a1130 irq 16
ata3: SATA max UDMA/133 cmd 0xd0000800872a1200 ctl 0xd0000800872a1220 bmdma 0xd0000800872a1230 irq 16
ata4: SATA max UDMA/133 cmd 0xd0000800872a1300 ctl 0xd0000800872a1320 bmdma 0xd0000800872a1330 irq 16
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6: ST380013AS, 3.05, max UDMA/133
ata1.00: 156301488 sectors, multi 0: LBA48 
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: Maxtor 6Y080M0, YAR511W0, max UDMA/133
ata2.00: 156312576 sectors, multi 0: LBA 
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST380013AS       3.05 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6Y080M0   YAR5 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 156312576 512-byte hardware sectors (80032 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 156312576 512-byte hardware sectors (80032 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: [mac] sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
sd 1:0:0:0: [sdb] Attached SCSI disk
ioctl32(showconsole:1036): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ff7fee6c) on /dev/console
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ioctl32(showconsole:1107): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ff836d1c) on /dev/console
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected Apple U3 chipset
agpgart: configuring for size idx: 8
agpgart: AGP aperture is 32M @ 0x0
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
PHY ID: 2062e0, addr: 1
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0a:95:a6:5d:66 
eth0: Found BCM5421-K2 PHY
tg3.c:v3.77 (May 31, 2007)
PCI: Enabling device: (0001:06:03.0), cmd 6
hda: ATAPI 32X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
snd-aoa-fabric-layout: found bus with layout 36
snd-aoa-fabric-layout: Using PMF GPIOs
snd-aoa-codec-tas: found 'deq' node
snd-aoa-fabric-layout: can use this codec
snd-aoa-codec-tas: tas found, addr 0x35 on /ht@0,f2000000/pci@3/mac-io@7/i2c@18000/deq@6a
eth0: Tigon3 [partno(3C996B-T) rev 0105 PHY(5701)] (PCI:33MHz:64-bit) 10/100/1000Base-T Ethernet 00:04:76:f3:c2:4f
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
PCI: Enabling device: (0001:03:0e.0), cmd 2
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[40]  MMIO=[80200000-802007ff]  Max Packet=[4096]  IR/IT contexts=[8/8]
Adding 1023992k swap on /dev/sdb3.  Priority:-1 extents:1 across:1023992k
ioctl32(showconsole:1711): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffb5fcbc) on /dev/console (deleted)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
eth1: Link is up at 100 Mbps, full-duplex.
ioctl32(showconsole:1742): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffed5cbc) on /dev/console (deleted)
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sdb4: found reiserfs format "3.6" with standard journal
ReiserFS: sdb4: using ordered data mode
ReiserFS: sdb4: journal params: device sdb4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb4: checking transaction log (sdb4)
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00010410100036e0]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[000a95fffea65d66]
ReiserFS: sdb4: Using r5 hash to sort names
ieee1394: sbp2: failed to set 4GB DMA mask
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xd0000000002b48dc
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA PowerMac
Modules linked in: sbp2 loop dm_mod snd_aoa_codec_tas snd_aoa_fabric_layout snd_aoa snd_aoa_i2sbus snd_aoa_soundbus ohci1394 snd_pcm snd_page_alloc snd_timer snd ide_cd cdrom ieee1394 soundcore tg3 sungem sungem_phy uninorth_agp agpgart sg sd_mod sata_svw libata scsi_mod
NIP: d0000000002b48dc LR: d0000000002b48c8 CTR: c00000000008e0c0
REGS: c00000000f1a33f0 TRAP: 0300   Not tainted  (2.6.22.1-20070801_sbp2_test-ppc64)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24022424  XER: 20000000
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c000000000cba040[1776] 'modprobe' THREAD: c00000000f1a0000 CPU: 0
GPR00: d0000000002b48c8 c00000000f1a3670 d0000000002c8048 c00000000fccd6bc 
GPR04: 0000000000000080 0000000000000080 0000000000000000 f000ffffffffffff 
GPR08: 0000000000000001 0000000000000000 c0000000007e3ff0 0000000000000400 
GPR12: d0000000002b7300 c0000000005db880 0000000000000000 d00000000041b740 
GPR16: 0000000000000009 0000000000000000 d00000000041aec2 0000000010001d70 
GPR20: 0000000000000000 0000000000000000 d0000000002b9440 d000000000411000 
GPR24: c00000000fccd6bc c00000000fccd6d0 c000000001b01400 0000000000000000 
GPR28: fffffffffffffff4 c00000000fccd600 d0000000002c7b00 c00000000fccd600 
NIP [d0000000002b48dc] .sbp2_remove_device+0x78/0x498 [sbp2]
LR [d0000000002b48c8] .sbp2_remove_device+0x64/0x498 [sbp2]
Call Trace:
[c00000000f1a3670] [d0000000002b48c8] .sbp2_remove_device+0x64/0x498 [sbp2] (unreliable)
[c00000000f1a3730] [d0000000002b5f38] .sbp2_probe+0x77c/0x7d4 [sbp2]
[c00000000f1a37e0] [c0000000002ca2a0] .driver_probe_device+0x13c/0x200
[c00000000f1a3870] [c0000000002ca55c] .__driver_attach+0xb4/0x138
[c00000000f1a3900] [c0000000002c9174] .bus_for_each_dev+0x7c/0xd4
[c00000000f1a39c0] [c0000000002ca00c] .driver_attach+0x28/0x40
[c00000000f1a3a40] [c0000000002c9638] .bus_add_driver+0x90/0x1fc
[c00000000f1a3ae0] [c0000000002ca930] .driver_register+0x94/0xb0
[c00000000f1a3b60] [d000000000176838] .__hpsb_register_protocol+0x40/0xac [ieee1394]
[c00000000f1a3bf0] [d0000000002b602c] .sbp2_module_init+0x9c/0xe0 [sbp2]
[c00000000f1a3c80] [c0000000000a2200] .sys_init_module+0x1644/0x1804
[c00000000f1a3e30] [c0000000000086c8] syscall_exit+0x0/0x40
Instruction dump:
419e0018 480029f1 e8410028 e87f0110 48002a15 e8410028 48002a3d e8410028 
3b1f00bc e93f00e0 3b3f00d0 7f03c378 <eb490000> 48002811 e8410028 7c771b78 
fuse init (API version 7.8)
ioctl32(showconsole:1843): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffadecdc) on /dev/console (deleted)
ioctl32(showconsole:1980): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffe5acfc) on /dev/console
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (1024 buckets, 8192 max)
ioctl32(showconsole:2134): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ff8c9c6c) on /dev/tty0
ioctl32(showconsole:2523): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ff94babc) on /dev/tty0
eth1: Link is up at 100 Mbps, full-duplex.
eth1: Pause is enabled (rxfifo: 10240 off: 7168 on: 5632)
audit(1185990717.111:2): audit_backlog_limit=320 old=64 by auid=4294967295 res=1
audit(1185990717.571:3): audit_pid=3154 old=0 by auid=4294967295
