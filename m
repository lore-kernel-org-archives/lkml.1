Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbXFAVmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbXFAVmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761106AbXFAVlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:41:52 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:54415 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760389AbXFAVlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:41:51 -0400
Message-ID: <46609290.5030701@dgreaves.com>
Date: Fri, 01 Jun 2007 22:41:36 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>
Subject: 2.6.22-rc3 hibernate(?) disables SMART on ide
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have 2 ide disks. If I enable SMART and hibernate/suspend2disk, SMART is
disabled when I resume.

Same as in 2.6.21.1

cu:~# smartctl -son /dev/hda
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF ENABLE/DISABLE COMMANDS SECTION ===
SMART Enabled.

cu:~# /usr/net/bin/hibernate
[poweron resume here]
cu:~# smartctl -a /dev/hda
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda ATA II family
Device Model:     ST320420A
Serial Number:    3CL04RKY
Firmware Version: 3.21
User Capacity:    20,404,101,120 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   4
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Jun  1 22:37:15 2007 BST
SMART support is: Available - device has SMART capability.
SMART support is: Disabled

SMART Disabled. Use option -s with argument 'on' to enable it.

here's some syslog


Jun  1 21:56:25 cu kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Jun  1 21:56:25 cu kernel: ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
Jun  1 21:56:25 cu kernel: VP_IDE: IDE controller at PCI slot 0000:00:0f.1
Jun  1 21:56:25 cu kernel: ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level,
low) -> IRQ 16
Jun  1 21:56:25 cu kernel: VP_IDE: chipset revision 6
Jun  1 21:56:25 cu kernel: VP_IDE: not 100%% native mode: will probe irqs later
Jun  1 21:56:25 cu kernel: VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on
pci0000:00:0f.1
Jun  1 21:56:25 cu kernel:     ide0: BM-DMA at 0x9000-0x9007, BIOS settings:
hda:DMA, hdb:DMA
Jun  1 21:56:25 cu kernel:     ide1: BM-DMA at 0x9008-0x900f, BIOS settings:
hdc:pio, hdd:DMA
Jun  1 21:56:25 cu kernel: Probing IDE interface ide0...
Jun  1 21:56:25 cu kernel: Switched to high resolution mode on CPU 0
Jun  1 21:56:25 cu kernel: hda: ST320420A, ATA DISK drive
Jun  1 21:56:25 cu kernel: hdb: Maxtor 5A300J0, ATA DISK drive
Jun  1 21:56:25 cu kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Jun  1 21:56:25 cu kernel: Probing IDE interface ide1...
Jun  1 21:56:25 cu kernel: hdd: PLEXTOR CD-R PX-W2410A, ATAPI CD/DVD-ROM drive
Jun  1 21:56:25 cu kernel: ide1 at 0x170-0x177,0x376 on irq 15
Jun  1 21:56:25 cu kernel: hda: max request size: 128KiB
Jun  1 21:56:25 cu kernel: hda: 39851760 sectors (20404 MB) w/2048KiB Cache,
CHS=39535/16/63, UDMA(66)
Jun  1 21:56:25 cu kernel: hda: cache flushes not supported
Jun  1 21:56:25 cu kernel:  hda: hda1 hda2 hda3
Jun  1 21:56:25 cu kernel: hdb: max request size: 512KiB
Jun  1 21:56:25 cu kernel: hdb: 585940320 sectors (300001 MB) w/2048KiB Cache,
CHS=36473/255/63, UDMA(133)
Jun  1 21:56:25 cu kernel: hdb: cache flushes supported
Jun  1 21:56:25 cu kernel:  hdb: hdb1 hdb2

anything else needed?

David
