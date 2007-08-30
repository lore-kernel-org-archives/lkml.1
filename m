Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXH3R4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXH3R4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbXH3R4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:56:31 -0400
Received: from smtp141.iad.emailsrvr.com ([207.97.245.141]:50001 "EHLO
	smtp141.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076AbXH3R4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:56:30 -0400
Message-ID: <46D70467.1040109@gentoo.org>
Date: Thu, 30 Aug 2007 13:54:47 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Ulrich Kunitz <kune@deine-taler.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/30] net: Don't do pointless kmalloc return value casts
 in zd1211 driver
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <d551047daed1cb4d9de1eff956268a468c9837f6.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <d551047daed1cb4d9de1eff956268a468c9837f6.1187912217.git.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Since kmalloc() returns a void pointer there is no reason to cast
> its return value.
> This patch also removes a pointless initialization of a variable.

NAK: adds a sparse warning
zd_chip.c:116:15: warning: implicit cast to nocast type

> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>  drivers/net/wireless/zd1211rw/zd_chip.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
> index c39f198..4942e5c 100644
> --- a/drivers/net/wireless/zd1211rw/zd_chip.c
> +++ b/drivers/net/wireless/zd1211rw/zd_chip.c
> @@ -106,8 +106,8 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
>  {
>  	int r;
>  	int i;
> -	zd_addr_t *a16 = (zd_addr_t *)NULL;
>  	u16 *v16;
> +	zd_addr_t *a16;
>  	unsigned int count16;
>  
>  	if (count > USB_MAX_IOREAD32_COUNT)
> @@ -115,8 +115,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
>  
>  	/* Allocate a single memory block for values and addresses. */
>  	count16 = 2*count;
> -	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> -		                   GFP_KERNEL);
> +	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)), GFP_KERNEL);
>  	if (!a16) {
>  		dev_dbg_f(zd_chip_dev(chip),
>  			  "error ENOMEM in allocation of a16\n");

