Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYH1CYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYH1CYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 22:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYH1CYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 22:24:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27824 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYH1CYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 22:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=K5Cuw4p/c87JwxCUQu2I+wfdMG/V6DNufvtwMRpwFAlQumhDYNsEhqY2ssJV+W5Jf0
         P+rOm5DhT2sG8UQPhUUdhGH1TCPVSY29+5Yrz7aFaSfTCJU/0C1JmTUT2z3y2Rp7r93c
         mll1puTUYDIJ8LXzwrQX3rWjGYccUHolLq2BQ=
Date: Thu, 28 Aug 2008 06:25:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] anondev: init IDR statically
Message-ID: <20080828022549.GA18499@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/super.c         |    7 +------
 include/linux/fs.h |    1 -
 init/main.c        |    1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -682,7 +682,7 @@ void emergency_remount(void)
  * filesystems which don't use real block-devices.  -- jrs
  */
 
-static struct idr unnamed_dev_idr;
+static DEFINE_IDR(unnamed_dev_idr);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
 
 int set_anon_super(struct super_block *s, void *data)
@@ -726,11 +726,6 @@ void kill_anon_super(struct super_block *sb)
 
 EXPORT_SYMBOL(kill_anon_super);
 
-void __init unnamed_dev_init(void)
-{
-	idr_init(&unnamed_dev_idr);
-}
-
 void kill_litter_super(struct super_block *sb)
 {
 	if (sb->s_root)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1568,7 +1568,6 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	struct vfsmount *mnt);
 extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
-void unnamed_dev_init(void);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
--- a/init/main.c
+++ b/init/main.c
@@ -686,7 +686,6 @@ asmlinkage void __init start_kernel(void)
 	fork_init(num_physpages);
 	proc_caches_init();
 	buffer_init();
-	unnamed_dev_init();
 	key_init();
 	security_init();
 	vfs_caches_init(num_physpages);

