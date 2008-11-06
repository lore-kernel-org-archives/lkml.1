Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYKFPeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYKFPeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYKFPdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:33:52 -0500
Received: from mail.atmel.fr ([81.80.104.162]:54430 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYKFPdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:33:50 -0500
Message-ID: <49130E50.8090009@atmel.com>
Date: Thu, 06 Nov 2008 16:33:36 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Julien Brunel <brunel@diku.dk>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/video: Bad error test before a dereference
References: <200809261553.45301.brunel@diku.dk>
In-Reply-To: <200809261553.45301.brunel@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julien Brunel :
> The error test that follows the call to backlight_device_register
> semms not to concern the right variable.
> 
> A simplified version of the semantic match that finds this problem is
> as follows: 
> (http://www.emn.fr/x-info/coccinelle/)
> // <smpl>
> @def0@
> expression x;
> position p0;
> @@
> x@p0 = backlight_device_register(...)
> 
> @protected@
> expression def0.x,E;
> position def0.p0;
> position p;
> statement S;
> @@
> x@p0
> ... when != x = E
> if (!IS_ERR(x) && ...) {<... x@p ...>} else S
> 
> @unprotected@
> expression def0.x;
> identifier fld;
> position def0.p0;
> position p != protected.p;
> @@
> x@p0
> ... when != x = E
> * x@p->fld
> // </smpl>
> 
> Signed-off-by: Julien Brunel <brunel@diku.dk>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> 
> ---
>  drivers/video/atmel_lcdfb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -132,7 +132,7 @@ static void init_backlight(struct atmel_
>  
>  	bl = backlight_device_register("backlight", &sinfo->pdev->dev,
>  			sinfo, &atmel_lcdc_bl_ops);
> -	if (IS_ERR(sinfo->backlight)) {
> +	if (IS_ERR(bl)) {
>  		dev_err(&sinfo->pdev->dev, "error %ld on backlight register\n",
>  				PTR_ERR(bl));
>  		return;
> 

Thanks, regards,
-- 
Nicolas Ferre

