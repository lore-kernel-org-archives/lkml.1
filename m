Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXJXHYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXJXHYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJXHYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:24:44 -0400
Received: from ns.suse.de ([195.135.220.2]:39815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXJXHYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:24:44 -0400
Date: Wed, 24 Oct 2007 09:24:40 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 5/12] ISDN/sc: fix longstanding warning
Message-ID: <20071024072440.GA17250@pingi.kke.suse.de>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	isdn4linux@listserv.isdn4linux.de
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223639.DF51F1F81AB@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071023223639.DF51F1F81AB@havoc.gtf.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 06:36:39PM -0400, Jeff Garzik wrote:
> drivers/isdn/sc/shmem.c: In function ‘memcpy_toshmem’:
> drivers/isdn/sc/shmem.c:54: warning: passing argument 1 of ‘memcpy_toio’ makes pointer from integer without a cast
> 
> Also, remove some unneeded braces, and add some useful whitespace.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Acked.
> ---
> 
> diff --git a/drivers/isdn/sc/shmem.c b/drivers/isdn/sc/shmem.c
> index 034d41a..e0331e0 100644
> --- a/drivers/isdn/sc/shmem.c
> +++ b/drivers/isdn/sc/shmem.c
> @@ -28,15 +28,15 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
>  {
>  	unsigned long flags;
>  	unsigned char ch;
> +	unsigned long dest_rem = ((unsigned long) dest) % 0x4000;
>  
> -	if(!IS_VALID_CARD(card)) {
> +	if (!IS_VALID_CARD(card)) {
>  		pr_debug("Invalid param: %d is not a valid card id\n", card);
>  		return;
>  	}
>  
> -	if(n > SRAM_PAGESIZE) {
> +	if (n > SRAM_PAGESIZE)
>  		return;
> -	}
>  
>  	/*
>  	 * determine the page to load from the address
> @@ -50,8 +50,7 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
>  
>  	outb(((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE) >> 14) | 0x80,
>  		sc_adapter[card]->ioport[sc_adapter[card]->shmem_pgport]);
> -	memcpy_toio(sc_adapter[card]->rambase +
> -		((unsigned long) dest % 0x4000), src, n);
> +	memcpy_toio(sc_adapter[card]->rambase + dest_rem, src, n);
>  	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
>  	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
>  		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
