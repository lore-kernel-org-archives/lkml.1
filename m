Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab0CANEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:04:38 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:57079 "EHLO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0CANEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:04:36 -0500
Message-ID: <4B8BBC14.9010705@ge.com>
Date: Mon, 01 Mar 2010 13:07:32 +0000
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev list <linuxppc-dev@ozlabs.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Sandeep Gopalpet <Sandeep.Kumar@freescale.com>, davem@davemloft.net
Subject: Re: Gianfar driver failing on MPC8641D based board
References: <20100225174935.GA32370@oksana.dev.rtsoft.ru> <7d1d9c251002251653n6473f01ex2d43933ec6aa010b@mail.gmail.com> <20100226031452.GA11319@oksana.dev.rtsoft.ru> <4B87B937.6010204@ge.com> <20100226143532.GA31622@oksana.dev.rtsoft.ru> <4B87E01E.4070704@windriver.com> <4B87E662.3080106@ge.com> <4B87E9EF.3010604@ge.com> <20100226161058.GA22954@oksana.dev.rtsoft.ru> <4B87F67E.5070601@windriver.com> <20100226213825.GA32363@oksana.dev.rtsoft.ru>
In-Reply-To: <20100226213825.GA32363@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
> index 8bd3c9f..cccb409 100644
> --- a/drivers/net/gianfar.c
> +++ b/drivers/net/gianfar.c
> @@ -2021,7 +2021,6 @@ static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	}
>  
>  	/* setup the TxBD length and buffer pointer for the first BD */
> -	tx_queue->tx_skbuff[tx_queue->skb_curtx] = skb;
>  	txbdp_start->bufPtr = dma_map_single(&priv->ofdev->dev, skb->data,
>  			skb_headlen(skb), DMA_TO_DEVICE);
>  
> @@ -2053,6 +2052,10 @@ static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	txbdp_start->lstatus = lstatus;
>  
> +	eieio(); /* force lstatus write before tx_skbuff */
> +
> +	tx_queue->tx_skbuff[tx_queue->skb_curtx] = skb;
> +
>  	/* Update the current skb pointer to the next entry we will use
>  	 * (wrapping if necessary) */
>  	tx_queue->skb_curtx = (tx_queue->skb_curtx + 1) &
>   
I can confirm 10/10 successful boots on p2020ds and mpc8641_hpcn.

Martyn


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

