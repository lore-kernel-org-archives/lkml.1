Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXDILdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXDILdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXDILdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:33:20 -0400
Received: from smtp.nokia.com ([131.228.20.171]:48746 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXDILdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:33:19 -0400
Message-ID: <461A22F3.5050108@yandex.ru>
Date: Mon, 09 Apr 2007 14:26:43 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] trivial: s/i_sem /i_mutex/
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Apr 2007 11:26:43.0580 (UTC) FILETIME=[F36ADBC0:01C77A99]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070409142650-79E90BB0-629DC365/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Adrian,

please, include this patch to your tree.

>From 6f20d2abd85874658ef424ac46b79c43244d2274 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Mon, 9 Apr 2007 14:23:48 +0300
Subject: [PATCH] trivial: s/i_sem /i_mutex/

This patch substitutes i_sem by i_mutex in Documentation/filesystems/Locking.
The patch also removes a couple of trailing white-spaces.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 Documentation/filesystems/Locking |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 28bfea7..6bb5706 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -21,12 +21,12 @@ locking rules:
 		dcache_lock	rename_lock	->d_lock	may block
 d_revalidate:	no		no		no		yes
 d_hash		no		no		no		yes
-d_compare:	no		yes		no		no 
+d_compare:	no		yes		no		no
 d_delete:	yes		no		yes		no
 d_release:	no		no		no		yes
 d_iput:		no		no		no		yes
 
---------------------------- inode_operations --------------------------- 
+--------------------------- inode_operations ---------------------------
 prototypes:
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameid
@@ -52,7 +52,7 @@ ata *);
 
 locking rules:
 	all may block, none have BKL
-		i_sem(inode)
+		i_mutex(inode)
 lookup:		yes
 create:		yes
 link:		yes (both)
@@ -72,7 +72,7 @@ setxattr:	yes
 getxattr:	no
 listxattr:	no
 removexattr:	yes
-	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_sem on
+	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
 	->truncate() is never called directly - it's a callback, not a
@@ -459,7 +459,7 @@ doesn't take the BKL.
 ->read on directories probably must go away - we should just enforce -EISDIR
 in sys_read() and friends.
 
-->fsync() has i_sem on inode.
+->fsync() has i_mutex on inode.
 
 --------------------------- dquot_operations -------------------------------
 prototypes:
-- 
1.5.0.6


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
