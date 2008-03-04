Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbYCDCGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbYCDCGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYCDCBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:25 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:14526 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYCDCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qkp2wC+NDDC9fL/4EEoqspzIkFAeB0WL6T3RlvTs1vz/DNl45Ox2Z4EwRLPIe1g1OND457Vk+oRN0CGrAe43ndbwzHeRK9MxwSnSP9/SWdIM9FOuHm8S12uEgNH1Q6RVZmRrVkushiMHQTFxWaH19l7e3MZ7nME1FMGrcAbSBoM=
Subject: [PATCH 13/13] fs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:08 -0800
Message-Id: <1204596068.22933.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, if you want this broken out, let me know.

 fs/adfs/adfs.h              |    2 +-
 fs/autofs4/autofs_i.h       |    2 +-
 fs/bfs/bfs.h                |    2 +-
 fs/buffer.c                 |    2 +-
 fs/configfs/file.c          |    2 +-
 fs/configfs/mount.c         |    2 +-
 fs/configfs/symlink.c       |    4 ++--
 fs/dlm/lockspace.c          |    2 +-
 fs/exportfs/expfs.c         |   10 +++++-----
 fs/fat/cache.c              |    6 +++---
 fs/fat/fatent.c             |    2 +-
 fs/fat/file.c               |    2 +-
 fs/gfs2/locking/dlm/sysfs.c |    2 +-
 fs/gfs2/util.h              |   18 +++++++++---------
 fs/jffs2/debug.h            |    8 ++++----
 fs/jffs2/xattr.c            |    4 ++--
 fs/lockd/clntproc.c         |    2 +-
 fs/lockd/svclock.c          |    2 +-
 fs/msdos/namei.c            |    2 +-
 fs/namespace.c              |    4 ++--
 fs/nfsd/nfs4callback.c      |    4 ++--
 fs/ntfs/debug.h             |    6 +++---
 fs/partitions/ldm.c         |    8 ++++----
 fs/smbfs/smb_debug.h        |    6 +++---
 fs/sysfs/file.c             |    2 +-
 fs/sysfs/mount.c            |    2 +-
 fs/udf/super.c              |    4 ++--
 fs/vfat/namei.c             |    2 +-
 28 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/fs/adfs/adfs.h b/fs/adfs/adfs.h
index 936f2af..8311575 100644
--- a/fs/adfs/adfs.h
+++ b/fs/adfs/adfs.h
@@ -75,7 +75,7 @@ extern unsigned int adfs_map_free(struct super_block *sb);
 /* Misc */
 void __adfs_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...);
-#define adfs_error(sb, fmt...) __adfs_error(sb, __FUNCTION__, fmt)
+#define adfs_error(sb, fmt...) __adfs_error(sb, __func__, fmt)
 
 /* super.c */
 
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 2d4ae40..c3d352d 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -35,7 +35,7 @@
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DPRINTK(fmt,args...) do { printk(KERN_DEBUG "pid %d: %s: " fmt "\n" , current->pid , __FUNCTION__ , ##args); } while(0)
+#define DPRINTK(fmt,args...) do { printk(KERN_DEBUG "pid %d: %s: " fmt "\n" , current->pid , __func__ , ##args); } while(0)
 #else
 #define DPRINTK(fmt,args...) do {} while(0)
 #endif
diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 71faf4d..70f5d3a 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -42,7 +42,7 @@ static inline struct bfs_inode_info *BFS_I(struct inode *inode)
 

 #define printf(format, args...) \
-	printk(KERN_ERR "BFS-fs: %s(): " format, __FUNCTION__, ## args)
+	printk(KERN_ERR "BFS-fs: %s(): " format, __func__, ## args)
 
 /* inode.c */
 extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
diff --git a/fs/buffer.c b/fs/buffer.c
index 897cd74..9aca397 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1098,7 +1098,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 
 		printk(KERN_ERR "%s: requested out-of-range block %llu for "
 			"device %s\n",
-			__FUNCTION__, (unsigned long long)block,
+			__func__, (unsigned long long)block,
 			bdevname(bdev, b));
 		return -EIO;
 	}
diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 397cb50..2b6cb23 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -115,7 +115,7 @@ configfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *pp
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
-		 __FUNCTION__, count, *ppos, buffer->page);
+		 __func__, count, *ppos, buffer->page);
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index de3b31d..8421cea 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -92,7 +92,7 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	root = d_alloc_root(inode);
 	if (!root) {
-		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
+		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
 		return -ENOMEM;
 	}
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 78929ea..2a731ef 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -210,13 +210,13 @@ static int configfs_get_target_path(struct config_item * item, struct config_ite
 	if (size > PATH_MAX)
 		return -ENAMETOOLONG;
 
-	pr_debug("%s: depth = %d, size = %d\n", __FUNCTION__, depth, size);
+	pr_debug("%s: depth = %d, size = %d\n", __func__, depth, size);
 
 	for (s = path; depth--; s += 3)
 		strcpy(s,"../");
 
 	fill_item_path(target, path, size);
-	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
+	pr_debug("%s: path = '%s'\n", __func__, path);
 
 	return 0;
 }
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index b64e55e..499e167 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -200,7 +200,7 @@ int __init dlm_lockspace_init(void)
 
 	dlm_kset = kset_create_and_add("dlm", NULL, kernel_kobj);
 	if (!dlm_kset) {
-		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 109ab5e..cc91227 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -150,12 +150,12 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir)
 			if (IS_ERR(ppd)) {
 				err = PTR_ERR(ppd);
 				dprintk("%s: get_parent of %ld failed, err %d\n",
-					__FUNCTION__, pd->d_inode->i_ino, err);
+					__func__, pd->d_inode->i_ino, err);
 				dput(pd);
 				break;
 			}
 
