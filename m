Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYHNIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYHNIaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYHNI3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:29:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41439 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbYHNI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:29:38 -0400
Message-ID: <48A3ECDA.4090208@garzik.org>
Date: Thu, 14 Aug 2008 04:29:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Robert Fitzsimons <robfitz@273k.net>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Jeff Garzik <jgarzik@redhat.com>, David Miller <davem@davemloft.net>,
       Samuel Chessman <chessman@tux.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tlan: Fix two regressions introduced by 64bit conversion.
References: <20080809165402.GA3726@localhost>
In-Reply-To: <20080809165402.GA3726@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Fitzsimons wrote:
> Two regressions were introduced by the recent tlan: 64bit conversion
> commit (93e16847c9db0093065c98063cfc639cdfccf19a).  The first in
> TLan_GetSKB caused a NULL pointer dereference.  With the second causing
> the link to fail to come up.
> 
> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
> ---
>  drivers/net/tlan.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
> index 85246ed..ec871f6 100644
> --- a/drivers/net/tlan.c
> +++ b/drivers/net/tlan.c
> @@ -360,8 +360,8 @@ TLan_GetSKB( const struct tlan_list_tag *tag)
>  {
>  	unsigned long addr;
>  
> -	addr = tag->buffer[8].address;
> -	addr |= (tag->buffer[9].address << 16) << 16;
> +	addr = tag->buffer[9].address;
> +	addr |= (tag->buffer[8].address << 16) << 16;
>  	return (struct sk_buff *) addr;
>  }
>  
> @@ -1984,7 +1984,6 @@ static void TLan_ResetLists( struct net_device *dev )
>  	TLanList	*list;
>  	dma_addr_t	list_phys;
>  	struct sk_buff	*skb;
> -	void		*t = NULL;
>  
>  	priv->txHead = 0;
>  	priv->txTail = 0;
> @@ -2022,7 +2021,8 @@ static void TLan_ResetLists( struct net_device *dev )
>  			}
>  
>  			skb_reserve( skb, NET_IP_ALIGN );
> -			list->buffer[0].address = pci_map_single(priv->pciDev, t,
> +			list->buffer[0].address = pci_map_single(priv->pciDev,

applied


