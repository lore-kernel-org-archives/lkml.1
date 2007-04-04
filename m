Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXDDUxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXDDUxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXDDUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:53:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45664 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbXDDUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:53:34 -0400
Subject: Re: 2.6.21-rc5-mm4 (SLUB powerpc)
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704041034270.26866@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
	 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
	 <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041003170.24640@schroedinger.engr.sgi.com>
	 <1175708002.6185.29.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041034270.26866@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 13:53:36 -0700
Message-Id: <1175720017.5019.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:35 -0700, Christoph Lameter wrote: 
> On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> 
> > Next issue ? Sorry.
> 
> No problem. Could have a look at the hvsi driver and figure out what is 
> failing there? What is the hvsi driver?
> 
> > Console: switching to colour frame buffer device 80x30
> > fb0: MATROX frame buffer device
> > matroxfb_crtc2: secondary head of fb0 was registered as fb1
> > Kernel panic - not syncing: Couldn't register hvsi console driver
> 
> Framebuffer allocation failure????
> 

It looks like.. hvsi.c:

if (tty_register_driver(hvsi_driver))
                panic("Couldn't register hvsi console driver\n");

I added printk() in all failure cases in tty_register_driver()
and I can't reproduce the problem.

Machine tries to boot and goes further and hangs. I saw similar
hang with RSDL earlier.

Thanks,
Badari

Welcome to yaboot version 10.1.5-r625.SuSE
booted from '/pci@800000020000003/pci@2,2/pci1069,b166@1/scsi@0/sd@4,0'
Enter "help" to get some basic usage information
boot: 2621rc5mm4
Please wait, loading kernel...
Allocated 0x00400000 bytes for executable @ 0x00400000
   Elf32 kernel loaded...

zImage starting: loaded at 0x00400000 (sp: 0x01a3fe60)
Allocating 0x806af0 bytes for kernel ...
OF version = 'IBM,SF225_096'
gunzipping (0x01c00000 <- 0x00408000:0x006a4cd2)...done 0x741f90 bytes
Finalizing device tree... using OF tree (promptr=00c39a50)
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/sda2 xmon=on slub_debug
memory layout at init:
  alloc_bottom : 000000000240b000
  alloc_top    : 0000000008000000
  alloc_top_hi : 00000001e8000000
  rmo_top      : 0000000008000000
  ram_top      : 00000001e8000000
