Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYHANeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYHANeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYHANeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:34:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:43486 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYHANeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=I3Jgo2yBkWjyoiZTJ37vfml/pamlB5EoAq9xNJ3a+KxVr+q5MQ8CPukW8yWjzxtNGT
         nxJfb6X2VKI7IHbfe+qgPYylDsYH7Tv01EmuRM9dMGv9QHPMGuUgJKzUbfhL/r+hJRcr
         nFkFEYUA1KXErWYl56C4owH6Ufx5HwW5eRh9A=
Message-ID: <48f7fe350808010633v3bfbb602x9995b74db323703f@mail.gmail.com>
Date: Fri, 1 Aug 2008 09:33:59 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch][reiser4] compile warning cleanups
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch cleans up some reiser4 compile warnings:

From: Ryan Hope <rmh3093@gmail.com>
Date: Fri, 1 Aug 2008 13:25:28 +0000 (-0400)
Subject: cleanup reiser4 warnings
X-Git-Url: http://zen-sources.org/cgi-bin/gitweb.cgi?p=kernel.git;a=commitdiff_plain;h=675342fe83269780f2699f47972d0059e13db0cc

cleanup reiser4 warnings
---

diff --git a/fs/reiser4/plugin/file/cryptcompress.c
b/fs/reiser4/plugin/file/cryptcompress.c
index 2e64374..7d3061d 100644
--- a/fs/reiser4/plugin/file/cryptcompress.c
+++ b/fs/reiser4/plugin/file/cryptcompress.c
@@ -821,7 +821,7 @@ static int need_cut_or_align(struct inode * inode,
 static void align_or_cut_overhead(struct inode * inode,
 				  struct cluster_handle * ch, rw_op rw)
 {
-	int oh;
+	unsigned int oh;
 	cipher_plugin * cplug = inode_cipher_plugin(inode);

 	assert("edward-1402", need_cipher(inode));
diff --git a/fs/reiser4/plugin/inode_ops.c b/fs/reiser4/plugin/inode_ops.c
index 6ac4d13..945a740 100644
--- a/fs/reiser4/plugin/inode_ops.c
+++ b/fs/reiser4/plugin/inode_ops.c
@@ -418,8 +418,7 @@ void *reiser4_follow_link_common(struct dentry
*dentry, struct nameidata *nd)
  *
  * Uses generic function to check for rwx permissions.
  */
-int reiser4_permission_common(struct inode *inode, int mask,
-			      struct nameidata *nameidata)
+int reiser4_permission_common(struct inode *inode, int mask)
 {
 	return generic_permission(inode, mask, NULL);
 }
diff --git a/fs/reiser4/plugin/object.h b/fs/reiser4/plugin/object.h
index 63abb07..88a53a5 100644
--- a/fs/reiser4/plugin/object.h
+++ b/fs/reiser4/plugin/object.h
@@ -25,8 +25,7 @@ int reiser4_mknod_common(struct inode *parent,
struct dentry *dentry,
 int reiser4_rename_common(struct inode *old_dir, struct dentry *old_name,
 			  struct inode *new_dir, struct dentry *new_name);
 void *reiser4_follow_link_common(struct dentry *, struct nameidata *data);
-int reiser4_permission_common(struct inode *, int mask,
-			      struct nameidata *nameidata);
+int reiser4_permission_common(struct inode *, int mask);
 int reiser4_setattr_common(struct dentry *, struct iattr *);
 int reiser4_getattr_common(struct vfsmount *mnt, struct dentry *,
 			   struct kstat *);
