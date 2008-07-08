Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYGHVsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYGHVsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYGHVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:48:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14167 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYGHVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:48:43 -0400
Date: Tue, 8 Jul 2008 14:47:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jgarzik@pobox.com
Subject: Re: linux-next: Tree for July 8 (ns8390)
Message-Id: <20080708144715.a904d426.randy.dunlap@oracle.com>
In-Reply-To: <20080708193513.51000246@the-village.bc.nu>
References: <20080708192251.3275d283.sfr@canb.auug.org.au>
	<20080708113529.9297e1ad.randy.dunlap@oracle.com>
	<20080708193513.51000246@the-village.bc.nu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 19:35:13 +0100 Alan Cox wrote:

> Diff between my tree 8390 bits and linux-next ones
> 
> 8390: diff between next and my driver
> 
> From: Alan Cox <alan@redhat.com>
> 
> Please try this and if it sorts it fold it into the driver. This is a diff
> between my tree and the linux-next tree

Yes, that's good.  Thanks/Ack.

> ---
> 
>  drivers/net/hp-plus.c |    2 +-
>  drivers/net/hp.c      |    2 +-
>  drivers/net/ne.c      |    8 ++++----
>  drivers/net/wd.c      |    2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/drivers/net/hp-plus.c b/drivers/net/hp-plus.c
> index c2c4f49..8239939 100644
> --- a/drivers/net/hp-plus.c
> +++ b/drivers/net/hp-plus.c
> @@ -262,7 +262,7 @@ static int __init hpp_probe1(struct net_device *dev, int ioaddr)
>  	}
>  
>  	outw(Perf_Page, ioaddr + HP_PAGING);
> -	NS8390_init(dev, 0);
> +	NS8390p_init(dev, 0);
>  	/* Leave the 8390 and HP chip reset. */
>  	outw(inw(ioaddr + HPP_OPTION) & ~EnableIRQ, ioaddr + HPP_OPTION);
>  
> diff --git a/drivers/net/hp.c b/drivers/net/hp.c
> index 8281209..0a8c649 100644
> --- a/drivers/net/hp.c
> +++ b/drivers/net/hp.c
> @@ -389,7 +389,7 @@ static void __init
>  hp_init_card(struct net_device *dev)
>  {
>  	int irq = dev->irq;
> -	NS8390_init(dev, 0);
> +	NS8390p_init(dev, 0);
>  	outb_p(irqmap[irq&0x0f] | HP_RUN,
>  		   dev->base_addr - NIC_OFFSET + HP_CONFIGURE);
>  	return;
> diff --git a/drivers/net/ne.c b/drivers/net/ne.c
> index 1412697..4a8a4b1 100644
> --- a/drivers/net/ne.c
> +++ b/drivers/net/ne.c
> @@ -355,7 +355,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
>  	}
>  
>  	/* Read the 16 bytes of station address PROM.
> -	   We must first initialize registers, similar to NS8390_init(eifdev, 0).
> +	   We must first initialize registers, similar to NS8390p_init(eifdev, 0).
>  	   We can't reliably read the SAPROM address without this.
>  	   (I learned the hard way!). */
>  	{
> @@ -536,7 +536,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
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
> +			NS8390p_init(dev,1);
>  			break;
>  		}
>  
> @@ -855,7 +855,7 @@ static int ne_drv_resume(struct platform_device *pdev)
>  
>  	if (netif_running(dev)) {
>  		ne_reset_8390(dev);
> -		NS8390_init(dev, 1);
> +		NS8390p_init(dev, 1);
>  		netif_device_attach(dev);
>  	}
>  	return 0;
> diff --git a/drivers/net/wd.c b/drivers/net/wd.c
> index fa14255..6f9aa16 100644
> --- a/drivers/net/wd.c
> +++ b/drivers/net/wd.c
> @@ -337,7 +337,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	dev->poll_controller = ei_poll;
>  #endif
> -	NS8390_init(dev, 0);
> +	NS8390p_init(dev, 0);
>  
>  #if 1
>  	/* Enable interrupt generation on softconfig cards -- M.U */
> --

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
