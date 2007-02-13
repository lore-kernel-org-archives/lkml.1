Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXBMCle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXBMCle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 21:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030588AbXBMCle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 21:41:34 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:50743 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030525AbXBMCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 21:41:33 -0500
Message-ID: <45D1255A.90502@lwfinger.net>
Date: Mon, 12 Feb 2007 20:41:30 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regress for 8139too in 2.6.20
References: <45CFAED5.2090808@lwfinger.net> <20070212140800.4d9378ad.akpm@linux-foundation.org>
In-Reply-To: <20070212140800.4d9378ad.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
> 
> That's a bit surprising - the initcall levels don't affect modules. 
> Presumably something went wrong in core kernel which later caused yenta
> and/or 8139too to fail.
> 
> Have you tried diffing the before- and after-dmesgs to see if that particular
> commit has caused any interesting differences?
> 
> And are you able to test any other cardbus devices to see whether it's
> specific to 8139too?

No devices would work until I manually loaded yenta_socket. Before the change, the PCMCIA bridge was
discovered earlier, and yenta_socket was automatically loaded. Now I need to add it to the list of
modules to be loaded at bootup. With that change, everyting is OK.

The diff between yenta as a module and yenta built is follows.

Thanks,
Larry

-----------

--- /ide/dmesg_with_yenta_module        2007-02-12 18:51:35.000000000 -0600
+++ /ide/dmesg_with_yenta_builtin       2007-02-12 16:25:24.000000000 -0600
@@ -1,4 +1,4 @@
-Linux version 2.6.20-default-g7096ede5-dirty (finger@sonylap) (gcc version 4.0.2 20050901
(prerelease) (SUSE Linux)) #119 Mon Feb 12 18:40:07 CST 2007
+Linux version 2.6.20-default-g7096ede5 (finger@sonylap) (gcc version 4.0.2 20050901 (prerelease)
(SUSE Linux)) #116 Sun Feb 11 14:27:53 CST 2007
 BIOS-provided physical RAM map:
 sanitize start
 sanitize end
@@ -39,28 +39,28 @@
 ACPI: FACS 07FFFFC0, 0040
 ACPI: Disabling ACPI support
 Allocating PCI resources starting at 10000000 (gap: 08000000:f7fea400)
-Detected 331.611 MHz processor.
+Detected 331.592 MHz processor.
 Built 1 zonelists.  Total pages: 32497
 Kernel command line: root=/dev/hda3 vga=0x314 selinux=0    resume=/dev/hda2  splash=silent showopts
 Local APIC disabled by BIOS -- you can enable it with "lapic"
 mapped APIC to ffffd000 (01101000)
 Enabling fast FPU save and restore... done.
 Initializing CPU#0
-CPU 0 irqstacks, hard=c0421000 soft=c0422000
+CPU 0 irqstacks, hard=c0432000 soft=c0433000
 PID hash table entries: 512 (order: 9, 2048 bytes)
 Console: colour dummy device 80x25
 Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
 Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
-Memory: 124256k/131008k available (2092k kernel code, 6220k reserved, 886k data, 200k init, 0k highmem)
+Memory: 124188k/131008k available (2137k kernel code, 6288k reserved, 909k data, 200k init, 0k highmem)
 virtual kernel memory layout:
     fixmap  : 0xfffb6000 - 0xfffff000   ( 292 kB)
     vmalloc : 0xc8800000 - 0xfffb4000   ( 887 MB)
     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
-      .init : 0xc03ea000 - 0xc041c000   ( 200 kB)
-      .data : 0xc030b24b - 0xc03e8c48   ( 886 kB)
-      .text : 0xc0100000 - 0xc030b24b   (2092 kB)
+      .init : 0xc03fb000 - 0xc042d000   ( 200 kB)
+      .data : 0xc031653b - 0xc03f9c48   ( 909 kB)
+      .text : 0xc0100000 - 0xc031653b   (2137 kB)
 Checking if this processor honours the WP bit even in supervisor mode... Ok.
-Calibrating delay using timer specific routine.. 664.03 BogoMIPS (lpj=1328067)
+Calibrating delay using timer specific routine.. 664.05 BogoMIPS (lpj=1328111)
 Mount-cache hash table entries: 512
 CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000 00000000 00000000 00000000
 CPU: L1 I cache: 16K, L1 D cache: 16K
@@ -104,8 +104,10 @@
   MEM window: 1c000000-1fffffff
 PCI: Found IRQ 9 for device 0000:00:0a.0
 PCI: Sharing IRQ 9 with 0000:00:08.1
+PCI: Setting latency timer of device 0000:00:0a.0 to 64
 PCI: Assigned IRQ 9 for device 0000:00:0a.1
 PCI: Sharing IRQ 9 with 0000:00:09.0
+PCI: Setting latency timer of device 0000:00:0a.1 to 64
 NET: Registered protocol family 2
 IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
 TCP established hash table entries: 4096 (order: 4, 81920 bytes)
