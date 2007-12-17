Return-Path: <linux-kernel-owner+w=401wt.eu-S1763345AbXLQFG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763345AbXLQFG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 00:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXLQFGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 00:06:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:12869 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbXLQFGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 00:06:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uaQ7KHcmQYHYBCXpDwaedBLQmWPC5GsYDqNJX/6W+Sxfr1PF5OkUcp2x1coh+ls5YpneJFwQ9XyN9OAc4Pybesx/vtPWnw+fg9tTRuSUr74N1/GUV8n0E/Dtat2NwioNAg5HruBgx7EB1zfP9lUcLbakouKC+ThmjIQPpwEG840=
Subject: [PATCH] NET: ns83820.c remove fastcall macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071216.203029.255544808.davem@davemloft.net>
References: <1197864985.3749.117.camel@brick>
	 <20071216.203029.255544808.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 21:06:39 -0800
Message-Id: <1197867999.3749.122.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Dave, this is the remainder of the FASTCALL/fastcall removal
patch that is not already in your tree.
Generated against net-2.6.25.git

 drivers/net/ns83820.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ns83820.c b/drivers/net/ns83820.c
index 3652c6c..b42c05f 100644
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -611,8 +611,7 @@ static inline int rx_refill(struct net_device *ndev, gfp_t gfp)
 	return i ? 0 : -ENOMEM;
 }
 
-static void rx_refill_atomic(struct net_device *ndev);
-static void fastcall rx_refill_atomic(struct net_device *ndev)
+static void rx_refill_atomic(struct net_device *ndev)
 {
 	rx_refill(ndev, GFP_ATOMIC);
 }
@@ -633,7 +632,7 @@ static inline void clear_rx_desc(struct ns83820 *dev, unsigned i)
 	build_rx_desc(dev, dev->rx_info.descs + (DESC_SIZE * i), 0, 0, CMDSTS_OWN, 0);
 }
 
-static void fastcall phy_intr(struct net_device *ndev)
+static void phy_intr(struct net_device *ndev)
 {
 	struct ns83820 *dev = PRIV(ndev);
 	static const char *speeds[] = { "10", "100", "1000", "1000(?)", "1000F" };
@@ -831,7 +830,7 @@ static void ns83820_cleanup_rx(struct ns83820 *dev)
 	}
 }
 
-static void fastcall ns83820_rx_kick(struct net_device *ndev)
+static void ns83820_rx_kick(struct net_device *ndev)
 {
 	struct ns83820 *dev = PRIV(ndev);
 	/*if (nr_rx_empty(dev) >= NR_RX_DESC/4)*/ {
@@ -852,7 +851,7 @@ static void fastcall ns83820_rx_kick(struct net_device *ndev)
 /* rx_irq
  *
  */
-static void fastcall rx_irq(struct net_device *ndev)
+static void rx_irq(struct net_device *ndev)
 {
 	struct ns83820 *dev = PRIV(ndev);
 	struct rx_info *info = &dev->rx_info;
-- 
1.5.4.rc0.1083.gf568



