Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbXLNPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbXLNPSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765560AbXLNPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:18:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59122 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765463AbXLNPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:18:15 -0500
Date: Fri, 14 Dec 2007 17:18:14 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [RFC/PATCH 8/8] revoke: add to documentation V7
Message-ID: <Pine.LNX.4.64.0712141718000.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add the ->revoke() file operation to VFS documentation.

Cc: Alan Cox <alan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 Documentation/filesystems/vfs.txt |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6/Documentation/filesystems/vfs.txt
===================================================================
--- 2.6.orig/Documentation/filesystems/vfs.txt	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/Documentation/filesystems/vfs.txt	2007-12-14 16:41:05.000000000 +0200
@@ -780,6 +780,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
+	int (*revoke)(struct file *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -853,6 +854,10 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  revoke: called by revokeat(2) system call to revoke access to an open file.
+	  This method must ensure that all currently blocked writes are flushed
+	  and that all pending reads will fail.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