@@ -115,7 +117,7 @@
 checking if image is initramfs... it is
 Freeing initrd memory: 1564k freed
 audit: initializing netlink socket (disabled)
-audit(1171306196.744:1): initialized
+audit(1171277305.752:1): initialized
 io scheduler noop registered
 io scheduler anticipatory registered (default)
 io scheduler deadline registered
@@ -138,25 +140,33 @@
 FDC 0 is a post-1991 82077
 RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
 loop: loaded (max 8 devices)
+Yenta: CardBus bridge found at 0000:00:0a.0 [104d:8042]
+Yenta: ISA IRQ mask 0x0cb8, PCI irq 9
+Socket status: 30000410
+Yenta: CardBus bridge found at 0000:00:0a.1 [104d:8042]
+Yenta: ISA IRQ mask 0x0cb8, PCI irq 9
+Socket status: 30000820
 PNP: No PS/2 controller found. Probing ports directly.
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX port at 0x60,0x64 irq 12
 mice: PS/2 mouse device common for all mice
 input: AT Translated Set 2 keyboard as /class/input/input0
 input: PC Speaker as /class/input/input1
+pccard: PCMCIA card inserted into slot 0
 input: PS/2 Mouse as /class/input/input2
 input: AlpsPS/2 ALPS GlidePoint as /class/input/input3
 NET: Registered protocol family 1
 Using IPI Shortcut mode
 Freeing unused kernel memory: 200k freed
 Time: tsc clocksource has been installed.
+pccard: CardBus card inserted into slot 1
 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
 PIIX4: IDE controller at PCI slot 0000:00:07.1
 PIIX4: chipset revision 1
 PIIX4: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xfcf0-0xfcf7, BIOS settings: hda:DMA, hdb:pio
-    ide1: BM-DMA at 0xfcf8-0xfcff, BIOS settings: hdc:DMA, hdd:pio
+    ide1: BM-DMA at 0xfcf8-0xfcff, BIOS settings: hdc:pio, hdd:pio
 Probing IDE interface ide0...
 hda: FUJITSU MHT2020AT, ATA DISK drive
 ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
@@ -184,16 +194,53 @@
 ReiserFS: hda4: checking transaction log (hda4)
 ReiserFS: hda4: Using r5 hash to sort names
 8139too Fast Ethernet driver 0.9.28
+PCI: Enabling device 0000:05:00.0 (0000 -> 0003)
+PCI: Setting latency timer of device 0000:05:00.0 to 64
+eth0: RealTek RTL8139 at 0x1800, 00:a0:b0:00:0b:da, IRQ 9
+eth0:  Identified 8139 chip type 'RTL-8139C'
 parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
 parport0: irq 7 detected
 lp0: using parport0 (polling).
+cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
+cs: IO port probe 0x100-0x3af: clean.
+cs: IO port probe 0xc00-0xcff: clean.
+cs: IO port probe 0x820-0x8ff: clean.
+cs: IO port probe 0xa00-0xaff: clean.
+cs: memory probe 0xa0000000-0xa0ffffff: clean.
+pcmcia: registering new device pcmcia0.0
+cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
+cs: IO port probe 0x100-0x3af: clean.
+cs: IO port probe 0xc00-0xcff: clean.
+cs: IO port probe 0x820-0x8ff: clean.
+cs: IO port probe 0xa00-0xaff: clean.
+ieee80211_crypt: registered algorithm 'NULL'
 hdc: ATAPI 20X DVD-ROM drive, 128kB Cache, DMA
 Uniform CD-ROM driver Revision: 3.20
-hdc: packet command error: status=0x51 { DriveReady SeekComplete Error }
-hdc: packet command error: error=0x50 { LastFailedSense=0x05 }
-ide: failed opcode was: unknown
+ieee80211: 802.11 data/management/control stack, git-1.1.13
+ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
+bcm43xx driver
+Probing IDE interface ide2...
+hde: FUJITSU MHT2080AT, ATA DISK drive
+ide2 at 0x100-0x107,0x10e on irq 3
+hde: max request size: 128KiB
+hde: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63
+hde: cache flushes supported
+ hde: hde1 hde2
+ide-cs: hde: Vpp = 0.0
+eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
 Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
 NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
 NFSD: unable to find recovery directory /var/lib/nfs/v4recovery
 NFSD: starting 90-second grace period
 BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
+kjournald starting.  Commit interval 5 seconds
+EXT3 FS on hde1, internal journal
+EXT3-fs: mounted filesystem with ordered data mode.
+kjournald starting.  Commit interval 5 seconds
+EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
+EXT3 FS on hde2, internal journal
+EXT3-fs: mounted filesystem with ordered data mode.
+pcmcia: Detected deprecated PCMCIA ioctl usage from process: hald.
+pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you
upgrade to new tools.
+pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
+spurious 8259A interrupt: IRQ7.
