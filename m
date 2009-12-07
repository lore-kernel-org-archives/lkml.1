Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZLGI0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZLGI0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbZLGI0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:26:32 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:49459 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758962AbZLGIZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:25:49 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: [PATCH 4/9] Squashfs: add decompressor entries for lzma and lzo
Message-Id: <E1NHYuo-00028R-9P@dylan.lougher.demon.co.uk>
From: root <root@lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 08:25:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add knowledge of lzma/lzo compression formats to the decompressor
framework.  For now these are added as unsupported.  Without
these entries lzma/lzo compressed filesystems will be flagged as
having unknown compression which is undesirable.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/decompressor.c |   10 ++++++++++
 fs/squashfs/squashfs_fs.h  |    4 +++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index 0072ccd..157478d 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -36,12 +36,22 @@
  * Squashfs, allowing multiple decompressors to be easily supported
  */
 
+static const struct squashfs_decompressor squashfs_lzma_unsupported_comp_ops = {
+	NULL, NULL, NULL, LZMA_COMPRESSION, "lzma", 0
+};
+
+static const struct squashfs_decompressor squashfs_lzo_unsupported_comp_ops = {
+	NULL, NULL, NULL, LZO_COMPRESSION, "lzo", 0
+};
+
 static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
 	NULL, NULL, NULL, 0, "unknown", 0
 };
 
 static const struct squashfs_decompressor *decompressor[] = {
 	&squashfs_zlib_comp_ops,
+	&squashfs_lzma_unsupported_comp_ops,
+	&squashfs_lzo_unsupported_comp_ops,
 	&squashfs_unknown_comp_ops
 };
 
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 283daaf..36e1604 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -211,7 +211,9 @@ struct meta_index {
 /*
  * definitions for structures on disk
  */
-#define ZLIB_COMPRESSION	 1
+#define ZLIB_COMPRESSION	1
+#define LZMA_COMPRESSION	2
+#define LZO_COMPRESSION		3
 
 struct squashfs_super_block {
 	__le32			s_magic;
-- 
1.6.3.3

