Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZDUNBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZDUNBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZDUNBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:01:24 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60751 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZDUNBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JpO1wXT+ucBQnlhQuZuCMIT56RTreuNUNBgcMJF8ZB132goNqKcMBHj5tw5I8TveJE
         03adbVGU0T5xKeIkyMLWdmMUI7sTUv4mhUtGnF21wnODsGSkwz4vx4r5vlSN+9L8uUKB
         4I5b5bx6H6CT+35BaZVkI8dO559xbDyaBSP1w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: =?iso-8859-15?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: Quick question about libata and hdparm
Date: Tue, 21 Apr 2009 14:59:26 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <20090420221955.2c71bd26@lxorguk.ukuu.org.uk> <20090421053258.GA18001@ime.usp.br>
In-Reply-To: <20090421053258.GA18001@ime.usp.br>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904211459.26965.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009 07:32:58 Rogério Brito wrote:
> Hi Alan, Bart and Co.
> 
> On Apr 20 2009, Alan Cox wrote:
> > > DISCLAIMER: I'm not handling this bugreport, this is best
> > > done by pata_pdc202xx_old Maintainer or libata Maintainer.
> > 
> > Be that as it may thanks - thats well spotted and definitely a bug.
> 
> Well, I just compiled the kernel both with libata and with the usual IDE
> drivers.
> 
> Unfortunately, it seems that Bart's patch isn't enough. OTOH, when I use
> the older IDE drive, it seems to work OK, as the attached dmesgs show
> (BTW, you may notice that there's something fishy with X, but that's
> another story).

Incremental patch (a certain theory to verify).
---
 drivers/ata/pata_pdc202xx_old.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -163,9 +163,11 @@ static void pdc2026x_bmdma_start(struct 
 	else
 		iowrite8(ioread8(clock) & ~sel66, clock);
 
+	/* FIXME: this thrashes internal UDMA timings previously set by
+	   controller on SET FEATURES - XFER MODE command "snooping" */
 	/* The DMA clocks may have been trashed by a reset. FIXME: make conditional
 	   and move to qc_issue ? */
-	pdc202xx_set_dmamode(ap, qc->dev);
+	/* pdc202xx_set_dmamode(ap, qc->dev); */
 
 	/* Cases the state machine will not complete correctly without help */
 	if ((tf->flags & ATA_TFLAG_LBA48) ||  tf->protocol == ATAPI_PROT_DMA) {
