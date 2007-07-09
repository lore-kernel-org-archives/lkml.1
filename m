Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbXGIQmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbXGIQmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbXGIQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbXGIQYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:53 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Wendy Cheng <wcheng@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Remove i_mode passing from NFS File Handle
Date: Mon,  9 Jul 2007 17:03:00 +0100
Message-Id: <11839970963525-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970941232-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
 <11839970852076-git-send-email-swhiteho@redhat.com>
 <11839970871671-git-send-email-swhiteho@redhat.com>
 <1183997089710-git-send-email-swhiteho@redhat.com>
 <11839970914023-git-send-email-swhiteho@redhat.com>
 <11839970921764-git-send-email-swhiteho@redhat.com>
 <11839970941232-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Cheng <wcheng@redhat.com>

GFS2 has been passing i_mode within NFS File Handle. Other than the
wrong assumption that there is always room for this extra 16 bit value,
the current gfs2_get_dentry doesn't really need the i_mode to work
correctly. Note that GFS2 NFS code does go thru the same lookup code
path as direct file access route (where the mode is obtained from name
lookup) but gfs2_get_dentry() is coded for different purpose. It is not
used during lookup time. It is part of the file access procedure call.
When the call is invoked, if on-disk inode is not in-memory, it has to
be read-in. This makes i_mode passing a useless overhead.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 26aaf54..34f7bcd 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -78,6 +78,36 @@ static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
 }
 
 /**
+ * GFS2 lookup code fills in vfs inode contents based on info obtained
+ * from directory entry inside gfs2_inode_lookup(). This has caused issues
+ * with NFS code path since its get_dentry routine doesn't have the relevant
+ * directory entry when gfs2_inode_lookup() is invoked. Part of the code
+ * segment inside gfs2_inode_lookup code needs to get moved around.
+ *
+ * Clean up I_LOCK and I_NEW as well.
+ **/
+
+void gfs2_set_iop(struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (S_ISREG(mode)) {
+		inode->i_op = &gfs2_file_iops;
+		inode->i_fop = &gfs2_file_fops;
+		inode->i_mapping->a_ops = &gfs2_file_aops;
+	} else if (S_ISDIR(mode)) {
+		inode->i_op = &gfs2_dir_iops;
+		inode->i_fop = &gfs2_dir_fops;
+	} else if (S_ISLNK(mode)) {
+		inode->i_op = &gfs2_symlink_iops;
+	} else {
+		inode->i_op = &gfs2_dev_iops;
+	}
+
+	unlock_new_inode(inode);
+}
+
+/**
  * gfs2_inode_lookup - Lookup an inode
  * @sb: The super block
  * @no_addr: The inode number
@@ -101,7 +131,6 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 
 	if (inode->i_state & I_NEW) {
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
-		umode_t mode;
 		inode->i_private = ip;
 		ip->i_no_formal_ino = no_formal_ino;
 
@@ -122,6 +151,11 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 
 		gfs2_glock_put(io_gl);
 
+		if ((type == DT_UNKNOWN) && (no_formal_ino == 0))
+			goto gfs2_nfsbypass;
+
+		inode->i_mode = DT2IF(type);
+
 		/*
 		 * We must read the inode in order to work out its type in
 		 * this case. Note that this doesn't happen often as we normally
@@ -129,33 +163,19 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 		 * unlinked inode recovery (where it is safe to do this glock,
 		 * which is not true in the general case).
 		 */
-		inode->i_mode = mode = DT2IF(type);
 		if (type == DT_UNKNOWN) {
 			struct gfs2_holder gh;
 			error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 			if (unlikely(error))
 				goto fail_glock;
 			/* Inode is now uptodate */
-			mode = inode->i_mode;
 			gfs2_glock_dq_uninit(&gh);
 		}
 
-		if (S_ISREG(mode)) {
-			inode->i_op = &gfs2_file_iops;
-			inode->i_fop = &gfs2_file_fops;
-			inode->i_mapping->a_ops = &gfs2_file_aops;
-		} else if (S_ISDIR(mode)) {
-			inode->i_op = &gfs2_dir_iops;
-			inode->i_fop = &gfs2_dir_fops;
-		} else if (S_ISLNK(mode)) {
-			inode->i_op = &gfs2_symlink_iops;
-		} else {
-			inode->i_op = &gfs2_dev_iops;
-		}
-
-		unlock_new_inode(inode);
+		gfs2_set_iop(inode);
 	}
 
