Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZFHTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZFHTcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZFHTXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:52 -0400
Received: from thunk.org ([69.25.196.29]:39603 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZFHTXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 19/49] ext4: Move fs/ext4/namei.h into ext4.h
Date: Mon,  8 Jun 2009 15:22:37 -0400
Message-Id: <1244488987-32564-20-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-19-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fs/ext4/namei.h header file had only a single function
declaration, and should have never been a standalone file.  Move it
into ext4.h, where should have been from the beginning.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/namei.c |    1 -
 fs/ext4/namei.h |    8 --------
 fs/ext4/super.c |    1 -
 4 files changed, 1 insertions(+), 10 deletions(-)
 delete mode 100644 fs/ext4/namei.h

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af3c906..d9c5251 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1594,6 +1594,7 @@ extern const struct file_operations ext4_file_operations;
 /* namei.c */
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
+extern struct dentry *ext4_get_parent(struct dentry *child);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8018e49..c9690b2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -37,7 +37,6 @@
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
-#include "namei.h"
 #include "xattr.h"
 #include "acl.h"
 
diff --git a/fs/ext4/namei.h b/fs/ext4/namei.h
deleted file mode 100644
index 5e4dfff..0000000
--- a/fs/ext4/namei.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/*  linux/fs/ext4/namei.h
- *
- * Copyright (C) 2005 Simtec Electronics
- *	Ben Dooks <ben@simtec.co.uk>
- *
-*/
-
-extern struct dentry *ext4_get_parent(struct dentry *child);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1fbf090..d79e1c4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -46,7 +46,6 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "namei.h"
 #include "group.h"
 
 struct proc_dir_entry *ext4_proc_root;
-- 
1.6.3.2.1.gb9f7d.dirty

