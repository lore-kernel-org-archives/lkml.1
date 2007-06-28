Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbXF1O3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbXF1O3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbXF1O3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:29:32 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51540 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbXF1O3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:29:32 -0400
Date: Thu, 28 Jun 2007 16:29:16 +0200 (MEST)
Message-Id: <200706281429.l5SETGND008605@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, htejun@gmail.com, jeff@garzik.org,
       torvalds@linux-foundation.org
Subject: Re: [git patches] libata fixes
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 03:35:26 -0400, Jeff Garzik wrote:
>Tejun Heo (9):
>      libata: kill the infamous abnormal status message
>      libata: kill non-sense warning message
>      libata: be less verbose about hpa
>      libata: remove unused variable from ata_eh_reset()
>      libata: fix ata_dev_disable()
>      libata: fix infinite EH waiting bug
>      libata: call ata_check_atapi_dma() with qc better prepared
>      libata: use PIO for non-16 byte aligned ATAPI commands
>      libata: kill ATA_HORKAGE_DMA_RW_ONLY

These changes fixed the CDROM IDENTIFY failures one of
my older test machines used to get with libata. I now
get much nicer results on that machine:

ata_piix 0000:00:1f.1: version 2.11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
ata1.00: ATA-5: IC35L080AVVA07-0, VA4OA52A, max UDMA/100
ata1.00: 160836480 sectors, multi 16: LBA 
ata1.00: configured for UDMA/100
ata2.00: ATAPI: CRD-8320B, 1.12, max MWDMA2
ata2.01: ATAPI: Hewlett-Packard CD-Writer Plus 9100, 1.0c, max UDMA/33
ata2.00: configured for MWDMA2
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IC35L080AVVA07-0 VA4O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            GoldStar CD-ROM CRD-8320B 1.12 PQ: 0 ANSI: 5
scsi 1:0:1:0: CD-ROM            HP       CD-Writer+ 9100  1.0c PQ: 0 ANSI: 5

It's the CRD-8320B that used to time out and fail IDENTIFY.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>
