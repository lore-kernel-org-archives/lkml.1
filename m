Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZCMPdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZCMPdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZCMPdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:33:12 -0400
Received: from trinity.fluff.org ([89.16.178.74]:33489 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbZCMPdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:33:12 -0400
Date: Fri, 13 Mar 2009 15:32:56 +0000
From: Ben Dooks <ben@simtec.co.uk>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] drivers/net/ax88796.c: take IRQ flags from platform_device
Message-ID: <20090313153255.GG6295@trinity.fluff.org>
References: <1236955851-14763-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236955851-14763-1-git-send-email-daniel@caiaq.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 03:50:51PM +0100, Daniel Mack wrote:
> This patch adds support to the ax88796 ethernet driver to take IRQ flags
> given by the platform_device definition.
> 
> The patch depends on the platform_get_irq_flags() function which I added
> in a patch posted here:
> 
> 	http://lkml.org/lkml/2009/3/13/267
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ben Dooks <ben@simtec.co.uk>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
>  drivers/net/ax88796.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
> index a4eb6c4..728e17c 100644
> --- a/drivers/net/ax88796.c
> +++ b/drivers/net/ax88796.c
> @@ -93,6 +93,7 @@ struct ax_device {
>  
>  	unsigned char		 running;
>  	unsigned char		 resume_open;
> +	unsigned int		 irqflags;
>  
>  	u32			 reg_offsets[0x20];
>  };
> @@ -474,7 +475,8 @@ static int ax_open(struct net_device *dev)
>  
>  	dev_dbg(&ax->dev->dev, "%s: open\n", dev->name);
>  
> -	ret = request_irq(dev->irq, ax_ei_interrupt, 0, dev->name, dev);
> +	ret = request_irq(dev->irq, ax_ei_interrupt, ax->irqflags,
> +			  dev->name, dev);
>  	if (ret)
>  		return ret;
>  
> @@ -856,6 +858,7 @@ static int ax_probe(struct platform_device *pdev)
>  		goto exit_mem;
>  	}
>  	dev->irq = ret;
> +	ax->irqflags = platform_get_irq_flags(pdev, 0);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (res == NULL) {
> -- 
> 1.6.2
> 

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

