Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYCXU5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYCXU5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYCXU5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:57:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41810 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYCXU5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:57:46 -0400
Message-ID: <47E815C2.1050900@garzik.org>
Date: Mon, 24 Mar 2008 16:57:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add random irq flag to natsemi network driver
References: <Pine.LNX.4.64.0803241428040.22437@pentafluge.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0803241428040.22437@pentafluge.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
> Please apply this patch. On the embbeded board I work on this is the only
> entropy source we have. 
> 
> diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
> index 385f69c..c6553dd 100644
> --- a/drivers/net/natsemi.c
> +++ b/drivers/net/natsemi.c
> @@ -1529,7 +1529,8 @@ static int netdev_open(struct net_device *dev)
>  	/* Reset the chip, just in case. */
>  	natsemi_reset(dev);
>  
> -	i = request_irq(dev->irq, &intr_handler, IRQF_SHARED, dev->name, dev);
> +	i = request_irq(dev->irq, &intr_handler, IRQF_SHARED | IRQF_SAMPLE_RANDOM,
> +				dev->name, dev);

With timed interrupt mitigation and remotely controlled interrupt 
sources, this can be distinctly non-random.

This type of patch is traditionally not applied...

	Jeff



