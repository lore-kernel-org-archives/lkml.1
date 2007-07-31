Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXGaNM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXGaNM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761803AbXGaNKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:10:00 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761799AbXGaNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:58 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125440.794755000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:22 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Ronald Bultje <rbultje@ronald.bitfreak.net>
Subject: [Patch 06/16] This removes unnecessary kmalloc casts and corrects a test for kmalloc failure.
Content-Disposition: inline; filename=drivers_media_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Ronald Bultje <rbultje@ronald.bitfreak.net>

---
 drivers/media/video/zoran_driver.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: b/drivers/media/video/zoran_driver.c
===================================================================
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -347,11 +347,8 @@ v4l_fbuffer_alloc (struct file *file)
 		if (fh->v4l_buffers.buffer_size <= MAX_KMALLOC_MEM) {
 			/* Use kmalloc */
 
-			mem =
-			    (unsigned char *) kmalloc(fh->v4l_buffers.
-						      buffer_size,
-						      GFP_KERNEL);
-			if (mem == 0) {
+			mem = kmalloc(fh->v4l_buffers.buffer_size, GFP_KERNEL);
+			if (!mem) {
 				dprintk(1,
 					KERN_ERR
 					"%s: v4l_fbuffer_alloc() - kmalloc for V4L buf %d failed\n",
@@ -520,10 +517,7 @@ jpg_fbuffer_alloc (struct file *file)
 
 		//if (alloc_contig) {
 		if (fh->jpg_buffers.need_contiguous) {
-			mem =
-			    (unsigned long) kmalloc(fh->jpg_buffers.
-						    buffer_size,
-						    GFP_KERNEL);
+			mem = kmalloc(fh->jpg_buffers.buffer_size, GFP_KERNEL);
 			if (mem == 0) {
 				dprintk(1,
 					KERN_ERR

-- 
