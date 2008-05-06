Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbYEFVTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbYEFVTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbYEFVST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:18:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920AbYEFVSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:18:16 -0400
Date: Tue, 6 May 2008 17:18:07 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805062118.m46LI7uC004069@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/18] flag parametersi: NONBLOCK in anon_inode_getfd
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building on the previous change to anon_inode_getfd, this patch introduces
support for handling of O_NONBLOCK in addition to the already supported
O_CLOEXEC.  Following patches will take advantage of this support.  As
can be seen, the additional support for supporting this functionality is
minimal.

 anon_inodes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 1a4eee6..3662dd4 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -116,7 +116,7 @@ int anon_inode_getfd(const char *name, const struct file_operations *fops,
 	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
-	file->f_flags = O_RDWR;
+	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
 	file->f_version = 0;
 	file->private_data = priv;
 
