Return-Path: <linux-kernel-owner+w=401wt.eu-S1764468AbXJRWvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764468AbXJRWvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbXJRWu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:50:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5727 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088AbXJRWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=VTZNw+2TD3V1OyicH3BbfFEjY1O4+b3IBChzVoS+kyT1nMEZXd3pY0pQI7bxXCEf8P3+6Gl66tiaJbadlAU8oLtCb+lhuhyOgxY0i1+kP9DmwCQMtbC94gsUAvBEc4G3r2YdLJQ1rhyVp3hL+SL/qPCR6oRbTlj01u5+/dM1X0k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/3] ide: Fix siimage driver accessing beyond array boundary
Date: Thu, 18 Oct 2007 23:10:46 +0200
User-Agent: KMail/1.9.7
Cc: Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, stable@kernel.org
References: <20071018005623.153C7DDEBD@ozlabs.org>
In-Reply-To: <20071018005623.153C7DDEBD@ozlabs.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710182310.46956.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007, Benjamin Herrenschmidt wrote:
> The siimage use an incorrect construct to access the other drive
> of a pair, causing it to access beyond an array boundary on non-0
> interfaces. This fixes it by using the new ide_get_paired_drive()
> hepler instead.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

applied with patch description fixes

> ---
> 
>  drivers/ide/pci/siimage.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-work/drivers/ide/pci/siimage.c
> ===================================================================
> --- linux-work.orig/drivers/ide/pci/siimage.c	2007-10-18 10:42:56.000000000 +1000
> +++ linux-work/drivers/ide/pci/siimage.c	2007-10-18 10:43:09.000000000 +1000
> @@ -180,7 +180,7 @@ static void sil_set_pio_mode(ide_drive_t
>  	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
>  
>  	ide_hwif_t *hwif	= HWIF(drive);
> -	ide_drive_t *pair	= &hwif->drives[drive->dn ^ 1];
> +	ide_drive_t *pair	= ide_get_paired_drive(drive);
>  	u32 speedt		= 0;
>  	u16 speedp		= 0;
>  	unsigned long addr	= siimage_seldev(drive, 0x04);
