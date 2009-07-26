Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZGZIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZGZIUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZGZIUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:20:43 -0400
Received: from www.tglx.de ([62.245.132.106]:33857 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZGZIUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:20:39 -0400
Message-Id: <20090726081556.685624663@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [Patch RFC 26/37] irda: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=drivers-net-irda-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/irda/sir_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/net/irda/sir_dev.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/irda/sir_dev.c
+++ linux-2.6-tip/drivers/net/irda/sir_dev.c
@@ -908,7 +908,7 @@ struct sir_dev * sirdev_get_instance(con
 	dev->tx_skb = NULL;
 
 	spin_lock_init(&dev->tx_lock);
-	init_MUTEX(&dev->fsm.sem);
+	semaphore_init(&dev->fsm.sem);
 
 	dev->drv = drv;
 	dev->netdev = ndev;


