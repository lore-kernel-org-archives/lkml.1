Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbXJJQgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbXJJQgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXJJQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:35:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49719 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759AbXJJQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:35:33 -0400
Subject: [RFC][PATCH 1/7] init_file(): only take writes on normal files
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 10 Oct 2007 09:34:39 -0700
Message-Id: <20071010163439.0F8089F7@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



---

 lxc-dave/fs/file_table.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/file_table.c~init_file-only-take-writes-on-normal-files fs/file_table.c
--- lxc/fs/file_table.c~init_file-only-take-writes-on-normal-files	2007-10-04 13:01:59.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-10-04 13:03:03.000000000 -0700
@@ -199,7 +199,12 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
-	if (mode & FMODE_WRITE) {
+	/*
+	 * These mounts don't really matter in practice
+	 * for r/o bind mounts.  They aren't userspace-
+	 * visible.  We do this for consistency.
+	 */
+	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
 		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
_
