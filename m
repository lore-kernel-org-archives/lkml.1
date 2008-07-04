Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYGDMOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYGDMOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYGDMOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:14:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48099 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYGDMOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:14:03 -0400
Message-ID: <486E1404.8090704@garzik.org>
Date: Fri, 04 Jul 2008 08:13:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add missing skb->dev assignment in Frame Relay RX code
References: <m3wsk8aupw.fsf@maximus.localdomain>
In-Reply-To: <m3wsk8aupw.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Hi,
> 
> Commit 4c13eb6657fe9ef7b4dc8f1a405c902e9e5234e0 ([ETH]: Make
> eth_type_trans set skb->dev like the other *_type_trans) removed
> skb->dev assignment from hdlc_fr.c:fr_rx(). Unfortunately it was also
> needed for cases other than eth_type_trans().
> 
> Adding it back.
> 
> It's quite serious and may be a security risk as it causes a wrong
> input interface indication (the physical hdlcX instead of logical
> pvcX). Probably -stable class fix.
> 
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index c4ab032..3a86e64 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -1008,6 +1008,7 @@ static int fr_rx(struct sk_buff *skb)
>  		stats->rx_bytes += skb->len;
>  		if (pvc->state.becn)
>  			stats->rx_compressed++;
> +		skb->dev = dev;
>  		netif_rx(skb);
>  		return NET_RX_SUCCESS;
>  	} else {

applied


