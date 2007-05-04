Return-Path: <linux-kernel-owner+w=401wt.eu-S1031427AbXEDRBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031427AbXEDRBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031423AbXEDRBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:01:51 -0400
Received: from smtp20.poczta.onet.pl ([213.180.130.91]:46270 "EHLO
	smtp20.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031415AbXEDRBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:01:48 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 13:01:48 EDT
Date: Fri, 4 May 2007 18:44:18 +0200
From: Michal Kepien <michal.kepien@poczta.onet.pl>
To: The Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: HPT366: 2.6.21 breaks HPT366 detection on boot
Message-Id: <20070504184418.c3c798e6.michal.kepien@poczta.onet.pl>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there all kernel hackers,

I own an Abit BE-6 v1 mainboard with an on-board HPT366 controller. Until kernel
version 2.6.20.7 it worked perfectly, however 2.6.21 broke it. My system is
Slackware 11.0 + current. Relevant log fragments:

2.6.20.7:
=========

-------------------------------------------------------------------------------
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
HPT366: onboard version of chipset, pin1=1 pin2=2
HPT366: IDE controller at PCI slot 0000:00:13.0
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:13.0
PCI: Sharing IRQ 11 with 0000:00:0b.0
PCI: Sharing IRQ 11 with 0000:00:13.1
HPT366: chipset revision 1
HPT366: 100% native mode on irq 11
    ide2: BM-DMA at 0xd800-0xd807, BIOS settings: hde:DMA, hdf:pio
PCI: Found IRQ 11 for device 0000:00:13.1
PCI: Sharing IRQ 11 with 0000:00:0b.0
PCI: Sharing IRQ 11 with 0000:00:13.0
    ide3: BM-DMA at 0xe400-0xe407, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: IBM-DJNA-371350, ATA DISK drive
hde: hw_config=2000
hde: hw_config=2000
ide2 at 0xd000-0xd007,0xd402 on irq 11
Probing IDE interface ide3...
hde: max request size: 128KiB
hde: 26520480 sectors (13578 MB) w/1966KiB Cache, CHS=26310/16/63, UDMA(33)
hde: cache flushes not supported
 hde: hde1 hde2 < hde5 >
hda: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
-------------------------------------------------------------------------------

2.6.21(.1):
===========

-------------------------------------------------------------------------------
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
hda: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
HPT366: onboard version of chipset, pin1=1 pin2=2
HPT366: IDE controller at PCI slot 0000:00:13.0
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:13.0
PCI: Sharing IRQ 11 with 0000:00:0b.0
PCI: Sharing IRQ 11 with 0000:00:13.1
HPT366: chipset revision 1
HPT366: using 33 MHz PCI clock
HPT366: 100% native mode on irq 11
HPT366: neither IDE port enabled (BIOS)
PCI: Found IRQ 11 for device 0000:00:13.1
PCI: Sharing IRQ 11 with 0000:00:0b.0
PCI: Sharing IRQ 11 with 0000:00:13.0
HPT366: using 33 MHz PCI clock
HPT366: neither IDE port enabled (BIOS)
hda: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
-------------------------------------------------------------------------------

Booting the system with 2.6.21 results in a kernel panic:

-------------------------------------------------------------------------------
VFS: Cannot open root device "2101" or unknown-block(31,1)
Please append a correct "root=" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(31,1) 
-------------------------------------------------------------------------------

I'd happily try out any patches and/or supply you with more details on demand.

-- 
Best regards,
Michal Kepien
