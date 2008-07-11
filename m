Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYGKOE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYGKOE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYGKOES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:04:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34822 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYGKOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:04:17 -0400
Message-ID: <4877685D.1030503@garzik.org>
Date: Fri, 11 Jul 2008 10:04:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [FIX] ARM: IXP4xx Ethernet NAPI fix
References: <m31w23ia8n.fsf@maximus.localdomain>
In-Reply-To: <m31w23ia8n.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> This patch removes some weirdness from IXP4xx Ethernet driver.
> Ideally it should go in 2.6.26 though it's not that critical. Thanks.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/arm/ixp4xx_eth.c b/drivers/net/arm/ixp4xx_eth.c
> index c617b64..9b777d9 100644
> --- a/drivers/net/arm/ixp4xx_eth.c
> +++ b/drivers/net/arm/ixp4xx_eth.c
> @@ -522,7 +522,6 @@ static int eth_poll(struct napi_struct *napi, int budget)
>  #endif
>  
>  		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
> -			received = 0; /* No packet received */
>  #if DEBUG_RX
>  			printk(KERN_DEBUG "%s: eth_poll netif_rx_complete\n",
>  			       dev->name);
> @@ -543,7 +542,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
>  			printk(KERN_DEBUG "%s: eth_poll all done\n",
>  			       dev->name);
>  #endif
> -			return 0; /* all work done */
> +			return received; /* all work done */

applied


