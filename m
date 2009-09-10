Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZIJDeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZIJDeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZIJDeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:34:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60109
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbZIJDen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:34:43 -0400
Date: Wed, 09 Sep 2009 20:35:00 -0700 (PDT)
Message-Id: <20090909.203500.53952434.davem@davemloft.net>
To: martin@decky.cz
Cc: j@w1.fi, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] hostap: Revert a toxic part of the conversion to
 net_device_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0909100333230.4334@hefaistos.decky.cz>
References: <alpine.LFD.2.00.0909100333230.4334@hefaistos.decky.cz>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Decky <martin@decky.cz>
Date: Thu, 10 Sep 2009 03:44:47 +0200 (CEST)

Thanks, linux-wireless CC:'d, please CC: them on all wireless
patches in the future.

> From: Martin Decky <martin@decky.cz>
> 
> As the hostap driver was converted to use net_device_ops, a mistake was 
> made in hostap_main.c (commit 5ae4efbcd2611562a8b93596be034e63495706a5). 
> Originally, the tx_queue_len was set to 0 for every other interface than 
> HOSTAP_INTERFACE_MASTER, but the new fragment of code sets tx_queue_len to 
> 0 only for HOSTAP_INTERFACE_MASTER. The opposite of the previous 
> behavior makes the driver to drop all packets in AP mode.
> 
> Change the way 0 is assigned to tx_queue_len according to the original 
> logic.
> 
> Signed-off-by: Martin Decky <martin@decky.cz>

> ----
> diff -Naurp linux-2.6.30.orig/drivers/net/wireless/hostap/hostap_main.c linux-2.6.30/drivers/net/wireless/hostap/hostap_main.c
> --- linux-2.6.30.orig/drivers/net/wireless/hostap/hostap_main.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.30/drivers/net/wireless/hostap/hostap_main.c	2009-09-08 11:11:23.892816045 +0200
> @@ -875,15 +875,16 @@ void hostap_setup_dev(struct net_device 
>  
>  	switch(type) {
>  	case HOSTAP_INTERFACE_AP:
> +		dev->tx_queue_len = 0;	/* use main radio device queue */
>  		dev->netdev_ops = &hostap_mgmt_netdev_ops;
>  		dev->type = ARPHRD_IEEE80211;
>  		dev->header_ops = &hostap_80211_ops;
>  		break;
>  	case HOSTAP_INTERFACE_MASTER:
> -		dev->tx_queue_len = 0;	/* use main radio device queue */
>  		dev->netdev_ops = &hostap_master_ops;
>  		break;
>  	default:
> +		dev->tx_queue_len = 0;	/* use main radio device queue */
>  		dev->netdev_ops = &hostap_netdev_ops;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
