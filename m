Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZGBFco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZGBFco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZGBFcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:32:00 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58731 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZGBFb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gq9rISyMI/RfHwmrwFbpROJbmZCeEV3IOvk7LxF8GYScb306hTypKbr1LO5qh6AzpX
         VAHzZUia97W7OrmlMWGY0P4gbgrJeNmmElo4Ly/46qTb8fmZm+wXdZBTmyVsf8wnkgvR
         VQoC/H+LNEivpDRelW/pBcDbhChiUhaCjmkbc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/8] SELinux netif.c non trivial fixes.
Date: Wed,  1 Jul 2009 22:32:42 -0700
Message-Id: <1246512767-2999-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some comments.
---
 security/selinux/netif.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index b4e14bc..dc6dc37 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -71,8 +71,8 @@ static inline struct sel_netif *sel_netif_find(int ifindex)
 	struct sel_netif *netif;
 
 	list_for_each_entry_rcu(netif, &sel_netif_hash[idx], list)
-		/* all of the devices should normally fit in the hash, so we
-		 * optimize for that case */
+		/* All of the devices should normally fit in the hash, so we
+		 * optimize for that case. */
 		if (likely(netif->nsec.ifindex == ifindex))
 			return netif;
 
@@ -152,13 +152,13 @@ static int sel_netif_sid_slow(int ifindex, u32 *sid)
 	struct sel_netif *new = NULL;
 	struct net_device *dev;
 
-	/* NOTE: we always use init's network namespace since we don't
-	 * currently support containers */
+	/* NOTE: We always use init's network namespace since we don't
+	 * currently support containers. */
 
 	dev = dev_get_by_index(&init_net, ifindex);
 	if (unlikely(dev == NULL)) {
 		printk(KERN_WARNING
-		       "SELinux: failure in sel_netif_sid_slow(),"
+		       "SELinux: Failure in sel_netif_sid_slow(),"
 		       " invalid network interface (%d)\n", ifindex);
 		return -ENOENT;
 	}
@@ -189,7 +189,7 @@ out:
 	dev_put(dev);
 	if (unlikely(ret)) {
 		printk(KERN_WARNING
-		       "SELinux: failure in sel_netif_sid_slow(),"
+		       "SELinux: Failure in sel_netif_sid_slow(),"
 		       " unable to determine network interface label (%d)\n",
 		       ifindex);
 		kfree(new);
-- 
1.6.3.2

