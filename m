Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYCBCnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYCBCnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 21:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYCBCnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 21:43:33 -0500
Received: from web52906.mail.re2.yahoo.com ([206.190.49.16]:32404 "HELO
	web52906.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751385AbYCBCn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 21:43:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=j8sH86EKew9ysxWOoviywmDPny46ahQl3AzuSQYaogArvrAgRWW1Eowd6zIpXsmMkNvwLClZ+ryBLgXWWBKXQ+xV6mkelmTW2FWgCQdMRwESgVLG19/bBIM4dE6raVKatAlkW53L6mMBnwSBS0+2JNHDWFsB6OaE+NoprADEqpU=;
X-YMail-OSG: jZiZULwVM1mjIJQAJU31g5vDrrDfznxCanp.GJON
Date: Sun, 2 Mar 2008 02:43:28 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; Solution!
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080226185216.f298784d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <441583.33122.qm@web52906.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> If you can identify the offending commit (see
> http://www.kernel.org/doc/local/git-quick.html) we'll get it working again
> and I really don't care how many commits we have to revert to do it.

I have finally worked out what was happening: my "Subarchitecture type" had somehow become set to
the default "Generic architecture" instead of "PC-compatible". I have no idea how! I now get the
following boot log with 2.6.24.3, although it still has a "feature" when it comes to enabling the
APIC timer:

Linux version 2.6.24.3 (chris@twopit.underworld) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33))
#1 SMP PREEMPT Sun Mar 2 02:00:33 GMT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffeb000 (usable)
 BIOS-e820: 000000001ffeb000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Entering add_active_range(0, 0, 131051) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131051
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131051
On node 0 totalpages: 131051
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125964 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F7B40, 0014 (r0 ASUS  )
ACPI: RSDT 1FFEB000, 0030 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: FACP 1FFEB100, 0074 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: DSDT 1FFEB180, 39FA (r1   ASUS TUSL2-C      1000 MSFT  100000B)
ACPI: FACS 1FFFF000, 0040
ACPI: BOOT 1FFEB040, 0028 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: APIC 1FFEB080, 005A (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130028
Kernel command line: ro root=LABEL=/ nmi_watchdog=1 video=matroxfb:vesa:0x11A
console=ttyS0,115200n8 console=tty0
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c035f000 soft=c035b000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1005.042 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513452k/524204k available (1578k kernel code, 10160k reserved, 607k data, 196k init, 0k
highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffeb000   ( 511 MB)
      .init : 0xc0327000 - 0xc0358000   ( 196 kB)
      .data : 0xc028a8a2 - 0xc03227c4   ( 607 kB)
      .text : 0xc0100000 - 0xc028a8a2   (1578 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 2011.87 BogoMIPS (lpj=4023740)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 9k freed
ACPI: Core revision 20070126
CPU0: Intel Pentium III (Coppermine) stepping 06
Total of 1 processors activated (2011.87 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 1, comm: swapper Not tainted 2.6.24.3 #1
 [<c0105020>] show_trace_log_lvl+0x1a/0x2f
 [<c0105990>] show_trace+0x12/0x14
 [<c010613d>] dump_stack+0x6c/0x72
 [<c0113ae3>] native_smp_call_function_mask+0x40/0x12a
 [<c0114eb9>] smp_call_function+0x1e/0x22
 [<c0125bc0>] on_each_cpu+0x2a/0x57
 [<c011721d>] setup_nmi+0x33/0x4a
 [<c033262e>] setup_IO_APIC+0x8b5/0xddd
 [<c032fe21>] native_smp_prepare_cpus+0x4b6/0x4c6
 [<c03273de>] kernel_init+0x54/0x2c3
 [<c0104c83>] kernel_thread_helper+0x7/0x10
 =======================
APIC timer registered as dummy, due to nmi_watchdog=1!
Brought up 1 CPUs
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0e30, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1fffffff could not be reserved
system 00:03: ioport range 0x3f0-0x3f1 has been reserved
system 00:03: ioport range 0x4d0-0x4d1 has been reserved
system 00:04: ioport range 0xe400-0xe47f has been reserved
system 00:04: ioport range 0xec00-0xec3f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: f8800000-f9cfffff
  PREFETCH window: f9f00000-fbffffff
PCI: Bridge: 0000:02:0d.0
  IO window: disabled.
  MEM window: f6000000-f7ffffff
  PREFETCH window: f9d00000-f9dfffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-dfff
  MEM window: f5800000-f87fffff
  PREFETCH window: f9d00000-f9efffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 196608 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
Freeing initrd memory: 2972k freed
Simple Boot Flag at 0x3a set to 0x1
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
matroxfb: Matrox Millennium G400 MAX (AGP) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1280x1024x16bpp (virtual: 1280x6553)
matroxfb: framebuffer at 0xFA000000, mapped to 0xe0880000, size 33554432
Console: switching to colour frame buffer device 160x64
fb0: MATROX frame buffer device
matroxfb_crtc2: secondary head of fb0 was registered as fb1
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0c: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Mar  2 2008
TCP cubic registered
NET: Registered protocol family 1
Testing NMI watchdog ... <6>input: AT Translated Set 2 keyboard as /class/input/input0
OK.
Using IPI No-Shortcut mode
Freeing unused kernel memory: 196k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:03:0d.2[C] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:03:0d.2: EHCI Host Controller
ehci_hcd 0000:03:0d.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:03:0d.2: irq 20, io mem 0xf6000000
ehci_hcd 0000:03:0d.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:03:0d.0[A] -> GSI 22 (level, low) -> IRQ 17
ohci_hcd 0000:03:0d.0: OHCI Host Controller
ohci_hcd 0000:03:0d.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:03:0d.0: irq 17, io mem 0xf7000000
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb 1-5: configuration #1 chosen from 1 choice
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:03:0d.1[B] -> GSI 23 (level, low) -> IRQ 18
ohci_hcd 0000:03:0d.1: OHCI Host Controller
ohci_hcd 0000:03:0d.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:03:0d.1: irq 18, io mem 0xf6800000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000a400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1f.4: irq 18, io base 0x0000a000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.12
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xa800 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xa808 irq 15
ata1.00: ATA-4: ST320420A, 3.12, max UDMA/66
ata1.00: 39851760 sectors, multi 16: LBA 
ata1.00: configured for UDMA/66
ata2.00: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-116  0122, E1.22, max UDMA/66
ata2.01: ATAPI: SONY    CD-RW  CRX145E, 1.0b, max UDMA/33
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST320420A        3.12 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            PIONEER  DVD-ROM DVD-116  1.22 PQ: 0 ANSI: 5
scsi 1:0:1:0: CD-ROM            SONY     CD-RW  CRX145E   1.0b PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
scsi 1:0:1:0: Attached scsi generic sg2 type 5
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1
ACPI: Invalid PBLK length [5]
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
Linux agpgart interface v0.102
agpgart: Detected an Intel i815 Chipset.
agpgart: AGP aperture is 32M @ 0xfc000000
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH2 TCO device (Version=1, TCOBASE=0xe460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
gameport: EMU10K1 is pci0000:02:0a.1/gameport0, io 0xd400, speed 1147kHz
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:02:0c.0[A] -> GSI 20 (level, low) -> IRQ 20
eth0: RealTek RTL8139 at 0xe28de000, 00:30:4f:10:da:38, IRQ 20
eth0:  Identified 8139 chip type 'RTL-8139C'
ACPI: PCI Interrupt 0000:02:0e.0[A] -> GSI 18 (level, low) -> IRQ 21
firewire_ohci: Added fw-ohci device 0000:02:0e.0, OHCI version 1.0
ACPI: PCI Interrupt 0000:03:0c.0[A] -> GSI 21 (level, low) -> IRQ 22
input: PC Speaker as /class/input/input3
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 23
firewire_ohci: Added fw-ohci device 0000:03:0c.0, OHCI version 1.0
firewire_ohci: swap not done yet
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
firewire_core: created new fw device fw0 (0 config rom retries, S400)
input: ImPS/2 Generic Wheel Mouse as /class/input/input4
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
firewire_core: created new fw device fw1 (0 config rom retries, S400)
firewire_ohci: swap not done yet
ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) -> IRQ 17
usbcore: registered new interface driver snd-usb-audio
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized mga 3.2.1 20051102 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[drm] Initialized card for AGP DMA.

Cheers,
Chris



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/
