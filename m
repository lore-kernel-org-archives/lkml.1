Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXFUSDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXFUSDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXFUSDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:03:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:52221 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbXFUSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lN87bVnhMkYkAH0e5Rfwc6WaVKVU6LWpLZWA+N3PSKxY3AJBFRVgPFjDOPugk874OmcDADEWyUydBLhzl26Nqa32kBH97fA9vHX/rZU7PXyzdkNPUF5Lf5Pu++PqrjNmSf7RS4bylvwczjG5zsAEgmeapl/Ta9ovBF/HMr2oywE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 19/19] ide: use PIO/MMIO operations directly where possible
Date: Thu, 21 Jun 2007 20:19:17 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070112042621.28794.6937.sendpatchset@localhost.localdomain> <20070112042807.28794.8251.sendpatchset@localhost.localdomain> <467AB253.8010902@ru.mvista.com>
In-Reply-To: <467AB253.8010902@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706212019.18001.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sergei,

On Thursday 21 June 2007, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > [PATCH] ide: use PIO/MMIO operations directly where possible
> 
> > This results in smaller/faster/simpler code and allows future optimizations.
> > Also remove no longer needed ide[_mm]_{inl,outl}() and ide_hwif_t.{INL,OUTL}.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: a/drivers/ide/pci/hpt366.c
> > ===================================================================
> > --- a.orig/drivers/ide/pci/hpt366.c
> > +++ a/drivers/ide/pci/hpt366.c
> > @@ -836,7 +836,7 @@ static int hpt374_ide_dma_test_irq(ide_d
> >  		return 0;
> >  	}
> >  
> > -	dma_stat = hwif->INB(hwif->dma_status);
> > +	dma_stat = inb(hwif->dma_status);
> >  	/* return 1 if INTR asserted */
> >  	if (dma_stat & 4)
> >  		return 1;
> 
>     Hmm... this driver *still* has a lot more indirect I/O accessors -- I 
> wonder why only this one had been converted then?

The reason for this is that my patch was done before some of your patches
for HPT IDE driver and I never really got to doing follow-up patch.

IIRC piix.c and and tc86c100.c may also want an update.

Thanks,
Bart
