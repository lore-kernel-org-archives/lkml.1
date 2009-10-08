Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZJHCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZJHCcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZJHCcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 22:32:18 -0400
Received: from msr31.hinet.net ([168.95.4.131]:46345 "EHLO msr31.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbZJHCcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 22:32:17 -0400
From: Thomas Chou <thomas@wytron.com.tw>
To: netdev@vger.kernel.org
Cc: thierry.reding@avionic-design.de,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] ethoc: use NET_IP_ALIGN in skb_reserve()
Date: Thu,  8 Oct 2009 10:32:41 +0800
Message-Id: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Stephen Hemminger.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/net/ethoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index ecc53d9..4a1ed81 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -409,7 +409,7 @@ static int ethoc_rx(struct net_device *dev, int limit)
 			struct sk_buff *skb = netdev_alloc_skb(dev, size);
 
 			size -= 4; /* strip the CRC */
-			skb_reserve(skb, 2); /* align TCP/IP header */
+			skb_reserve(skb, NET_IP_ALIGN);
 
 			if (likely(skb)) {
 				void *src = phys_to_virt(bd.addr);
-- 
1.6.2.5

