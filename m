Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZAKRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZAKRwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZAKRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:52:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:1584 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAKRwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=Y9bg3mGRlVZa+h2aKVQjfynRGXzafIDCbDPHV7AcHV+PZ8vEWOhu8rAeNS/wvgKHMG
         xF1Sp2qKmuRDsnTuApnPywXRPBvJTl2EdA10J7G7xT27sRyZEvseASGPm/fTy1Yj4Imk
         BttM21l39XScb1+YWivFpDujw2TmvhwO9nxVk=
Message-ID: <496a31c9.04506e0a.03e0.0963@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs & squashfs: Move btrfs and squashfsto's magic number
 to <linux/magic.h>
Date: Mon, 12 Jan 2009 01:52:04 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard magic.h for btrfs and squashfs.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a14b49..7256cf2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -38,6 +38,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/version.h>
+#include <linux/magic.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -51,7 +52,6 @@
 #include "export.h"
 #include "compression.h"
 
-#define BTRFS_SUPER_MAGIC 0x9123683E
 
 static struct super_operations btrfs_super_ops;
 
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 6840da1..283daaf 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -26,7 +26,6 @@
 #define SQUASHFS_CACHED_FRAGMENTS	CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE
 #define SQUASHFS_MAJOR			4
 #define SQUASHFS_MINOR			0
-#define SQUASHFS_MAGIC			0x73717368
 #define SQUASHFS_START			0
 
 /* size of metadata (inode and directory) blocks */
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index a0466d7..071df5b 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/zlib.h>
+#include <linux/magic.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 439f6f3..0b4df7e 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -10,11 +10,13 @@
 #define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define TMPFS_MAGIC		0x01021994
+#define SQUASHFS_MAGIC		0x73717368
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
 #define EXT3_SUPER_MAGIC	0xEF53
 #define XENFS_SUPER_MAGIC	0xabba1974
 #define EXT4_SUPER_MAGIC	0xEF53
+#define BTRFS_SUPER_MAGIC	0x9123683E
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6

