Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXELDuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXELDuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 23:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXELDuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 23:50:01 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41994 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXELDuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 23:50:00 -0400
Date: Sat, 12 May 2007 12:49:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: libata reset-seq merge broke sata_sil on sh
Message-ID: <20070512034928.GB29259@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	garyhade@us.ibm.com
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org> <464439C8.7090309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464439C8.7090309@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 11:39:20AM +0200, Tejun Heo wrote:
> Paul Mundt wrote:
> > Bumping the hardreset delay up does indeed fix it, I've had to bump it up
> > to 1200 before it started working (at 600 it still fails):
> > 
> > [    0.967379] scsi0 : sata_sil
> > [    0.970425] scsi1 : sata_sil
> > [    0.973298] ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
> > [    0.981331] ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
> > [    1.299353] ata1: device not ready (errno=-19), forcing hardreset
> > [    2.817893] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> > [    2.826284] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
> > [    2.831052] ata1.00: ATA-5: HHD424020F7SV00, 00MLA0A5, max UDMA/100
> > [    2.837548] ata1.00: 39070080 sectors, multi 0: LBA
> > [    2.842702] ata1.00: applying bridge limits
> > [    2.854162] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
> > [    2.858938] ata1.00: configured for UDMA/100
> > [    3.172602] ata2: SATA link down (SStatus 0 SControl 310)
> > [    3.175736] scsi 0:0:0:0: Direct-Access     ATA      HHD424020F7SV00  00ML PQ: 0 ANSI: 5
> > 
> > I'm not sure if it matters or not, but this is an iVDR drive, so that
> > might also have additional implications.
> 
> Don't have the flimsiest idea what an iVDR drive is but I take it that
> it's some sort of special purpose thing.  :-)
> 
http://www.ivdr.org

The GoVault appears to be a similar device, in that they're both
removeable cartridges.

> Gary, IIRC, the requirement for GoVault was 3secs, right?  Paul, can you
> try to estimate the minimum required delay?  Please go down by 100ms and
> report where it breaks.
> 
800ms was the lowest it would work at, 700ms still breaks.
