Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbXITUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbXITUDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbXITUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:03:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34182 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbXITUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:03:07 -0400
Subject: [resend PATCH 03/25] give may_open() a local 'mnt' variable
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 13:03:04 -0700
Message-Id: <1190318584.26982.173.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
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
-- Dave

