Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbZAKHdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbZAKHdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZAKHct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:32:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38979
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbZAKHcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:32:47 -0500
Date: Sat, 10 Jan 2009 23:32:48 -0800 (PST)
Message-Id: <20090110.233248.158093272.davem@davemloft.net>
To: mingo@elte.hu
Cc: parag.lkml@gmail.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix net/irda build breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090110105827.GA9460@elte.hu>
References: <alpine.LFD.2.00.0901091829270.21215@localhost.localdomain>
	<20090109.170258.169849917.davem@davemloft.net>
	<20090110105827.GA9460@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 10 Jan 2009 11:58:27 +0100

> * David Miller <davem@davemloft.net> wrote:
> 
> > Already fixed in the net-2.6 GIT tree, but thanks.
> 
> mind sending the patch here to lkml too so that people can pick it up? 
> Current -git is broken with x86 allyesconfig and Parag's patch above is 
> whitespace damaged.

Sure, here ya go:

irda: fix incomplete conversation to internal stats

Fix for commit af0490810c (irda: convert to internal stats)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/irda/au1k_ir.c  |    2 +-
 drivers/net/irda/donauboe.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
index 75a1d0a..9411640 100644
--- a/drivers/net/irda/au1k_ir.c
+++ b/drivers/net/irda/au1k_ir.c
@@ -594,7 +594,7 @@ static int au1k_irda_rx(struct net_device *dev)
 			update_rx_stats(dev, flags, count);
 			skb=alloc_skb(count+1,GFP_ATOMIC);
 			if (skb == NULL) {
-				aup->stats.rx_dropped++;
+				aup->netdev->stats.rx_dropped++;
 				continue;
 			}
 			skb_reserve(skb, 1);
diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 687c2d5..6f3e7f7 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -1194,13 +1194,13 @@ toshoboe_interrupt (int irq, void *dev_id)
               txp = txpc;
               txpc++;
               txpc %= TX_SLOTS;
-              self->stats.tx_packets++;
+              self->netdev->stats.tx_packets++;
               if (self->ring->tx[txpc].control & OBOE_CTL_TX_HW_OWNS)
                   self->ring->tx[txp].control &= ~OBOE_CTL_TX_RTCENTX;
             }
-          self->stats.tx_packets--;
+          self->netdev->stats.tx_packets--;
 #else
-          self->stats.tx_packets++;
+          self->netdev->stats.tx_packets++;
 #endif
           toshoboe_start_DMA(self, OBOE_CONFIG0H_ENTX);
         }
@@ -1280,7 +1280,7 @@ dumpbufs(self->rx_bufs[self->rxs],len,'<');
                       skb_put (skb, len);
                       skb_copy_to_linear_data(skb, self->rx_bufs[self->rxs],
 					      len);
-                      self->stats.rx_packets++;
+                      self->netdev->stats.rx_packets++;
                       skb->dev = self->netdev;
                       skb_reset_mac_header(skb);
                       skb->protocol = htons (ETH_P_IRDA);
-- 
1.6.1.15.g159c88

