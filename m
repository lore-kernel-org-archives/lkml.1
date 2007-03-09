Return-Path: <linux-kernel-owner+w=401wt.eu-S2993075AbXCIIQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993075AbXCIIQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993078AbXCIIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:16:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44308 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993077AbXCIIQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:16:10 -0500
Date: Fri, 9 Mar 2007 10:16:09 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       serue@us.ibm.com
Subject: [PATCH 5/7] revoke: add documentation
Message-ID: <Pine.LNX.4.64.0703091015460.32320@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This documents revoke file operation in Documentation/filesystems/vfs.txt.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 Documentation/filesystems/vfs.txt |    5 +++++
 1 file changed, 5 insertions(+)

Index: uml-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- uml-2.6.orig/Documentation/filesystems/vfs.txt	2007-03-08 10:24:23.000000000 +0200
+++ uml-2.6/Documentation/filesystems/vfs.txt	2007-03-08 10:24:33.000000000 +0200
@@ -732,6 +732,7 @@
 int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned  
 int);
+	int (*revoke)(struct file *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -805,6 +806,10 @@
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  revoke: called by revokeat(2) and frevoke(2) system calls to revoke access
+	  to an open file. This method must ensure that all currently blocked
+	  writes are flushed and reads will fail.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
