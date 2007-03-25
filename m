Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbXCYO60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbXCYO60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXCYO60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:58:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34046 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408AbXCYO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:58:21 -0400
Date: Sun, 25 Mar 2007 16:58:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make remove_inode_dquot_ref() static
Message-ID: <20070325145825.GK16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove_inode_dquot_ref() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jan Kara <jack@suse.cz>

---

This patch was already sent on:
- 20 Feb 2007

 fs/dquot.c               |    3 ++-
 include/linux/quotaops.h |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.20-mm2/include/linux/quotaops.h.old	2007-02-18 22:27:48.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/quotaops.h	2007-02-18 22:27:54.000000000 +0100
@@ -37,9 +37,6 @@
 extern int dquot_commit_info(struct super_block *sb, int type);
 extern int dquot_mark_dquot_dirty(struct dquot *dquot);
 
-int remove_inode_dquot_ref(struct inode *inode, int type,
-			   struct list_head *tofree_head);
-
 extern int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path);
 extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 		int format_id, int type);
--- linux-2.6.20-mm2/fs/dquot.c.old	2007-02-18 22:28:03.000000000 +0100
+++ linux-2.6.20-mm2/fs/dquot.c	2007-02-18 22:28:16.000000000 +0100
@@ -721,7 +721,8 @@
 
 /* Remove references to dquots from inode - add dquot to list for freeing if needed */
 /* We can't race with anybody because we hold dqptr_sem for writing... */
-int remove_inode_dquot_ref(struct inode *inode, int type, struct list_head *tofree_head)
+static int remove_inode_dquot_ref(struct inode *inode, int type,
+				  struct list_head *tofree_head)
 {
 	struct dquot *dquot = inode->i_dquot[type];
 

