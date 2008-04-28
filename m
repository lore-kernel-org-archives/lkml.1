Return-Path: <linux-kernel-owner+w=401wt.eu-S933688AbYD1Kcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbYD1Kcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933547AbYD1Kc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:32:28 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61328 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762549AbYD1Kc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:32:26 -0400
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
Message-Id: <20080428193156t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 28 Apr 2008 19:31:56 +0900
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

diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25-freeze/fs/xfs/linux-2.6/xfs_ioctl.c linux-2.6.25-xfs/fs/
xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.25-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-04-24 20:42:20.000000000 +0900
+++ linux-2.6.25-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-04-24 20:44:48.000000000 +0900
@@ -906,21 +906,6 @@ xfs_ioctl(
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
 
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c linux-2.6.25-xfs/f
s/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.25-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-04-24 20:42:20.000000000 +0900
+++ linux-2.6.25-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-04-24 20:44:48.000000000 +0900
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25-freeze/fs/xfs/xfs_fs.h linux-2.6.25-xfs/fs/xfs/xfs_fs.h
--- linux-2.6.25-freeze/fs/xfs/xfs_fs.h	2008-04-24 20:42:20.000000000 +0900
+++ linux-2.6.25-xfs/fs/xfs/xfs_fs.h	2008-04-24 20:44:48.000000000 +0900
@@ -473,8 +473,8 @@ typedef struct xfs_handle {
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
