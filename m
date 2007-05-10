Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXEJPPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXEJPPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXEJPPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:15:06 -0400
Received: from smtp.boksi.fi ([195.10.143.42]:1785 "EHLO smtp1.boksi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbXEJPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:15:04 -0400
Date: Thu, 10 May 2007 18:15:01 +0300
From: Mika Kukkonen <mikukkon@miku.homelinux.net>
To: mhalcrow@us.ibm.com, ecryptfs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Couple fixes to fs/ecryptfs/inode.c
Message-ID: <20070510151501.GA16480@srv1-m700-lanp.koti>
Reply-To: mikukkon@iki.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following was uncovered by compiling the kernel with '-W' flag:

  CC [M]  fs/ecryptfs/inode.o
fs/ecryptfs/inode.c: In function ‘ecryptfs_lookup’:
fs/ecryptfs/inode.c:304: warning: comparison of unsigned expression < 0 is always false
fs/ecryptfs/inode.c: In function ‘ecryptfs_symlink’:
fs/ecryptfs/inode.c:486: warning: comparison of unsigned expression < 0 is always false

Function ecryptfs_encode_filename() can return -ENOMEM, so change the
variables to plain int, as in the first case the only real use actually
expects int, and in latter case there is no use beoynd the error check.

Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 1548be2..d230a48 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -282,7 +282,7 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *lower_dentry;
 	struct vfsmount *lower_mnt;
 	char *encoded_name;
-	unsigned int encoded_namelen;
+	int encoded_namelen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	char *page_virt = NULL;
@@ -473,7 +473,7 @@ static int ecryptfs_symlink(struct inode *dir, struct dentry *dentry,
 	struct dentry *lower_dir_dentry;
 	umode_t mode;
 	char *encoded_symname;
-	unsigned int encoded_symlen;
+	int encoded_symlen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
