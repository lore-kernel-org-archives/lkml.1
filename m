Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZFQETt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZFQETt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZFQETj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZFQETj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:19:39 -0400
Message-Id: <200906170419.n5H4Jdkn017670@voreg.hos.anvin.org>
To: Al Viro <viro@zeniv.linux.org.uk>
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 16 Jun 2009 21:15:04 -0700
Subject: [PATCH] devpts: remove module-related code
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days, the devpts filesystem is closely integrated with the pty
memory management, and cannot be built as a module, even less removed
from the kernel.  Accordingly, remove all module-related stuff from
this filesystem.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 fs/devpts/inode.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 9b1d285..ec75329 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -10,7 +10,6 @@
  *
  * ------------------------------------------------------------------------- */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
@@ -423,7 +422,6 @@ static void devpts_kill_sb(struct super_block *sb)
 }
 
 static struct file_system_type devpts_fs_type = {
-	.owner		= THIS_MODULE,
 	.name		= "devpts",
 	.get_sb		= devpts_get_sb,
 	.kill_sb	= devpts_kill_sb,
@@ -564,13 +562,3 @@ static int __init init_devpts_fs(void)
 	}
 	return err;
 }
-
-static void __exit exit_devpts_fs(void)
-{
-	unregister_filesystem(&devpts_fs_type);
-	mntput(devpts_mnt);
-}
-
-module_init(init_devpts_fs)
-module_exit(exit_devpts_fs)
-MODULE_LICENSE("GPL");
-- 
1.6.0.6

