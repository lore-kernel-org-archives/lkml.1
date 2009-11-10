Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZKJQpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZKJQpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZKJQpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:45:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:10195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbZKJQpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:45:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,717,1249282800"; 
   d="scan'208";a="209852146"
Subject: Re: [PATCH] ixgbe: r_idx not used in ixgbe_msix_clean_rx()
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: "David S. Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>
In-Reply-To: <20091110164006.GB816@lilem.mirepesht>
References: <20091110164006.GB816@lilem.mirepesht>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 08:45:14 -0800
Message-Id: <1257871514.3007.23.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 08:40 -0800, Ali Gholami Rudi wrote:
> The values of r_idx and rx_ring are not used after the last time they
> are set in ixgbe_msix_clean_rx(), so they can be removed.
> 

Thanks for cleaning this up.

Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>

> Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
> ---
>  drivers/net/ixgbe/ixgbe_main.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
> index 5bd9e6b..6541c80 100644
> --- a/drivers/net/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ixgbe/ixgbe_main.c
> @@ -1344,8 +1344,6 @@ static irqreturn_t ixgbe_msix_clean_rx(int irq, void *data)
>  	if (!q_vector->rxr_count)
>  		return IRQ_HANDLED;
>  
> -	r_idx = find_first_bit(q_vector->rxr_idx, adapter->num_rx_queues);
> -	rx_ring = &(adapter->rx_ring[r_idx]);
>  	/* disable interrupts on this vector only */
>  	ixgbe_irq_disable_queues(adapter, ((u64)1 << q_vector->v_idx));
>  	napi_schedule(&q_vector->napi);

