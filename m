Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab0BEEo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:44:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47207 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab0BEEoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:44:55 -0500
Date: Fri, 5 Feb 2010 15:44:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
       <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the percpu tree with the net tree
Message-Id: <20100205154452.91230c09.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
drivers/net/macvlan.c between commit
fc0663d6b5e6d8e9b57f872a644c0aafd82361b7 ("macvlan: allow multiple driver
backends") from the net tree and commit
e20b68160144bcacbde008b9cf7df4e1544b2507 ("percpu: add __percpu sparse
annotations to net drivers") from the percpu tree.

The struct that is being modified by the latter commit has been moved by
the former into include/linux/if_macvlan.h.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 5 Feb 2010 15:29:35 +1100
Subject: [PATCH] percpu: macvlan merge fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/if_macvlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 51f1512..f9cb9ba 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -30,7 +30,7 @@ struct macvlan_dev {
 	struct hlist_node	hlist;
 	struct macvlan_port	*port;
 	struct net_device	*lowerdev;
-	struct macvlan_rx_stats *rx_stats;
+	struct macvlan_rx_stats __percpu *rx_stats;
 	enum macvlan_mode	mode;
 	int (*receive)(struct sk_buff *skb);
 	int (*forward)(struct net_device *dev, struct sk_buff *skb);
-- 
1.6.6.1

