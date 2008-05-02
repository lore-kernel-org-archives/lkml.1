Return-Path: <linux-kernel-owner+w=401wt.eu-S1765452AbYEBAEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765452AbYEBAEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYEBAE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:04:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYEBAE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:04:26 -0400
Date: Thu, 1 May 2008 20:04:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@goodmis.org, rbultje@ronald.bitfreak.net
Subject: [PATCH] use unsigned long for zoran_driver
Message-ID: <Pine.LNX.4.58.0805012003020.7954@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My typecheck flags patch flagged the zoran_driver.c as having an incompatible
flags for spin_lock_irqsave. This isn't really true since "long" was used.
But since the convention is to use "unsigned long" this is a clean up
patch to make the zoran_driver conform to the rest of the kernel.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 drivers/media/video/zoran_driver.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-compile.git/drivers/media/video/zoran_driver.c
===================================================================
--- linux-compile.git.orig/drivers/media/video/zoran_driver.c	2008-05-01 16:58:39.000000000 -0400
+++ linux-compile.git/drivers/media/video/zoran_driver.c	2008-05-01 19:58:19.000000000 -0400
@@ -1167,7 +1167,7 @@ zoran_close_end_session (struct file *fi

 	/* v4l capture */
 	if (fh->v4l_buffers.active != ZORAN_FREE) {
-		long flags;
+		unsigned long flags;

 		spin_lock_irqsave(&zr->spinlock, flags);
 		zr36057_set_memgrab(zr, 0);
@@ -3436,7 +3436,7 @@ zoran_do_ioctl (struct inode *inode,

 			/* unload capture */
 			if (zr->v4l_memgrab_active) {
-				long flags;
+				unsigned long flags;

 				spin_lock_irqsave(&zr->spinlock, flags);
 				zr36057_set_memgrab(zr, 0);
@@ -4375,7 +4375,7 @@ zoran_vm_close (struct vm_area_struct *v
 				mutex_lock(&zr->resource_lock);

 				if (fh->v4l_buffers.active != ZORAN_FREE) {
-					long flags;
+					unsigned long flags;

 					spin_lock_irqsave(&zr->spinlock, flags);
 					zr36057_set_memgrab(zr, 0);

