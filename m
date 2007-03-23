Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXCWWj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXCWWj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXCWWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:39:29 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:45506 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbXCWWj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:39:27 -0400
Date: Fri, 23 Mar 2007 23:39:12 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.21-rc regression in mptbase
Message-ID: <Pine.LNX.4.61.0703232322030.10028@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello world,


in at least 2.6.21-rc4, one or more of the mptscsi scsi modules is 
broken with respect to not detecting any harddisk (VMware provides that 
virtual LSI MPT controller), which means no working system.
No problems in 2.6.20.2.

I will be trying 2.6.21-rc1 shortly.

2.6.20.2:
<6>PIIX4: IDE controller at PCI slot 0000:00:07.1
<6>PIIX4: chipset revision 1
<6>PIIX4: not 100% native mode: will probe irqs later
<6>    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:pio
<7>Probing IDE interface ide1...
<4>hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
<4>ide1 at 0x170-0x177,0x376 on irq 15
<6>Fusion MPT base driver 3.04.03
<6>Copyright (c) 1999-2007 LSI Logic Corporation
<6>Fusion MPT SPI Host driver 3.04.03
<6>ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 17
<6>mptbase: Initiating ioc0 bringup
<6>ioc0: 53C1030: Capabilities={Initiator}
<6>scsi0 : ioc0: LSI53C1030, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
<5>scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
<6> target0:0:0: Beginning Domain Validation
<6> target0:0:0: Domain Validation skipping write tests
<6> target0:0:0: Ending Domain Validation
<6> target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
<5>SCSI device sda: 16777216 512-byte hdwr sectors (8590 MB)
<5>sda: Write Protect is off
<7>sda: Mode Sense: 5d 00 00 00
<5>sda: cache data unavailable
<3>sda: assuming drive cache: write through
<5>SCSI device sda: 16777216 512-byte hdwr sectors (8590 MB)
<5>sda: Write Protect is off
<7>sda: Mode Sense: 5d 00 00 00
<5>sda: cache data unavailable
<3>sda: assuming drive cache: write through
<6> sda: sda1 sda2
<5>sd 0:0:0:0: Attached scsi disk sda
<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
<7>libata version 2.00 loaded.
<6>BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
<6>SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
<6>SGI XFS Quota Management subsystem
<5>XFS mounting filesystem sda2

2.6.21:
Loading piix
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:pio
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Loading scsi_transport_spi
Loading mptbase
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Loading mptscsih
Loading mptspi
Fusion MPT SPI Host driver 3.04.04
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 17
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
Loading libata
Loading ata_piix
Loading fan
Loading edd
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Loading xfs
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Waiting for device /dev/sda2 to appear: ...............




Jan
-- 
