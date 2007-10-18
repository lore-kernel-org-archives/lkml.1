Return-Path: <linux-kernel-owner+w=401wt.eu-S934350AbXJRWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbXJRWvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762869AbXJRWue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:50:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:5966 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbXJRWu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Woq+6/mV6TZdraecoQTWUUZ0EqvAslfxgczpJ+niM4bNixFyMBjpPljCCZKfNRGKQWYWXVwV1QH7HsZ6Y8yJ7Mv3o4GJe/Nn+r/+iPQZJfA/5XN+wVTq4alnDlwIHMu2KtRplG9C3XIblB0s6PyGTBSJ62TaMpOavWtzj8XALvA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/3] ide: Fix cs5535 driver accessing beyond array boundary
Date: Thu, 18 Oct 2007 23:10:50 +0200
User-Agent: KMail/1.9.7
Cc: Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, stable@kernel.org
References: <20071018005624.DC749DDEAB@ozlabs.org>
In-Reply-To: <20071018005624.DC749DDEAB@ozlabs.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710182310.50315.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007, Benjamin Herrenschmidt wrote:
> The cs5535 use an incorrect construct to access the other drive
> of a pair, causing it to access beyond an array boundary on non-0
> interfaces. This fixes it by using the new ide_get_paired_drive()
> hepler instead.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

applied with patch description fixes

> ---
> 
>  drivers/ide/pci/cs5535.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-work/drivers/ide/pci/cs5535.c
> ===================================================================
> --- linux-work.orig/drivers/ide/pci/cs5535.c	2007-10-18 10:43:39.000000000 +1000
> +++ linux-work/drivers/ide/pci/cs5535.c	2007-10-18 10:44:00.000000000 +1000
> @@ -84,7 +84,7 @@ static void cs5535_set_speed(ide_drive_t
>  
>  	/* Set the PIO timings */
>  	if ((speed & XFER_MODE) == XFER_PIO) {
> -		ide_drive_t *pair = &drive->hwif->drives[drive->dn ^ 1];
> +		ide_drive_t *pair = ide_get_paired_drive(drive);
>  		u8 cmd, pioa;
>  
>  		cmd = pioa = speed - XFER_PIO_0;
