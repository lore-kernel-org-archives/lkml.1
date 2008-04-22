Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbYDVHuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbYDVHuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYDVHuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:50:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62389 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbYDVHt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:49:58 -0400
Message-Id: <200804220749.m3M7nufm061384@www262.sakura.ne.jp>
Subject: [BUG] NULL pointer dereference in uart_write_room().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Apr 2008 16:49:56 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I always encounter NULL pointer dereference at uart_write_room()
when "console=ttyS0,115200n8" is added to kernel's command line
if the kernel is built with specific kernel config.

  static int uart_write_room(struct tty_struct *tty)
  {
          struct uart_state *state = tty->driver_data;
  
          return uart_circ_chars_free(&state->info->xmit);
  }

Kernel configs are at
  http://I-love.SAKURA.ne.jp/tmp/config-2.6.23.17
  http://I-love.SAKURA.ne.jp/tmp/config-2.6.25

I don't know whether it is correct fix to add non-NULL check
in uart_write_room() like uart_write().

Regards.
------------------------------------------------------------
Linux version 2.6.23.17 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Tue Apr 22 15:19:28 JST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
 BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
512MB LOWMEM available.
found SMP MP-table at 000f6c90
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131072
  HighMem    131072 ->   131072
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131072
DMI present.
Using APIC driver default
ACPI: RSDP 000F6C20, 0014 (r0 PTLTD )
ACPI: RSDT 1FEFAB68, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FEFEF14, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 1FEFAB98, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 1FEFFFC0, 0040
ACPI: APIC 1FEFEF88, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 1FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000ca000
swsusp: Registered nosave memory region: 00000000000ca000 - 00000000000cc000
swsusp: Registered nosave memory region: 00000000000cc000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
swsusp: Registered nosave memory region: 000000001fef0000 - 000000001feff000
swsusp: Registered nosave memory region: 000000001feff000 - 000000001ff00000
Built 1 zonelists in Zone order.  Total pages: 130048
Kernel command line: root=/dev/sda1 ro ramdisk_size=8192 console=ttyS0,115200n8 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1994.867 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 510172k/524288k available (2277k kernel code, 13448k reserved, 831k data, 292k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe13000 - 0xfffff000   (1968 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc0410000 - 0xc0459000   ( 292 kB)
      .data : 0xc033978f - 0xc0409580   ( 831 kB)
      .text : 0xc0100000 - 0xc033978f   (2277 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3995.44 BogoMIPS (lpj=7990892)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Total of 1 processors activated (3995.44 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-103f claimed by PIIX4 ACPI
PCI quirk: region 1040-104f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 786432 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
Freeing initrd memory: 5092k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1208878166.328:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
loop: module loaded
USB Universal Host Controller Interface driver v3.0
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
Switched to high resolution mode on CPU 0
md: raid1 personality registered for level 1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 5092KiB [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly.
Freeing unused kernel memory: 292k freed
initrd-tools: 0.1.81.1
mount: unknown filesystem type 'devfs'
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 16
scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x1060, IRQ Channel: 16/Level
scsi0:   PCI Bus: 0, Device: 16, Address: 0xE8800000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0 : BusLogic BT-958
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi 0:0:1:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi 0:0:2:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Cache data unavailable
sd 0:0:1:0: [sdb] Assuming drive cache: write through
sd 0:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Cache data unavailable
sd 0:0:1:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:2:0: [sdc] 41943040 512-byte hardware sectors (21475 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Cache data unavailable
sd 0:0:2:0: [sdc] Assuming drive cache: write through
sd 0:0:2:0: [sdc] 41943040 512-byte hardware sectors (21475 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Cache data unavailable
sd 0:0:2:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 0:0:2:0: [sdc] Attached SCSI disk
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
FATAL: Could not open '/lib/modules/2.6.23.17/kernel/drivers/net/pcnet32.ko': No such file or directory
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:pio
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 1X CD-ROM drive, 32kB Cache
Uniform CD-ROM driver Revision: 3.20
Linux agpgart interface v0.102
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 256M @ 0x0
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
umount: devfs: not mounted
mount: unknown filesystem type 'devfs'
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
umount: devfs: not mounted

INIT: version 2.86 booting

Activating swap.
Checking root file system...
fsck 1.37 (21-Mar-2005)
/: clean, 165491/524288 files, 890283/1048233 blocks
EXT3 FS on sda1, internal journal
System time was Tue Apr 22 06:29:36 UTC 2008.
Setting the System Clock using the Hardware Clock as reference...
System Clock set. System local time is now Tue Apr 22 15:29:38 JST 2008.
Cleaning up ifupdown...done.
Calculating module dependencies... done.
Loading modules...
    ide-cd
    ide-detect
FATAL: Module ide_detect not found.
    ide-disk
    psmouse
    sd_mod
All modules loaded.
Checking all file systems...
fsck 1.37 (21-Mar-2005)
Setting kernel variables ...
... done.
Mounting local filesystems...
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb1 on /usr/src/vanilla type ext3 (rw,noatime,nodiratime)
/dev/sdc1 on /usr/src/distro type ext3 (rw,noatime,nodiratime)
Detecting hardware: agpgart pcnet32 piix BusLogic ide_scsi
Skipping already loaded module agpgart.
Loading pcnet32 module.
pcnet32.c:v1.33 27.Jun.2006 tsbogend@alpha.franken.de
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 18 (level, low) -> IRQ 17
pcnet32: PCnet/PCI II 79C970A at 0x1080, 00 0c 29 9e eb 32 assigned IRQ 17.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
Skipping already loaded module piix.
Skipping already loaded module BusLogic.
Loading ide_scsi module.
Running 0dns-down to make sure resolv.conf is ok...done.
Setting up networking...done.
Starting hotplug subsystem:
   pci     
     intel-agp: already loaded
     ata_generic: loaded successfully
     ata_piix: loaded successfully
     generic: loaded successfully
     piix: already loaded
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
     i2c-piix4: loaded successfully
     ignoring pci display device 00:0f.0
     BusLogic: already loaded
     pcnet32: already loaded
   pci      [success]
   usb     
mount: usbfs already mounted or /proc/bus/usb busy
mount: according to mtab, usbfs is already mounted on /proc/bus/usb
   usb      [failed]
   isapnp  
     psmouse: loaded sucessfully
     parport_pc: loaded sucessfully
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c
 printing eip:
c027538d
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: 8250_pnp i2c_piix4 i2c_core generic ata_piix ata_generic libata ide_scsi pcnet32 floppy parport_pc parport intel_agp agpgart piix mii tsdev evdev psmouse ide_disk ide_cd cdrom ide_core sd_mod BusLogic scsi_mod
CPU:    0
EIP:    0060:[<c027538d>]    Not tainted VLI
EFLAGS: 00010296   (2.6.23.17 #2)
EIP is at uart_write_room+0xd/0x20
eax: df992c00   ebx: dfeb1c00   ecx: 00000022   edx: 00000000
esi: 00000022   edi: 00000000   ebp: df177eac   esp: df177e98
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process isapnp.rc (pid: 1738, ti=df176000 task=df7b2570 task.ti=df176000)
Stack: c0263749 df7f2400 fffffff2 00000022 00000000 df177f14 c0265604 dfeb1d2c 
       df7f2400 df7f2400 dfbf4540 dfeb1c00 00000000 df7b2570 c0127ca0 00000000 
       00000000 00000000 00000008 c012392f 00000000 df7b2570 c0127ca0 dfeb1d30 
Call Trace:
 [<c01060dc>] show_trace_log_lvl+0x1c/0x40
 [<c01061ba>] show_stack_log_lvl+0x9a/0xc0
 [<c0106416>] show_registers+0x1d6/0x2c0
 [<c0106666>] die+0x106/0x230
 [<c0122452>] do_page_fault+0x292/0x660
 [<c0338a4a>] error_code+0x72/0x78
 [<c0265604>] write_chan+0x184/0x210
 [<c026080e>] tty_write+0x16e/0x1e0
 [<c0260902>] redirected_tty_write+0x82/0x90
 [<c01881e6>] vfs_write+0xc6/0x160
 [<c0188331>] sys_write+0x41/0x70
 [<c010530a>] syscall_call+0x7/0xb
 =======================
Code: 9d 8b 55 e0 8b 45 e8 e8 72 34 0c 00 8b 45 f0 e8 2a fa ff ff 8b 45 dc e9 50 ff ff ff 89 f6 55 8b 80 58 01 00 00 89 e5 5d 8b 50 10 <8b> 42 0c 8b 4a 08 29 c8 48 25 ff 0f 00 00 c3 8d 74 26 00 55 8b 
EIP: [<c027538d>] uart_write_room+0xd/0x20 SS:ESP 0068:df177e98
------------------------------------------------------------
Linux version 2.6.25 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Tue Apr 22 16:37:55 JST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
 BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
512MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f6c90] 000f6c90
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131072
  HighMem    131072 ->   131072
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131072
DMI present.
Using APIC driver default
ACPI: RSDP 000F6C20, 0014 (r0 PTLTD )
ACPI: RSDT 1FEFAB68, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FEFEF14, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 1FEFAB98, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 1FEFFFC0, 0040
ACPI: APIC 1FEFEF88, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 1FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ca000
PM: Registered nosave memory: 00000000000ca000 - 00000000000cc000
PM: Registered nosave memory: 00000000000cc000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
PM: Registered nosave memory: 000000001fef0000 - 000000001feff000
PM: Registered nosave memory: 000000001feff000 - 000000001ff00000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: root=/dev/sda1 ro ramdisk_size=8192 console=ttyS0,115200n8 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1994.918 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 509968k/524288k available (2328k kernel code, 13608k reserved, 834k data, 272k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc0420000 - 0xc0464000   ( 272 kB)
      .data : 0xc03463b1 - 0xc0416d1c   ( 834 kB)
      .text : 0xc0100000 - 0xc03463b1   (2328 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3995.76 BogoMIPS (lpj=7991536)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 20k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Total of 1 processors activated (3995.76 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
net_namespace: 548 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
Freeing initrd memory: 5180k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1208882494.336:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
USB Universal Host Controller Interface driver v3.0
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
md: raid1 personality registered for level 1
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 5180KiB [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly.
Freeing unused kernel memory: 272k freed
initrd-tools: 0.1.81.1
mount: unknown filesystem type 'devfs'
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 17
scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x1060, IRQ Channel: 17/Level
scsi0:   PCI Bus: 0, Device: 16, Address: 0xE8800000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0 : BusLogic BT-958
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi 0:0:1:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi 0:0:2:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Cache data unavailable
sd 0:0:1:0: [sdb] Assuming drive cache: write through
sd 0:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Cache data unavailable
sd 0:0:1:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:2:0: [sdc] 41943040 512-byte hardware sectors (21475 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Cache data unavailable
sd 0:0:2:0: [sdc] Assuming drive cache: write through
sd 0:0:2:0: [sdc] 41943040 512-byte hardware sectors (21475 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Cache data unavailable
sd 0:0:2:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 0:0:2:0: [sdc] Attached SCSI disk
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
FATAL: Could not open '/lib/modules/2.6.25/kernel/drivers/net/pcnet32.ko': No such file or directory
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
PIIX4: IDE port disabled
    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:PIO
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
Linux agpgart interface v0.103
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 256M @ 0x0
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
umount: devfs: not mounted
mount: unknown filesystem type 'devfs'
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
umount: devfs: not mounted

INIT: version 2.86 booting

Activating swap.
Checking root file system...
fsck 1.37 (21-Mar-2005)
/: clean, 167042/524288 files, 904192/1048233 blocks
EXT3 FS on sda1, internal journal
System time was Tue Apr 22 07:41:42 UTC 2008.
Setting the System Clock using the Hardware Clock as reference...
System Clock set. System local time is now Tue Apr 22 16:41:44 JST 2008.
Cleaning up ifupdown...done.
Calculating module dependencies... done.
Loading modules...
    ide-cd
hdc: ATAPI 1X CD-ROM drive, 32kB Cache
Uniform CD-ROM driver Revision: 3.20
    ide-detect
FATAL: Module ide_detect not found.
    ide-disk
    psmouse
    sd_mod
All modules loaded.
Checking all file systems...
fsck 1.37 (21-Mar-2005)
Setting kernel variables ...
... done.
Mounting local filesystems...
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb1 on /usr/src/vanilla type ext3 (rw,noatime,nodiratime)
/dev/sdc1 on /usr/src/distro type ext3 (rw,noatime,nodiratime)
Detecting hardware: agpgart pcnet32 piix BusLogic ide_scsi
Skipping already loaded module agpgart.
Loading pcnet32 module.
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 18 (level, low) -> IRQ 18
pcnet32: PCnet/PCI II 79C970A at 0x1080, 00:0c:29:9e:eb:32 assigned IRQ 18.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
Skipping already loaded module piix.
Skipping already loaded module BusLogic.
Loading ide_scsi module.
Running 0dns-down to make sure resolv.conf is ok...done.
Setting up networking...done.
Starting hotplug subsystem:
   pci     
     intel-agp: already loaded
No dock devices found.
     ata_generic: loaded successfully
     ata_piix: loaded successfully
     ide-pci-generic: loaded successfully
     piix: already loaded
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
     i2c-piix4: loaded successfully
     ignoring pci display device 00:0f.0
     BusLogic: already loaded
     pcnet32: already loaded
   pci      [success]
   usb     
mount: usbfs already mounted or /proc/bus/usb busy
mount: according to mtab, usbfs is already mounted on /proc/bus/usb
   usb      [failed]
   isapnp  
     psmouse: loaded sucessfully
     parport_pc: loaded sucessfully
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c0274f7d>] uart_write_room+0xd/0x20
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: 8250_pnp i2c_piix4 i2c_core ide_pci_generic ata_piix ata_generic libata dock ide_scsi pcnet32 ide_cd_mod cdrom floppy parport_pc parport intel_agp agpgart piix mii evdev psmouse ide_disk ide_core sd_mod BusLogic scsi_mod

Pid: 1797, comm: isapnp.rc Not tainted (2.6.25 #2)
EIP: 0060:[<c0274f7d>] EFLAGS: 00010296 CPU: 0
EIP is at uart_write_room+0xd/0x20
EAX: df8e79c0 EBX: de88b800 ECX: 00000022 EDX: 00000000
ESI: 00000022 EDI: 00000000 EBP: df8fbeac ESP: df8fbe98
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process isapnp.rc (pid: 1797, ti=df8fa000 task=df4590b0 task.ti=df8fa000)
Stack: c0262d19 de891c00 fffffff2 00000022 00000000 df8fbf14 c0264cc4 de88b918 
       de891c00 de891c00 df4626c0 de88b800 00000000 df4590b0 c0122cb0 00000000 
       00000000 c1029ee0 00000000 c1029ee0 00000000 df4590b0 c0122cb0 de88b91c 
Call Trace:
 [<c0262d19>] ? opost_block+0x19/0x110
 [<c0264cc4>] ? write_chan+0x184/0x210
 [<c0122cb0>] ? default_wake_function+0x0/0x10
 [<c0122cb0>] ? default_wake_function+0x0/0x10
 [<c0212737>] ? copy_from_user+0x37/0x70
 [<c025fe2e>] ? tty_write+0x15e/0x1d0
 [<c0264b40>] ? write_chan+0x0/0x210
 [<c025ff22>] ? redirected_tty_write+0x82/0x90
 [<c01865b3>] ? vfs_write+0xa3/0x130
 [<c01866f1>] ? sys_write+0x41/0x70
 [<c0105c32>] ? syscall_call+0x7/0xb
 =======================
Code: 9d 8b 55 e0 8b 45 e8 e8 52 05 0d 00 8b 45 f0 e8 3a fa ff ff 8b 45 dc e9 50 ff ff ff 89 f6 55 8b 80 44 01 00 00 89 e5 5d 8b 50 10 <8b> 42 0c 8b 4a 08 29 c8 48 25 ff 0f 00 00 c3 8d 74 26 00 55 8b 
EIP: [<c0274f7d>] uart_write_room+0xd/0x20 SS:ESP 0068:df8fbe98
---[ end trace 14c240b2ffcab734 ]---
------------------------------------------------------------
