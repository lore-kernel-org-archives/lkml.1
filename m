Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZKJQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZKJQig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbZKJQif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:38:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:32973 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbZKJQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YoR4VSzT+KPj+AReazUFBLx4+OMQb+/CMWilNh/m29W9S57CZwJJgGbnm3TbDPLM55
         mXvgdooWqhz+zurExMbcLfp6ErBzSlz4yXDQMHo9yfGU2gwpOTxHMvpvKtD5FZ0pmVQ8
         xl2I2v1NwkTyaeTTGXumtcJ6TfdynIJkE6rnE=
Date: Tue, 10 Nov 2009 20:10:06 +0330
From: Ali Gholami Rudi <ali@rudi.ir>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>
Subject: [PATCH] ixgbe: r_idx not used in ixgbe_msix_clean_rx()
Message-ID: <20091110164006.GB816@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The values of r_idx and rx_ring are not used after the last time they
are set in ixgbe_msix_clean_rx(), so they can be removed.

Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
---
 drivers/net/ixgbe/ixgbe_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 5bd9e6b..6541c80 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -1344,8 +1344,6 @@ static irqreturn_t ixgbe_msix_clean_rx(int irq, void *data)
 	if (!q_vector->rxr_count)
 		return IRQ_HANDLED;
 
-	r_idx = find_first_bit(q_vector->rxr_idx, adapter->num_rx_queues);
-	rx_ring = &(adapter->rx_ring[r_idx]);
 	/* disable interrupts on this vector only */
 	ixgbe_irq_disable_queues(adapter, ((u64)1 << q_vector->v_idx));
 	napi_schedule(&q_vector->napi);
