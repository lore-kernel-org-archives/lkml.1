Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbYEUAgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbYEUAgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764863AbYEUAcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:32:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45319 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbYEUAcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:32:32 -0400
To: mchehab@infradead.org
Subject: [PATCH] zoran: endianness annotations
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycFr-0004tY-Rm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:32:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/zoran.h        |    4 ++--
 drivers/media/video/zoran_device.c |    2 +-
 drivers/media/video/zoran_driver.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/zoran.h b/drivers/media/video/zoran.h
index 81cc3b0..46b7ad4 100644
--- a/drivers/media/video/zoran.h
+++ b/drivers/media/video/zoran.h
@@ -285,7 +285,7 @@ struct zoran_mapping {
 
 struct zoran_jpg_buffer {
 	struct zoran_mapping *map;
-	u32 *frag_tab;		/* addresses of frag table */
+	__le32 *frag_tab;		/* addresses of frag table */
 	u32 frag_tab_bus;	/* same value cached to save time in ISR */
 	enum zoran_buffer_state state;	/* non-zero if corresponding buffer is in use in grab queue */
 	struct zoran_sync bs;	/* DONE: info to return to application */
@@ -450,7 +450,7 @@ struct zoran {
 	unsigned long jpg_queued_num;	/* count of frames queued since grab/play started */
 
 	/* zr36057's code buffer table */
-	u32 *stat_com;		/* stat_com[i] is indexed by dma_head/tail & BUZ_MASK_STAT_COM */
+	__le32 *stat_com;		/* stat_com[i] is indexed by dma_head/tail & BUZ_MASK_STAT_COM */
 
 	/* (value & BUZ_MASK_FRAME) corresponds to index in pend[] queue */
 	int jpg_pend[BUZ_MAX_FRAME];
diff --git a/drivers/media/video/zoran_device.c b/drivers/media/video/zoran_device.c
index 37629ff..88d3697 100644
--- a/drivers/media/video/zoran_device.c
+++ b/drivers/media/video/zoran_device.c
@@ -1320,7 +1320,7 @@ error_handler (struct zoran *zr,
 			if (i) {
 				/* Rotate stat_comm entries to make current entry first */
 				int j;
-				u32 bus_addr[BUZ_NUM_STAT_COM];
+				__le32 bus_addr[BUZ_NUM_STAT_COM];
 
 				/* Here we are copying the stat_com array, which
 				 * is already in little endian format, so
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index 345c77e..497736a 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -495,7 +495,7 @@ jpg_fbuffer_alloc (struct file *file)
 			jpg_fbuffer_free(file);
 			return -ENOBUFS;
 		}
-		fh->jpg_buffers.buffer[i].frag_tab = (u32 *) mem;
+		fh->jpg_buffers.buffer[i].frag_tab = (__le32 *) mem;
 		fh->jpg_buffers.buffer[i].frag_tab_bus =
 		    virt_to_bus((void *) mem);
 
@@ -4506,7 +4506,7 @@ zoran_mmap (struct file           *file,
 				if (todo > fraglen)
 					todo = fraglen;
 				pos =
-				    le32_to_cpu((unsigned long) fh->jpg_buffers.
+				    le32_to_cpu(fh->jpg_buffers.
 				    buffer[i].frag_tab[2 * j]);
 				/* should just be pos on i386 */
 				page = virt_to_phys(bus_to_virt(pos))
-- 
1.5.3.GIT


