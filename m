Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbZLGIiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbZLGIiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbZLGIiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:38:04 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:60680 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759171AbZLGIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:37:44 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: [PATCH 5/9] Squashfs: make decompressor init function pass superblock info
Message-Id: <E1NHZ6L-00029i-7s@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 08:37:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/decompressor.h |    4 ++--
 fs/squashfs/zlib_wrapper.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 778760c..7425f80 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -24,7 +24,7 @@
  */
 
 struct squashfs_decompressor {
-	void	*(*init)(void);
+	void	*(*init)(struct squashfs_sb_info *);
 	void	(*free)(void *);
 	int	(*decompress)(struct squashfs_sb_info *, void **,
 		struct buffer_head **, int, int, int, int, int);
@@ -35,7 +35,7 @@ struct squashfs_decompressor {
 
 static inline void *squashfs_decompressor_init(struct squashfs_sb_info *msblk)
 {
-	return msblk->decompressor->init();
+	return msblk->decompressor->init(msblk);
 }
 
 static inline void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 381768c..4dd70e0 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -32,7 +32,7 @@
 #include "squashfs.h"
 #include "decompressor.h"
 
-static void *zlib_init(void)
+static void *zlib_init(struct squashfs_sb_info *dummy)
 {
 	z_stream *stream = kmalloc(sizeof(z_stream), GFP_KERNEL);
 	if (stream == NULL)
-- 
1.6.3.3

