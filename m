Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbXEXCGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbXEXCGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbXEXCGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 22:06:48 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:2254 "EHLO critter"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757698AbXEXCGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 22:06:48 -0400
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Message-Id: <91fcd7d6a83321c37f6769164b1b41ce78a07bfa.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <98cd38b5.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 18:30:46 -0400
Subject: [PATCH 5/6] SUNHME: Workaround ancient hang on U1's
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This work around has been in use by almost any distribution trying to
support sparc64 since at least 2002. Without it, sunhme hangs fairly
quickly on UltraSPARC 1's.

Dave, I know it's not in the kernel because it isn't a "fix", but given
that we haven't seen a fix in more than 5 years, can we get this out of my
tree please? :)

CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
---
 drivers/net/sunhme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 51c3fe2..5753298 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -1969,6 +1969,7 @@ static void happy_meal_tx(struct happy_meal *hp)
 	}
 	hp->tx_old = elem;
 	TXD((">"));
+	udelay(1);
 
 	if (netif_queue_stopped(dev) &&
 	    TX_BUFFS_AVAIL(hp) > (MAX_SKB_FRAGS + 1))
-- 
1.5.1.4

