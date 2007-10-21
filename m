Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbXJUXxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbXJUXxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXJUXvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:55 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49209 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXJUXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:50 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Christoph Lameter <clameter@sgi.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/9] Unionfs: slab api remove useless ctor parameter and reorder parameters
Date: Sun, 21 Oct 2007 19:51:15 -0400
Message-Id: <11930106834106-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

fs/unionfs/super.c: In function 'unionfs_init_inode_cache':
fs/unionfs/super.c:874: warning: passing argument 5 of 'kmem_cache_create' from incompatible pointer type

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 515689d..7d28045 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -863,9 +863,9 @@ static void unionfs_destroy_inode(struct inode *inode)
 }
 
 /* unionfs inode cache constructor */
-static void init_once(void *v, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *obj)
 {
-	struct unionfs_inode_info *i = v;
+	struct unionfs_inode_info *i = obj;
 
 	inode_init_once(&i->vfs_inode);
 }
-- 
1.5.2.2

