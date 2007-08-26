Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbXHZE3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbXHZE3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 00:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXHZE3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 00:29:15 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43868 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXHZE3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 00:29:14 -0400
Date: Sat, 25 Aug 2007 22:27:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.22.5 SATA Failure
In-reply-to: <fa.9lnv231u8AU5Nlw9OFEhJs+u+Yw@ifi.uio.no>
To: Dong Feng <middle.fengdong@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Message-id: <46D1013D.5040801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.9lnv231u8AU5Nlw9OFEhJs+u+Yw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Feng wrote:
> I have been using 2.6.21.1. It seems working well, that is, all my
> disk partitions are mapped as "/dev/sda*" and the performance looks
> good. After I upgrade to 2.6.22.5 with the exact same configuration,
> all the disk device turn to "/dev/hda*" and the performance degrade
> obviously.
> 
> While I boot with 2.6.21.1, the logs regarding disk are:
> 
> Aug 26 06:11:26 localhost kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> Aug 26 06:11:26 localhost kernel: ACPI: PCI Interrupt 0000:00:1f.2[B]
> -> GSI 17 (level, low) -> IRQ 17
> Aug 26 06:11:26 localhost kernel: ata: 0x170 IDE port busy
> Aug 26 06:11:26 localhost kernel: ata: conflict with ide1
> Aug 26 06:11:26 localhost kernel: ata1: SATA max UDMA/133 cmd
> 0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
> Aug 26 06:11:26 localhost kernel: ata2: DUMMY
> Aug 26 06:11:26 localhost kernel: scsi0 : ata_piix
> Aug 26 06:11:26 localhost kernel: ata1.00: ATA-7: ST9120821AS, 8.03,
> max UDMA/133
> Aug 26 06:11:26 localhost kernel: ata1.00: 234441648 sectors, multi 8:
> LBA48 NCQ (depth 0/32)
> Aug 26 06:11:26 localhost kernel: ata1.00: configured for UDMA/133
> Aug 26 06:11:26 localhost kernel: scsi1 : ata_piix
> Aug 26 06:11:26 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA
>     ST9120821AS      8.03 PQ: 0 ANSI: 5
> Aug 26 06:11:26 localhost kernel: SCSI device sda: 234441648 512-byte
> hdwr sectors (120034 MB)
> Aug 26 06:11:26 localhost kernel: sda: Write Protect is off
> Aug 26 06:11:26 localhost kernel: SCSI device sda: write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 26 06:11:26 localhost kernel: SCSI device sda: 234441648 512-byte
> hdwr sectors (120034 MB)
> Aug 26 06:11:26 localhost kernel: sda: Write Protect is off
> Aug 26 06:11:26 localhost kernel: SCSI device sda: write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 26 06:11:26 localhost kernel:  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
> 
> 
> 
> While booting with 2.6.22.5, the logs are:
> 
> Aug 26 09:30:04 localhost kernel: ACPI: PCI Interrupt 0000:00:1f.2[B]
> -> GSI 17 (level, low) -> IRQ 17
> Aug 26 09:30:04 localhost kernel: ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
> Aug 26 09:30:04 localhost kernel: ata_piix 0000:00:1f.2: 0x170 IDE port busy
> Aug 26 09:30:04 localhost kernel: ata_piix 0000:00:1f.2: no available
> legacy port
> 
> 
> 
> It seems the dramatic change in libata.c incurs this failure.

It looks like you have some CONFIG_IDE options enabled in your kernel 
configuration that result in drivers/ide trying to drive part or all of 
that controller, preventing libata from doing so. Likely the easiest 
thing to do is just set CONFIG_IDE=n entirely..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

