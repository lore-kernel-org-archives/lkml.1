Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXIQIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXIQIAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXIQIAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:00:35 -0400
Received: from sacred.ru ([62.205.161.221]:36573 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbXIQIAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:00:35 -0400
Message-ID: <46EE335C.3010106@openvz.org>
Date: Mon, 17 Sep 2007 11:57:16 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH 5/5][NFS] Cleanup explicit check for mandatory locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 11:59:39 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __mandatory_lock(inode) macro makes the same check, but
makes the code more readable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>

---

 fs/nfs/file.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 73ddd2e..7a07be1 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -605,8 +605,7 @@ static int nfs_lock(struct file *filp, i
 	nfs_inc_stats(inode, NFSIOS_VFSLOCK);
 
 	/* No mandatory locks over NFS */
-	if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
-	    fl->fl_type != F_UNLCK)
+	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if (IS_GETLK(cmd))

