Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbXLNPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbXLNPSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764832AbXLNPSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:18:01 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59122 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764643AbXLNPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:18:00 -0500
Date: Fri, 14 Dec 2007 17:17:58 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [RFC/PATCH 7/8] revoke: support for ext2 and ext3 V7
Message-ID: <Pine.LNX.4.64.0712141717420.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add revoke support to ext2, ext3 and ext4 by wiring f_ops->revoke with
generic_file_revoke.

Cc: Alan Cox <alan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 fs/ext2/file.c |    1 +
 fs/ext3/file.c |    1 +
 fs/ext4/file.c |    1 +
 3 files changed, 3 insertions(+)

Index: 2.6/fs/ext2/file.c
===================================================================
--- 2.6.orig/fs/ext2/file.c	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/fs/ext2/file.c	2007-12-14 16:41:02.000000000 +0200
@@ -58,6 +58,7 @@ const struct file_operations ext2_file_o
 	.fsync		= ext2_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke		= generic_file_revoke,
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
Index: 2.6/fs/ext3/file.c
===================================================================
--- 2.6.orig/fs/ext3/file.c	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/fs/ext3/file.c	2007-12-14 16:41:02.000000000 +0200
@@ -122,6 +122,7 @@ const struct file_operations ext3_file_o
 	.fsync		= ext3_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext3_file_inode_operations = {
Index: 2.6/fs/ext4/file.c
===================================================================
--- 2.6.orig/fs/ext4/file.c	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/fs/ext4/file.c	2007-12-14 16:41:02.000000000 +0200
@@ -122,6 +122,7 @@ const struct file_operations ext4_file_o
 	.fsync		= ext4_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
