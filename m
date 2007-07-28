Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXG1Pkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXG1Pkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXG1Pk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:40:27 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:58768 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbXG1PkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:40:24 -0400
Message-ID: <46AB631B.6070109@howardsilvan.com>
Date: Sat, 28 Jul 2007 08:39:07 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Paul Fulghum <paulkf@microgate.com>, Tilman Schmidt <tilman@imap.cc>,
       Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	<46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com>	<20070726173121.70088a92@the-village.bc.nu>	<46A98845.8010806@howardsilvan.com>	<46A9F712.70706@imap.cc>	<46D33636.7070200@microgate.com>	<46AA5A0E.1050600@howardsilvan.com>	<1185578908.2989.15.camel@x2>	<46AACB4D.7080004@howardsilvan.com> <20070728130009.43ea9e14@the-village.bc.nu>
In-Reply-To: <20070728130009.43ea9e14@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------060807030603040508030609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060807030603040508030609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:

>>Curiously, the session at 38400 bps that skipped 858 bytes... coincided, 
>>not just in sequence but also in precice timing within the session, with 
>>a small but noticeable disk load that I caused by grepping through a 
>>hundred session logs.  (I can't reproduce it easily, though, because of 
>>disk caching.)
>>    
>>
>
>Can you send me a dmesg, there are some cases when high disk load can
>cause high interrupt latency in both 2.2 and 2.6 depending upon what is
>configured.
>

I've attached dmesg output.  The os version I used yesterday to run 
those tests was Debian 4.0r0 (kernel 2.6.18-4-686).  It's still running, 
and that's where I give you this dmesg output from.

> I don't think thats related to the main problem but it is
>worth knowing about hdparm -u1
>

# hdparm -u1 /dev/hda

/dev/hda:
 setting unmaskirq to 1 (on)
 unmaskirq    =  1 (on)
#

After doing this I re-ran the 5 test sends at 115200 bps.  The number of 
lost bytes were:  0, 14, 8, 0, and 3.  Compared with yesterday's 63, 5, 
44, 48, and 2 this may indicate an improvement.  Note also that in the 
4th session where no bytes were lost there was still one element of 
corrupt data as detected by the image decoder.

Thanks,

Lee.

--------------060807030603040508030609
Content-Type: text/plain;
 name="dmesg.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.out"

Linux version 2.6.18-4-686 (Debian 2.6.18.dfsg.1-12) (waldi@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Mon Mar 26 17:17:36 UTC 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000e000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
224MB LOWMEM available.
On node 0 totalpages: 57344
  DMA zone: 4096 pages, LIFO batch:0
  Normal zone: 53248 pages, LIFO batch:15
DMI 2.0 present.
ACPI: Unable to locate RSDP
Allocating PCI resources starting at 10000000 (gap: 0e000000:f1ff0000)
Detected 400.953 MHz processor.
Built 1 zonelists.  Total pages: 57344
Kernel command line: root=/dev/hda3 ro 
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (011c9000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 219828k/229376k available (1544k kernel code, 9052k reserved, 577k data, 196k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 802.59 BogoMIPS (lpj=1605193)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0183f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 16k freed
CPU0: Intel Pentium II (Deschutes) stepping 03
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
migration_cost=0
checking if image is initramfs... it is
Freeing initrd memory: 4375k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb4a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fc0f0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc118, dseg 0xf0000
PnPBIOS: 14 nodes reported by PnP BIOS; 14 recorded by driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Firmware left 0000:00:0b.0 e100 interrupts enabled, disabling
Boot video device is 0000:01:00.0
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: e4000000-e5ffffff
  PREFETCH window: e7000000-e77fffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 4096)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1185563327.604:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Activating ISA DMA hang workarounds.
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Couldn't register serial port 0000:00:0a.0: -28
Couldn't register serial port 0000:00:0c.0: -28
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI No-Shortcut mode
Freeing unused kernel memory: 196k freed
Time: tsc clocksource has been installed.
input: AT Translated Set 2 keyboard as /class/input/input0
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
e100: eth0: e100_probe: addr 0xe7a00000, irq 10, MAC addr 00:60:B0:68:53:F4
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
PCI: VIA IRQ fixup for 0000:00:07.1, from 255 to 0
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c596a (rev 06) IDE UDMA33 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: QUANTUM BIGFOOT TS12.7A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: LTN301, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 25075008 sectors (12838 MB) w/418KiB Cache, CHS=24876/16/63, UDMA(33)
 hda: hda1 hda2 hda3
hdc: ATAPI 32X CD-ROM drive, 120kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input1
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA Apollo Pro 133 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Adding 498004k swap on /dev/hda2.  Priority:-1 extents:1 across:498004k
EXT3 FS on hda3, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
eth0: no IPv6 routers present

--------------060807030603040508030609--
