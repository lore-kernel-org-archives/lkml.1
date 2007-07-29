Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXG2FAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXG2FAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 01:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXG2E7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 00:59:52 -0400
Received: from kukmak.uni-mb.si ([164.8.100.3]:46666 "EHLO kukmak.uni-mb.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXG2E7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 00:59:51 -0400
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 00:59:51 EDT
Date: Sun, 29 Jul 2007 06:37:08 +0200
From: Domen Puncer <domen@coderock.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Steven Hirsch <shirsch@adelphia.net>,
       "David S. Miller" <davem@davemloft.net>,
       Franco Venturi <fventuri@mediaone.net>
Subject: Re: [PATCH] sb1000: prevent a potential NULL pointer dereference in sb1000_dev_ioctl()
Message-ID: <20070729043707.GA8343@nd47.coderock.org>
References: <200707290002.42722.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707290002.42722.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/07 00:02 +0200, Jesper Juhl wrote:
> Hi,
> 
> Here's a small patch, prompted by a find by the Coverity checker, 
> that removes a potential NULL pointer dereference from 
> drivers/net/sb1000.c::sb1000_dev_ioctl().
> The checker spotted that we do a NULL test of 'dev', yet we 
> dereference the pointer prior to that check.
> This patch simply moves the dereference after the NULL test.

But... it can't be called without a valid 'dev', no?
A quick 'grep do_ioctl net/' confirms that all calls are in
the form of 'dev->do_ioctl(dev, ...'.


	Domen

	
> @@ -991,11 +991,13 @@ static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	short PID[4];
>  	int ioaddr[2], status, frequency;
>  	unsigned int stats[5];
> -	struct sb1000_private *lp = netdev_priv(dev);
> +	struct sb1000_private *lp;
>  
>  	if (!(dev && dev->flags & IFF_UP))
>  		return -ENODEV;
>  
> +	lp = netdev_priv(dev);
> +
>  	ioaddr[0] = dev->base_addr;
>  	/* mem_start holds the second I/O address */
>  	ioaddr[1] = dev->mem_start;
> 
