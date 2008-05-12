Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYELQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYELQk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYELQkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:40:12 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:54839 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbYELQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:40:11 -0400
Date: Mon, 12 May 2008 18:17:34 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Julia Lawall <julia@diku.dk>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers/net: remove null pointer dereference
Message-ID: <20080512161734.GA22190@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0805121537320.3694@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805121537320.3694@ask.diku.dk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> :
[...]
> diff -u -p a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
> --- a/drivers/net/au1000_eth.c	2008-04-27 11:41:11.000000000 +0200
> +++ b/drivers/net/au1000_eth.c	2008-05-12 09:32:54.000000000 +0200
> @@ -1242,7 +1242,7 @@ static irqreturn_t au1000_interrupt(int 
>  	struct net_device *dev = (struct net_device *) dev_id;
>  
>  	if (dev == NULL) {
> -		printk(KERN_ERR "%s: isr: null dev ptr\n", dev->name);
> +		printk(KERN_ERR "isr: null dev ptr\n");
>  		return IRQ_RETVAL(1);
>  	}

The lifespan of 'dev' covers the request_irq..free_irq interval in this
driver. The whole 'dev == NULL' block can be removed.

-- 
Ueimor
