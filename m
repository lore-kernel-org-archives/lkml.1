Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZL2TPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZL2TPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZL2TPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:15:45 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59563 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZL2TPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:15:44 -0500
Date: Tue, 29 Dec 2009 20:15:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/net : Correct the size argument to kzalloc
Message-ID: <Pine.LNX.4.64.0912292015240.4001@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

lp->rx_skb has type struct sk_buff **, not struct sk_buff *, so the
elements of the array should have pointer type, not structure type.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/ll_temac_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -134,7 +134,7 @@ static int temac_dma_bd_init(struct net_
 	struct sk_buff *skb;
 	int i;
 
-	lp->rx_skb = kzalloc(sizeof(struct sk_buff)*RX_BD_NUM, GFP_KERNEL);
+	lp->rx_skb = kzalloc(sizeof(*lp->rx_skb) * RX_BD_NUM, GFP_KERNEL);
 	/* allocate the tx and rx ring buffer descriptors. */
 	/* returns a virtual addres and a physical address. */
 	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
