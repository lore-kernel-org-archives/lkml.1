Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab0BITSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:18:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:55987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0BITSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:18:02 -0500
Date: Tue, 9 Feb 2010 19:18:00 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Julia Lawall <julia@diku.dk>
cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/11] drivers/video/mbx: Correct NULL test
In-Reply-To: <Pine.LNX.4.64.1002060944400.8092@ask.diku.dk>
Message-ID: <alpine.LFD.2.00.1002091917340.26270@casper.infradead.org>
References: <Pine.LNX.4.64.1002060944400.8092@ask.diku.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Julia Lawall <julia@diku.dk>
> 
> Test the value that was just allocated rather than the previously tested one.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> expression *x;
> expression e;
> identifier l;
> @@
> 
> if (x == NULL || ...) {
>     ... when forall
>     return ...; }
> ... when != goto l;
>     when != x = e
>     when != &x
> *x == NULL
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: James Simmons <jsimmons@infradead.org>
 
> ---
>  drivers/video/mbx/mbxfb.c           |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
> index afea9ab..7140405 100644
> --- a/drivers/video/mbx/mbxfb.c
> +++ b/drivers/video/mbx/mbxfb.c
> @@ -950,7 +950,7 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
>  
>  	mfbi->fb_virt_addr = ioremap_nocache(mfbi->fb_phys_addr,
>  					     res_size(mfbi->fb_req));
> -	if (!mfbi->reg_virt_addr) {
> +	if (!mfbi->fb_virt_addr) {
>  		dev_err(&dev->dev, "failed to ioremap frame buffer\n");
>  		ret = -EINVAL;
>  		goto err4;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
