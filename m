Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbYLVWBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbYLVWBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbYLVVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:38678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbYLVVtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:50 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 35/56] quota: Unexport dqblk_v1.h and dqblk_v2.h
Date: Mon, 22 Dec 2008 13:48:16 -0800
Message-Id: <1229982517-3455-36-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Unexport header files dqblk_v[12].h since except for quota format ID they
don't contain information userspace should be interested in. Move ID
definitions to quota.h.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/Kbuild     |    2 --
 include/linux/dqblk_v1.h |    3 ---
 include/linux/dqblk_v2.h |    3 ---
 include/linux/quota.h    |    4 ++++
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 0fd2da3..4c32642 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -56,8 +56,6 @@ header-y += dlm_device.h
 header-y += dlm_netlink.h
 header-y += dm-ioctl.h
 header-y += dn.h
-header-y += dqblk_v1.h
-header-y += dqblk_v2.h
 header-y += dqblk_xfs.h
 header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
diff --git a/include/linux/dqblk_v1.h b/include/linux/dqblk_v1.h
index 9cea901..3713a72 100644
--- a/include/linux/dqblk_v1.h
+++ b/include/linux/dqblk_v1.h
@@ -5,9 +5,6 @@
 #ifndef _LINUX_DQBLK_V1_H
 #define _LINUX_DQBLK_V1_H
 
-/* Id of quota format */
-#define QFMT_VFS_OLD 1
-
 /* Root squash turned on */
 #define V1_DQF_RSQUASH 1
 
diff --git a/include/linux/dqblk_v2.h b/include/linux/dqblk_v2.h
index ff8af1b..18000a5 100644
--- a/include/linux/dqblk_v2.h
+++ b/include/linux/dqblk_v2.h
@@ -7,9 +7,6 @@
 
 #include <linux/dqblk_qtree.h>
 
-/* Id number of quota format */
-#define QFMT_VFS_V0 2
-
 /* Numbers of blocks needed for updates */
 #define V2_INIT_ALLOC QTREE_INIT_ALLOC
 #define V2_INIT_REWRITE QTREE_INIT_REWRITE
diff --git a/include/linux/quota.h b/include/linux/quota.h
index ec82beb..d72d5d8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -70,6 +70,10 @@
 #define Q_GETQUOTA 0x800007	/* get user quota structure */
 #define Q_SETQUOTA 0x800008	/* set user quota structure */
 
+/* Quota format type IDs */
+#define	QFMT_VFS_OLD 1
+#define	QFMT_VFS_V0 2
+
 /* Size of block in which space limits are passed through the quota
  * interface */
 #define QIF_DQBLKSIZE_BITS 10
-- 
1.5.6

