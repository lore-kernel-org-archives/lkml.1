Return-Path: <linux-kernel-owner+w=401wt.eu-S1765346AbXILL01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765346AbXILL01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbXILL0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:26:19 -0400
Received: from sacred.ru ([62.205.161.221]:40970 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761738AbXILL0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:26:19 -0400
Message-ID: <46E7CC34.2060602@openvz.org>
Date: Wed, 12 Sep 2007 15:23:32 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
       Latchesar Ionkov <lucho@ionkov.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 3/5][9PFS] Use macro instead of explicit check for mandatory
 locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 12 Sep 2007 15:25:47 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __MANDATORY_LOCK(inode) macro makes the same check, but
makes the code more readable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>

---

 fs/9p/vfs_file.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 2a40c29..7e75309 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -105,7 +105,7 @@ static int v9fs_file_lock(struct file *f
 	P9_DPRINTK(P9_DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
 
 	/* No mandatory locks */
-	if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+	if (__MANDATORY_LOCK(inode))
 		return -ENOLCK;
 
 	if ((IS_SETLK(cmd) || IS_SETLKW(cmd)) && fl->fl_type != F_UNLCK) {

