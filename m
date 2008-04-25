Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYDYGC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYDYGC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbYDYGCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:02:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58472 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbYDYGCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:02:06 -0400
Message-ID: <481173DC.6010907@garzik.org>
Date: Fri, 25 Apr 2008 02:02:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] WAN: Fix confusing insmod error code for C101 too.
References: <m3myno5u5b.fsf@maximus.localdomain>
In-Reply-To: <m3myno5u5b.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> WAN: Fix confusing insmod error code for C101 too.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
> index c4c8eab..c2cc42f 100644
> --- a/drivers/net/wan/c101.c
> +++ b/drivers/net/wan/c101.c
> @@ -402,7 +402,7 @@ static int __init c101_init(void)
>  #ifdef MODULE
>  		printk(KERN_INFO "c101: no card initialized\n");
>  #endif
> -		return -ENOSYS;	/* no parameters specified, abort */
> +		return -EINVAL;	/* no parameters specified, abort */
>  	}
>  
>  	printk(KERN_INFO "%s\n", version);
> @@ -420,11 +420,11 @@ static int __init c101_init(void)
>  			c101_run(irq, ram);
>  
>  		if (*hw == '\x0')
> -			return first_card ? 0 : -ENOSYS;
> +			return first_card ? 0 : -EINVAL;
>  	}while(*hw++ == ':');
>  
>  	printk(KERN_ERR "c101: invalid hardware parameters\n");
> -	return first_card ? 0 : -ENOSYS;
> +	return first_card ? 0 : -EINVAL;
>  }
>  

applied


