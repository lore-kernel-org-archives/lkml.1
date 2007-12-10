Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXLJHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXLJHST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 02:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXLJHSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 02:18:10 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38527 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbXLJHSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 02:18:08 -0500
Date: Mon, 10 Dec 2007 08:18:04 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: fpavlic@de.ibm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix use of skb after netif_rx
In-Reply-To: <475CA464.1060408@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0712100813440.13319@ask.diku.dk>
References: <Pine.LNX.4.64.0712092103560.11165@ask.diku.dk>
 <475CA464.1060408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > // </smpl>
> > 
> > diff a/drivers/s390/net/ctcmain.c b/drivers/s390/net/ctcmain.c
> > diff a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
> 
> Julia, seems that your semantic patch misses following place.
> 
> drivers/s390/net/qeth_main.c:2733
> ...
> #endif
> 			rxrc = netif_rx(skb);
> 		card->dev->last_rx = jiffies;
> 		card->stats.rx_packets++;
> 		card->stats.rx_bytes += skb->len;
> ...

Actually, I found this one as well, but I wasn't sure what to do with it.  
This one is a bit more complicated because the line with the call to 
netif_rx is in an else branch if the #ifdef above is taken.  So I wasn't 
sure what would be the best way to solve the problem in this case.

Perhaps the solution would be just to save the value of the len field 
in a local variable in this case, as you proposed in your original patch.

julia

