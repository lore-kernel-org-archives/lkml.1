Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbXHCRwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbXHCRwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764612AbXHCRuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:17 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50680 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763738AbXHCRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:15 -0400
Message-Id: <20070803174932.998776699@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:32 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 06/11] fuse: set i_nlink to sane value after mount
Content-Disposition: inline; filename=fuse_i_nlink_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Aufs seems to depend on a positive i_nlink value.  So fill in a dummy
but sane value for the root inode at mount time.

The inode attributes are refreshed with the correct values at the
first opportunity.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-08-03 18:36:13.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-08-03 18:36:14.000000000 +0200
@@ -480,6 +480,7 @@ static struct inode *get_root_inode(stru
 
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
+	attr.nlink = 1;
 	return fuse_iget(sb, 1, 0, &attr);
 }
 

--
