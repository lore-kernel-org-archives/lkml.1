Return-Path: <linux-kernel-owner+w=401wt.eu-S1765245AbXILLXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765245AbXILLXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764723AbXILLXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:23:24 -0400
Received: from sacred.ru ([62.205.161.221]:44422 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764990AbXILLXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:23:23 -0400
Message-ID: <46E7CB8B.4080205@openvz.org>
Date: Wed, 12 Sep 2007 15:20:43 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Steven Whitehouse <swhiteho@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 2/5][GFS2] Use macro instead of explicit check for mandatory
 locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 12 Sep 2007 15:23:00 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __MANDATORY_LOCK(inode) macro makes the same check, but
makes the code more readable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>

---

 fs/gfs2/ops_file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 94d76ac..7e814f4 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -535,7 +535,7 @@ static int gfs2_lock(struct file *file, 
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
-	if ((ip->i_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+	if (__MANDATORY_LOCK(ip->i_inode))
 		return -ENOLCK;
 
 	if (sdp->sd_args.ar_localflocks) {
@@ -637,7 +637,7 @@ static int gfs2_flock(struct file *file,
 
 	if (!(fl->fl_flags & FL_FLOCK))
 		return -ENOLCK;
-	if ((ip->i_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+	if (__MANDATORY_LOCK(ip->i_inode))
 		return -ENOLCK;
 
 	if (sdp->sd_args.ar_localflocks)