-			dprintk("%s: find name of %lu in %lu\n", __FUNCTION__,
+			dprintk("%s: find name of %lu in %lu\n", __func__,
 				pd->d_inode->i_ino, ppd->d_inode->i_ino);
 			err = exportfs_get_name(mnt, ppd, nbuf, pd);
 			if (err) {
@@ -168,14 +168,14 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir)
 					continue;
 				break;
 			}
-			dprintk("%s: found name: %s\n", __FUNCTION__, nbuf);
+			dprintk("%s: found name: %s\n", __func__, nbuf);
 			mutex_lock(&ppd->d_inode->i_mutex);
 			npd = lookup_one_len(nbuf, ppd, strlen(nbuf));
 			mutex_unlock(&ppd->d_inode->i_mutex);
 			if (IS_ERR(npd)) {
 				err = PTR_ERR(npd);
 				dprintk("%s: lookup failed: %d\n",
-					__FUNCTION__, err);
+					__func__, err);
 				dput(ppd);
 				dput(pd);
 				break;
@@ -188,7 +188,7 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir)
 			if (npd == pd)
 				noprogress = 0;
 			else
-				printk("%s: npd != pd\n", __FUNCTION__);
+				printk("%s: npd != pd\n", __func__);
 			dput(npd);
 			dput(ppd);
 			if (IS_ROOT(pd)) {
diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 639b3b4..fda2547 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -242,7 +242,7 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
 			fat_fs_panic(sb, "%s: detected the cluster chain loop"
-				     " (i_pos %lld)", __FUNCTION__,
+				     " (i_pos %lld)", __func__,
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
@@ -253,7 +253,7 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
 			fat_fs_panic(sb, "%s: invalid cluster chain"
-				     " (i_pos %lld)", __FUNCTION__,
+				     " (i_pos %lld)", __func__,
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
@@ -286,7 +286,7 @@ static int fat_bmap_cluster(struct inode *inode, int cluster)
 		return ret;
 	else if (ret == FAT_ENT_EOF) {
 		fat_fs_panic(sb, "%s: request beyond EOF (i_pos %lld)",
-			     __FUNCTION__, MSDOS_I(inode)->i_pos);
+			     __func__, MSDOS_I(inode)->i_pos);
 		return -EIO;
 	}
 	return dclus;
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 5fb3669..946fcd2 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -544,7 +544,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			goto error;
 		} else if (cluster == FAT_ENT_FREE) {
 			fat_fs_panic(sb, "%s: deleting FAT entry beyond EOF",
-				     __FUNCTION__);
+				     __func__);
 			err = -EIO;
 			goto error;
 		}
diff --git a/fs/fat/file.c b/fs/fat/file.c
index c614175..366527c 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -304,7 +304,7 @@ static int fat_free(struct inode *inode, int skip)
 		} else if (ret == FAT_ENT_FREE) {
 			fat_fs_panic(sb,
 				     "%s: invalid cluster chain (i_pos %lld)",
-				     __FUNCTION__, MSDOS_I(inode)->i_pos);
+				     __func__, MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
 			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index a87b098..04bb9bc 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -214,7 +214,7 @@ int gdlm_sysfs_init(void)
 {
 	gdlm_kset = kset_create_and_add("lock_dlm", NULL, kernel_kobj);
 	if (!gdlm_kset) {
-		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 28938a4..69f1db9 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -41,7 +41,7 @@ int gfs2_assert_withdraw_i(struct gfs2_sbd *sdp, char *assertion,
 
 #define gfs2_assert_withdraw(sdp, assertion) \
 ((likely(assertion)) ? 0 : gfs2_assert_withdraw_i((sdp), #assertion, \
-					__FUNCTION__, __FILE__, __LINE__))
+					__func__, __FILE__, __LINE__))
 

 int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
@@ -49,28 +49,28 @@ int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
 
 #define gfs2_assert_warn(sdp, assertion) \
 ((likely(assertion)) ? 0 : gfs2_assert_warn_i((sdp), #assertion, \
-					__FUNCTION__, __FILE__, __LINE__))
+					__func__, __FILE__, __LINE__))
 

 int gfs2_consist_i(struct gfs2_sbd *sdp, int cluster_wide,
 		   const char *function, char *file, unsigned int line);
 
 #define gfs2_consist(sdp) \
