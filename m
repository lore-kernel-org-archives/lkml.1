Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbYCEBXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbYCEBXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935638AbYCEBVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:21:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:47900 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935176AbYCEBVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=H+9EH/3vq1e5lrxfHH2TP9CX8jREpiNapWfwt5eMQPsrdRfVauIonpjDBX1dLn1gzYJc1Zo9J6B8WCFVDaEkhHUWdmUfW/IKjr17vhg/2gUIp2r3oRKc/gdJ6qCLNkau3q1GhzlK06R/8l3h8+04KmpWmukjnDNu13jXhG8QWcQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: akpm@linux-foundation.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
Date: Wed, 5 Mar 2008 02:34:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       alan@redhat.com, linux-kernel@vger.kernel.org
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
In-Reply-To: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803050234.40594.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff,

Could we get this merged ASAP (it was first posted on 26th February)?

This patch fixes data corruption for libata PATA ServerWorks and HPT drivers.

[ IDE users are already leaving happy life since they are not affected
  (modes masking has always worked correctly in the original drivers)...

  Can we make life happy also for libata PATA users? :) ]

On Wednesday 05 March 2008, akpm@linux-foundation.org wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> When masking mask out the modes that are unsupported not the ones that are
> supported.  This makes life happier.
> 
> [akpm@linux-foundation.org: coding-style fixes]
> Signed-off-by: Alan Cox <alan@redhat.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/ata/pata_hpt366.c      |    6 +++---
>  drivers/ata/pata_hpt37x.c      |    6 +++---
>  drivers/ata/pata_serverworks.c |    2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff -puN drivers/ata/pata_hpt366.c~pata-i-do-not-think-it-means-what-you-think-it-means drivers/ata/pata_hpt366.c
> --- a/drivers/ata/pata_hpt366.c~pata-i-do-not-think-it-means-what-you-think-it-means
> +++ a/drivers/ata/pata_hpt366.c
> @@ -27,7 +27,7 @@
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"pata_hpt366"
> -#define DRV_VERSION	"0.6.1"
> +#define DRV_VERSION	"0.6.2"
>  
>  struct hpt_clock {
>  	u8	xfer_speed;
> @@ -180,9 +180,9 @@ static unsigned long hpt366_filter(struc
>  		if (hpt_dma_blacklisted(adev, "UDMA",  bad_ata33))
>  			mask &= ~ATA_MASK_UDMA;
>  		if (hpt_dma_blacklisted(adev, "UDMA3", bad_ata66_3))
> -			mask &= ~(0x07 << ATA_SHIFT_UDMA);
> +			mask &= ~(0xF8 << ATA_SHIFT_UDMA);
>  		if (hpt_dma_blacklisted(adev, "UDMA4", bad_ata66_4))
> -			mask &= ~(0x0F << ATA_SHIFT_UDMA);
> +			mask &= ~(0xF0 << ATA_SHIFT_UDMA);
>  	}
>  	return ata_pci_default_filter(adev, mask);
>  }
> diff -puN drivers/ata/pata_hpt37x.c~pata-i-do-not-think-it-means-what-you-think-it-means drivers/ata/pata_hpt37x.c
> --- a/drivers/ata/pata_hpt37x.c~pata-i-do-not-think-it-means-what-you-think-it-means
> +++ a/drivers/ata/pata_hpt37x.c
> @@ -24,7 +24,7 @@
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"pata_hpt37x"
> -#define DRV_VERSION	"0.6.9"
> +#define DRV_VERSION	"0.6.11"
>  
>  struct hpt_clock {
>  	u8	xfer_speed;
> @@ -281,7 +281,7 @@ static unsigned long hpt370_filter(struc
>  		if (hpt_dma_blacklisted(adev, "UDMA", bad_ata33))
>  			mask &= ~ATA_MASK_UDMA;
>  		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
> -			mask &= ~(0x1F << ATA_SHIFT_UDMA);
> +			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
>  	}
>  	return ata_pci_default_filter(adev, mask);
>  }
> @@ -297,7 +297,7 @@ static unsigned long hpt370a_filter(stru
>  {
>  	if (adev->class == ATA_DEV_ATA) {
>  		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
> -			mask &= ~ (0x1F << ATA_SHIFT_UDMA);
> +			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
>  	}
>  	return ata_pci_default_filter(adev, mask);
>  }
> diff -puN drivers/ata/pata_serverworks.c~pata-i-do-not-think-it-means-what-you-think-it-means drivers/ata/pata_serverworks.c
> --- a/drivers/ata/pata_serverworks.c~pata-i-do-not-think-it-means-what-you-think-it-means
> +++ a/drivers/ata/pata_serverworks.c
> @@ -226,7 +226,7 @@ static unsigned long serverworks_csb_fil
>  
>  	for (i = 0; (p = csb_bad_ata100[i]) != NULL; i++) {
>  		if (!strcmp(p, model_num))
> -			mask &= ~(0x1F << ATA_SHIFT_UDMA);
> +			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
>  	}
>  	return ata_pci_default_filter(adev, mask);
>  }
