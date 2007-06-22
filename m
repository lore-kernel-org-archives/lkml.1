Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXFVTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXFVTFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbXFVTFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:05:10 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:15854 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759637AbXFVTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:05:09 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2007 15:05:09 EDT
Date: Fri, 22 Jun 2007 14:40:18 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Error in syslog on 2.6.20
Message-ID: <20070622184018.GA20301@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not on either list, keep me in CC.

I noticed the following error on a cdrom device:
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
         res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA2
ata2: EH complete

This is the device when it was found:
libata version 2.00 loaded.
ata_piix 0000:00:1f.1: version 2.00ac7
ata1: PATA max UDMA/100 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
scsi0 : ata_piix
ata1.00: ATA-4, max UDMA/66, 16514064 sectors: LBA
ata1.00: ata1: dev 0 multi count 8
ata1.00: configured for UDMA/66
scsi1 : ata_piix
ata2.00: ATAPI, max MWDMA2
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      WDC WD84AA       05.0 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            LITEON   CD-ROM LTN486S   YQSM PQ: 0 ANSI: 5

I have a program that does a scsi TEST UNIT READY on many devices once every
.1 second.  The problem occured when I ejected the cdrom and closed the tray
again with valid media in the drive.  My program noticed media removed and
inserted, then said the device was dead/unpollable.  This is when I saw this
error.
