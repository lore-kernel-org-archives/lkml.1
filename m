Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbXIQH7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbXIQH7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 03:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXIQH7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 03:59:48 -0400
Received: from sacred.ru ([62.205.161.221]:36453 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXIQH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 03:59:47 -0400
Message-ID: <46EE3317.5020207@openvz.org>
Date: Mon, 17 Sep 2007 11:56:07 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5][AFS] Cleanup explicit check for mandatory locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 11:58:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __mandatory_lock(inode) macro makes the same check, but
makes the code more readable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: David Howells <dhowells@redhat.com>

---

 fs/afs/flock.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index af6952e..210acaf 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -524,8 +524,7 @@ int afs_lock(struct file *file, int cmd,
 	       (long long) fl->fl_start, (long long) fl->fl_end);
 
 	/* AFS doesn't support mandatory locks */
-	if ((vnode->vfs_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
-	    fl->fl_type != F_UNLCK)
+	if (__mandatory_lock(&vnode->vfs_inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if (IS_GETLK(cmd))

