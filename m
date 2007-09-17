Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXIQHzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXIQHzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 03:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXIQHzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 03:55:15 -0400
Received: from sacred.ru ([62.205.161.221]:50584 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbXIQHzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 03:55:13 -0400
Message-ID: <46EE3228.30002@openvz.org>
Date: Mon, 17 Sep 2007 11:52:08 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/5][GFS2] Cleanup explicit check for mandatory locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 11:54:28 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __mandatory_lock(inode) function makes the same check, but
makes the code more readable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>

---

 fs/gfs2/ops_file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 94d76ac..28773ca 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -535,7 +535,7 @@ static int gfs2_lock(struct file *file, 
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
-	if ((ip->i_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+	if (__mandatory_lock(&ip->i_inode))
 		return -ENOLCK;
 
 	if (sdp->sd_args.ar_localflocks) {
@@ -637,7 +637,7 @@ static int gfs2_flock(struct file *file,
 
 	if (!(fl->fl_flags & FL_FLOCK))
 		return -ENOLCK;
-	if ((ip->i_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+	if (__mandatory_lock(&ip->i_inode))
 		return -ENOLCK;
 
 	if (sdp->sd_args.ar_localflocks)