+gfs2_nfsbypass:
 	return inode;
 fail_glock:
 	gfs2_glock_dq(&ip->i_iopen_gh);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 3268a2f..4517ac8 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -47,6 +47,7 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 
 
 void gfs2_inode_attr_in(struct gfs2_inode *ip);
+void gfs2_set_iop(struct inode *inode);
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
 				u64 no_addr, u64 no_formal_ino);
 struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index 0fe1447..e317db2 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -27,12 +27,7 @@
 #include "util.h"
 
 #define GFS2_SMALL_FH_SIZE 4
-#define GFS2_LARGE_FH_SIZE 10
-
-struct gfs2_fh_obj {
-	struct gfs2_inum_host this;
-	u32 imode;
-};
+#define GFS2_LARGE_FH_SIZE 8
 
 static struct dentry *gfs2_decode_fh(struct super_block *sb,
 				     __u32 *p,
@@ -43,11 +38,8 @@ static struct dentry *gfs2_decode_fh(struct super_block *sb,
 				     void *context)
 {
 	__be32 *fh = (__force __be32 *)p;
-	struct gfs2_fh_obj fh_obj;
-	struct gfs2_inum_host *this, parent;
+	struct gfs2_inum_host inum, parent;
 
-	this 		= &fh_obj.this;
-	fh_obj.imode 	= DT_UNKNOWN;
 	memset(&parent, 0, sizeof(struct gfs2_inum));
 
 	switch (fh_len) {
@@ -56,18 +48,17 @@ static struct dentry *gfs2_decode_fh(struct super_block *sb,
 		parent.no_formal_ino |= be32_to_cpu(fh[5]);
 		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
 		parent.no_addr |= be32_to_cpu(fh[7]);
-		fh_obj.imode = be32_to_cpu(fh[8]);
 	case GFS2_SMALL_FH_SIZE:
-		this->no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
-		this->no_formal_ino |= be32_to_cpu(fh[1]);
-		this->no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
-		this->no_addr |= be32_to_cpu(fh[3]);
+		inum.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
+		inum.no_formal_ino |= be32_to_cpu(fh[1]);
+		inum.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
+		inum.no_addr |= be32_to_cpu(fh[3]);
 		break;
 	default:
 		return NULL;
 	}
 
-	return gfs2_export_ops.find_exported_dentry(sb, &fh_obj, &parent,
+	return gfs2_export_ops.find_exported_dentry(sb, &inum, &parent,
 						    acceptable, context);
 }
 
@@ -102,9 +93,6 @@ static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
 	fh[5] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
 	fh[6] = cpu_to_be32(ip->i_no_addr >> 32);
 	fh[7] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
-
-	fh[8]  = cpu_to_be32(inode->i_mode);
-	fh[9]  = 0;	/* pad to double word */
 	*len = GFS2_LARGE_FH_SIZE;
 
 	iput(inode);
@@ -201,8 +189,7 @@ static struct dentry *gfs2_get_parent(struct dentry *child)
 static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	struct gfs2_fh_obj *fh_obj = (struct gfs2_fh_obj *)inum_obj;
-	struct gfs2_inum_host *inum = &fh_obj->this;
+	struct gfs2_inum_host *inum = inum_obj;
 	struct gfs2_holder i_gh, ri_gh, rgd_gh;
 	struct gfs2_rgrpd *rgd;
 	struct inode *inode;
@@ -245,9 +232,9 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 	gfs2_glock_dq_uninit(&rgd_gh);
 	gfs2_glock_dq_uninit(&ri_gh);
 
-	inode = gfs2_inode_lookup(sb, fh_obj->imode,
+	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
 					inum->no_addr,
-					inum->no_formal_ino);
+					0);
 	if (!inode)
 		goto fail;
 	if (IS_ERR(inode)) {
@@ -260,6 +247,11 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 		iput(inode);
 		goto fail;
 	}
+
+	/* Pick up the works we bypass in gfs2_inode_lookup */
+	if (inode->i_state & I_NEW) 
+		gfs2_set_iop(inode);
+
 	if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
 		iput(inode);
 		goto fail;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7fb7448..e4e0406 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -872,7 +872,7 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 			continue;
 		*last_unlinked = no_addr;
 		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
-					no_addr, 0);
+					no_addr, -1);
 		if (!IS_ERR(inode))
 			return inode;
 	}
-- 
1.5.1.2

