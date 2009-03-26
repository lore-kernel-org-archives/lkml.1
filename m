Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbZCZXbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbZCZXbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZCZXb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:31:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47200
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbZCZXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:31:26 -0400
Date: Thu, 26 Mar 2009 16:31:14 -0700 (PDT)
Message-Id: <20090326.163114.131582923.davem@davemloft.net>
To: rdreier@cisco.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RDMA/nes: Fix mis-merge
From: David Miller <davem@davemloft.net>
In-Reply-To: <adahc1fuarm.fsf_-_@cisco.com>
References: <20090326.152515.43533230.davem@davemloft.net>
	<alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
	<adahc1fuarm.fsf_-_@cisco.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Mar 2009 16:25:49 -0700

> When net-next and infiniband were merged upstream, each branch deleted
> one of a pair of adjacent lines from nes_nic.c, but when Linus fixed the
> conflict up, he brought back both of the lines.  Fix up to the intended
> final tree state.
> ---
>  > Well, I merged infiniband, and that caused more conflicts. I fixed them 
>  > up, but people need to double-check my fixes.
> 
> Looks like you mismerged one file -- each side deleted one line right
> next to each other, but your merge left both lines in.  I think the
> patch below is needed.  (The cxgb3 fix looks correct)
> 
>  drivers/infiniband/hw/nes/nes_nic.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

Looks good, Linus please apply:

Acked-by: David S. Miller <davem@davemloft.net>

> diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
> index 8d3e4c6..ecb1f6f 100644
> --- a/drivers/infiniband/hw/nes/nes_nic.c
> +++ b/drivers/infiniband/hw/nes/nes_nic.c
> @@ -1602,8 +1602,6 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
>  	netif_napi_add(netdev, &nesvnic->napi, nes_netdev_poll, 128);
>  	nes_debug(NES_DBG_INIT, "Enabling VLAN Insert/Delete.\n");
>  	netdev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
> -	netdev->vlan_rx_register = nes_netdev_vlan_rx_register;
> -	netdev->features |= NETIF_F_LLTX;
>  
>  	/* Fill in the port structure */
>  	nesvnic->netdev = netdev;