Looking for displays
found display   : /pci@800000020000002/pci@2,2/pci@1/display@0,
opening ... done
instantiating rtas at 0x00000000077ca000 ... done
0000000000000000 : boot cpu     0000000000000000
0000000000000002 : starting cpu hw idx 0000000000000002... done
0000000000000004 : starting cpu hw idx 0000000000000004... done
0000000000000006 : starting cpu hw idx 0000000000000006... done
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x000000000240c000 -> 0x000000000240d2fe
Device tree struct  0x000000000240e000 -> 0x0000000002423000
Calling quiesce ...
returning from prom_init
Partition configured for 8 cpus.
Starting Linux PPC64 #5 SMP Wed Apr 4 10:55:34 PDT 2007
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1e8000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0x0000000000000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Linux version 2.6.21-rc4-mm1-ppc64 (root@elm3a121) (gcc version 4.1.0
(SUSE Linux)) #5 SMP Wed Apr 4 10:55:34 PDT 2007
[boot]0012 Setup Arch
No ramdisk, default root is /dev/sda2
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 8192 bytes
Zone PFN ranges:
  DMA             0 ->  1998848
  Normal    1998848 ->  1998848
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->   974848
    1:   974848 ->  1998848
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 1971520
Kernel command line: root=/dev/sda2 xmon=on slub_debug
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg-1] -> real [hvc0]
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 7855772k/7995392k available (5992k kernel code, 139620k
reserved, 1224k data, 814k bss, 272k init)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
Processor 1 found.
Processor 2 found.
Processor 3 found.
Processor 4 found.
Processor 5 found.
Processor 6 found.
Processor 7 found.
Brought up 8 CPUs
migration_cost=0,3,25
NET: Registered protocol family 16
IOMMU table initialized, virtual merging enabled
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
vio_bus_init: device_register returned -19
IBM eBus Device Driver
audit: initializing netlink socket (disabled)
audit(1175719341.610:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Registering unionfs 2.0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
rpaphp: Slot [0001:00:02.0](PCI location=U7879.001.DQD02PW-P1-C3)
registered
rpaphp: Slot [0001:00:02.2](PCI location=U7879.001.DQD02PW-P1-C4)
registered
rpaphp: Slot [0001:00:02.4](PCI location=U7879.001.DQD02PW-P1-C5)
registered
rpaphp: Slot [0001:00:02.6](PCI location=U7879.001.DQD02PW-P1-C6)
registered
rpaphp: Slot [0002:00:02.0](PCI location=U7879.001.DQD02PW-P1-C1)
registered
rpaphp: Slot [0002:00:02.6](PCI location=U7879.001.DQD02PW-P1-C2)
registered
matroxfb: Matrox G450 detected
PInS data found at offset 31168
PInS memtype = 5
matroxfb: 640x480x8bpp (virtual: 640x26214)
matroxfb: framebuffer at 0x40170000000, mapped to 0xd000080080004000,
size 33554432
Console: switching to colour frame buffer device 80x30
fb0: MATROX frame buffer device
matroxfb_crtc2: secondary head of fb0 was registered as fb1
Generic RTC Driver v1.07
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
disabled
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
RAMDISK driver initialized: 16 RAM disks of 123456K size 1024 blocksize
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000: 0000:d0:01.0: e1000_probe: (PCI-X:133MHz:64-bit)
00:09:6b:dd:0d:9c
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:d0:01.1: e1000_probe: (PCI-X:133MHz:64-bit)
00:09:6b:dd:0d:9d
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
ipr: IBM Power RAID SCSI Device Driver version: 2.3.1 (January 23, 2007)
ipr 0000:c0:01.0: Found IOA with IRQ: 83
ipr 0000:c0:01.0: Initializing IOA.
ipr 0000:c0:01.0: Starting IOA initialization sequence.
ipr 0000:c0:01.0: Adapter firmware version: 020A004E
ipr 0000:c0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
scsi 0:0:15:0: Enclosure         IBM      VSBPD3E   U4SCSI 4812 PQ: 0
ANSI: 2
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      570B001          0150 PQ:
0 ANSI: 0
ipr 0002:c8:01.0: Found IOA with IRQ: 117
ipr 0002:c8:01.0: Starting IOA initialization sequence.
ipr 0002:c8:01.0: Adapter firmware version: 020A004E
ipr 0002:c8:01.0: IOA initialized.
scsi1 : IBM 570B Storage Adapter
scsi 1:0:4:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0
ANSI: 4
scsi 1:0:5:0: Direct-Access     IBM      ST373453LC       C51A PQ: 0
ANSI: 3
scsi 1:0:15:0: Enclosure         IBM      VSBPD3E   U4SCSI 4812 PQ: 0
ANSI: 2
scsi: unknown device type 31
scsi 1:255:255:255: No Device         IBM      570B001          0150 PQ:
0 ANSI: 0
sd 1:0:4:0: [sda] 286748000 512-byte hardware sectors (146815 MB)
sd 1:0:4:0: [sda] Write Protect is off
sd 1:0:4:0: [sda] Write cache: disabled, read cache: enabled, supports
DPO and FUA
sd 1:0:4:0: [sda] 286748000 512-byte hardware sectors (146815 MB)
sd 1:0:4:0: [sda] Write Protect is off
sd 1:0:4:0: [sda] Write cache: disabled, read cache: enabled, supports
DPO and FUA
 sda: sda1 sda2
sd 1:0:4:0: [sda] Attached SCSI disk
sd 1:0:5:0: [sdb] 143374000 512-byte hardware sectors (73407 MB)
sd 1:0:5:0: [sdb] Write Protect is off
sd 1:0:5:0: [sdb] Write cache: disabled, read cache: enabled, supports
DPO and FUA
sd 1:0:5:0: [sdb] 143374000 512-byte hardware sectors (73407 MB)
sd 1:0:5:0: [sdb] Write Protect is off
sd 1:0:5:0: [sdb] Write cache: disabled, read cache: enabled, supports
DPO and FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:5:0: [sdb] Attached SCSI disk
ehci_hcd 0000:c8:01.2: EHCI Host Controller
ehci_hcd 0000:c8:01.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:c8:01.2: irq 85, io mem 0x400a0002000
ehci_hcd 0000:c8:01.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.21-rc4-mm1-ppc64 ehci_hcd
usb usb1: SerialNumber: 0000:c8:01.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd 0000:c8:01.0: OHCI Host Controller
ohci_hcd 0000:c8:01.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:c8:01.0: irq 85, io mem 0x400a0001000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.21-rc4-mm1-ppc64 ohci_hcd
usb usb2: SerialNumber: 0000:c8:01.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0000:c8:01.1: OHCI Host Controller
ohci_hcd 0000:c8:01.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:c8:01.1: irq 85, io mem 0x400a0000000
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.21-rc4-mm1-ppc64 ohci_hcd
usb usb3: SerialNumber: 0000:c8:01.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
mice: PS/2 mouse device common for all mice
async_tx: api initialized (sync-only)
xor: measuring software checksumming speed
   8regs     :  6358.800 MB/sec
   8regs_prefetch:  5449.200 MB/sec
   32regs    :  6944.000 MB/sec
   32regs_prefetch:  4956.800 MB/sec
xor: using function: 32regs (6944.000 MB/sec)
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: replayed 38 transactions in 7 seconds
ReiserFS: sda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 272k freed
Warning: unable to open an initial console.
ioctl32(showconsole:1020): Unknown cmd fd(0) cmd(40045432){00} arg
(ffb7cb48) on /dev/tty0
ioctl32(showconsole:1048): Unknown cmd fd(0) cmd(40045432){00} arg
(ffabdad8) on /dev/tty0
PDC20275: IDE controller at PCI slot 0002:d0:01.0
PDC20275: chipset revision 1
PDC20275: PLL input clock is 32814 kHz
PDC20275: 100% native mode on irq 119
    ide2: BM-DMA at 0x2eec00-0x2eec07, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x2eec08-0x2eec0f, BIOS settings: hdg:pio, hdh:pio
scsi 0:0:15:0: Attached scsi generic sg0 type 13
scsi 0:255:255:255: Attached scsi generic sg1 type 31
sd 1:0:4:0: Attached scsi generic sg2 type 0
sd 1:0:5:0: Attached scsi generic sg3 type 0
scsi 1:0:15:0: Attached scsi generic sg4 type 13
scsi 1:255:255:255: Attached scsi generic sg5 type 31
hde: IBM DROM00205, ATAPI CD/DVD-ROM drive
ide2 at 0x2ee400-0x2ee407,0x2edc02 on irq 119
hde: ATAPI 24X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
ReiserFS: sda2: Removing [653 745793 0x0 SD]..done
ReiserFS: sda2: There were 1 uncompleted unlinks/truncates. Completed
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-
devel@redhat.com
ioctl32(showconsole:1924): Unknown cmd fd(0) cmd(40045432){00} arg
(fffe8ad8) on /dev/tty0
loop: loaded (max 8 devices)
ioctl32(showconsole:2098): Unknown cmd fd(0) cmd(40045432){00} arg
(ffcb0ae8) on /dev/tty0
Adding 1050616k swap on /dev/sdb2.  Priority:-1 extents:1
across:1050616k
ioctl32(showconsole:2144): Unknown cmd fd(0) cmd(40045432){00} arg
(fffebb28) on /dev/tty0
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX
audit(1175719380.150:2): audit_pid=2789 old=0 by auid=4294967295
ioctl32(showconsole:3015): Unknown cmd fd(0) cmd(40045432){00} arg
(ffe0ca98) on /dev/tty0



