Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZKDQG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZKDQG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZKDQG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:06:56 -0500
Received: from server1.wserver.cz ([82.113.45.157]:59711 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbZKDQGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:06:55 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] NET: sungem, use spin_trylock_irqsave
Date: Wed,  4 Nov 2009 17:06:58 +0100
Message-Id: <1257350818-4194-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
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
index 7019a0d..51bde03 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -1034,10 +1034,8 @@ static netdev_tx_t gem_start_xmit(struct sk_buff *skb,
 			(csum_stuff_off << 21));
 	}
 
-	local_irq_save(flags);
-	if (!spin_trylock(&gp->tx_lock)) {
+	if (!spin_trylock_irqsave(&gp->tx_lock, flags)) {
 		/* Tell upper layer to requeue */
-		local_irq_restore(flags);
 		return NETDEV_TX_LOCKED;
 	}
 	/* We raced with gem_do_stop() */
-- 
1.6.4.2

