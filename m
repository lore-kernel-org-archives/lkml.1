Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYETPcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYETPcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932609AbYETPaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:30 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2881 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYETPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/11] Convert pipe over to unlocked_fasync
Message-Id: <20080520152844.D401E1B4203@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:44 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:44.0215 (UTC) FILETIME=[362D4270:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/pipe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/fs/pipe.c
===================================================================
--- linux.orig/fs/pipe.c
+++ linux/fs/pipe.c
@@ -787,7 +787,7 @@ const struct file_operations read_fifo_f
 	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
+	.unlocked_fasync = pipe_read_fasync,
 };
 
 const struct file_operations write_fifo_fops = {
@@ -799,7 +799,7 @@ const struct file_operations write_fifo_
 	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
+	.unlocked_fasync = pipe_write_fasync,
 };
 
 const struct file_operations rdwr_fifo_fops = {
@@ -812,7 +812,7 @@ const struct file_operations rdwr_fifo_f
 	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
+	.unlocked_fasync = pipe_rdwr_fasync,
 };
 
 static const struct file_operations read_pipe_fops = {
@@ -824,7 +824,7 @@ static const struct file_operations read
 	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_read_open,
 	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
+	.unlocked_fasync = pipe_read_fasync,
 };
 
 static const struct file_operations write_pipe_fops = {
@@ -836,7 +836,7 @@ static const struct file_operations writ
 	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_write_open,
 	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
+	.unlocked_fasync = pipe_write_fasync,
 };
 
 static const struct file_operations rdwr_pipe_fops = {
@@ -849,7 +849,7 @@ static const struct file_operations rdwr
 	.unlocked_ioctl	= pipe_ioctl,
 	.open		= pipe_rdwr_open,
 	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
+	.unlocked_fasync = pipe_rdwr_fasync,
 };
 
 struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
