Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbXBRW0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbXBRW0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXBRW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:26:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:20114 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbXBRW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:26:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent:from;
        b=dAuRHgbTuYodAzCGBeT7r2f8qXZar2f6aFZlmQRUdfS2v9ChLtdDVXKeY4wCiv9wr0sNVBzsP5ziigVr+jNcVy6zRVcUgLVPw0eUFgYjS/5RUXa+U7/JQJZod+Bo5L4TwFETDmw94HksHNyeiqy9z0nv78rVcgGUmS3cxktwDjY=
Date: Sun, 18 Feb 2007 23:26:19 +0100
To: linux-kernel@vger.kernel.org
Subject: [Patch] net/core: change hlist_for_each/hlist_entry to
	hlist_for_each_entry
Message-ID: <20070218222619.GA7366@unknown-00-0d-60-79-ca-00.lan>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2007-02-12)
From: Thomas Hisch <t.hisch@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

change occurrence of hlist_for_each/hlist_entry to hlist_for_each_entry as it
combines the previous two macros

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
---
 net/core/dev.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index cf71614..83c2f43 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -475,13 +475,11 @@ __setup("netdev=", netdev_boot_setup);
 struct net_device *__dev_get_by_name(const char *name)
 {
 	struct hlist_node *p;
+	struct net_device *dev;
 
-	hlist_for_each(p, dev_name_hash(name)) {
-		struct net_device *dev
-			= hlist_entry(p, struct net_device, name_hlist);
+	hlist_for_each_entry(dev, p, dev_name_hash(name), name_hlist)
 		if (!strncmp(dev->name, name, IFNAMSIZ))
 			return dev;
-	}
 	return NULL;
 }
 
@@ -522,13 +520,11 @@ struct net_device *dev_get_by_name(const char *name)
 struct net_device *__dev_get_by_index(int ifindex)
 {
 	struct hlist_node *p;
+	struct net_device *dev;
 
-	hlist_for_each(p, dev_index_hash(ifindex)) {
-		struct net_device *dev
-			= hlist_entry(p, struct net_device, index_hlist);
+	hlist_for_each_entry(dev, p, dev_index_hash(ifindex), index_hlist)
 		if (dev->ifindex == ifindex)
 			return dev;
-	}
 	return NULL;
 }
 
@@ -2878,6 +2874,7 @@ int register_netdevice(struct net_device *dev)
 {
 	struct hlist_head *head;
 	struct hlist_node *p;
+	struct net_device *d;
 	int ret;
 
 	BUG_ON(dev_boot_phase);
@@ -2918,9 +2915,7 @@ int register_netdevice(struct net_device *dev)
 
 	/* Check for existence of name */
 	head = dev_name_hash(dev->name);
-	hlist_for_each(p, head) {
-		struct net_device *d
-			= hlist_entry(p, struct net_device, name_hlist);
+	hlist_for_each_entry(d, p, head, name_hlist) {
 		if (!strncmp(d->name, dev->name, IFNAMSIZ)) {
 			ret = -EEXIST;
 			goto out;
-- 
1.5.0-rc2.GIT

-- 
Thomas Hisch
e0625874@stud.tuwien.ac.at
