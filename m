Return-Path: <linux-kernel-owner+w=401wt.eu-S1761723AbXFKJ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723AbXFKJ0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 05:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXFKJ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 05:26:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:3007 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbXFKJ0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 05:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nMS0M3DazlBKijOIqL8bnob9dnv3eaAayeS/bB/iuyNSXBdWdIN/evDtwXm8kcKioW/DdxXL+sM+ZKN4R6Cqz/cocQk6QgaNfQu+oirxfHrVx/nYka5jUSVYEot6ra/4DMvItluc5eB29Hd0ImusohfHxL1T9stkwX0SVHbqXRI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] pata_it821x: (partially) fix DMA in RAID mode
Date: Mon, 11 Jun 2007 11:37:26 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
References: <200706101843.20947.bzolnier@gmail.com> <466CD502.6010201@garzik.org>
In-Reply-To: <466CD502.6010201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706111137.26343.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007, Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Code intended to check DMA status was checking DMA command register.
> > 
> > Moreover firmware seems to "forget" to set DMA capable bit for the
> > slave device (at least in RAID mode but without ITE RAID volumes) so
> > check device ID for DMA capable bit when deciding whether to use DMA
> > and remove DMA status check completely.
> > 
> > Thanks to Pavol ©imo for the bugreport and testing the initial fix.
> > 
> > This change unfortunately still doesn't fix DMA in RAID mode (which
> > works fine with IDE it821x) but Alan is working on the missing pieces
> > (pata_it821x vs libata EH issues).
> > 
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Cc: Tejun Heo <htejun@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > 
> >  drivers/ata/pata_it821x.c |   11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> Patch is OK but it's mangled by your mailer:
> 
> @@ -79,7 +80,7 @@
> =20
> =20
>   #define DRV_NAME "pata_it821x"
> =2D#define DRV_VERSION "0.3.6"
> +#define DRV_VERSION "0.3.7"
> =20
>   struct it821x_dev
>   {
> @@ -460,14 +461,8 @@ static unsigned int it821x_passthru_qc_i
> =20
> 
> =2D     int dma_enabled =3D 0;
>          int i;
> =20
> 
> etc.

Ah, non-ASCII char confused the mailer... resend.  Sorry for that.
