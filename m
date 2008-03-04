Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbYCDTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbYCDTNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765587AbYCDTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:13:20 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56112 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbYCDTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:13:20 -0500
Date: Tue, 4 Mar 2008 19:12:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25-rc3-mm1] fix ext2 borkage
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803041910080.12261@blonde.site>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use-page_cache_xxx-in-ext2.patch gave me lots of EXT2-fs error (device
loop0): ext2_find_entry: dir 52629 size 5120 exceeds block count 2
so I stopped it quickly.  Creating a directory entry was muddling up the
directory and the linked inode, writing directory page out to the latter.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/ext2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.25-rc3-mm1/fs/ext2/dir.c	2008-03-04 11:37:47.000000000 +0000
+++ linux/fs/ext2/dir.c	2008-03-04 18:25:24.000000000 +0000
@@ -472,7 +472,7 @@ void ext2_set_link(struct inode *dir, st
 int ext2_add_link (struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
-	struct address_space *mapping = inode->i_mapping;
+	struct address_space *mapping = dir->i_mapping;
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
 	unsigned chunk_size = ext2_chunk_size(dir);
