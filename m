Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXC1Pcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXC1Pcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbXC1PcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:32:18 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49251 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXC1PcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:32:16 -0400
Date: Wed, 28 Mar 2007 11:28:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Blaisorblade <blaisorblade@yahoo.it>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - hostfs variable renaming
Message-ID: <20070328152846.GA6330@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

* rename name to host_root_path
* rename data to req_root.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it> 
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---

 fs/hostfs/hostfs_kern.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6.21-mm/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.21-mm.orig/fs/hostfs/hostfs_kern.c	2007-03-27 12:29:28.000000000 -0400
+++ linux-2.6.21-mm/fs/hostfs/hostfs_kern.c	2007-03-27 12:34:10.000000000 -0400
@@ -938,7 +938,7 @@ static const struct address_space_operat
 static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 {
 	struct inode *root_inode;
-	char *name, *data = d;
+	char *host_root_path, *req_root = d;
 	int err;
 
 	sb->s_blocksize = 1024;
@@ -947,16 +947,16 @@ static int hostfs_fill_sb_common(struct 
 	sb->s_op = &hostfs_sbops;
 
 	/* NULL is printed as <NULL> by sprintf: avoid that. */
-	if (data == NULL)
-		data = "";
+	if (req_root == NULL)
+		req_root = "";
 
 	err = -ENOMEM;
-	name = kmalloc(strlen(root_ino) + 1
-			+ strlen(data) + 1, GFP_KERNEL);
-	if(name == NULL)
+	host_root_path = kmalloc(strlen(root_ino) + 1
+				 + strlen(req_root) + 1, GFP_KERNEL);
+	if(host_root_path == NULL)
 		goto out;
 
-	sprintf(name, "%s/%s", root_ino, data);
+	sprintf(host_root_path, "%s/%s", root_ino, req_root);
 
 	root_inode = iget(sb, 0);
 	if(root_inode == NULL)
@@ -966,10 +966,10 @@ static int hostfs_fill_sb_common(struct 
 	if(err)
 		goto out_put;
 
-	HOSTFS_I(root_inode)->host_filename = name;
-	/* Avoid that in the error path, iput(root_inode) frees again name through
-	 * hostfs_destroy_inode! */
-	name = NULL;
+	HOSTFS_I(root_inode)->host_filename = host_root_path;
+	/* Avoid that in the error path, iput(root_inode) frees again
+	 * host_root_path through hostfs_destroy_inode! */
+	host_root_path = NULL;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
@@ -989,7 +989,7 @@ static int hostfs_fill_sb_common(struct 
  out_put:
         iput(root_inode);
  out_free:
-	kfree(name);
+	kfree(host_root_path);
  out:
 	return(err);
 }
