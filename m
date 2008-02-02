Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbYBBSH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbYBBSH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYBBSHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:07:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:56791 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989AbYBBSHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:07:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L+JUWONM0WCFqZm/Y4/xHILkGaGxGPcomV6w4mKGzteuAZ/PAf7hqVeI7ZQjXgKlLhLUEARDPMxjES6t26AbVKDlBAyL93F7uSVGaFEFTcgBZf7sqZZXb/NsFmmfPQVZIE2FGX5OhiLckuBU6OZ1XzIjBZQqS0mPkRPLoqEWOBY=
From: Denis Cheng <crquan@gmail.com>
To: Tim Shimmin <tes@chook.melbourne.sgi.com>,
       Tim Shimmin <xfs-masters@oss.sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: add __init/__exit mark to specific init/cleanup functions
Date: Sun,  3 Feb 2008 02:07:23 +0800
Message-Id: <1201975643-8662-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_vnode.c |    2 +-
 fs/xfs/support/ktrace.c      |    4 ++--
 fs/xfs/support/uuid.c        |    2 +-
 fs/xfs/xfs_vfsops.c          |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 8cb63c6..abacbdd 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -361,7 +361,7 @@ xfs_fs_inode_init_once(
 	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
-STATIC int
+STATIC int __init
 xfs_init_zones(void)
 {
 	xfs_vnode_zone = kmem_zone_init_flags(sizeof(bhv_vnode_t), "xfs_vnode",
diff --git a/fs/xfs/linux-2.6/xfs_vnode.c b/fs/xfs/linux-2.6/xfs_vnode.c
index 814169f..56e23cd 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.c
+++ b/fs/xfs/linux-2.6/xfs_vnode.c
@@ -40,7 +40,7 @@
 #define vptosync(v)             (&vsync[((unsigned long)v) % NVSYNC])
 static wait_queue_head_t vsync[NVSYNC];
 
-void
+void __init
 vn_init(void)
 {
 	int i;
diff --git a/fs/xfs/support/ktrace.c b/fs/xfs/support/ktrace.c
index 5cf2e86..17f2b7c 100644
--- a/fs/xfs/support/ktrace.c
+++ b/fs/xfs/support/ktrace.c
@@ -21,7 +21,7 @@ static kmem_zone_t *ktrace_hdr_zone;
 static kmem_zone_t *ktrace_ent_zone;
 static int          ktrace_zentries;
 
-void
+void __init
 ktrace_init(int zentries)
 {
 	ktrace_zentries = zentries;
@@ -36,7 +36,7 @@ ktrace_init(int zentries)
 	ASSERT(ktrace_ent_zone);
 }
 
-void
+void __exit
 ktrace_uninit(void)
 {
 	kmem_zone_destroy(ktrace_hdr_zone);
diff --git a/fs/xfs/support/uuid.c b/fs/xfs/support/uuid.c
index e157015..493a6ec 100644
--- a/fs/xfs/support/uuid.c
+++ b/fs/xfs/support/uuid.c
@@ -133,7 +133,7 @@ uuid_table_remove(uuid_t *uuid)
 	mutex_unlock(&uuid_monitor);
 }
 
-void
+void __init
 uuid_init(void)
 {
 	mutex_init(&uuid_monitor);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index a154459..cde337e 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -58,7 +58,7 @@
 #include "xfs_vfsops.h"
 
 
-int
+int __init
 xfs_init(void)
 {
 	extern kmem_zone_t	*xfs_bmap_free_item_zone;
@@ -152,7 +152,7 @@ xfs_init(void)
 	return 0;
 }
 
-void
+void __exit
 xfs_cleanup(void)
 {
 	extern kmem_zone_t	*xfs_bmap_free_item_zone;
-- 
1.5.3.8

