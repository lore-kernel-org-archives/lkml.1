Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZLJI2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZLJI2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbZLJI2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:28:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57875 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbZLJI2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:28:34 -0500
Date: Thu, 10 Dec 2009 09:28:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/12] arch/arm: Correct size given to memset
Message-ID: <20091210082803.GA6255@pengutronix.de>
References: <Pine.LNX.4.64.0912092022040.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0912092022040.1870@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 09, 2009 at 08:22:26PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Memset should be given the size of the structure, not the size of the pointer.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> T *x;
> expression E;
> @@
> 
> memset(x, E, sizeof(
> + *
>  x))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/arm/plat-mxc/dma-mx1-mx2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/arch/arm/plat-mxc/dma-mx1-mx2.c b/arch/arm/plat-mxc/dma-mx1-mx2.c
> --- a/arch/arm/plat-mxc/dma-mx1-mx2.c
> +++ b/arch/arm/plat-mxc/dma-mx1-mx2.c
> @@ -694,7 +694,7 @@ int imx_dma_request(int channel, const c
>  		local_irq_restore(flags);
>  		return -EBUSY;
>  	}
> -	memset(imxdma, 0, sizeof(imxdma));
> +	memset(imxdma, 0, sizeof(*imxdma));
>  	imxdma->name = name;
>  	local_irq_restore(flags); /* request_irq() can block */
Patch is OK, Sascha, if you take it you can add my Ack, if not I can
take care of it in my cleanup series.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
