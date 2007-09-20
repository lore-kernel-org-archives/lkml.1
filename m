Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbXITTxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbXITTxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXITTw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:52:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59905 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXITTwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:52:55 -0400
Subject: [PATCH 03/25] give may_open() a local 'mnt' variable
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:52:52 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195252.BE019DC4@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


First of all, this makes the structure jumping look a little
bit cleaner.  So, this stands alone as a tiny cleanup.  But,
we also need 'mnt' by itself a few more times later in this
series, so this isn't _just_ a cleanup.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~give-may_open-a-local-mnt-variable fs/namei.c
--- lxc/fs/namei.c~give-may_open-a-local-mnt-variable	2007-09-20 12:16:09.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:09.000000000 -0700
@@ -230,6 +230,10 @@ int permission(struct inode *inode, int 
 {
 	umode_t mode = inode->i_mode;
 	int retval, submask;
+	struct vfsmount *mnt = NULL;
+
+	if (nd)
+		mnt = nd->mnt;
 
 	if (mask & MAY_WRITE) {
 
@@ -254,7 +258,7 @@ int permission(struct inode *inode, int 
 	 * the fs is mounted with the "noexec" flag.
 	 */
 	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
-			(nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))))
+			(mnt && (mnt->mnt_flags & MNT_NOEXEC))))
 		return -EACCES;
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
_