-gfs2_consist_i((sdp), 0, __FUNCTION__, __FILE__, __LINE__)
+gfs2_consist_i((sdp), 0, __func__, __FILE__, __LINE__)
 

 int gfs2_consist_inode_i(struct gfs2_inode *ip, int cluster_wide,
 			 const char *function, char *file, unsigned int line);
 
 #define gfs2_consist_inode(ip) \
-gfs2_consist_inode_i((ip), 0, __FUNCTION__, __FILE__, __LINE__)
+gfs2_consist_inode_i((ip), 0, __func__, __FILE__, __LINE__)
 

 int gfs2_consist_rgrpd_i(struct gfs2_rgrpd *rgd, int cluster_wide,
 			 const char *function, char *file, unsigned int line);
 
 #define gfs2_consist_rgrpd(rgd) \
-gfs2_consist_rgrpd_i((rgd), 0, __FUNCTION__, __FILE__, __LINE__)
+gfs2_consist_rgrpd_i((rgd), 0, __func__, __FILE__, __LINE__)
 

 int gfs2_meta_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
@@ -91,7 +91,7 @@ static inline int gfs2_meta_check_i(struct gfs2_sbd *sdp,
 }
 
 #define gfs2_meta_check(sdp, bh) \
-gfs2_meta_check_i((sdp), (bh), __FUNCTION__, __FILE__, __LINE__)
+gfs2_meta_check_i((sdp), (bh), __func__, __FILE__, __LINE__)
 

 int gfs2_metatype_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
@@ -118,7 +118,7 @@ static inline int gfs2_metatype_check_i(struct gfs2_sbd *sdp,
 }
 
 #define gfs2_metatype_check(sdp, bh, type) \
-gfs2_metatype_check_i((sdp), (bh), (type), __FUNCTION__, __FILE__, __LINE__)
+gfs2_metatype_check_i((sdp), (bh), (type), __func__, __FILE__, __LINE__)
 
 static inline void gfs2_metatype_set(struct buffer_head *bh, u16 type,
 				     u16 format)
@@ -134,14 +134,14 @@ int gfs2_io_error_i(struct gfs2_sbd *sdp, const char *function,
 		    char *file, unsigned int line);
 
 #define gfs2_io_error(sdp) \
-gfs2_io_error_i((sdp), __FUNCTION__, __FILE__, __LINE__);
+gfs2_io_error_i((sdp), __func__, __FILE__, __LINE__);
 

 int gfs2_io_error_bh_i(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		       const char *function, char *file, unsigned int line);
 
 #define gfs2_io_error_bh(sdp, bh) \
-gfs2_io_error_bh_i((sdp), (bh), __FUNCTION__, __FILE__, __LINE__);
+gfs2_io_error_bh_i((sdp), (bh), __func__, __FILE__, __LINE__);
 

 extern struct kmem_cache *gfs2_glock_cachep;
