Return-Path: <linux-kernel-owner+w=401wt.eu-S933729AbXJRWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbXJRWvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761241AbXJRWu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:50:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:5966 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135AbXJRWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=G1RqgQ0OlUJURXFU8F+StnDfK/0U1r33kW0+gLqpitNQzQdCB0a1t/y+lyzdox9gWjDZoFB25zapxEkeKXdBHm8phH0RsyC7Ybb+HWI5BCimYG+CfQ1tJPDxJ6zN+X4lAcpskfZQVAQrkLhzMz3qeVYimjBLh/jjJb0O+CXRSAw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] ide: Add ide_get_paired_drive() helper
Date: Thu, 18 Oct 2007 23:10:13 +0200
User-Agent: KMail/1.9.7
Cc: Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, stable@kernel.org
References: <20071018005621.8F637DDEB8@ozlabs.org>
In-Reply-To: <20071018005621.8F637DDEB8@ozlabs.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710182310.13272.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007, Benjamin Herrenschmidt wrote:
> This adds a helper to get to the "other" drive on a pair connected
> to a given hwif.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

applied

-stable team: please include this patch series in 2.6.23.2

> ---
> 
> Note: You may want to use the 1 - select.b.unit construct instead,
> as you prefer, I just used what was there and fixed it.
> 
>  include/linux/ide.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-work/include/linux/ide.h
> ===================================================================
> --- linux-work.orig/include/linux/ide.h	2007-10-18 10:41:42.000000000 +1000
> +++ linux-work/include/linux/ide.h	2007-10-18 10:42:40.000000000 +1000
> @@ -1454,4 +1454,11 @@ static inline int hwif_to_node(ide_hwif_
>  	return dev ? pcibus_to_node(dev->bus) : -1;
>  }
>  
> +static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
> +{
> +	ide_hwif_t *hwif	= HWIF(drive);
> +
> +	return &hwif->drives[(drive->dn ^ 1) & 1];
> +}
> +
>  #endif /* _IDE_H */
