Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZFWIAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZFWIAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZFWIAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:00:44 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:56749 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZFWIAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:00:43 -0400
Date: Tue, 23 Jun 2009 10:00:33 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: roel.kluin@gmail.com, Mikael Starvik <mikael.starvik@axis.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FW: [PATCH] cris: remove redundant tests on unsigned
Message-ID: <20090623080033.GX12383@axis.com>
References: <4BEA3FF3CAA35E408EA55C7BE2E61D053B0952BE56@xmail3.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEA3FF3CAA35E408EA55C7BE2E61D053B0952BE56@xmail3.se.axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks good, I'll pull it into my CRIS tree.

Thanks!

/Jesper

On Mon, Jun 22, 2009 at 03:11:05PM +0200, Mikael Starvik wrote:
> -----Original Message-----
> From: Roel Kluin [mailto:roel.kluin@gmail.com] 
> Sent: den 22 juni 2009 17:07
> To: Mikael Starvik
> Cc: dev-etrax; Andrew Morton
> Subject: [PATCH] cris: remove redundant tests on unsigned
> 
> Since dmanr is unsigned, negatives are wrapped and caught by the other test.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/arch/cris/arch-v10/kernel/dma.c b/arch/cris/arch-v10/kernel/dma.c
> index 929e686..d31504b 100644
> --- a/arch/cris/arch-v10/kernel/dma.c
> +++ b/arch/cris/arch-v10/kernel/dma.c
> @@ -24,7 +24,7 @@ int cris_request_dma(unsigned int dmanr, const char * device_id,
>  	unsigned long int gens;
>  	int fail = -EINVAL;
>  
> -	if ((dmanr < 0) || (dmanr >= MAX_DMA_CHANNELS)) {
> +	if (dmanr >= MAX_DMA_CHANNELS) {
>  		printk(KERN_CRIT "cris_request_dma: invalid DMA channel %u\n", dmanr);
>  		return -EINVAL;
>  	}
> @@ -213,7 +213,7 @@ int cris_request_dma(unsigned int dmanr, const char * device_id,
>  void cris_free_dma(unsigned int dmanr, const char * device_id)
>  {
>  	unsigned long flags;
> -	if ((dmanr < 0) || (dmanr >= MAX_DMA_CHANNELS)) {
> +	if (dmanr >= MAX_DMA_CHANNELS) {
>  		printk(KERN_CRIT "cris_free_dma: invalid DMA channel %u\n", dmanr);
>  		return;
>  	}
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
