Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbXBJRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbXBJRVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXBJRVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:21:52 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:32998 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXBJRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:21:51 -0500
Date: Sat, 10 Feb 2007 11:20:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: AHCI - remove probing of ata2
In-reply-to: <fa.R5BFxVmVJj5OnAPGQI7410dt/fA@ifi.uio.no>
To: rol@as2917.net
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Message-id: <45CDFECC.5060500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.R5BFxVmVJj5OnAPGQI7410dt/fA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hello,
> 
> I'm using an Asus P5W DH motherboard, with an Intel ICH7 controler, and a 
> Jmicron JMB363.
> 
> On the Intel, I've connected an IDE HDD and a CD-RW, no problem.
> On the SATA side, i've connected 3 SATA disks, but at boot time, the kernel
> detects 4 ports, and goes on timeout on ata2 :
> 
> ..
> ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
> ata1: SATA max UDMA/133 cmd 0xFFFFC200000BC900 ctl 0x0 bmdma 0x0 irq 505
> ata2: SATA max UDMA/133 cmd 0xFFFFC200000BC980 ctl 0x0 bmdma 0x0 irq 505
> ata3: SATA max UDMA/133 cmd 0xFFFFC200000BCA00 ctl 0x0 bmdma 0x0 irq 505
> ata4: SATA max UDMA/133 cmd 0xFFFFC200000BCA80 ctl 0x0 bmdma 0x0 irq 505
> scsi0 : ahci
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth 31/32)
> ata1.00: ata1: dev 0 multi count 0
> ata1.00: configured for UDMA/133
> scsi1 : ahci
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
> ata2: port is slow to respond, please be patient (Status 0x80)
> ata2: port failed to respond (30 secs, Status 0x80)
> ata2: COMRESET failed (device not ready)
> ata2: hardreset failed, retrying in 5 secs
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: ATA-6, max UDMA/133, 640 sectors: LBA 
> ata2.00: ata2: dev 0 multi count 1
> ata2.00: configured for UDMA/133
> scsi2 : ahci
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth 31/32)
> ata3.00: ata3: dev 0 multi count 0
> ata3.00: configured for UDMA/133
> ..
> 
> Is there a way to exclude ata2 from probing ? Nothing is connected, and there
> is no associated port on the motherboard...

There is something connected, I believe what's actually there on this 
board on that port is the SiI4723 chip which is connected to two other 
SATA ports. For whatever reason it gets detected as a drive, and it also 
seems to be not responding until we do a few resets..

http://www.siliconimage.com/products/product.aspx?id=64

> 
> 
> The second problem is the Jmicron controler. It can act as IDE, SATA, ...
> but I've configured it as IDE in the BIOS, and connected a DRD-RW on.
> Problem is that IDE driver detects it, as containing ide2 and ide3, and
> when probing for the DVD, I've got a lot of timeout on the command.
> .. But, I'm lost in all the JMICRON configuration possibilities in the 
> kernel :
>  - it is detected by the IDE driver,
>  - it can be activated in ATA/ATAPI/MFM/RLL
>  - it can be activated in Serial ATA (prod) and Parallel ATA (experimental)
> 
> What should I select ?

My advice on recent kernels is just set CONFIG_IDE=n and enable 
PATA_JMICRON if you want JMicron support, unless you really want to use 
the crusty old IDE layer..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

