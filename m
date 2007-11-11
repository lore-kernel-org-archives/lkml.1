Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbXKKSjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbXKKSjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbXKKSix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:38:53 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47401 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbXKKSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:38:52 -0500
Date: Sun, 11 Nov 2007 13:38:04 -0500
Message-Id: <200711111838.lABIc4Im012713@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH] Unionfs: stop using iget() and read_inode() 
In-reply-to: Your message of "Wed, 07 Nov 2007 01:48:44 EST."
             <200711070648.lA76miPW005794@agora.fsl.cs.sunysb.edu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, the following small patch is critical to have after:

iget-stop-unionfs-from-using-iget-and-read_inode.patch

Question: since the above patch isn't in my unionfs.git tree (not until the
whole iget series makes it to Linus), then do you prefer if I give you a
replacement patch to the above patch, or a small incremental one; either
way, you can choose to fold the above and below patches into one.

Thanks,
Erez.


Unionfs: bugfix to initialize unionfs_inode_info node

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 7408b0f..d6544f8 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -38,6 +38,7 @@ struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 
  	unionfs_read_lock(sb);
 
+	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
