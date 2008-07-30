Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYG3R4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYG3R4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbYG3Rzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:55:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34485 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbYG3Rzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:55:43 -0400
Message-ID: <4890AB14.1030009@garzik.org>
Date: Wed, 30 Jul 2008 13:55:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1]: fix NE2000 linkage error
References: <200807301144.m6UBitOG022822@harpo.it.uu.se>
In-Reply-To: <200807301144.m6UBitOG022822@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Trying to build with CONFIG_NE2000=m fails with:
> 
>   scripts/mod/modpost   -o /tmp/tmp/linux-2.6.27-rc1/Module.symvers    -S     -s
> ERROR: "NS8390_init" [drivers/net/ne.ko] undefined!
> 
> This is because the split of 8390 into pausing and non-pausing
> versions was incompletely propagated to ne.c. This fixes it.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
> 
> --- linux-2.6.27-rc1/drivers/net/ne.c.~1~	2008-07-29 10:40:11.000000000 +0200
> +++ linux-2.6.27-rc1/drivers/net/ne.c	2008-07-30 13:17:16.000000000 +0200
> @@ -536,7 +536,7 @@ static int __init ne_probe1(struct net_d
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	dev->poll_controller = eip_poll;
>  #endif
> -	NS8390_init(dev, 0);
> +	NS8390p_init(dev, 0);
>  
>  	ret = register_netdev(dev);
>  	if (ret)
> @@ -794,7 +794,7 @@ retry:
>  		if (time_after(jiffies, dma_start + 2*HZ/100)) {		/* 20ms */
>  			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
>  			ne_reset_8390(dev);
> -			NS8390_init(dev,1);
> +			NS8390p_init(dev, 1);
>  			break;
>  		}
>  
> @@ -855,7 +855,7 @@ static int ne_drv_resume(struct platform
>  
>  	if (netif_running(dev)) {
>  		ne_reset_8390(dev);
> -		NS8390_init(dev, 1);
> +		NS8390p_init(dev, 1);
>  		netif_device_attach(dev);

Yep, already got this one, but thanks!