diff --git a/fs/jffs2/debug.h b/fs/jffs2/debug.h
index 4130ada..a05a68d 100644
--- a/fs/jffs2/debug.h
+++ b/fs/jffs2/debug.h
@@ -81,28 +81,28 @@
 	do {								\
 		printk(JFFS2_ERR_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_WARNING(fmt, ...)						\
 	do {								\
 		printk(JFFS2_WARN_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_NOTICE(fmt, ...)						\
 	do {								\
 		printk(JFFS2_NOTICE_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_DEBUG(fmt, ...)						\
 	do {								\
 		printk(JFFS2_DBG_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 /*
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index e486659..574cb75 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -82,7 +82,7 @@ static int is_xattr_datum_unchecked(struct jffs2_sb_info *c, struct jffs2_xattr_
 static void unload_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_datum *xd)
 {
 	/* must be called under down_write(xattr_sem) */
-	D1(dbg_xattr("%s: xid=%u, version=%u\n", __FUNCTION__, xd->xid, xd->version));
+	D1(dbg_xattr("%s: xid=%u, version=%u\n", __func__, xd->xid, xd->version));
 	if (xd->xname) {
 		c->xdatum_mem_usage -= (xd->name_len + 1 + xd->value_len);
 		kfree(xd->xname);
@@ -1252,7 +1252,7 @@ int jffs2_garbage_collect_xattr_ref(struct jffs2_sb_info *c, struct jffs2_xattr_
 	rc = jffs2_reserve_space_gc(c, totlen, &length, JFFS2_SUMMARY_XREF_SIZE);
 	if (rc) {
 		JFFS2_WARNING("%s: jffs2_reserve_space_gc() = %d, request = %u\n",
-			      __FUNCTION__, rc, totlen);
+			      __func__, rc, totlen);
 		rc = rc ? rc : -EBADFD;
 		goto out;
 	}
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index b6b74a6..02f87a9 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -532,7 +532,7 @@ again:
 		/* Ensure the resulting lock will get added to granted list */
 		fl->fl_flags = fl_flags | FL_SLEEP;
 		if (do_vfs_lock(fl) < 0)
-			printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n", __FUNCTION__);
+			printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n", __func__);
 		up_read(&host->h_rwsem);
 	}
 	status = nlm_stat_to_errno(resp->status);
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index fe9bdb4..7ffaf26 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -752,7 +752,7 @@ nlmsvc_grant_blocked(struct nlm_block *block)
 		return;
 	default:
 		printk(KERN_WARNING "lockd: unexpected error %d in %s!\n",
-				-error, __FUNCTION__);
+				-error, __func__);
 		nlmsvc_insert_block(block, 10 * HZ);
 		nlmsvc_release_block(block);
 		return;
diff --git a/fs/msdos/namei.c b/fs/msdos/namei.c
index 30f7d0a..a47a91d 100644
--- a/fs/msdos/namei.c
+++ b/fs/msdos/namei.c
@@ -609,7 +609,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_panic(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __FUNCTION__, sinfo.i_pos);
+			     __func__, sinfo.i_pos);
 	}
 	goto out;
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index 7953c96..c7de391 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1892,10 +1892,10 @@ void __init mnt_init(void)
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
-			__FUNCTION__, err);
+			__func__, err);
 	fs_kobj = kobject_create_and_add("fs", NULL);
 	if (!fs_kobj)
-		printk(KERN_WARNING "%s: kobj create error\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: kobj create error\n", __func__);
 	init_rootfs();
 	init_mount_tree();
 }
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index aae2b29..d09bc63 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -104,7 +104,7 @@ xdr_writemem(__be32 *p, const void *ptr, int nbytes)
 } while (0)
 #define RESERVE_SPACE(nbytes)   do {                            \
 	p = xdr_reserve_space(xdr, nbytes);                     \
-	if (!p) dprintk("NFSD: RESERVE_SPACE(%d) failed in function %s\n", (int) (nbytes), __FUNCTION__); \
+	if (!p) dprintk("NFSD: RESERVE_SPACE(%d) failed in function %s\n", (int) (nbytes), __func__); \
 	BUG_ON(!p);                                             \
 } while (0)
 
@@ -134,7 +134,7 @@ xdr_error:                                      \
 	p = xdr_inline_decode(xdr, nbytes); \
 	if (!p) { \
 		dprintk("NFSD: %s: reply buffer overflowed in line %d.\n", \
-			__FUNCTION__, __LINE__); \
+			__func__, __LINE__); \
 		return -EIO; \
 	} \
 } while (0)
