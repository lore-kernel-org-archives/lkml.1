Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYIZJBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYIZJBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYIZI7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:59:52 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61213 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbYIZI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:59:49 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/10] Remove XFS specific ioctl interfaces for freeze feature
Message-Id: <20080926175924t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:59:24 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It removes XFS specific ioctl interfaces and request codes
for freeze feature.
This patch has been supplied by David Chinner.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 linux-2.6/xfs_ioctl.c   |   15 ---------------
 linux-2.6/xfs_ioctl32.c |    2 --
 xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl.c linux-
2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-22 14:19:19.000000000 +0900
@@ -1529,21 +1529,6 @@ xfs_ioctl(
 		return -error;
 	}
 
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
 	case XFS_IOC_GOINGDOWN: {
 		__uint32_t in;
 
diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c linu
x-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-09-22 14:19:19.000000000 +0900
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/xfs_fs.h linux-2.6.27-rc7-xf
s/fs/xfs/xfs_fs.h
--- linux-2.6.27-rc7-freeze/fs/xfs/xfs_fs.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/xfs_fs.h	2008-09-22 14:19:19.000000000 +0900
@@ -477,8 +477,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
-#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
-#define XFS_IOC_THAW		     _IOWR('X', 120, int)
+/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
+/*	XFS_IOC_THAW		  -- FITHAW     120	 */
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
