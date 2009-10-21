Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZJUTXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZJUTXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZJUTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:23:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZJUTVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:36 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Felix Fietkau <nbd@openwrt.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: [PATCH 33/41] fallthru: jffs2 fallthru support
Date: Wed, 21 Oct 2009 12:19:31 -0700
Message-Id: <1256152779-10054-34-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-33-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
 <1256152779-10054-30-git-send-email-vaurora@redhat.com>
 <1256152779-10054-31-git-send-email-vaurora@redhat.com>
 <1256152779-10054-32-git-send-email-vaurora@redhat.com>
 <1256152779-10054-33-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

Add support for fallthru dentries to jffs2.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/jffs2/dir.c        |   31 ++++++++++++++++++++++++++++++-
 include/linux/jffs2.h |    6 ++++++
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 46a2e1b..544d6c5 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -35,6 +35,7 @@ static int jffs2_rename (struct inode *, struct dentry *,
 			 struct inode *, struct dentry *);
 
 static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
+static int jffs2_fallthru (struct inode *, struct dentry *);
 
 const struct file_operations jffs2_dir_operations =
 {
@@ -57,6 +58,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.rmdir =	jffs2_rmdir,
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
+	.fallthru =     jffs2_fallthru,
 	.whiteout =     jffs2_whiteout,
 	.permission =	jffs2_permission,
 	.setattr =	jffs2_setattr,
@@ -107,6 +109,9 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 		case DT_WHT:
 			target->d_flags |= DCACHE_WHITEOUT;
 			break;
+		case JFFS2_DT_FALLTHRU:
+			target->d_flags |= DCACHE_FALLTHRU;
+			break;
 		default:
 			ino = fd->ino;
 			break;
@@ -168,7 +173,10 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				  fd->name, fd->ino, fd->type, curofs, offset));
 			continue;
 		}
-		if (!fd->ino) {
+		if (fd->type == JFFS2_DT_FALLTHRU)
+			/* XXX Should really do a lookup for the real inode number here */
+			fd->ino = 100;
+		else if (!fd->ino && (fd->type != DT_WHT)) {
 			D2(printk(KERN_DEBUG "Skipping deletion dirent \"%s\"\n", fd->name));
 			offset++;
 			continue;
@@ -797,6 +805,26 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, int mode, de
 	return 0;
 }
 
+static int jffs2_fallthru (struct inode *dir, struct dentry *dentry)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(dir->i_sb);
+	uint32_t now;
+	int ret;
+
+	now = get_seconds();
+	ret = jffs2_do_link(c, JFFS2_INODE_INFO(dir), 0, DT_UNKNOWN,
+			    dentry->d_name.name, dentry->d_name.len, now);
+	if (ret)
+		return ret;
+
+	d_instantiate(dentry, NULL);
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+
+	return 0;
+}
+
 static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
 			   struct dentry *new_dentry)
 {
@@ -830,6 +858,7 @@ static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
 		return ret;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 65533bb..dbe8c93 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -114,6 +114,12 @@ struct jffs2_unknown_node
 	jint32_t hdr_crc;
 };
 
+/*
+ * Non-standard directory entry type(s), for on-disk use
+ */
+
+#define                JFFS2_DT_FALLTHRU       (DT_WHT + 1)
+
 struct jffs2_raw_dirent
 {
 	jint16_t magic;
-- 
1.6.3.3

