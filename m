Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYBGQOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYBGQOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbYBGQOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:14:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:25339 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844AbYBGQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dOgFDpSeNDul8rNWgvPvLRHZn5vIRtGUbJkgDUWA3rnBYM6mKvmJFYmbtO+zzgsfSAzMxjH7DrZjWtoxdljdlCkSoZQ2cDUkNDOjyWe9mb3cMqZHy84E+gRNOohH47ndsabXN9+pQwz8B33DTjeQz0hcH3hSqsnS7A0O2lSXWf0=
Message-ID: <58cb370e0802070814y44e37cf4h91f57fd4bc993133@mail.gmail.com>
Date: Thu, 7 Feb 2008 17:14:18 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/3] palm_bk3710: factor out cable detection
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Anton Salnikov" <asalnikov@ru.mvista.com>
In-Reply-To: <47AB1882.8060103@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802071542.29628.bzolnier@gmail.com>
	 <47AB1882.8060103@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 3:41 PM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Bartlomiej Zolnierkiewicz wrote:
>
> > Factor out cable detection to palm_bk3710_cable_detect().
>
> > Cc: Anton Salnikov <asalnikov@ru.mvista.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>
> > Index: b/drivers/ide/arm/palm_bk3710.c
> > ===================================================================
> > --- a/drivers/ide/arm/palm_bk3710.c
> > +++ b/drivers/ide/arm/palm_bk3710.c
> > @@ -311,6 +311,12 @@ static void __devinit palm_bk3710_chipin
> >       palm_bk3710_setpiomode(base, NULL, 0, 600, 0);
> >       palm_bk3710_setpiomode(base, NULL, 1, 600, 0);
> >  }
> > +
> > +static u8 __devinit palm_bk3710_cable_detect(ide_hwif_t *hwif)
> > +{
> > +     return ATA_CBL_PATA80;
> > +}
> > +
> >  static int __devinit palm_bk3710_probe(struct platform_device *pdev)
> >  {
> >       struct clk *clkp;
> > @@ -381,7 +387,7 @@ static int __devinit palm_bk3710_probe(s
> >       hwif->set_dma_mode = &palm_bk3710_set_dma_mode;
> >       hwif->mmio = 1;
> >       default_hwif_mmiops(hwif);
> > -     hwif->cbl = ATA_CBL_PATA80;
> > +     hwif->cbl = palm_bk3710_cable_detect(hwif);
> >       hwif->ultra_mask = 0x1f;        /* Ultra DMA Mode 4 Max
> >                                               (input clk 99MHz) */
> >       hwif->mwdma_mask = 0x7;
>
>     Hm, how does it help if you don't make it into driver's method? :-O

This was meant to be a preparation before converting palm_bk3710 to
use struct ide_port_info.  On the second thought this change may be as
well integrated into the future patch (which I'll try to cook later
today, unless somebody beats me to it ;-).

Thanks,
Bart
