Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYGDMmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYGDMmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYGDMmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:42:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54560 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYGDMma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:42:30 -0400
Message-ID: <486E1AB1.30902@garzik.org>
Date: Fri, 04 Jul 2008 08:42:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: davem@davemloft.net
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [NET-NEXT PATCH 17/18] net: add netif_napi_del function to allow
 for	removal of napistructs
References: <20080627175921.22428.52767.stgit@localhost.localdomain> <20080627180200.22428.70787.stgit@localhost.localdomain>
In-Reply-To: <20080627180200.22428.70787.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> From: Alexander Duyck <alexander.h.duyck@intel.com>
> 
> Adds netif_napi_del function which is used to remove the napi struct from
> the netdev napi_list in cases where CONFIG_NETPOLL was enabled.
> The motivation for adding this is to handle the case in which the number of
> queues on a device changes due to a configuration change.  Previously the
> napi structs for each queue would be left in the list until the netdev was
> freed.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> 
>  include/linux/netdevice.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 1304ad2..42fc98e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -826,6 +826,19 @@ static inline void netif_napi_add(struct net_device *dev,
>  	set_bit(NAPI_STATE_SCHED, &napi->state);
>  }
>  
> +/**
> + *  netif_napi_del - remove a napi context
> + *  @napi: napi context
> + *
> + *  netif_napi_del() removes a napi context from the network device napi list
> + */
> +static inline void netif_napi_del(struct napi_struct *napi)
> +{
> +#ifdef CONFIG_NETPOLL
> +	list_del(&napi->dev_list);
> +#endif
> +}
> +

David - ACK?

I would prefer to throw this in with the 18-patch igb pile, if that's OK 
with you.

