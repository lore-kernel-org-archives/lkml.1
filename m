Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbXILL3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbXILL3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762801AbXILL3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:29:39 -0400
Received: from sacred.ru ([62.205.161.221]:41093 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXILL3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:29:38 -0400
Message-ID: <46E7CD0B.6050008@openvz.org>
Date: Wed, 12 Sep 2007 15:27:07 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH 4/5][AFS] Use macro instead of explicit check for mandatory
 locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 12 Sep 2007 15:29:20 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __MANDATORY_LOCK(inode) macro makes the same check, but
makes the code more readable.

Unfortunately, I haven't found the maintainer for this FS in 
the MAINTAINERS file.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 fs/afs/flock.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index af6952e..9ddac05 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -524,8 +524,7 @@ int afs_lock(struct file *file, int cmd,
 	       (long long) fl->fl_start, (long long) fl->fl_end);
 
 	/* AFS doesn't support mandatory locks */
-	if ((vnode->vfs_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
-	    fl->fl_type != F_UNLCK)
+	if (__MANDATORY_LOCK(vnode->vfs_inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if (IS_GETLK(cmd))

