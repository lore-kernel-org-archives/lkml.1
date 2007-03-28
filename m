Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXC1AJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXC1AJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 20:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXC1AJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 20:09:05 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:39367 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXC1AJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 20:09:04 -0400
Date: Wed, 28 Mar 2007 01:08:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070328000851.GA25551@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: HPA patches
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 07:13:21PM +0000, Alan Cox wrote:
> For reference this is what I am currently using with 2.6.21-rc4-mm1 and
> it is working for all my test cases so far: Its basically Kyle's patch
> with a libata switch to turn it on/off and some minor fixups from
> the original patch as posted

Fails for me on a Macbook Pro with:

ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140b0 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140b8 irq 15
scsi0: ata_piix
ata1.00: ATAPI, max UDMA/66
ata1.00: configured for UDMA/66
scsi1 : ata_piix
ATA: abornaml status 0x7f on port 0x00010177
scsi 0:0:0:0: CD-ROM MATSHITA DVD-R UJ-857D KCV9 PQ : 0 ANSI: 5
ata_piix 0000:00:1f.2: MAP [ P0 p" XX XX ]
ata_piix 0000:00:1f.2: invalid MAP value 0
ata3: SATA max UDMA/133 cmd 0x000140c8 ctl 0x000140e6 bmdma 0x000140a0 irq 20
ata4: SATA max UDMA/133 cmd 0x000140c0 ctl 0x000140e2 bmdma 0x000140a8 irq 20
scsi2 : ata_piix
ATA: abnormal status 0x7F on port 0x000140cf
ATA: abnormal status 0x7F on port 0x000140cf
ATA: abnormal status 0x7F on port 0x000140cf
ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 0
ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.01: failed to set xfermode (err_mask=0x40)
ata3: failed to recover some devices, retrying in 5 secs
ATA: abnormal status 0x7F on port 0x000140cf
ATA: abnormal status 0x7F on port 0x000140cf
ATA: abnormal status 0x7F on port 0x000140cf
ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 0
ata3.01: failed to set xfermode (err_mask=0x40)
ata3.01: limiting speed to UDMA/100:PIO3
ata3: failed to recover some devices, retrying in 5 secs
ATA: abnormal status 0x7F on port 0x000140cf
ATA: abnormal status 0x7F on port 0x000140cf
ATA: abnormal status 0x7F on port 0x000140cf
ata3.01: qc timeout (cmd 0x27)
ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 0
ata3.01: failed to set xfermode (err_mask=0x40)
ata3.01: disabled
scsi3: ata_piix
ATA: abnormal status 0x7F on port 0x000140c7

and I end up with no root filesystem. Reverting the patch leaves things 
working. This is the ubuntu tree - I can try libata-dev if you think 
there's likely to be any relevant difference.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
