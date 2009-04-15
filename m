Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZDOCuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZDOCuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZDOCuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:50:09 -0400
Received: from mail.kolorific.com ([61.63.28.39]:38089 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbZDOCuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:50:08 -0400
Subject: [PATCH]Documentation/rbtree.txt: cleanup kerneldoc of rbtree
From: fzhang <figo.zhang@kolorific.com>
To: andrea@suse.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 15 Apr 2009 10:49:44 +0800
Message-Id: <1239763784.10095.3.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter of the rb_link_node() is a pointer, and the "node"
is
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

