Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXCKLbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXCKLbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXCKLbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:31:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbXCKLbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:31:44 -0400
Date: Sun, 11 Mar 2007 13:31:43 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 4/5] revoke: add documentation
Message-ID: <Pine.LNX.4.64.0703111331190.765@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This documents revoke file operation in Documentation/filesystems/vfs.txt.

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 Documentation/filesystems/vfs.txt |    5 +++++
 1 file changed, 5 insertions(+)

Index: uml-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- uml-2.6.orig/Documentation/filesystems/vfs.txt	2007-03-11 13:05:33.000000000 +0200
+++ uml-2.6/Documentation/filesystems/vfs.txt	2007-03-11 13:09:22.000000000 +0200
@@ -732,6 +732,7 @@ struct file_operations {
 int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned  
 int);
+	int (*revoke)(struct file *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -805,6 +806,10 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  revoke: called by revokeat(2) and frevoke(2) system calls to revoke access
+	  to an open file. This method must ensure that all currently blocked
+	  writes are flushed and reads will fail.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
