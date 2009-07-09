Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbZGIAFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbZGIAFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZGIAFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:05:34 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40863 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbZGIAFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:05:34 -0400
X-IronPort-AV: E=Sophos;i="4.42,371,1243814400"; 
   d="scan'208";a="85073602"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: fealnx: Fix build breakage -- PR_CONT should be KERN_CONT
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Jul 2009 17:05:32 -0700
Message-ID: <aday6qyzpo3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jul 2009 00:05:33.0280 (UTC) FILETIME=[FA607E00:01CA0028]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ad361c98 ("Remove multiple KERN_ prefixes from printk formats")
broke the build for fealnx because it added some "printk(PR_CONT ..."
calls, when PR_CONT doesn't exist; it should be "printk(KERN_CONT ..."

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/net/fealnx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index 053fb49..48385c4 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -1216,13 +1216,13 @@ static void fealnx_tx_timeout(struct net_device *dev)
 	{
 		printk(KERN_DEBUG "  Rx ring %p: ", np->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
-			printk(PR_CONT " %8.8x",
+			printk(KERN_CONT " %8.8x",
 			       (unsigned int) np->rx_ring[i].status);
 		printk(KERN_CONT "\n");
 		printk(KERN_DEBUG "  Tx ring %p: ", np->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(PR_CONT " %4.4x", np->tx_ring[i].status);
-		printk(PR_CONT "\n");
+			printk(KERN_CONT " %4.4x", np->tx_ring[i].status);
+		printk(KERN_CONT "\n");
 	}
 
 	spin_lock_irqsave(&np->lock, flags);
