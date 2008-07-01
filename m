Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYGAJ3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYGAJ3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbYGAJ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:28:51 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:58646
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbYGAJ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:28:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADSWaUjLO9AP/2dsb2JhbACyBw
X-IronPort-AV: E=Sophos;i="4.27,730,1204470000"; 
   d="scan'208";a="242140515"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/5] autofs4 - fix symlink name allocation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2008 17:25:50 +0800
Message-ID: <20080701092548.12041.69868.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The length of the symlink name has been moved but it needs to be
set before allocating space for it in the dentry info struct.
This corrects a mistake in a recent patch.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 7f3ebf1..10add99 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -774,6 +774,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 		list_del_init(&ino->active);
 	spin_unlock(&sbi->lookup_lock);
 
+	ino->size = strlen(symname);
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
 	if (!cp) {
 		if (!dentry->d_fsdata)
@@ -805,7 +806,6 @@ static int autofs4_dir_symlink(struct inode *dir,
 		atomic_inc(&p_ino->count);
 	ino->inode = inode;
 
-	ino->size = strlen(symname);
 	ino->u.symlink = cp;
 	dir->i_mtime = CURRENT_TIME;
 
