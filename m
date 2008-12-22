Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYLVWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYLVWCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbYLVVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYLVVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:52 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 36/56] quota: Export dquot_alloc() and dquot_destroy() functions
Date: Mon, 22 Dec 2008 13:48:17 -0800
Message-Id: <1229982517-3455-37-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

These are default functions for creating and destroying quota structures
and they should be used from filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c               |    6 ++++--
 include/linux/quotaops.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 6f7df91..c724586 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -413,10 +413,11 @@ out_dqlock:
 	return ret;
 }
 
-static void dquot_destroy(struct dquot *dquot)
+void dquot_destroy(struct dquot *dquot)
 {
 	kmem_cache_free(dquot_cachep, dquot);
 }
+EXPORT_SYMBOL(dquot_destroy);
 
 static inline void do_destroy_dquot(struct dquot *dquot)
 {
@@ -668,10 +669,11 @@ we_slept:
 	spin_unlock(&dq_list_lock);
 }
 
-static struct dquot *dquot_alloc(struct super_block *sb, int type)
+struct dquot *dquot_alloc(struct super_block *sb, int type)
 {
 	return kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
 }
+EXPORT_SYMBOL(dquot_alloc);
 
 static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 {
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f491394..21b781a 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -31,6 +31,8 @@ int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
 		      unsigned long priv);
+struct dquot *dquot_alloc(struct super_block *sb, int type);
+void dquot_destroy(struct dquot *dquot);
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
-- 
1.5.6

