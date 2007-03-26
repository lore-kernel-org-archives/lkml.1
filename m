Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXCZMM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXCZMM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXCZMM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:12:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44993 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXCZMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:12:57 -0400
Date: Mon, 26 Mar 2007 15:12:56 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, bryan.wu@analog.com, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk
Subject: revoke: no revoke for nommu
Message-ID: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

There's just no sane way to revoke shared memory mappings for NOMMU so lets
disable the thing completely when CONFIG_MMU=n.

Cc: Bryan Wu <bryan.wu@analog.com> 
Cc: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: uml-2.6/fs/Makefile
===================================================================
--- uml-2.6.orig/fs/Makefile	2007-03-26 15:08:42.000000000 +0300
+++ uml-2.6/fs/Makefile	2007-03-26 15:09:03.000000000 +0300
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o revoke.o revoked_inode.o
+		stack.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
@@ -19,6 +19,7 @@ else
 obj-y +=	no-block.o
 endif
 
+obj-$(CONFIG_MMU)		+= revoke.o revoked_inode.o
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
