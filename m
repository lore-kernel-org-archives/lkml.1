Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZGMVdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZGMVdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZGMVdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:33:10 -0400
Received: from server1.wserver.cz ([82.113.45.157]:52904 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbZGMVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:33:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] NET: sungem, use spin_trylock_irqsave
Date: Mon, 13 Jul 2009 23:23:40 +0200
Message-Id: <1247520220-31960-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>
References: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use spin_trylock_irqsave instead of open-coded
local_irq_save+spin_trylock.

Impact: cleanup

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/sungem.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index d2dfe0a..22474a8 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -1032,10 +1032,8 @@ static int gem_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			(csum_stuff_off << 21));
 	}
 
-	local_irq_save(flags);
-	if (!spin_trylock(&gp->tx_lock)) {
+	if (!spin_trylock_irqsave(&gp->tx_lock)) {
 		/* Tell upper layer to requeue */
-		local_irq_restore(flags);
 		return NETDEV_TX_LOCKED;
 	}
 	/* We raced with gem_do_stop() */
-- 
1.6.3.2

