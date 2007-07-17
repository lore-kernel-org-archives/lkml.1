Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbXGQIZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbXGQIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933430AbXGQIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:23:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:63981 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765309AbXGQIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h3jNHrn+AVZ9qCuEY1BqTGKeEKKsf6IeZKqjxdwui+tBCZlTFAwWE6mXCB0uhZpXE6fXeetU5l9YZ2UlAu6sfMVa70QFRQe4BnyR/PtrRHk/TzQwl6CihpKjUxRtr4we0GQTazCgnAcLnZkUwbgYC4EIqkweJmqDM1TYNERAKdA=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 4/4] [NET] move __dev_addr_discard adjacent to dev_addr_discard for readability
Date: Tue, 17 Jul 2007 16:23:25 +0800
Message-Id: <11846606382771-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11846606302073-git-send-email-crquan@gmail.com>
References: <11846606051099-git-send-email-crquan@gmail.com>
 <1184660618735-git-send-email-crquan@gmail.com>
 <11846606302073-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/core/dev.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 17c9cbd..6357f54 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2715,20 +2715,6 @@ int __dev_addr_add(struct dev_addr_list **list, int *count,
 	return 0;
 }
 
-static void __dev_addr_discard(struct dev_addr_list **list)
-{
-	struct dev_addr_list *tmp;
-
-	while (*list != NULL) {
-		tmp = *list;
-		*list = tmp->next;
-		if (tmp->da_users > tmp->da_gusers)
-			printk("__dev_addr_discard: address leakage! "
-			       "da_users=%d\n", tmp->da_users);
-		kfree(tmp);
-	}
-}
-
 /**
  *	dev_unicast_delete	- Release secondary unicast address.
  *	@dev: device
@@ -2777,6 +2763,20 @@ int dev_unicast_add(struct net_device *dev, void *addr, int alen)
 }
 EXPORT_SYMBOL(dev_unicast_add);
 
+static void __dev_addr_discard(struct dev_addr_list **list)
+{
+	struct dev_addr_list *tmp;
+
+	while (*list != NULL) {
+		tmp = *list;
+		*list = tmp->next;
+		if (tmp->da_users > tmp->da_gusers)
+			printk("__dev_addr_discard: address leakage! "
+			       "da_users=%d\n", tmp->da_users);
+		kfree(tmp);
+	}
+}
+
 static void dev_addr_discard(struct net_device *dev)
 {
 	netif_tx_lock_bh(dev);
-- 
1.5.2.2

