Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYBQIXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYBQIXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYBQIUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:20:46 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59734 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759030AbYBQIUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:20:45 -0500
Date: Sun, 17 Feb 2008 10:20:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/hfsplus/: proper externs
Message-ID: <20080217082019.GR3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper extern declarations for two structs in 
fs/hfsplus/hfsplus_fs.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/hfsplus/hfsplus_fs.h |    4 ++++
 fs/hfsplus/inode.c      |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

27e62814fe7426c3c318c0e0e82789190966fb05 diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index d72d0a8..9e59537 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -311,6 +311,10 @@ int hfsplus_delete_cat(u32, struct inode *, struct qstr *);
 int hfsplus_rename_cat(u32, struct inode *, struct qstr *,
 		       struct inode *, struct qstr *);
 
+/* dir.c */
+extern const struct inode_operations hfsplus_dir_inode_operations;
+extern const struct file_operations hfsplus_dir_operations;
+
 /* extents.c */
 int hfsplus_ext_cmp_key(const hfsplus_btree_key *, const hfsplus_btree_key *);
 void hfsplus_ext_write_extent(struct inode *);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 37744cf..d53b2af 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -278,9 +278,6 @@ static int hfsplus_file_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-extern const struct inode_operations hfsplus_dir_inode_operations;
-extern struct file_operations hfsplus_dir_operations;
-
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,

