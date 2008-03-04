Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYCDCEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYCDCEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYCDCBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:10568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYCDCBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TI0btcRVqM4shs6u5A0VF7ccH6c3+HxrkpKPYv33bE09RToRo8DXfpM9+nWVfOZBmGgkvLo60AVDttd1DBGYnre+DCNYRgBircctF8Fbl2G3JmxYCIJpJlQH4GxOYyodadBYg9QPJQsV6fJQ1RuHrru51fn39oYxl5ZfQIe5Fb0=
Subject: [PATCH 08/13] reiserfs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:04 -0800
Message-Id: <1204596064.22933.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/bitmap.c   |    8 ++++----
 fs/reiserfs/journal.c  |    8 ++++----
 fs/reiserfs/namei.c    |    8 ++++----
 fs/reiserfs/objectid.c |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index f491ceb..4646caa 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -479,7 +479,7 @@ static void __discard_prealloc(struct reiserfs_transaction_handle *th,
 	if (ei->i_prealloc_count < 0)
 		reiserfs_warning(th->t_super,
 				 "zam-4001:%s: inode has negative prealloc blocks count.",
-				 __FUNCTION__);
+				 __func__);
 #endif
 	while (ei->i_prealloc_count > 0) {
 		reiserfs_free_prealloc_block(th, inode, ei->i_prealloc_block);
@@ -517,7 +517,7 @@ void reiserfs_discard_all_prealloc(struct reiserfs_transaction_handle *th)
 		if (!ei->i_prealloc_count) {
 			reiserfs_warning(th->t_super,
 					 "zam-4001:%s: inode is in prealloc list but has no preallocated blocks.",
-					 __FUNCTION__);
+					 __func__);
 		}
 #endif
 		__discard_prealloc(th, ei);
@@ -632,7 +632,7 @@ int reiserfs_parse_alloc_options(struct super_block *s, char *options)
 		}
 
 		reiserfs_warning(s, "zam-4001: %s : unknown option - %s",
-				 __FUNCTION__, this_char);
+				 __func__, this_char);
 		return 1;
 	}
 
@@ -1254,7 +1254,7 @@ struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
 	bh = sb_bread(sb, block);
 	if (bh == NULL)
 		reiserfs_warning(sb, "sh-2029: %s: bitmap block (#%u) "
-		                 "reading failed", __FUNCTION__, block);
+		                 "reading failed", __func__, block);
 	else {
 		if (buffer_locked(bh)) {
 			PROC_INFO_INC(sb, scan_bitmap.wait);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index bb05a3e..912d203 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1187,7 +1187,7 @@ static int flush_commit_list(struct super_block *s,
 
 	if (retval)
 		reiserfs_abort(s, retval, "Journal write error in %s",
-			       __FUNCTION__);
+			       __func__);
 	put_fs_excl();
 	return retval;
 }
@@ -1534,7 +1534,7 @@ static int flush_journal_list(struct super_block *s,
 			reiserfs_warning(s,
 					 "clm-2082: Unable to flush buffer %llu in %s",
 					 (unsigned long long)saved_bh->
-					 b_blocknr, __FUNCTION__);
+					 b_blocknr, __func__);
 		}
 	      free_cnode:
 		last = cn;
@@ -1586,7 +1586,7 @@ static int flush_journal_list(struct super_block *s,
 	if (err)
 		reiserfs_abort(s, -EIO,
 			       "Write error while pushing transaction to disk in %s",
-			       __FUNCTION__);
+			       __func__);
       flush_older_and_return:
 
 	/* before we can update the journal header block, we _must_ flush all 
@@ -1616,7 +1616,7 @@ static int flush_journal_list(struct super_block *s,
 		if (err)
 			reiserfs_abort(s, -EIO,
 				       "Write error while updating journal header in %s",
-				       __FUNCTION__);
+				       __func__);
 	}
 	remove_all_from_journal_list(s, jl, 0);
 	list_del_init(&jl->j_list);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b378eea..d12e471 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -301,7 +301,7 @@ static int reiserfs_find_entry(struct inode *dir, const char *name, int namelen,
 					path_to_entry, de);
 		if (retval == IO_ERROR) {
 			reiserfs_warning(dir->i_sb, "zam-7001: io error in %s",
-					 __FUNCTION__);
+					 __func__);
 			return IO_ERROR;
 		}
 
@@ -496,7 +496,7 @@ static int reiserfs_add_entry(struct reiserfs_transaction_handle *th,
 			reiserfs_warning(dir->i_sb,
 					 "zam-7002:%s: \"reiserfs_find_entry\" "
 					 "has returned unexpected value (%d)",
-					 __FUNCTION__, retval);
+					 __func__, retval);
 		}
 
 		return -EEXIST;
@@ -907,7 +907,7 @@ static int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (inode->i_nlink != 2 && inode->i_nlink != 1)
 		reiserfs_warning(inode->i_sb, "%s: empty directory has nlink "
-				 "!= 2 (%d)", __FUNCTION__, inode->i_nlink);
+				 "!= 2 (%d)", __func__, inode->i_nlink);
 
 	clear_nlink(inode);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
@@ -984,7 +984,7 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (!inode->i_nlink) {
 		reiserfs_warning(inode->i_sb, "%s: deleting nonexistent file "
-				 "(%s:%lu), %d", __FUNCTION__,
+				 "(%s:%lu), %d", __func__,
 				 reiserfs_bdevname(inode->i_sb), inode->i_ino,
 				 inode->i_nlink);
 		inode->i_nlink = 1;
diff --git a/fs/reiserfs/objectid.c b/fs/reiserfs/objectid.c
index 65feba4..4c397b2 100644
--- a/fs/reiserfs/objectid.c
+++ b/fs/reiserfs/objectid.c
@@ -61,7 +61,7 @@ __u32 reiserfs_get_unused_objectid(struct reiserfs_transaction_handle *th)
 	/* comment needed -Hans */
 	unused_objectid = le32_to_cpu(map[1]);
 	if (unused_objectid == U32_MAX) {
-		reiserfs_warning(s, "%s: no more object ids", __FUNCTION__);
+		reiserfs_warning(s, "%s: no more object ids", __func__);
 		reiserfs_restore_prepared_buffer(s, SB_BUFFER_WITH_SB(s));
 		return 0;
 	}
-- 
1.5.4.3.500.g83a2c


