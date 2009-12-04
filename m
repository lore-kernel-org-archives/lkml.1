Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZLDWpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZLDWpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZLDWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:45:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520AbZLDWpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:45:16 -0500
Message-ID: <4B199173.3050207@gmail.com>
Date: Fri, 04 Dec 2009 23:47:15 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: matthew@wil.cx, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct super_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/fs.h |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..4e23c70 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1553,30 +1553,30 @@ extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
 struct super_operations {
-   	struct inode *(*alloc_inode)(struct super_block *sb);
-	void (*destroy_inode)(struct inode *);
-
-   	void (*dirty_inode) (struct inode *);
-	int (*write_inode) (struct inode *, int);
-	void (*drop_inode) (struct inode *);
-	void (*delete_inode) (struct inode *);
-	void (*put_super) (struct super_block *);
-	void (*write_super) (struct super_block *);
-	int (*sync_fs)(struct super_block *sb, int wait);
-	int (*freeze_fs) (struct super_block *);
-	int (*unfreeze_fs) (struct super_block *);
-	int (*statfs) (struct dentry *, struct kstatfs *);
-	int (*remount_fs) (struct super_block *, int *, char *);
-	void (*clear_inode) (struct inode *);
-	void (*umount_begin) (struct super_block *);
-
-	int (*show_options)(struct seq_file *, struct vfsmount *);
-	int (*show_stats)(struct seq_file *, struct vfsmount *);
+   	struct inode *(* const alloc_inode)(struct super_block *sb);
+	void (* const destroy_inode)(struct inode *);
+
+   	void (* const dirty_inode) (struct inode *);
+	int (* const write_inode) (struct inode *, int);
+	void (* const drop_inode) (struct inode *);
+	void (* const delete_inode) (struct inode *);
+	void (* const put_super) (struct super_block *);
+	void (* const write_super) (struct super_block *);
+	int (* const sync_fs)(struct super_block *sb, int wait);
+	int (* const freeze_fs) (struct super_block *);
+	int (* const unfreeze_fs) (struct super_block *);
+	int (* const statfs) (struct dentry *, struct kstatfs *);
+	int (* const remount_fs) (struct super_block *, int *, char *);
+	void (* const clear_inode) (struct inode *);
+	void (* const umount_begin) (struct super_block *);
+
+	int (* const show_options)(struct seq_file *, struct vfsmount *);
+	int (* const show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
-	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
-	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+	ssize_t (* const quota_read)(struct super_block *, int, char *, size_t, loff_t);
+	ssize_t (* const quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
-	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (* const bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 };
 
 /*

