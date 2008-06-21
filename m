Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYFUTWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYFUTWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYFUTWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:14 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:54980 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYFUTWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AZJpvmBwyl4ojZ+GMocP8YBwjJjrsFilUzulZfASOwpn4ALaeA3vnUZ7FmiCe/NQeV
         zQgpFsE2a8YKFV28SAYCxLsM1E0tXVATTZR66j+XmzIDVmXpg2OaBGf1yhRnOS4EvMSj
         8dF6nu9ed7SnBUnxahlCeDSv8XodZFvWyf6TU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 04/18] ide: remove ide_setup_dma()
Date: Sat, 21 Jun 2008 21:06:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213350.13202.73557.sendpatchset@localhost.localdomain> <485C2924.7040905@ru.mvista.com>
In-Reply-To: <485C2924.7040905@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212106.03484.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > Export sff_dma_ops and then remove ide_setup_dma().
> >
> > There should be no functional changes caused by this patch.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >
> >   
> [...]
> > Index: b/drivers/ide/arm/palm_bk3710.c
> > ===================================================================
> > --- a/drivers/ide/arm/palm_bk3710.c
> > +++ b/drivers/ide/arm/palm_bk3710.c
> > @@ -318,15 +318,14 @@ static u8 __devinit palm_bk3710_cable_de
> >  static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
> >  					  const struct ide_port_info *d)
> >  {
> > -	unsigned long base =
> > -		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
> > -
> >  	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
> >  
> >  	if (ide_allocate_dma_engine(hwif))
> >  		return -1;
> >  
> > -	ide_setup_dma(hwif, base);
> > +	hwif->dma_base = hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
> >   
> 
>    That's er... too complex. Actually, 'base' has the value for 
> 'dma_base' at that moment...

Well, the above place is the only user of 'base' so isn't the variable
kind of superfluous?

Thanks,
Bart
