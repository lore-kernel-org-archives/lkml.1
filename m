Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXKNPFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXKNPFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXKNPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:05:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:53716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbXKNPFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:05:17 -0500
Date: Wed, 14 Nov 2007 16:05:14 +0100
From: Karsten Keil <kkeil@suse.de>
To: Frank Lichtenheld <frank@lichtenheld.de>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] [ISDN] sc: Really, really fix warning
Message-ID: <20071114150513.GA7926@pingi.kke.suse.de>
Mail-Followup-To: Frank Lichtenheld <frank@lichtenheld.de>,
	linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <1195051581-15842-1-git-send-email-frank@lichtenheld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1195051581-15842-1-git-send-email-frank@lichtenheld.de>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 03:46:20PM +0100, Frank Lichtenheld wrote:
>   CC [M]  drivers/isdn/sc/shmem.o
> drivers/isdn/sc/shmem.c: In function ‘memcpy_toshmem’:
> drivers/isdn/sc/shmem.c:53: warning: passing argument 1 of ‘memcpy_toio’ makes pointer from integer without a cast
> 
> 9317d4313e0cd51b2256ea9a9316f2d8561e37a8 claimed to fix it, but
> it didn't.
> 
> CC: Jeff Garzik <jeff@garzik.org>
Acked-by:Karsten Keil <kkeilæsuse.de>
> Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
> ---
>  drivers/isdn/sc/shmem.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/sc/shmem.c b/drivers/isdn/sc/shmem.c
> index e0331e0..06a5554 100644
> --- a/drivers/isdn/sc/shmem.c
> +++ b/drivers/isdn/sc/shmem.c
> @@ -50,7 +50,7 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
>  
>  	outb(((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE) >> 14) | 0x80,
>  		sc_adapter[card]->ioport[sc_adapter[card]->shmem_pgport]);
> -	memcpy_toio(sc_adapter[card]->rambase + dest_rem, src, n);
> +	memcpy_toio((void*)(sc_adapter[card]->rambase + dest_rem), src, n);
>  	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
>  	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
>  		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
> -- 
> 1.5.3.4

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
