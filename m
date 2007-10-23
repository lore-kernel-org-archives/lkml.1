Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbXJWAgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbXJWAgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXJWAgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:36:00 -0400
Received: from 70-56-216-30.albq.qwest.net ([70.56.216.30]:60563 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750926AbXJWAf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:35:59 -0400
X-Greylist: delayed 1270 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 20:35:59 EDT
Date: Mon, 22 Oct 2007 18:14:47 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: v9fs_vfs_rename incorrect clunk order
Message-ID: <20071023001447.GA5628@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In v9fs_vfs_rename function labels don't match the fids that are clunked.
The correct clunk order is clunking newdirfid first and then olddirfid next.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 0c9269a1384273b7a409a2163fdf91cd39092889
tree 8a4984196ccb7ed027c086a53866e5582835e61f
parent 55b70a0300b873c0ec7ea6e33752af56f41250ce
author Latchesar Ionkov <lucho@ionkov.net> Mon, 22 Oct 2007 18:11:19 -0600
committer Latchesar Ionkov <lucho@ionkov.net> Mon, 22 Oct 2007 18:11:19 -0600

 fs/9p/vfs_inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 175b4d9..23581bc 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -687,10 +687,10 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = p9_client_wstat(oldfid, &wstat);
 
 clunk_newdir:
-	p9_client_clunk(olddirfid);
+	p9_client_clunk(newdirfid);
 
 clunk_olddir:
-	p9_client_clunk(newdirfid);
+	p9_client_clunk(olddirfid);
 
 done:
 	return retval;
