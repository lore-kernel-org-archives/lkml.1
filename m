Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYKZT1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYKZT1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYKZT12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:27:28 -0500
Received: from styx.suse.cz ([82.119.242.94]:47257 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753694AbYKZT11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:27:27 -0500
Date: Wed, 26 Nov 2008 20:27:25 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingming Cao <cmm@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] quota: Move EXPORT_SYMBOL immediately next to the
	functions/variables (refreshed)
Message-ID: <20081126192725.GK23124@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

According to checkpatch: EXPORT_SYMBOL(foo); should immediately follow its
function/variable

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c |   78 +++++++++++++++++++++++++++++------------------------------
 1 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index de56033..e18ae3c 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -127,6 +127,7 @@
 
 static DEFINE_SPINLOCK(dq_list_lock);
 DEFINE_SPINLOCK(dq_data_lock);
+EXPORT_SYMBOL(dq_data_lock);
 
 static char *quotatypes[] = INITQFNAMES;
 static struct quota_format_type *quota_formats;	/* List of registered formats */
@@ -143,6 +144,7 @@ int register_quota_format(struct quota_format_type *fmt)
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(register_quota_format);
 
 void unregister_quota_format(struct quota_format_type *fmt)
 {
@@ -154,6 +156,7 @@ void unregister_quota_format(struct quota_format_type *fmt)
 		*actqf = (*actqf)->qf_next;
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(unregister_quota_format);
 
 static struct quota_format_type *find_quota_format(int id)
 {
@@ -210,6 +213,7 @@ static unsigned int dq_hash_bits, dq_hash_mask;
 static struct hlist_head *dquot_hash;
 
 struct dqstats dqstats;
+EXPORT_SYMBOL(dqstats);
 
 static inline unsigned int
 hashfn(const struct super_block *sb, unsigned int id, int type)
@@ -304,6 +308,7 @@ int dquot_mark_dquot_dirty(struct dquot *dquot)
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 
 /* This function needs dq_list_lock */
 static inline int clear_dquot_dirty(struct dquot *dquot)
@@ -355,6 +360,7 @@ out_iolock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_acquire);
 
 /*
  *	Write dquot to disk
@@ -384,6 +390,7 @@ out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit);
 
 /*
  *	Release dquot
@@ -412,6 +419,7 @@ out_dqlock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_release);
 
 void dquot_destroy(struct dquot *dquot)
 {
@@ -511,6 +519,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_scan_active);
 
 int vfs_quota_sync(struct super_block *sb, int type)
 {
@@ -558,6 +567,7 @@ int vfs_quota_sync(struct super_block *sb, int type)
 
 	return 0;
 }
+EXPORT_SYMBOL(vfs_quota_sync);
 
 /* Free unused dquots from cache */
 static void prune_dqcache(int count)
@@ -668,6 +678,7 @@ we_slept:
 	put_dquot_last(dquot);
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(dqput);
 
 struct dquot *dquot_alloc(struct super_block *sb, int type)
 {
@@ -713,6 +724,7 @@ int dquot_is_cached(struct super_block *sb, unsigned int id, int type)
 	spin_unlock(&dq_list_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_is_cached);
 
 /*
  * Get reference to dquot
@@ -766,6 +778,7 @@ we_slept:
 
 	return dquot;
 }
+EXPORT_SYMBOL(dqget);
 
 static int dqinit_needed(struct inode *inode, int type)
 {
@@ -1260,6 +1273,7 @@ out_err:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_initialize);
 
 /*
  * 	Release all quotas referenced by inode
@@ -1277,6 +1291,7 @@ int dquot_drop_locked(struct inode *inode)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop_locked);
 
 int dquot_drop(struct inode *inode)
 {
@@ -1285,6 +1300,7 @@ int dquot_drop(struct inode *inode)
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop);
 
 /* Wrapper to remove references to quota structures from inode */
 void vfs_dq_drop(struct inode *inode)
@@ -1307,6 +1323,7 @@ void vfs_dq_drop(struct inode *inode)
 			inode->i_sb->dq_op->drop(inode);
 	}
 }
+EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
  * Following four functions update i_blocks+i_bytes fields and
