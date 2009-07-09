Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbZGIA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbZGIA2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZGIA2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:28:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46859 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbZGIA2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:28:32 -0400
Date: Thu, 9 Jul 2009 10:28:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: linux-next: origin tree build failure
Message-Id: <20090709102829.ab45dc71.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/net/fealnx.c: In function 'fealnx_tx_timeout':
drivers/net/fealnx.c:1219: error: 'PR_CONT' undeclared (first use in this function)
drivers/net/fealnx.c:1219: error: (Each undeclared identifier is reported only once
drivers/net/fealnx.c:1219: error: for each function it appears in.)
drivers/net/fealnx.c:1219: error: expected ')' before string constant
drivers/net/fealnx.c:1224: error: expected ')' before string constant
drivers/net/fealnx.c:1225: error: expected ')' before string constant

Caused by commit ad361c9884e809340f6daca80d56a9e9c871690a ("Remove
multiple KERN_ prefixes from printk formats").  I applied the following
patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 9 Jul 2009 10:23:07 +1000
Subject: [PATCH] Fix up typo in KERN_ prefixes removal

This fixes a type in commit ad361c9884e809340f6daca80d56a9e9c871690a
"Remove multiple KERN_ prefixes from printk formats".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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
-- 
1.6.3.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
