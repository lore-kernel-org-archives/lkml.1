Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYGSCqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYGSCqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 22:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYGSCqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 22:46:35 -0400
Received: from ns.hanzlici.cz ([212.158.159.56]:45542 "EHLO franta.hanzlici.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750772AbYGSCqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 22:46:34 -0400
Message-ID: <48815567.2080001@hanzlici.cz>
Date: Sat, 19 Jul 2008 04:45:59 +0200
From: Frantisek Hanzlik <franta@hanzlici.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9.0.2pre) Gecko/2008071601 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: serverworks CSB5 IDE: DMA disabled on secondary channel
References: <fa.Fmf0CiaCc/J+JAWaZ5FS+ihhhzA@ifi.uio.no>	<487FED33.2030207@shaw.ca> <20080718100607.1589ed2f@the-village.bc.nu>
In-Reply-To: <20080718100607.1589ed2f@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
>>> ata2.00: simplex DMA is claimed by other device, disabling DMA
>>> ata2.01: simplex DMA is claimed by other device, disabling DMA
>>> ata2.00: configured for PIO4
>>> ata2.01: configured for PIO4
>
>
> Disable the pata_acpi driver and let me know if it then behaves. We had a
> similar problem with the ATI hardware which lost and messed up its
> internal state if pata_acpi was loaded first.
>
Before I post to lkml I tried disable ata_generic driver, (which was loaded
before pata_serverworks too, my mail already not show it as is blacklisted),
but this not solved problem. YES, problem was in pata_acpi, after disabling
it all works fine (no matter if is ata_generic enabled and loaded before
pata_serverworks or not).
What is the meaning of "simplex DMA is claimed..." I probably must learn in
sources itself ;)
Many thanks, Alan, You are big magicians!

dmesg:
...
libata version 3.00 loaded.
scsi0 : pata_serverworks
scsi1 : pata_serverworks
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2440 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2448 irq 15
ata1.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
ata1.00: 781422768 sectors, multi 16: LBA48
ata1.01: ATAPI: TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
ata2.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
ata2.00: 781422768 sectors, multi 16: LBA48
ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
ata2.00: configured for UDMA/100
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST3400620A       3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:1:0: CD-ROM            TOSHIBA  DVD-ROM SD-M1612 1004 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      ST3400620A       3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 1:0:1:0: CD-ROM            TEAC     CD-W540E         1.0D PQ: 0 ANSI: 5
md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
...


# hdparm -Tt /dev/sda
/dev/sda:
  Timing cached reads:   732 MB in  2.00 seconds = 366.18 MB/sec
  Timing buffered disk reads:  206 MB in  3.01 seconds =  68.40 MB/sec

# hdparm -Tt /dev/sdb
/dev/sdb:
  Timing cached reads:   806 MB in  2.00 seconds = 402.65 MB/sec
  Timing buffered disk reads:  202 MB in  3.03 seconds =  66.72 MB/sec



