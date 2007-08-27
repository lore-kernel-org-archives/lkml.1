Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbXH0R2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbXH0R2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbXH0R1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:27:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760595AbXH0R1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:27:37 -0400
Date: Mon, 27 Aug 2007 13:27:33 -0400
Message-Id: <200708271727.l7RHRXdK007265@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 3/4] CIFS: add cifs_killattr inode_operation
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

..make it just clear the ATTR_KILL_S*ID bits since we want the
server to handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cabb6a5..c357c55 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -553,6 +553,13 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 	return remote_llseek(file, offset, origin);
 }
 
+/* The server should handle this, so we just clear the bits */
+static void cifs_killattr(struct dentry *dentry, struct iattr *attr)
+{
+	attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
+	return;
+}
+
 static struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
@@ -574,6 +581,7 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.setattr = cifs_setattr,
 	.symlink = cifs_symlink,
 	.mknod   = cifs_mknod,
+	.killattr = cifs_killattr,
 #ifdef CONFIG_CIFS_XATTR
 	.setxattr = cifs_setxattr,
 	.getxattr = cifs_getxattr,
@@ -588,6 +596,7 @@ const struct inode_operations cifs_file_inode_ops = {
 	.getattr = cifs_getattr, /* do we need this anymore? */
 	.rename = cifs_rename,
 	.permission = cifs_permission,
+	.killattr = cifs_killattr,
 #ifdef CONFIG_CIFS_XATTR
 	.setxattr = cifs_setxattr,
 	.getxattr = cifs_getxattr,
-- 
1.5.2.1

