Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304Ab0AKXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab0AKXOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538Ab0AKXOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:14:11 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65491 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0AKXOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:14:10 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19DjowSK5HHKSCjS52e8l/+
Date: Mon, 11 Jan 2010 15:14:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: dma_chan[lch_head].flag & OMAP_DMA_ACTIVE tested
 twice in omap_dma_unlink_lch()
Message-ID: <20100111231415.GE5055@atomide.com>
References: <4B488ABF.4070403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B488ABF.4070403@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin <roel.kluin@gmail.com> [100109 05:49]:
> The same flag and bits were tested twice.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/arm/plat-omap/dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Is this what was intended? please review.

Thanks, nice catch. Will queue into omap-fixes.

Regards,

Tony
 
> diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> index 09d82b3..728c642 100644
> --- a/arch/arm/plat-omap/dma.c
> +++ b/arch/arm/plat-omap/dma.c
> @@ -1183,7 +1183,7 @@ void omap_dma_unlink_lch(int lch_head, int lch_queue)
>  	}
>  
>  	if ((dma_chan[lch_head].flags & OMAP_DMA_ACTIVE) ||
> -	    (dma_chan[lch_head].flags & OMAP_DMA_ACTIVE)) {
> +	    (dma_chan[lch_queue].flags & OMAP_DMA_ACTIVE)) {
>  		printk(KERN_ERR "omap_dma: You need to stop the DMA channels "
>  		       "before unlinking\n");
>  		dump_stack();
