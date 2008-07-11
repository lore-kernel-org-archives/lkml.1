Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYGKTV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYGKTV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbYGKTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759570AbYGKTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:58 -0400
Date: Fri, 11 Jul 2008 12:18:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>, <netdev@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [FIX] ARM: IXP4xx Ethernet NAPI fix
Message-Id: <20080711121822.2d7bccc0.akpm@linux-foundation.org>
In-Reply-To: <m31w23ia8n.fsf@maximus.localdomain>
References: <m31w23ia8n.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 13:10:32 +0200 Krzysztof Halasa <khc@pm.waw.pl> wrote:

> This patch removes some weirdness from IXP4xx Ethernet driver.
> Ideally it should go in 2.6.26 though it's not that critical. Thanks.
> 
> Signed-off-by: Krzysztof Ha__asa <khc@pm.waw.pl>
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
>  		}
>  
>  		desc = rx_desc_ptr(port, n);

This is a functional change, and I do not believe that "fixes some
weirdness" is an adequate description of it.

Please: what was wrong with the old code?  Were the effects user-visible? 
How does the new code fix those problems?  Stuff like that.

You hint that this might be a 2.6.26-worthy change, but we should be able
to work this out ourselves from your description of it.  But the description
was no good :(

