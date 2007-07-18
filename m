Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbXGRIcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbXGRIcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXGRIcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:32:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:53478 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXGRIcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=ST4McsKaw3+gfw2n2oQUPMrUc+lQiBR0l3bnAM1PkTuGiY1NTPxjjW5UM1v3Lo6doJbcIOVn5K3scwLYFAOyRjlWPOeZ74gj3SGc7P52pXINz2jy6/NCJvGE0INcmmGqgkf6gi00KF5F18XWsHY51vKiSaYXf9obRQjeapU7zMo=
Date: Wed, 18 Jul 2007 16:35:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: chexum@shadow.banki.hu
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: [Patch] fs/romfs/inode.c: trivial improvements
Message-ID: <20070718083517.GA6179@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


1. There's no lists in fs/romfs/inode.c, so using list_entry is
a bit confusing. Replace it with container_of.

2. It is unnecessary to cast the return value of kmem_cache_alloc,
since it returns a void* pointer.

This patch is against 2.6.22.1.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 fs/romfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22.1/fs/romfs/inode.c
===================================================================
--- linux-2.6.22.1.orig/fs/romfs/inode.c	2007-07-12 00:47:28.000000000 +0800
+++ linux-2.6.22.1/fs/romfs/inode.c	2007-07-18 16:08:56.000000000 +0800
@@ -92,7 +92,7 @@
 
 static inline struct romfs_inode_info *ROMFS_I(struct inode *inode)
 {
-	return list_entry(inode, struct romfs_inode_info, vfs_inode);
+	return container_of(inode, struct romfs_inode_info, vfs_inode);
 }
 
 static __u32
@@ -555,7 +555,7 @@
 static struct inode *romfs_alloc_inode(struct super_block *sb)
 {
 	struct romfs_inode_info *ei;
-	ei = (struct romfs_inode_info *)kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
