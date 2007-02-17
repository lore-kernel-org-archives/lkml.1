Return-Path: <linux-kernel-owner+w=401wt.eu-S965134AbXBQMHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134AbXBQMHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965216AbXBQMHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:07:55 -0500
Received: from guri.is.scarlet.be ([193.74.71.22]:52513 "EHLO
	guri.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134AbXBQMHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:07:54 -0500
Message-ID: <45D6EFF0.2000106@scarlet.be>
Date: Sat, 17 Feb 2007 12:07:12 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, Luming Yu <luming.yu@gmail.com>,
       Alan Cox <alan@redhat.com>, Ioan Ionita <opslynx@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be> <200702131915.12373.bzolnier@gmail.com>
In-Reply-To: <200702131915.12373.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Tuesday 13 February 2007 18:35, Joel Soete wrote:
> 
>> scsi3 : ata_piix
>> ata1.00: ATA-4, max UDMA/66, 29336832 sectors: LBA
>> ata1.00: ata1: dev 0 multi count 16
>> ata1.00: configured for UDMA/33
> 
> <...>
> 
>> scsi 3:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A03. PQ: 0 ANSI: 5
> 
> IDE driver with CONFIG_IDEDMA_IVB=y should give you UDMA/66.
> 
I didn't find this config option but most probably because I remove IDE support from my kernel to test this libata?
mmm btw, I still have to check how to access my floppy with libata?

that said as far as:
# dmesg
[snip]
ata_piix 0000:00:07.1: version 2.00ac7
ata1: PATA max UDMA/33 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
scsi3 : ata_piix
[snip]
(sorry, it seems that I forgot to copy it)

it make sense to me to limit to this bus capability?

> Could you send me output of "hdparm --Istdout /dev/sdc" command?
> 
# hdparm --Istdout /dev/sdc

/dev/sdc:
045a 3fff 0000 0010 7e00 5332 003f 0000
0000 5154 3937 3330 3036 3332 3633 3937
2020 2020 2020 2020 0003 0344 0004 4130
332e 3039 3030 5155 414e 5455 4d20 4649
5245 4241 4c4c 6c63 7431 3020 3135 2020
2020 2020 2020 2020 2020 2020 2020 8010
0000 0f00 4000 0200 0200 0007 3fff 0010
003f fc10 00fb 0110 a500 01bf 0000 0007
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
001e 0011 346b 4001 4000 3468 0001 4000
041f 0008 0000 0000 fffe 0040 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0001 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000

>> scsi4 : ata_piix
>> ata2.01: ATAPI, max MWDMA1
>> ata2.01: configured for MWDMA1
> 
> and "hdparm --Istdout /dev/sr0"
> 
# hdparm --Istdout /dev/sr0

/dev/sr0:
  HDIO_DRIVE_CMD(identify) failed: Input/output error

> [ max speed == MWDMA1 is possible but quite unusual ]
> 
sorry that wouldn't help ;-(

Thanks for feedback,
	Joel
> Thanks,
> Bart
> 
> 
