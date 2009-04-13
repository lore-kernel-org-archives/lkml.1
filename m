Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZDMCAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZDMCAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZDMB7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:59:51 -0400
Received: from mail.kolorific.com ([61.63.28.39]:41436 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZDMB7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:59:51 -0400
Subject: [PATCH]Documentation/rbtree.txt: cleanup kerneldoc of rbtree.txt
From: fzhang <figo.zhang@kolorific.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 13 Apr 2009 09:59:23 +0800
Message-Id: <1239587963.3223.3.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter of the rb_link_node() is pointer, and the "node" is
define a struct (pls see line 67 and line 73 in the doc), so should use
"&data->node".

Signed-off-by: Figo.zhang <figo1802@126.com>
---
diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 7224459..7710214 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -131,8 +131,8 @@ Example:
       }
 
       /* Add new node and rebalance tree. */
-      rb_link_node(data->node, parent, new);
-      rb_insert_color(data->node, root);
+      rb_link_node(&data->node, parent, new);
+      rb_insert_color(&data->node, root);
 
     return TRUE;
   }
@@ -146,10 +146,10 @@ To remove an existing node from a tree, call:
 
 Example:
 
-  struct mytype *data = mysearch(mytree, "walrus");
+  struct mytype *data = mysearch(&mytree, "walrus");
 
   if (data) {
-      rb_erase(data->node, mytree);
+      rb_erase(&data->node, &mytree);
       myfree(data);
   }

