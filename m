Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbXIQH5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbXIQH5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 03:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXIQH5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 03:57:04 -0400
Received: from sacred.ru ([62.205.161.221]:50642 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXIQH5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 03:57:02 -0400
Message-ID: <46EE328E.5050205@openvz.org>
Date: Mon, 17 Sep 2007 11:53:50 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
Subject: [PATCH 3/5][9PFS] Cleanup explicit check for mandatory locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 11:56:13 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __mandatory_lock(inode) macro makes the same check, but
makes the code more readable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>

---

 fs/9p/vfs_file.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 2a40c29..7166916 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -105,7 +105,7 @@ static int v9fs_file_lock(struct file *f
 	P9_DPRINTK(P9_DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
 
 	/* No mandatory locks */
-	if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+	if (__mandatory_lock(inode))
 		return -ENOLCK;
 
 	if ((IS_SETLK(cmd) || IS_SETLKW(cmd)) && fl->fl_type != F_UNLCK) {

