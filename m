Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbYEBFfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbYEBFfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYEBFf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:35:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63586 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYEBFf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:35:26 -0400
Message-Id: <200805020535.m425ZBti070010@www262.sakura.ne.jp>
Subject: Re: [BUG] NULL pointer dereference in uart_write_room().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: devzero@web.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 May 2008 14:35:11 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:
> > > Also, I sent a bug report to linux-serial@vger.kernel.org , but no response.
> > > http://lkml.org/lkml/2008/4/22/42
> > > If you know, please tell me whom to report.
> > 
> > I discussed this with Alan (cc'ed here) and he said something forgettable
> > which I forgot ;)
> 
> Yes I have looked at the traces and can make no sense of them.
> 
> > How repeatable is this?
> 
> and can you get a clear trace of where it blew up and what the trigger
> is ?
> 
It is 100% repeatable on VMware Workstation 6 environment.
I compiled kernel 2.6.25 while changing kernel config, and
it turned out that CONFIG_SERIAL_8250_PNP=m triggers this bug.
CONFIG_SERIAL_8250_PNP=y and CONFIG_SERIAL_8250_PNP=n do not trigger this bug,
so I think something is wrong with initialization of 8250_pnp module.

Regards.
------------------------------------------------------------
Linux version 2.6.25 (root@tomoyo) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Fri May 2 12:42:57 JST 2008
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
found SMP MP-table at [c00f6cd0] 000f6cd0
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131072
  HighMem    131072 ->   131072
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131072
DMI present.
Using APIC driver default
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 1FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 1FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 1FEFFFC0, 0040
ACPI: APIC 1FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 1FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 17
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
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
Kernel command line: root=UUID=bb7fd866-d530-4293-a666-009eca2d34ad ro console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1993.971 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 509084k/524288k available (2280k kernel code, 14484k reserved, 747k data, 276k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc03fe000 - 0xc0443000   ( 276 kB)
      .data : 0xc033a10e - 0xc03f4d40   ( 747 kB)
      .text : 0xc0100000 - 0xc033a10e   (2280 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 3995.24 BogoMIPS (lpj=7990498)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Booting processor 1/1 ip 4000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.70 BogoMIPS (lpj=7983408)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Total of 2 processors activated (7986.95 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 548 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
PCI: Transparent bridge - 0000:00:11.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)
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
PCI: Bridge: 0000:00:11.0
  IO window: 2000-2fff
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 18 (level, low) -> IRQ 18
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6159k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1209732522.932:1): initialized
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
Starting balanced_irq
Using IPI No-Shortcut mode
Freeing unused kernel memory: 276k freed
Loading, please wait...
Begin: Loading essential drivers... ...
fuse init (API version 7.9)
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Done.
Begin: Running /scripts/init-premount ...
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top ...
Done.
Begin: Waiting for root file system... ...
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
PIIX4: IDE port disabled
    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:PIO
SCSI subsystem initialized
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 18
pcnet32: PCnet/PCI II 79C970A at 0x2000,<6>ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 17
mptbase: ioc0: Initiating bringup
 00:0c:29:91:8c:5a assigned IRQ 18.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
No dock devices found.
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
hdc: ATAPI 1X CD-ROM drive, 32kB Cache
Uniform CD-ROM driver Revision: 3.20
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
sd 0:0:0:0: Attached scsi generic sg0 type 0
Done.
Begin: Running /scripts/local-premount ...
Done.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Begin: Running /scripts/local-bottom ...
Done.
Done.
Begin: Running /scripts/init-bottom ...
Done.
 * Setting preliminary keymap...       [ OK ]
 * Preparing restricted drivers...     [ OK ]
 * Setting the system clock
 * Starting basic networking...        [ OK ]
 * Starting kernel event manager...    [ OK ]
 * Loading hardware drivers...         eth0: link up
Linux agpgart interface v0.103
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 256M @ 0x0
warning: `dhclient3' uses 32-bit capabilities (legacy support in use)
input: Power Button (FF) as /class/input/input2
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
ACPI: Power Button (FF) [PWRF]
ACPI: AC Adapter [ACAD] (on-line)
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c026bbcd>] uart_write_room+0xd/0x20
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: 8250_pnp parport_pc parport container ac psmouse serio_raw i2c_piix4 i2c_core button intel_agp agpgart evdev sg sd_mod ide_cd_mod cdrom ata_generic ata_piix libata dock floppy pcnet32 mii mptspi mptscsih mptbase scsi_transport_spi scsi_mod piix ide_pci_generic ide_core thermal processor fan fuse

Pid: 2444, comm: S10udev Not tainted (2.6.25 #1)
EIP: 0060:[<c026bbcd>] EFLAGS: 00010202 CPU: 1
EIP is at uart_write_room+0xd/0x20
EAX: 00000000 EBX: 00000001 ECX: de394d1c EDX: de1dae00
ESI: 00000001 EDI: de394c00 EBP: df89ff1c ESP: df89fee4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process S10udev (pid: 2444, ti=df89e000 task=df9c2b20 task.ti=df89e000)
Stack: c025a93b de1f4400 df83b0c0 de394d18 de1f4400 c025711f 00000000 df9c2b20 
       c011f390 de394d1c de394d1c 00000001 de394c00 df83b0c0 df89ff50 c02581a7 
       00000001 00000001 08064708 c025a840 de394c0c 00000000 00000001 00000000 
Call Trace:
 [<c025a93b>] ? write_chan+0xfb/0x310
 [<c025711f>] ? tty_ldisc_ref_wait+0xf/0xa0
 [<c011f390>] ? default_wake_function+0x0/0x10
 [<c02581a7>] ? tty_write+0x127/0x1c0
 [<c025a840>] ? write_chan+0x0/0x310
 [<c0259b84>] ? redirected_tty_write+0x74/0x80
 [<c0180946>] ? vfs_write+0x96/0x130
 [<c0259b10>] ? redirected_tty_write+0x0/0x80
 [<c0180fcd>] ? sys_write+0x3d/0x70
 [<c0105bde>] ? sysenter_past_esp+0x5f/0x85
 =======================
Code: 5d c3 8b 40 10 81 48 10 00 00 00 02 eb db 81 49 10 00 00 00 04 eb c2 8d b4 26 00 00 00 00 55 8b 80 44 01 00 00 89 e5 5d 8b 40 10 <8b> 50 08 8b 40 0c 83 c2 01 29 d0 25 ff 0f 00 00 c3 66 90 55 8b 
EIP: [<c026bbcd>] uart_write_room+0xd/0x20 SS:ESP 0068:df89fee4
---[ end trace aaa0a39c3c6c7aac ]---
------------------------------------------------------------
