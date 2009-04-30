Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbZD3Ihu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbZD3Ihu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbZD3IhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:37:07 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:39340 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756853AbZD3IhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:37:05 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] fs: Remove sparse errors in proc_devtree.c
Date: Thu, 30 Apr 2009 10:35:51 +0200
Message-Id: <1241080551-18281-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

  CHECK   fs/proc/proc_devtree.c
fs/proc/proc_devtree.c:197:14: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:203:34: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:210:14: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:223:26: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:226:14: warning: Using plain integer as NULL pointer

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 fs/proc/proc_devtree.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index de2bba5..9fe0e4b 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -194,20 +194,20 @@ void proc_device_tree_add_node(struct device_node *np,
 			p = fixup_name(np, de, p);
 
 		ent = proc_mkdir(p, de);
-		if (ent == 0)
+		if (ent == NULL)
 			break;
 		proc_device_tree_add_node(child, ent);
 	}
 	of_node_put(child);
 
-	for (pp = np->properties; pp != 0; pp = pp->next) {
+	for (pp = np->properties; pp != NULL; pp = pp->next) {
 		p = pp->name;
 
 		if (duplicate_name(de, p))
 			p = fixup_name(np, de, p);
 
 		ent = __proc_device_tree_add_prop(de, pp, p);
-		if (ent == 0)
+		if (ent == NULL)
 			break;
 	}
 }
@@ -220,10 +220,10 @@ void __init proc_device_tree_init(void)
 	struct device_node *root;
 
 	proc_device_tree = proc_mkdir("device-tree", NULL);
-	if (proc_device_tree == 0)
+	if (proc_device_tree == NULL)
 		return;
 	root = of_find_node_by_path("/");
-	if (root == 0) {
+	if (root == NULL) {
 		printk(KERN_ERR "/proc/device-tree: can't find root\n");
 		return;
 	}
-- 
1.5.5.1

