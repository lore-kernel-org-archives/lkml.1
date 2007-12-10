Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXLJCcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXLJCcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXLJCcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:32:06 -0500
Received: from [222.73.24.84] ([222.73.24.84]:50717 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXLJCcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:32:04 -0500
Message-ID: <475CA464.1060408@cn.fujitsu.com>
Date: Mon, 10 Dec 2007 10:28:52 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: fpavlic@de.ibm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix use of skb after netif_rx
References: <Pine.LNX.4.64.0712092103560.11165@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0712092103560.11165@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall said the following on 2007-12-10 4:05:
> From: Julia Lawall <julia@diku.dk>
> // <smpl>
> @@
> expression skb, e,e1;
> @@
> 
> (
>  netif_rx(skb);
> |
>  netif_rx_ni(skb);
> )
>   ... when != skb = e
> (
>   skb = e1
> |
> * skb
> )
> // </smpl>
> 
> diff a/drivers/s390/net/ctcmain.c b/drivers/s390/net/ctcmain.c
> diff a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c

Julia, seems that your semantic patch misses following place.

drivers/s390/net/qeth_main.c:2733
...
#endif
			rxrc = netif_rx(skb);
		card->dev->last_rx = jiffies;
		card->stats.rx_packets++;
		card->stats.rx_bytes += skb->len;
...

--
WCN

