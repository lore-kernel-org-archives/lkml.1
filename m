Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbZKZRCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbZKZRCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbZKZRB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:01:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60854 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955AbZKZRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:01:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=W9LUJntie6tz4u3v0/P4Ojr8eLIjrDQtZv8MklPnacPFXbQOvK0oGfLajvLzFxkQ2z
         Vlx9tSyNV1NIwSgsnh5SfDjY+0rFdIOReWQNZ11Xh/1uMtEc24I0w+70Nm+VE3xALGlK
         hrqHz7U0LiPKxxi8oDmjIH3Mp6amDq3otDIGk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 18:00:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200911261728.36433.bzolnier@gmail.com>
In-Reply-To: <200911261728.36433.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911261800.55025.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 05:28:36 pm Bartlomiej Zolnierkiewicz wrote:
> 
> MWDMA0 timings cannot be met with the PIIX based controller
> programming interface.
> 
> This change should be safe as this is how we have been doing
> things in IDE it8213 host driver for years.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Verified with the documentation (similar case as with pata_efar).

Uhhh, no...

Too many damn drivers.

Too much damn duplication.

Too much damn subtle differences here and there.

The hardware is probably fine for MWMDA0 when it comes to pata_{efar,it8213},
it just not documented properly in the data sheet.

I'll drop those two patches from my tree and take some break..

> On top of patches from yesterday.
> 
>  drivers/ata/pata_it8213.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/ata/pata_it8213.c
> ===================================================================
> --- a/drivers/ata/pata_it8213.c
> +++ b/drivers/ata/pata_it8213.c
> @@ -227,7 +227,7 @@ static int it8213_init_one (struct pci_d
>  	static const struct ata_port_info info = {
>  		.flags		= ATA_FLAG_SLAVE_POSS,
>  		.pio_mask	= ATA_PIO4,
> -		.mwdma_mask	= ATA_MWDMA2,
> +		.mwdma_mask	= ATA_MWDMA12_ONLY,
>  		.udma_mask 	= ATA_UDMA6,
>  		.port_ops	= &it8213_ops,
>  	};
