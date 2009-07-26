Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZGZIX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZGZIX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZGZIX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:23:26 -0400
Received: from www.tglx.de ([62.245.132.106]:34050 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbZGZIXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:23:15 -0400
Message-Id: <20090726081554.158940299@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: [Patch RFC 07/37] net: 3c527: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=driver-net-3c527-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc:  David Miller <davem@davemloft.net>
---
 drivers/net/3c527.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/net/3c527.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/3c527.c
+++ linux-2.6-tip/drivers/net/3c527.c
@@ -521,7 +521,7 @@ static int __init mc32_probe1(struct net
 	lp->tx_len 		= lp->exec_box->data[9];   /* Transmit list count */
 	lp->rx_len 		= lp->exec_box->data[11];  /* Receive list count */
 
-	init_MUTEX_LOCKED(&lp->cmd_mutex);
+	semaphore_init_locked(&lp->cmd_mutex);
 	init_completion(&lp->execution_cmd);
 	init_completion(&lp->xceiver_cmd);
 


