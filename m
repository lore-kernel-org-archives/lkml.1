Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736Ab0AXTSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0AXTSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 14:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287Ab0AXTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 14:18:38 -0500
Received: from ppp-156-220.adsl.restena.lu ([158.64.156.220]:46354 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0AXTSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 14:18:38 -0500
Date: Sun, 24 Jan 2010 20:18:08 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in
 vlan_skb_recv - probably introduced by commit
 9793241fe92f7d9303fb221e43fc598eb065f267
Message-ID: <20100124201808.2bbbf0b0@neptune.home>
In-Reply-To: <4B5C74BF.5060604@gmail.com>
References: <20100123165657.187c11e4@neptune.home>
	<20100123223132.0e62d8cb@neptune.home>
	<4B5C4E5E.2010507@gmail.com>
	<20100124160228.366f4e72@neptune.home>
	<20100124162549.2b39b222@neptune.home>
	<4B5C74BF.5060604@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yep, works fine and RX stats look right as well.

So
Reported-By: Bruno Prémont <bonbons@linux-vserver.org>
Tested-By: Bruno Prémont <bonbons@linux-vserver.org>

Thanks,
Bruno


On Sun, 24 January 2010 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Ok, I believe I found the problem :)
> 
> Please try following patch, if it works I'll submit with appropriate
> Changelog and signatures
> 
> Thanks
> 
> 
> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> index b788978..c1b92ca 100644
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -163,7 +163,7 @@ int vlan_skb_recv(struct sk_buff *skb, struct net_device *dev,
>               goto err_unlock;
>  	}
>  
> -	rx_stats = per_cpu_ptr(vlan_dev_info(dev)->vlan_rx_stats,
> +	rx_stats = per_cpu_ptr(vlan_dev_info(skb->dev)->vlan_rx_stats,
>                              smp_processor_id());
>       rx_stats->rx_packets++;
>  	rx_stats->rx_bytes += skb->len;
