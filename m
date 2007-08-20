Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbXHTQgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbXHTQgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXHTQfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:35:48 -0400
Received: from mx30.mail.ru ([194.67.23.238]:7953 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXHTQfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:35:45 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 12:35:45 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Mon, 20 Aug 2007 20:35:39 +0400
User-Agent: KMail/1.9.7
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708192147.47433.bjorn.helgaas@hp.com> <200708202028.22806.arvidjaar@mail.ru>
In-Reply-To: <200708202028.22806.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3487374.3F4RLORAPP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708202035.39757.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3487374.3F4RLORAPP
Content-Type: multipart/mixed;
  boundary="Boundary-01=_bLcyGQ6XggzPx3v"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_bLcyGQ6XggzPx3v
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 20 August 2007, Andrey Borzenkov wrote:
> On Monday 20 August 2007, Bjorn Helgaas wrote:
> > On Saturday 18 August 2007 01:07:55 am Andrey Borzenkov wrote:
> > > This is related to thread "2.6.22-rc: regression: no irda0 interface
> > > (2.6.21 was OK), smsc does not find chip" but it is already way too
> > > overloaded.
> > >
> > > In 2.6.23 smsc-ircc2 fails to initialize IrDA controller. Apparently
> > > because it by default is using the same IO port as ttyS3 and this is
> > > now claimed by 8250.
> >
> > 8250 should have claimed ttyS3 in 2.6.21 and earlier.  So from
> > the 8250 point of view, 2.6.21 and 2.6.23 should behave the same.
>
> I only know that this worked in 2.6.21. I remind that previous regression
> was post-2.6.21 which obviously implies that it did work ...
>
> For reference I attach dmesg from 2.6.21. I do not see any ttyS3 there ...
>

Sorry, really attached.

> > From the smsc-ircc2 point of view, 2.6.21 and 2.6.23 should work
> > the same except for the additional quirk_smc_enable().  If
> > 2.6.23 is worse than 2.6.21, please try removing the body of
> > quirk_smc_enable() and see whether that makes 2.6.23 as good
> > as 2.6.21.
>
> This worked in 2.6.22 with the same quirks. I will test without later but I
> fail to see how they are related.
>
> > For smsc-ircc2, 2.6.23 is definitely a regression from 2.6.22,
> > because 8250 stayed out of the way in 2.6.22.  But we had to
> > revert 8250 back to the 2.6.21 behavior because the change
> > swapped ttyS0 and ttyS1 on some machines, so we just have to
> > live with that 8250/smsc-ircc2 conflict for the time being.
>
> This worked in 2.6.21 and 2.6.22 (and earlier BTW). So if you just had
> revert to 2.6.21 it would have worked. Something else changed.



--Boundary-01=_bLcyGQ6XggzPx3v
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg.2.6.21"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dmesg.2.6.21"

1 TOSHIB 750        970814 TASM  4010000)
ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM  4010000)
ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT  100000A)
ACPI: FACS 000EEE00, 0040
ACPI: PM-Timer IO Port: 0xee08
Allocating PCI resources starting at 30000000 (gap: 20000000:dff80000)
Nosave address range: 000a00000009f000 - 0000000000000000
Nosave address range: 000e0000000a0000 - 0000000000000000
Nosave address range: 000ee000000e0000 - 00000000000000e0
Nosave address range: 000ef000000ee000 - 0000000000000000
Nosave address range: 00100000000ef000 - 00000000000000ef
Built 1 zonelists.  Total pages: 125826
Kernel command line: BOOT_IMAGE=3D2.6.21-cfs-v7-1avb root=3DLABEL=3D/ resum=
e=3D/dev/sda1 vga=3D791 1
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (013e7000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 747.681 MHz processor.
Console: colour dummy device 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
=2E.. MAX_LOCKDEP_SUBCLASSES:    8
=2E.. MAX_LOCK_DEPTH:          30
=2E.. MAX_LOCKDEP_KEYS:        2048
=2E.. CLASSHASH_SIZE:           1024
=2E.. MAX_LOCKDEP_ENTRIES:     8192
=2E.. MAX_LOCKDEP_CHAINS:      16384
=2E.. CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1096 kB
 per task-struct memory footprint: 1200 bytes
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 496044k/507264k available (1745k kernel code, 10644k reserved, 808k=
 data, 200k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xdf800000 - 0xfffb5000   ( 519 MB)
    lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
      .init : 0xc0382000 - 0xc03b4000   ( 200 kB)
      .data : 0xc02b4582 - 0xc037e8b4   ( 808 kB)
      .text : 0xc0100000 - 0xc02b4582   (1745 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1497.64 BogoMIPS (lpj=3D24=
95438)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 0000=
0000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00=
000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium III (Coppermine) stepping 0a
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0a00)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
PCI quirk: region ef00-ef1f claimed by ali7101 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x1ef5ffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: f7f00000-fdffffff
  PREFETCH window: 48000000-480fffff
PCI: Bus 2, cardbus bridge: 0000:00:10.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 34000000-37ffffff
PCI: Bus 6, cardbus bridge: 0000:00:11.0
  IO window: 00001800-000018ff
  IO window: 00001c00-00001cff
  PREFETCH window: 38000000-3bffffff
  MEM window: 3c000000-3fffffff
PCI: Bus 10, cardbus bridge: 0000:00:11.1
  IO window: 00002000-000020ff
  IO window: 00002400-000024ff
  PREFETCH window: 40000000-43ffffff
  MEM window: 44000000-47ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11 (level, low) -=
> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 7, 720896 bytes)
TCP bind hash table entries: 16384 (order: 7, 720896 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
=46reeing initrd memory: 1165k freed
audit: initializing netlink socket (disabled)
audit(1187626638.223:1): initialized
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Activating ISA DMA hang workarounds.
vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, using 3072k, total=
 16384k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
vesafb: protected mode interface info at c000:775e
vesafb: pmi: set display start =3D c00c777f, set palette =3D c00c77e2
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Switched to high resolution mode on CPU 0
Real Time Clock Driver v1.12ac
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 1
Using IPI Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
=46reeing unused kernel memory: 200k freed
Write protecting the kernel read-only data: 626k
SCSI subsystem initialized
input: AT Translated Set 2 keyboard as /class/input/input0
libata version 2.20 loaded.
ACPI: Unable to derive IRQ for device 0000:00:04.0
ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001eff0 irq =
14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001eff8 irq =
15
scsi0 : pata_ali
ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
ata1.00: 39070080 sectors, multi 0: LBA=20
ata1.00: configured for UDMA/33
scsi1 : pata_ali
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA3O PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 1313 PQ: 0 ANSI: 5
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected ALi M1644 chipset
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
agpgart: AGP aperture is 64M @ 0xf0000000
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11 (level, low) -=
> IRQ 11
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
Yenta: ISA IRQ mask 0x0000, PCI irq 11
Socket status: 30000059
Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000087
Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000007
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11 (level, low) -=
> IRQ 11
NET: Registered protocol family 23
e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr 00:00:39:D7:14:A1
Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip, pr=
e-configuring device.
Activated ALi 1533 ISA bridge port 0x02e8.
Activated ALi 1533 ISA bridge port 0x02f8.
found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e): LPC47N227
smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, mode: 0x0e
SMsC IrDA Controller found
 IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=3D7
No transceiver found. Defaulting to Fast pin select
IrDA: Registered device irda0
pccard: PCMCIA card inserted into slot 0
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 (level, low) -=
> IRQ 11
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcbfff 0xe0000-0xfff=
ff
cs: memory probe 0x60000000-0x60ffffff: clean.
cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia: registering new device pcmcia0.0
wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere Systems, http:=
//www.agere.com
*** Modified for kernel 2.6 by Andrey Borzenkov <arvidjaar@mail.ru> $Revisi=
on: 39 $
*** Station Mode (STA) Support: YES
*** Access Point Mode (AP) Support: YES
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
eth1: Wireless, io_addr 0x100, irq 11, mac_address 00:02:2D:26:95:6C
Toshiba System Managment Mode driver v1.11 26/9/2001
Non-volatile memory driver v1.2
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
ACPI: AC Adapter [ADP1] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
ACPI: Battery Slot [BAT2] (battery absent)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
ACPI: Transitioning device [FAN] to D3
ACPI: Transitioning device [FAN] to D3
ACPI: Fan [FAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Thermal Zone [THRM] (59 C)
Time: acpi_pm clocksource has been installed.
toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
Clocksource tsc unstable (delta =3D -180109026 ns)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
loop: loaded (max 8 devices)
Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1 across:500432k

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[ INFO: possible circular locking dependency detected ]
2.6.21-cfs-v7-1avb #11
=2D------------------------------------------------------
chgrp/2277 is trying to acquire lock:
 (&REISERFS_SB(s)->xattr_dir_sem){..--}, at: [<dfbefd7a>] reiserfs_chown_xa=
ttrs+0x5a/0x120 [reiserfs]

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<c02af8f1>] mutex_lock+0x21/0x30

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

=2D> #1 (&inode->i_mutex){--..}:
       [<c0139cdd>] __lock_acquire+0xdfd/0xfc0
       [<c0139ef7>] lock_acquire+0x57/0x70
       [<c02af69b>] __mutex_lock_slowpath+0x6b/0x2a0
       [<c02af8f1>] mutex_lock+0x21/0x30
       [<dfbeee1e>] get_xa_root+0x3e/0x120 [reiserfs]
       [<dfbeef3f>] open_xa_dir+0x1f/0x100 [reiserfs]
       [<dfbf0332>] reiserfs_delete_xattrs+0x62/0x180 [reiserfs]
       [<dfbd1ff7>] reiserfs_delete_inode+0x57/0xb0 [reiserfs]
       [<c0180601>] generic_delete_inode+0x61/0xd0
       [<c01807a7>] generic_drop_inode+0x137/0x160
       [<c017fc0f>] iput+0x5f/0x70
       [<c0176d10>] do_unlinkat+0xe0/0x140
       [<c0176d80>] sys_unlink+0x10/0x20
       [<c010402e>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

=2D> #0 (&REISERFS_SB(s)->xattr_dir_sem){..--}:
       [<c0139b4d>] __lock_acquire+0xc6d/0xfc0
       [<c0139ef7>] lock_acquire+0x57/0x70
       [<c0131d50>] down_read+0x40/0x60
       [<dfbefd7a>] reiserfs_chown_xattrs+0x5a/0x120 [reiserfs]
       [<dfbd2332>] reiserfs_setattr+0x112/0x260 [reiserfs]
       [<c0181314>] notify_change+0xd4/0x2d0
       [<c016bd79>] chown_common+0xa9/0xc0
       [<c016bf68>] sys_chown+0x38/0x50
       [<c010402e>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by chgrp/2277:
 #0:  (&inode->i_mutex){--..}, at: [<c02af8f1>] mutex_lock+0x21/0x30

stack backtrace:
 [<c010500a>] show_trace_log_lvl+0x1a/0x30
 [<c0105652>] show_trace+0x12/0x20
 [<c0105706>] dump_stack+0x16/0x20
 [<c0137c4f>] print_circular_bug_tail+0x6f/0x80
 [<c0139b4d>] __lock_acquire+0xc6d/0xfc0
 [<c0139ef7>] lock_acquire+0x57/0x70
 [<c0131d50>] down_read+0x40/0x60
 [<dfbefd7a>] reiserfs_chown_xattrs+0x5a/0x120 [reiserfs]
 [<dfbd2332>] reiserfs_setattr+0x112/0x260 [reiserfs]
 [<c0181314>] notify_change+0xd4/0x2d0
 [<c016bd79>] chown_common+0xa9/0xc0
 [<c016bf68>] sys_chown+0x38/0x50
 [<c010402e>] sysenter_past_esp+0x5f/0x99
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--Boundary-01=_bLcyGQ6XggzPx3v--

--nextPart3487374.3F4RLORAPP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGycLbR6LMutpd94wRAjUGAJ9enHrQ4GZqcFHwUmRTCjBK1wJaFgCeP2Jf
MnjuFcbna/ZsZ3r9ZEodM8w=
=xzOF
-----END PGP SIGNATURE-----

--nextPart3487374.3F4RLORAPP--
