Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbXCKLbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbXCKLbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXCKLbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:31:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbXCKLbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:31:18 -0400
Date: Sun, 11 Mar 2007 13:31:18 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 3/5] revoke: support for ext2 and ext3
Message-ID: <Pine.LNX.4.64.0703111330510.765@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add revoke support to ext2 and ext3 by wiring f_ops->revoke with
generic_file_revoke.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext2/file.c |    1 +
 fs/ext3/file.c |    1 +
 2 files changed, 2 insertions(+)

Index: uml-2.6/fs/ext2/file.c
===================================================================
--- uml-2.6.orig/fs/ext2/file.c	2007-03-11 13:05:33.000000000 +0200
+++ uml-2.6/fs/ext2/file.c	2007-03-11 13:09:21.000000000 +0200
@@ -56,6 +56,7 @@ const struct file_operations ext2_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke		= generic_file_revoke,
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
Index: uml-2.6/fs/ext3/file.c
===================================================================
--- uml-2.6.orig/fs/ext3/file.c	2007-03-11 13:05:33.000000000 +0200
+++ uml-2.6/fs/ext3/file.c	2007-03-11 13:09:21.000000000 +0200
@@ -123,6 +123,7 @@ const struct file_operations ext3_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext3_file_inode_operations = {
