Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYBQIWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYBQIWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYBQIUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:20:20 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34061 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049AbYBQIUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:20:17 -0500
Date: Sun, 17 Feb 2008 10:19:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] make __put_super() static
Message-ID: <20080217081951.GP3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global __put_super() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/super.c         |    2 +-
 include/linux/fs.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

2f076cdd5f1d693cc46559d48df6b060242e7f4c diff --git a/fs/super.c b/fs/super.c
index 88811f6..260f4f4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -115,7 +115,7 @@ static inline void destroy_super(struct super_block *s)
  * Drop a superblock's refcount.  Returns non-zero if the superblock was
  * destroyed.  The caller must hold sb_lock.
  */
-int __put_super(struct super_block *sb)
+static int __put_super(struct super_block *sb)
 {
 	int ret = 0;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 23528b8..f16e8fc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1471,7 +1471,6 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	const struct super_operations *ops, unsigned long,
 	struct vfsmount *mnt);
 extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
-int __put_super(struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 void unnamed_dev_init(void);
 

