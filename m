Return-Path: <linux-kernel-owner+w=401wt.eu-S933581AbXCPKHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbXCPKHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933583AbXCPKHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:07:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60544 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581AbXCPKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:07:41 -0400
Date: Fri, 16 Mar 2007 12:07:39 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] revoke: move magic
Message-ID: <Pine.LNX.4.64.0703161207130.18621@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Move REVOKEFS_MAGIC to <linux/magic.h> where it belongs.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c                  |    1 +
 include/linux/magic.h        |    1 +
 include/linux/revoked_fs_i.h |    2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

Index: uml-2.6/include/linux/magic.h
===================================================================
--- uml-2.6.orig/include/linux/magic.h	2007-03-16 09:01:07.000000000 +0200
+++ uml-2.6/include/linux/magic.h	2007-03-16 09:01:50.000000000 +0200
@@ -34,6 +34,7 @@ #define REISERFS_SUPER_MAGIC	0x52654973	
 #define REISERFS_SUPER_MAGIC_STRING	"ReIsErFs"
 #define REISER2FS_SUPER_MAGIC_STRING	"ReIsEr2Fs"
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"
+#define REVOKEFS_MAGIC		0x5245564B      /* REVK */
 
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
Index: uml-2.6/include/linux/revoked_fs_i.h
===================================================================
--- uml-2.6.orig/include/linux/revoked_fs_i.h	2007-03-16 09:01:12.000000000 +0200
+++ uml-2.6/include/linux/revoked_fs_i.h	2007-03-16 09:01:21.000000000 +0200
@@ -1,8 +1,6 @@
 #ifndef _LINUX_REVOKED_FS_I_H
 #define _LINUX_REVOKED_FS_I_H
 
-#define REVOKEFS_MAGIC 0x5245564B      /* REVK */
-
 struct revokefs_inode_info {
 	struct task_struct *owner;
 	struct file *file;
Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-16 09:01:59.000000000 +0200
+++ uml-2.6/fs/revoke.c	2007-03-16 09:02:08.000000000 +0200
@@ -9,6 +9,7 @@  * Copyright (C) 2006-2007  Pekka Enberg
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
+#include <linux/magic.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/module.h>
