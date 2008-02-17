Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYBQIU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYBQIU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYBQISO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:18:14 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36843 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbYBQISM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:18:12 -0500
Date: Sun, 17 Feb 2008 10:17:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/drop_caches.c: make 2 functions static
Message-ID: <20080217081746.GI3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- drop_pagecache()
- drop_slab()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/drop_caches.c   |    4 ++--
 include/linux/mm.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

32191754eb7aed31406850a082565bc428268a08 diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 59375ef..e2c6b65 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -25,7 +25,7 @@ static void drop_pagecache_sb(struct super_block *sb)
 	spin_unlock(&inode_lock);
 }
 
-void drop_pagecache(void)
+static void drop_pagecache(void)
 {
 	struct super_block *sb;
 
@@ -45,7 +45,7 @@ restart:
 	spin_unlock(&sb_lock);
 }
 
-void drop_slab(void)
+static void drop_slab(void)
 {
 	int nr_objects;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 26c7124..48927d4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1192,8 +1192,6 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
-void drop_pagecache(void);
-void drop_slab(void);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0

