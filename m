Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbXBJUCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbXBJUCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXBJUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:02:52 -0500
Received: from tag.witbe.net ([81.88.96.48]:55935 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbXBJUCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:02:52 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Alan'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: AHCI - remove probing of ata2
Date: Sat, 10 Feb 2007 21:01:53 +0100
Organization: AS2917.net
Message-ID: <00d101c74d4e$4ff62df0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070210190643.2e865cc9@localhost.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdNRLOehoesynT3SJCl+eCEPX82cAABgrdw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> You have the old driver 0n 0x1F0
> 
> 
> > PCI: Device 0000:02:00.0 not available because of resource 
> collisions
> > ahci: probe of 0000:02:00.0 failed with error -22
> > ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
> > ata: 0x1F0 IDE port busy
> 
> And the new drivers trying to manage the same port
> 
> > CONFIG_IDE=y
> > CONFIG_BLK_DEV_IDE=y
> 
> Set those to "N" and try again

Done that, rebuilt and rebooted...
/dev/hda and /dev/hdb (old driver) are gone... 
OK, rebooting again, with a new root device as /dev/sde1...
No problem for the old IDE devices, they are now /dev/sdX.

But the Jmicron stuff is still broken though no more conflict :(

PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
ata7: PATA max UDMA/100 cmd 0x9C00 ctl 0x9882 bmdma 0x9400 irq 16
ata8: PATA max UDMA/100 cmd 0x9800 ctl 0x9482 bmdma 0x9408 irq 16
scsi6 : pata_jmicron
ata7.00: ATAPI, max UDMA/66
ata7.00: qc timeout (cmd 0xef)
ata7.00: failed to set xfermode (err_mask=0x4)
ata7.00: limiting speed to UDMA/44
ata7: failed to recover some devices, retrying in 5 secs
ata7.00: qc timeout (cmd 0xef)
ata7.00: failed to set xfermode (err_mask=0x4)
ata7.00: limiting speed to PIO0
ata7: failed to recover some devices, retrying in 5 secs
ata7.00: qc timeout (cmd 0xef)
ata7.00: failed to set xfermode (err_mask=0x4)
ata7.00: disabled
scsi7 : pata_jmicron
ATA: abnormal status 0x7F on port 0x9807


Also, I've seen a :

ata1: Spurious SDB FIS during NCQ issue=0x0 SAct=0x7ff8001f
FIS=004040a1:00040000

What's this ? Is it really bad or just a warning ???

Regards,
Paul


