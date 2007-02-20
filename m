Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbXBTHv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbXBTHv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964916AbXBTHv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:51:56 -0500
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:32829 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898AbXBTHvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:51:55 -0500
Subject: [KJ][PATCH] is_power_of_2 in fs/hfs
From: Vignesh Babu BM <vignesh.babu@wipro.com>
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Feb 2007 13:20:09 +0530
Message-Id: <1171957809.6127.66.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 20 Feb 2007 07:51:53.0237 (UTC) FILETIME=[FC589C50:01C754C3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing (n & (n-1)) in the context of power of 2 checks 
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 5fd0ed7..8a3a650 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/log2.h>
 
 #include "btree.h"
 
@@ -76,7 +77,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	tree->depth = be16_to_cpu(head->depth);
 
 	size = tree->node_size;
-	if (!size || size & (size - 1))
+	if (!is_power_of_2(size))
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index a9b9e87..90ebab7 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -10,6 +10,7 @@
 
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/log2.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
@@ -69,7 +70,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	}
 
 	size = tree->node_size;
-	if (!size || size & (size - 1))
+	if (!is_power_of_2(size))
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"
