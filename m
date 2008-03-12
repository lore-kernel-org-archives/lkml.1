Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYCLBi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYCLBi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYCLBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:38:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59441 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYCLBiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:38:18 -0400
Message-Id: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
Subject: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: penguin-kernel@i-love.sakura.ne.jp
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 10:37:41 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I encountered

  BUG: unable to handle kernel paging request at de92efe8
  IP: [<c017e0bb>] mnt_want_write+0x40/0x5f

2.6.25-rc5 works fine.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.25-rc5-mm1

Regards.

---------- dmesg ----------

Linux version 2.6.25-rc5-mm1 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Wed Mar 12 10:28:13 JST 2008
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
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
Processor #0 6:15 APIC version 17
Processor #1 6:15 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: root=/dev/sda1 ro console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0524000 soft=c0522000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1994.930 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1024 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 510616k/524288k available (2345k kernel code, 12980k reserved, 1268k data, 584k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff84000 - 0xfffff000   ( 492 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc048d000 - 0xc051f000   ( 584 kB)
      .data : 0xc034a703 - 0xc0487ab0   (1268 kB)
      .text : 0xc0100000 - 0xc034a703   (2345 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay using timer specific routine.. 4004.49 BogoMIPS (lpj=8008983)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
lockdep: fixing up alternatives.
Booting processor 1/1 ip 2000
CPU 1 irqstacks, hard=c0525000 soft=c0523000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3993.54 BogoMIPS (lpj=7987097)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Total of 2 processors activated (7998.04 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
khelper used greatest stack depth: 2684 bytes left
net_namespace: 320 bytes
NET: Registered protocol family 16
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 1, comm: swapper Not tainted 2.6.25-rc5-mm1 #1
 [<c013dd91>] __lock_acquire+0x194/0x6a3
 [<c0167ded>] ? cache_free_debugcheck+0x1fd/0x219
 [<c0168938>] ? kfree+0xdb/0xe5
 [<c013e775>] lock_acquire+0x6a/0x87
 [<c01368e4>] ? down+0xc/0x2f
 [<c03492b1>] _spin_lock_irqsave+0x25/0x55
 [<c01368e4>] ? down+0xc/0x2f
 [<c01368e4>] down+0xc/0x2f
 [<c022caf3>] device_add+0x152/0x243
 [<c022cbf6>] device_register+0x12/0x15
 [<c022ce9b>] device_create+0x76/0x90
 [<c04a1861>] vtconsole_class_init+0x72/0xb9
 [<c048d8ae>] ? kernel_init+0x0/0x88
 [<c048d784>] do_initcalls+0x59/0x134
 [<c014bcb1>] ? register_irq_proc+0xb1/0xca
 [<c01a0000>] ? proc_symlink+0x5/0x73
 [<c048d8ae>] ? kernel_init+0x0/0x88
 [<c048d87b>] do_basic_setup+0x1c/0x1e
 [<c048d8fb>] kernel_init+0x4d/0x88
 [<c01045b7>] kernel_thread_helper+0x7/0x10
 =======================
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
PCI->APIC IRQ transform: 0000:00:10.0[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:11.0[A] -> IRQ 18
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
debug: unmapping init memory dfdd7000..dfee0000
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
Initializing RT-Tester: OK
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 997 for ipc namespace c045d3e0
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:0f.0: Boot video device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
PIIX4: IDE port disabled
    ide0: BM-DMA at 0x1058-0x105f
Probing IDE interface ide0...
hda: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x170-0x177,0x376 on irq 15
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: ATAPI 1X CD-ROM drive, 32kB Cache
Uniform CD-ROM driver Revision: 3.20
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
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 5d 00 00 00
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 5d 00 00 00
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 5d 00 00 00
sd 0:0:1:0: [sdb] Cache data unavailable
sd 0:0:1:0: [sdb] Assuming drive cache: write through
sd 0:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 5d 00 00 00
sd 0:0:1:0: [sdb] Cache data unavailable
sd 0:0:1:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 0:0:1:0: [sdb] Attached SCSI disk
Driver 'sr' needs updating - please use bus_type methods
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
EDAC MC: Ver: 2.1.0 Mar 12 2008
EISA: Probing bus 0 at eisa.0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 1060KiB [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly.
mount used greatest stack depth: 2620 bytes left
linuxrc used greatest stack depth: 2344 bytes left
debug: unmapping init memory c048d000..c051f000
Write protecting the kernel text: 2348k
Write protecting the kernel read-only data: 1052k
initrd-tools: 0.1.81.1
BUG: unable to handle kernel paging request at de92efe8
IP: [<c017e0bb>] mnt_want_write+0x40/0x5f
*pde = 1ec02163 *pte = 1e92e160
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file:
Modules linked in:

Pid: 1, comm: init Not tainted (2.6.25-rc5-mm1 #1)
EIP: 0060:[<c017e0bb>] EFLAGS: 00010286 CPU: 1
EIP is at mnt_want_write+0x40/0x5f
EAX: 00000000 EBX: c14a3460 ECX: 00000001 EDX: de92ef78
ESI: de926f78 EDI: 00000000 EBP: df8e1ef8 ESP: df8e1eec
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process init (pid: 1, ti=df8e1000 task=df8f8020 task.ti=df8e1000)
Stack: ffffffeb 00000200 df8e1f28 df8e1f84 c017346d 00000003 00000000 df8f8020
       00000002 00008242 00000000 00000002 00008241 de926f78 df55ff50 de926f78
       df55ff50 92aaee34 0000000d df24f010 00000300 00000000 00000000 df8e1f60
Call Trace:
 [<c017346d>] ? do_filp_open+0x233/0x52f
 [<c03496b3>] ? _spin_unlock+0x1d/0x20
 [<c016aaac>] ? do_sys_open+0x3f/0xbe
 [<c016ab41>] ? sys_open+0x16/0x18
 [<c0103966>] ? syscall_call+0x7/0xb
 =======================
Code: 53 8d 1c 02 89 d8 e8 c7 b4 1c 00 89 f0 e8 7e ff ff ff 85 c0 74 07 bf e2 ff ff ff eb 1f 8b 53 2c 39 f2 74 15 85 d2 74 0e 8b 43 28 <f0> 01 42 70 c7 43 28
 00 00 00 00 89 73 2c ff 43 28 89 d8 e8 c3
EIP: [<c017e0bb>] mnt_want_write+0x40/0x5f SS:ESP 0068:df8e1eec
---[ end trace 6f0b2838d1d55c90 ]---
Kernel panic - not syncing: Attempted to kill init!
