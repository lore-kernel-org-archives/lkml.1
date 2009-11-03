Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZKCQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZKCQS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZKCQS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:18:56 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:44132 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbZKCQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:18:56 -0500
To: jblunck@suse.de
Subject: Re: [PATCH 01/27] BKL: Push down BKL from do_new_mount() to the filesystems get_sb/fill_super operation
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       matthew@wil.cx
Message-Id: <E1N5M62-00007S-PZ@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 03 Nov 2009 16:19:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jan Blunck wrote:
> Attached is a new version of the patch that includes the changes for
> filesystems outside of fs/ directory as well. Besides that I trimmed the CC
> list this time.

Your patch fails to compile for configfs/btrfs/cramfs/befs and efs due
to a missing <linux/smp_lock.h> (at least with my .config).  The following
should fix this.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/befs/linuxvfs.c  |    1 +
 fs/btrfs/super.c    |    1 +
 fs/configfs/mount.c |    1 +
 fs/cramfs/inode.c   |    1 +
 fs/efs/super.c      |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index f2aa193..ca48bc7 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -15,6 +15,7 @@
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>
 
 #include "befs.h"
 #include "btree.h"
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e5cd2cf..87a0185 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -38,6 +38,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 5b2e06e..3d0e614 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -29,6 +29,7 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 13e696a..77aa05b 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
diff --git a/fs/efs/super.c b/fs/efs/super.c
index 0981141..6a7d0fe 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/smp_lock.h>
 
 #include "efs.h"
 #include <linux/efs_vh.h>
-- 
1.5.2.5

