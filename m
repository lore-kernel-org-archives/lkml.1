Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYJUIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYJUIqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJUIqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:46:11 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54609 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYJUIqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:46:10 -0400
Message-ID: <48FD96C9.6060204@atmel.com>
Date: Tue, 21 Oct 2008 10:46:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atmel_lcdfb: unsigned irq_base cannot be negative
References: <48FD4F7E.6010708@gmail.com>
In-Reply-To: <48FD4F7E.6010708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

roel kluin :
> unsigned irq_base cannot be negative

Indeed. Thanks for taking this point !

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index f8d0a57..f93f57a 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -857,12 +857,12 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
>  		goto stop_clk;
>  	}
>  
> -	sinfo->irq_base = platform_get_irq(pdev, 0);
> -	if (sinfo->irq_base < 0) {
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
>  		dev_err(dev, "unable to get irq\n");
> -		ret = sinfo->irq_base;
>  		goto stop_clk;
>  	}
> +	sinfo->irq_base = ret;

I prefer changing the definition of irq_base to plain int.

So the patch becomes obvious:
-       unsigned long           irq_base;
+       int                     irq_base;

What do you think of this ?

I repost a patch addressing this issue.

Regards,
-- 
Nicolas Ferre

