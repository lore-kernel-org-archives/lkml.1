Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYA0CU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYA0CU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbYA0CR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:54499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbYA0CRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [15/18] BKL-removal: Convert pipe over to unlocked_fasync
Message-Id: <20080127021722.162FA14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/pipe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/fs/pipe.c
===================================================================
--- linux.orig/fs/pipe.c
+++ linux/fs/pipe.c
@@ -788,7 +788,7 @@ const struct file_operations read_fifo_f
 	.ioctl		= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
+	.unlocked_fasync = pipe_read_fasync,
 };
 
 const struct file_operations write_fifo_fops = {
@@ -800,7 +800,7 @@ const struct file_operations write_fifo_
 	.ioctl		= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
+	.unlocked_fasync = pipe_write_fasync,
 };
 
 const struct file_operations rdwr_fifo_fops = {
@@ -813,7 +813,7 @@ const struct file_operations rdwr_fifo_f
 	.ioctl		= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
+	.unlocked_fasync = pipe_rdwr_fasync,
 };
 
 static const struct file_operations read_pipe_fops = {
@@ -825,7 +825,7 @@ static const struct file_operations read
 	.ioctl		= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
+	.unlocked_fasync = pipe_read_fasync,
 };
 
 static const struct file_operations write_pipe_fops = {
@@ -837,7 +837,7 @@ static const struct file_operations writ
 	.ioctl		= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
+	.unlocked_fasync = pipe_write_fasync,
 };
 
 static const struct file_operations rdwr_pipe_fops = {
@@ -850,7 +850,7 @@ static const struct file_operations rdwr
 	.ioctl		= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
+	.unlocked_fasync = pipe_rdwr_fasync,
 };
 
 struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
