Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbXCEVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbXCEVBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbXCEU6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:44 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46872 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203AbXCEU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:11 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 05/11] hostfs: rename some vars for clarity
Date: Mon, 05 Mar 2007 21:49:03 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204903.9072.73019.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L4YZJ008331

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

* rename name to host_root_path
* rename data to req_root.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 fs/hostfs/hostfs_kern.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 0bcf7ac..b4e127b 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -961,7 +961,7 @@ static int contains_dotdot(const char* path)
 static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 {
 	struct inode *root_inode;
-	char *name, *data = d;
+	char *host_root_path, *req_root = d;
 	int err;
 
 	sb->s_blocksize = 1024;
@@ -970,20 +970,20 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	sb->s_op = &hostfs_sbops;
 
 	/* NULL is printed as <NULL> by sprintf: avoid that. */
-	if (data == NULL)
-		data = "";
+	if (req_root == NULL)
+		req_root = "";
 
 	err = -EINVAL;
-	if (unlikely(contains_dotdot(data)))
+	if (unlikely(contains_dotdot(req_root)))
 		goto out;
 
 	err = -ENOMEM;
-	name = kmalloc(strlen(root_ino) + 1
-			+ strlen(data) + 1, GFP_KERNEL);
-	if(name == NULL)
+	host_root_path = kmalloc(strlen(root_ino) + 1
+			+ strlen(req_root) + 1, GFP_KERNEL);
+	if(host_root_path == NULL)
 		goto out;
 
-	sprintf(name, "%s/%s", root_ino, data);
+	sprintf(host_root_path, "%s/%s", root_ino, req_root);
 
 	root_inode = iget(sb, 0);
 	if(root_inode == NULL)
@@ -993,10 +993,10 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
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
@@ -1016,7 +1016,7 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
  out_put:
         iput(root_inode);
  out_free:
-	kfree(name);
+	kfree(host_root_path);
  out:
 	return(err);
 }


