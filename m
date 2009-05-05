Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbZEEVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbZEEVqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZEEVqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:46:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZEEVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:46:14 -0400
Message-Id: <20090505214434.097370118@suse.de>
User-Agent: quilt/0.47-14.10
Date: Tue, 05 May 2009 23:32:05 +0200
From: jblunck@suse.de
To: Arnd Bergmann <arndb@de.ibm.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [patch 2/2] spufs: remove double check for non-negative dentry
References: <20090505213203.797397821@suse.de>
Content-Disposition: inline; filename=spufs-remove-unnecessary-EEXIST-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unnecessary double check if the dentry returned by
lookup_create() is actually non-negative. Since lookup_create() itself returns
an error in this case just remove the check.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -625,10 +625,6 @@ long spufs_create(struct nameidata *nd,
 	if (IS_ERR(dentry))
 		goto out_dir;
 
-	ret = -EEXIST;
-	if (dentry->d_inode)
-		goto out_dput;
-
 	mode &= ~current->fs->umask;
 
 	if (flags & SPU_CREATE_GANG)


