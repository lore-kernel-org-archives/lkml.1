Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbXE3RBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbXE3RBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXE3RBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:01:32 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8868 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXE3RBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:01:31 -0400
From: divy@chelsio.com
Subject: [PATCH 1/5] cxgb3 - fix skb->dev dereference
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Wed, 30 May 2007 10:01:29 -0700
Message-ID: <20070530170128.22789.3485.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

eth_type_trans() now sets skb->dev. 
References to skb->dev should happen after it is called.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 3666586..eaa7dac 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -1690,8 +1690,8 @@ static void rx_eth(struct adapter *adap,
 	struct port_info *pi;
 
 	skb_pull(skb, sizeof(*p) + pad);
-	skb->dev->last_rx = jiffies;
 	skb->protocol = eth_type_trans(skb, adap->port[p->iff]);
+	skb->dev->last_rx = jiffies;
 	pi = netdev_priv(skb->dev);
 	if (pi->rx_csum_offload && p->csum_valid && p->csum == 0xffff &&
 	    !p->fragment) {
