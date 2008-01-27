Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYA0DOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYA0DOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 22:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYA0DOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 22:14:14 -0500
Received: from ns.suse.de ([195.135.220.2]:58261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYA0DOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 22:14:14 -0500
Date: Sun, 27 Jan 2008 04:14:10 +0100
From: Andi Kleen <ak@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] BKL-Removal: Convert pipe to use unlocked_ioctl too
Message-ID: <20080127031409.GA26409@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's another patch that was missing in the previous BKL-removal series.

No BKL needed in pipe_ioctl

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/fs/pipe.c
===================================================================
--- linux.orig/fs/pipe.c
+++ linux/fs/pipe.c
@@ -576,9 +576,7 @@ bad_pipe_w(struct file *filp, const char
 	return -EBADF;
 }
 
-static int
-pipe_ioctl(struct inode *pino, struct file *filp,
-	   unsigned int cmd, unsigned long arg)
+static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pipe_inode_info *pipe;
@@ -785,7 +783,7 @@ const struct file_operations read_fifo_f
 	.aio_read	= pipe_read,
 	.write		= bad_pipe_w,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
 	.unlocked_fasync = pipe_read_fasync,
@@ -797,7 +795,7 @@ const struct file_operations write_fifo_
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
 	.unlocked_fasync = pipe_write_fasync,
@@ -810,7 +808,7 @@ const struct file_operations rdwr_fifo_f
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
 	.unlocked_fasync = pipe_rdwr_fasync,
@@ -822,7 +820,7 @@ static const struct file_operations read
 	.aio_read	= pipe_read,
 	.write		= bad_pipe_w,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
 	.unlocked_fasync = pipe_read_fasync,
@@ -834,7 +832,7 @@ static const struct file_operations writ
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
 	.unlocked_fasync = pipe_write_fasync,
@@ -847,7 +845,7 @@ static const struct file_operations rdwr
 	.write		= do_sync_write,
 	.aio_write	= pipe_write,
 	.poll		= pipe_poll,
-	.ioctl		= pipe_ioctl,
+	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
 	.unlocked_fasync = pipe_rdwr_fasync,