@@ -1383,6 +1400,7 @@ out:
 		inode_add_bytes(inode, number);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_space);
 
 int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
 {
@@ -1401,6 +1419,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_reserve_space);
 
 int dquot_claim_space(struct inode *inode, qsize_t number)
 {
@@ -1439,6 +1458,7 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 	inode_add_bytes(inode, number);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_claim_space);
 
 /*
  * Release reserved quota space
@@ -1468,6 +1488,7 @@ out_unlock:
 out:
 	return;
 }
+EXPORT_SYMBOL(dquot_release_reserved_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1513,6 +1534,7 @@ warn_put_all:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_inode);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1553,6 +1575,7 @@ out_sub:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1589,6 +1612,7 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_inode);
 
 /*
  * Transfer the number of inode and blocks from one diskquota to an other.
@@ -1699,6 +1723,7 @@ warn_put_all:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
@@ -1710,7 +1735,7 @@ int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL(vfs_dq_transfer);
 
 /*
  * Write info of quota file to disk
@@ -1725,6 +1750,7 @@ int dquot_commit_info(struct super_block *sb, int type)
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit_info);
 
 /*
  * Definitions of diskquota operations.
@@ -1872,12 +1898,14 @@ put_inodes:
 		}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_quota_disable);
 
 int vfs_quota_off(struct super_block *sb, int type, int remount)
 {
 	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
 				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
 }
+EXPORT_SYMBOL(vfs_quota_off);
 
 /*
  *	Turn quotas on on a device
@@ -2031,6 +2059,7 @@ int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 					     DQUOT_LIMITS_ENABLED);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_path);
 
 int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 		 int remount)
@@ -2048,6 +2077,7 @@ int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on);
 
 /*
  * More powerful function for turning on quotas allowing setting
@@ -2092,6 +2122,7 @@ out_lock:
 load_quota:
 	return vfs_load_quota_inode(inode, type, format_id, flags);
 }
+EXPORT_SYMBOL(vfs_quota_enable);
 
 /*
  * This function is used when filesystem needs to initialize quotas
@@ -2121,6 +2152,7 @@ out:
 	dput(dentry);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_mount);
 
 /* Wrapper to turn on quotas when remounting rw */
 int vfs_dq_quota_on_remount(struct super_block *sb)
@@ -2137,6 +2169,7 @@ int vfs_dq_quota_on_remount(struct super_block *sb)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
 
 static inline qsize_t qbtos(qsize_t blocks)
 {
@@ -2180,6 +2213,7 @@ int vfs_get_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *d
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqblk);
 
 /* Generic routine for setting common part of quota structure */
 static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
@@ -2271,6 +2305,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
+EXPORT_SYMBOL(vfs_set_dqblk);
 
 /* Generic routine for getting common part of quota file information */
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2292,6 +2327,7 @@ int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqinfo);
 
 /* Generic routine for setting common part of quota file information */
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2320,6 +2356,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
@@ -2475,42 +2512,3 @@ static int __init dquot_init(void)
 	return 0;
 }
 module_init(dquot_init);
-
-EXPORT_SYMBOL(register_quota_format);
-EXPORT_SYMBOL(unregister_quota_format);
-EXPORT_SYMBOL(dqstats);
-EXPORT_SYMBOL(dq_data_lock);
-EXPORT_SYMBOL(vfs_quota_enable);
-EXPORT_SYMBOL(vfs_quota_on);
-EXPORT_SYMBOL(vfs_quota_on_path);
-EXPORT_SYMBOL(vfs_quota_on_mount);
-EXPORT_SYMBOL(vfs_quota_disable);
-EXPORT_SYMBOL(vfs_quota_off);
-EXPORT_SYMBOL(dquot_scan_active);
-EXPORT_SYMBOL(vfs_quota_sync);
-EXPORT_SYMBOL(vfs_get_dqinfo);
-EXPORT_SYMBOL(vfs_set_dqinfo);
-EXPORT_SYMBOL(vfs_get_dqblk);
-EXPORT_SYMBOL(vfs_set_dqblk);
-EXPORT_SYMBOL(dquot_commit);
-EXPORT_SYMBOL(dquot_commit_info);
-EXPORT_SYMBOL(dquot_acquire);
-EXPORT_SYMBOL(dquot_release);
-EXPORT_SYMBOL(dquot_mark_dquot_dirty);
-EXPORT_SYMBOL(dquot_initialize);
-EXPORT_SYMBOL(dquot_drop);
-EXPORT_SYMBOL(dquot_drop_locked);
-EXPORT_SYMBOL(vfs_dq_drop);
-EXPORT_SYMBOL(dqget);
-EXPORT_SYMBOL(dqput);
-EXPORT_SYMBOL(dquot_is_cached);
-EXPORT_SYMBOL(dquot_alloc_space);
-EXPORT_SYMBOL(dquot_alloc_inode);
-EXPORT_SYMBOL(dquot_free_space);
-EXPORT_SYMBOL(dquot_free_inode);
-EXPORT_SYMBOL(dquot_reserve_space);
-EXPORT_SYMBOL(dquot_claim_space);
-EXPORT_SYMBOL(dquot_release_reserved_space);
-EXPORT_SYMBOL(dquot_transfer);
-EXPORT_SYMBOL(vfs_dq_transfer);
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);
-- 
1.6.0.4

