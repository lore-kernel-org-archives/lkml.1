Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbYBOUCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbYBOUCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbYBOUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:02:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:61522 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459AbYBOUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aTk7rZFTdc0cF0hZ9D276xY4UQPTBCl8w5WYQ4EFDy1+sFyc77D/8BPCbP3MDHFETQn+XmI5mVP6rlFznoYWOEaZna3sm8AK2esGFGnsSvBBS3GmuBm0CD4T/PCnobxpF6tTGN3fFR+CzINsKqa64Ui/yO1iG9Mzuipki0wOpgo=
Subject: [PATCH 1/3] ncpfs: add prototypes to ncp_fs.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 12:02:25 -0800
Message-Id: <1203105745.15275.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some externs from C files, noticed from the sparse warnings:
fs/ncpfs/dir.c:90:26: warning: symbol 'ncp_root_dentry_operations' was not declared. Should it be static?
fs/ncpfs/symlink.c:107:5: warning: symbol 'ncp_symlink' was not declared. Should it be static?
fs/ncpfs/symlink.c:101:39: warning: symbol 'ncp_symlink_aops' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ncpfs/inode.c       |    6 ------
 include/linux/ncp_fs.h |    7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index fbbb9f7..2e5ab12 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -107,12 +107,6 @@ static const struct super_operations ncp_sops =
 	.show_options	= ncp_show_options,
 };
 
-extern struct dentry_operations ncp_root_dentry_operations;
-#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
-extern const struct address_space_operations ncp_symlink_aops;
-extern int ncp_symlink(struct inode*, struct dentry*, const char*);
-#endif
-
 /*
  * Fill in the ncpfs-specific information in the inode.
  */
diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 88766e4..9f2d763 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -204,6 +204,7 @@ void ncp_update_inode2(struct inode *, struct ncp_entry_info *);
 /* linux/fs/ncpfs/dir.c */
 extern const struct inode_operations ncp_dir_inode_operations;
 extern const struct file_operations ncp_dir_operations;
+extern struct dentry_operations ncp_root_dentry_operations;
 int ncp_conn_logged_in(struct super_block *);
 int ncp_date_dos2unix(__le16 time, __le16 date);
 void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
@@ -223,6 +224,12 @@ int ncp_disconnect(struct ncp_server *server);
 void ncp_lock_server(struct ncp_server *server);
 void ncp_unlock_server(struct ncp_server *server);
 
+/* linux/fs/ncpfs/symlink.c */
+#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
+extern const struct address_space_operations ncp_symlink_aops;
+int ncp_symlink(struct inode*, struct dentry*, const char*);
+#endif
+
 /* linux/fs/ncpfs/file.c */
 extern const struct inode_operations ncp_file_inode_operations;
 extern const struct file_operations ncp_file_operations;
-- 
1.5.4.1.1278.gc75be