diff --git a/fs/ntfs/debug.h b/fs/ntfs/debug.h
index 8ac37c3..5e6724c 100644
--- a/fs/ntfs/debug.h
+++ b/fs/ntfs/debug.h
@@ -45,7 +45,7 @@ static void ntfs_debug(const char *f, ...);
 extern void __ntfs_debug (const char *file, int line, const char *function,
 	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 #define ntfs_debug(f, a...)						\
-	__ntfs_debug(__FILE__, __LINE__, __FUNCTION__, f, ##a)
+	__ntfs_debug(__FILE__, __LINE__, __func__, f, ##a)
 
 extern void ntfs_debug_dump_runlist(const runlist_element *rl);
 
@@ -58,10 +58,10 @@ extern void ntfs_debug_dump_runlist(const runlist_element *rl);
 
 extern void __ntfs_warning(const char *function, const struct super_block *sb,
 		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
-#define ntfs_warning(sb, f, a...)	__ntfs_warning(__FUNCTION__, sb, f, ##a)
+#define ntfs_warning(sb, f, a...)	__ntfs_warning(__func__, sb, f, ##a)
 
 extern void __ntfs_error(const char *function, const struct super_block *sb,
 		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
-#define ntfs_error(sb, f, a...)		__ntfs_error(__FUNCTION__, sb, f, ##a)
+#define ntfs_error(sb, f, a...)		__ntfs_error(__func__, sb, f, ##a)
 
 #endif /* _LINUX_NTFS_DEBUG_H */
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index e7dd1d4..0fdda2e 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -41,12 +41,12 @@
 #ifndef CONFIG_LDM_DEBUG
 #define ldm_debug(...)	do {} while (0)
 #else
-#define ldm_debug(f, a...) _ldm_printk (KERN_DEBUG, __FUNCTION__, f, ##a)
+#define ldm_debug(f, a...) _ldm_printk (KERN_DEBUG, __func__, f, ##a)
 #endif
 
-#define ldm_crit(f, a...)  _ldm_printk (KERN_CRIT,  __FUNCTION__, f, ##a)
-#define ldm_error(f, a...) _ldm_printk (KERN_ERR,   __FUNCTION__, f, ##a)
-#define ldm_info(f, a...)  _ldm_printk (KERN_INFO,  __FUNCTION__, f, ##a)
+#define ldm_crit(f, a...)  _ldm_printk (KERN_CRIT,  __func__, f, ##a)
+#define ldm_error(f, a...) _ldm_printk (KERN_ERR,   __func__, f, ##a)
+#define ldm_info(f, a...)  _ldm_printk (KERN_INFO,  __func__, f, ##a)
 
 __attribute__ ((format (printf, 3, 4)))
 static void _ldm_printk (const char *level, const char *function,
diff --git a/fs/smbfs/smb_debug.h b/fs/smbfs/smb_debug.h
index 734972b..fc4b1a5 100644
--- a/fs/smbfs/smb_debug.h
+++ b/fs/smbfs/smb_debug.h
@@ -11,14 +11,14 @@
  * these are normally enabled.
  */
 #ifdef SMBFS_PARANOIA
-# define PARANOIA(f, a...) printk(KERN_NOTICE "%s: " f, __FUNCTION__ , ## a)
+# define PARANOIA(f, a...) printk(KERN_NOTICE "%s: " f, __func__ , ## a)
 #else
 # define PARANOIA(f, a...) do { ; } while(0)
 #endif
 
 /* lots of debug messages */
 #ifdef SMBFS_DEBUG_VERBOSE
-# define VERBOSE(f, a...) printk(KERN_DEBUG "%s: " f, __FUNCTION__ , ## a)
+# define VERBOSE(f, a...) printk(KERN_DEBUG "%s: " f, __func__ , ## a)
 #else
 # define VERBOSE(f, a...) do { ; } while(0)
 #endif
@@ -28,7 +28,7 @@
  * too common name.
  */
 #ifdef SMBFS_DEBUG
-#define DEBUG1(f, a...) printk(KERN_DEBUG "%s: " f, __FUNCTION__ , ## a)
+#define DEBUG1(f, a...) printk(KERN_DEBUG "%s: " f, __func__ , ## a)
 #else
 #define DEBUG1(f, a...) do { ; } while(0)
 #endif
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a271c87..c903b8d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -128,7 +128,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
-		 __FUNCTION__, count, *ppos, buffer->page);
+		 __func__, count, *ppos, buffer->page);
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 7416826..14f0023 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -61,7 +61,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* instantiate and link root dentry */
 	root = d_alloc_root(inode);
 	if (!root) {
-		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
+		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
 		return -ENOMEM;
 	}
diff --git a/fs/udf/super.c b/fs/udf/super.c
index f3ac4ab..3088584 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -242,7 +242,7 @@ static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
 	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
 				  GFP_KERNEL);
 	if (!sbi->s_partmaps) {
-		udf_error(sb, __FUNCTION__,
+		udf_error(sb, __func__,
 			  "Unable to allocate space for %d partition maps",
 			  count);
 		sbi->s_partitions = 0;
@@ -1047,7 +1047,7 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 		bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
 
 	if (bitmap == NULL) {
-		udf_error(sb, __FUNCTION__,
+		udf_error(sb, __func__,
 			  "Unable to allocate space for bitmap "
 			  "and %d buffer_head pointers", nr_groups);
 		return NULL;
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index cd450be..2d314f1 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -991,7 +991,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_panic(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __FUNCTION__, sinfo.i_pos);
+			     __func__, sinfo.i_pos);
 	}
 	goto out;
 }
-- 
1.5.4.3.500.g83a2c

