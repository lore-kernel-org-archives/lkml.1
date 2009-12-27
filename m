Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZL0VvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZL0VvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZL0VvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:51:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40883 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZL0VvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:51:17 -0500
Date: Sun, 27 Dec 2009 22:51:06 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] arch/arm: Correct NULL test
Message-ID: <20091227215106.GA18317@pengutronix.de>
References: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 10:26:54PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Test the just-allocated value for NULL rather than some other value.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> ....
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/arm/plat-pxa/dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
> --- a/arch/arm/plat-pxa/dma.c
> +++ b/arch/arm/plat-pxa/dma.c
> @@ -244,7 +244,7 @@ static void pxa_dma_init_debugfs(void)
>  
>  	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
>  			     GFP_KERNEL);
> -	if (!dbgfs_state)
> +	if (!dbgfs_chan)
>  		goto err_alloc;
Shouldn't the malloc line read:

	... = kmalloc(sizeof(*dbgfs_chan) * ...)
	                      ^^^^^^^^^^

?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
