Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXJVCsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXJVCsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXJVCrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:47:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47847 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754614AbXJVCrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:47:51 -0400
Date: Mon, 22 Oct 2007 04:48:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill UDFFS_{DATE,VERSION}
Message-ID: <20071022024820.GM30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Printing date and version of a driver makes sense if there's a 
maintainer who's maintaining and using these, but printing ancient 
version information only confuses users.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/udf/super.c         |    3 +--
 include/linux/udf_fs.h |    3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

2b021a6f76507cf43c80d726d35fd1979cc95c6c 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4360c7a..64526c3 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1542,9 +1542,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	if (!silent) {
 		kernel_timestamp ts;
 		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
-		udf_info("UDF %s (%s) Mounting volume '%s', "
+		udf_info("UDF: Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-			 UDFFS_VERSION, UDFFS_DATE,
 			 UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
 			 ts.typeAndTimezone);
 	}
diff --git a/include/linux/udf_fs.h b/include/linux/udf_fs.h
index 36c684e..3116b03 100644
--- a/include/linux/udf_fs.h
+++ b/include/linux/udf_fs.h
@@ -32,9 +32,6 @@
 #define UDF_PREALLOCATE
 #define UDF_DEFAULT_PREALLOC_BLOCKS	8
 
-#define UDFFS_DATE			"2004/29/09"
-#define UDFFS_VERSION			"0.9.8.1"
-
 #undef UDFFS_DEBUG
 
 #ifdef UDFFS_DEBUG

