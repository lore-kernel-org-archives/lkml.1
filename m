Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYGRBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYGRBJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbYGRBJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:09:11 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27147 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753874AbYGRBJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:09:10 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=9gZnaWKhA_sJvBM6YncA:9 a=w7KUrYszZ2Kiap2N3iUA:7 a=Lc0y70IaNWsPi-wHtQ5QMMd7Dz4A:4 a=_k4lPXJt7qcA:10 a=NVE_liazxiUA:10
Message-ID: <487FED33.2030207@shaw.ca>
Date: Thu, 17 Jul 2008 19:09:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Frantisek Hanzlik <franta@hanzlici.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: serverworks CSB5 IDE: DMA disabled on secondary channel
References: <fa.Fmf0CiaCc/J+JAWaZ5FS+ihhhzA@ifi.uio.no>
In-Reply-To: <fa.Fmf0CiaCc/J+JAWaZ5FS+ihhhzA@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frantisek Hanzlik wrote:
> Server with Intel SHG2 board, servervorks CSB5 rev. 93: After
> upgrade from kernel 2.6.22 (IDE serverworks driver) to 2.6.25
> (Fedora 9: libata+pata_serverworks driver), SW RAID1 performance
> is very bad. Problem is probably with secondary IDE channel,
> which has disabled DMA:
> 
> # hdparm -Tt /dev/sda
> /dev/sda:
>  Timing cached reads:   828 MB in  2.00 seconds = 414.26 MB/sec
>  Timing buffered disk reads:  210 MB in  3.01 seconds =  69.83 MB/sec
> 
> # hdparm -Tt /dev/sdb
> /dev/sdb:
>  Timing cached reads:   408 MB in  2.00 seconds = 203.72 MB/sec
>  Timing buffered disk reads:    6 MB in  3.05 seconds =   1.96 MB/sec
> 
> dmesg output:
> ..
> libata version 3.00 loaded.
> PCI: Setting latency timer of device 0000:00:0f.1 to 64
> scsi0 : pata_serverworks
> scsi1 : pata_serverworks
> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2440 irq 14
> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2448 irq 15
> ata1.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
> ata1.00: 781422768 sectors, multi 16: LBA48
> ata1.01: ATAPI: TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
> ata1.00: configured for UDMA/100
> ata1.01: configured for UDMA/33
> ata2.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
> ata2.00: 781422768 sectors, multi 16: LBA48
> ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
> ata2.00: simplex DMA is claimed by other device, disabling DMA
> ata2.01: simplex DMA is claimed by other device, disabling DMA
> ata2.00: configured for PIO4
> ata2.01: configured for PIO4
> ..
> 
> # lsmod|grep ata
> pata_serverworks       10496  8
> pata_acpi               8320  0
> libata                127328  2 pata_serverworks,pata_acpi
> scsi_mod              120948  4 sg,sr_mod,libata,sd_mod
> 
> It's some sort of pata_serverworks bug, or is needed any special
> setup for this driver to work?
> What is "simplex DMA" term?

It means this controller can only do DMA on the primary or secondary 
channel, not both at the same time. It looks like libata currently deals 
with this by disabling DMA on the secondary channel. Not sure how the 
old IDE stuff handled it?

ServerWorks IDE always seemed to pretty much suck, I always got the 
impression that they stuck it on there as an afterthought just to 
operate a CD drive enough to install the OS..
