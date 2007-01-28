Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXA1VBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXA1VBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbXA1VBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:01:21 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:33271 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbXA1VBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:01:20 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 28 Jan 2007 16:00:37 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: xfs-masters@oss.sgi.com, Andrew Morton <akpm@osdl.org>, dgc@sgi.com
Subject: [PATCH} XFS: Remove placeholders for unimplemented functionality.
Message-ID: <Pine.LNX.4.64.0701281557410.11046@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_BH 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove a couple kernel config variables (FS_POSIX_CAP and
FS_POSIX_MAC) that represent placeholders for unimplemented
functionality.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  compile-tested on i386.


 fs/xfs/xfs_cap.h |   15 ---------------
 fs/xfs/xfs_mac.h |   17 -----------------
 2 files changed, 32 deletions(-)

diff --git a/fs/xfs/xfs_cap.h b/fs/xfs/xfs_cap.h
index 7a0e482..cfedfd1 100644
--- a/fs/xfs/xfs_cap.h
+++ b/fs/xfs/xfs_cap.h
@@ -45,25 +45,10 @@ typedef struct xfs_cap_set {

 #ifdef __KERNEL__

-#ifdef CONFIG_FS_POSIX_CAP
-
-#include <linux/posix_cap_xattr.h>
-
-struct bhv_vnode;
-
-extern int xfs_cap_vhascap(struct bhv_vnode *);
-extern int xfs_cap_vset(struct bhv_vnode *, void *, size_t);
-extern int xfs_cap_vget(struct bhv_vnode *, void *, size_t);
-extern int xfs_cap_vremove(struct bhv_vnode *);
-
-#define _CAP_EXISTS		xfs_cap_vhascap
-
-#else
 #define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
 #define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
 #define xfs_cap_vremove(v)	(-EOPNOTSUPP)
 #define _CAP_EXISTS		(NULL)
-#endif

 #endif	/* __KERNEL__ */

diff --git a/fs/xfs/xfs_mac.h b/fs/xfs/xfs_mac.h
index 18e0e98..a3f7eaf 100644
--- a/fs/xfs/xfs_mac.h
+++ b/fs/xfs/xfs_mac.h
@@ -80,26 +80,9 @@ typedef struct xfs_mac_label {

 #ifdef __KERNEL__

-#ifdef CONFIG_FS_POSIX_MAC
-
-/* NOT YET IMPLEMENTED */
-
-#define MACEXEC		00100
-#define MACWRITE	00200
-#define MACREAD		00400
-
-struct xfs_inode;
-extern int  xfs_mac_iaccess(struct xfs_inode *, mode_t, cred_t *);
-
-#define _MAC_XFS_IACCESS(i,m,c) (xfs_mac_iaccess(i,m,c))
-#define _MAC_VACCESS(v,c,m)	(xfs_mac_vaccess(v,c,m))
-#define _MAC_EXISTS		xfs_mac_vhaslabel
-
-#else
 #define _MAC_XFS_IACCESS(i,m,c)	(0)
 #define _MAC_VACCESS(v,c,m)	(0)
 #define _MAC_EXISTS		(NULL)
-#endif

 #endif	/* __KERNEL__ */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
