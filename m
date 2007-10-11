Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXJKJR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXJKJR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbXJKJRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:17:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:27045 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbXJKJRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n6leV5MuI3AO14OU9Iwj0LdhOWWc9O571DBh19731T9McLPG1P3o/VaFlcIkyync2qzl9aATDD2b4ZJvLd/HhB+CtxV9KqEUibvzmVYG1oqPEHyat46Z1T6aZrNAbdEg5RxU6G/42VnZjyipxqvbuKrQQvc7FxhaBajazO5zdqA=
Subject: [PATCH] FAT: Fix printk format strings.
From: Vegard Nossum <vegard.nossum@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Oct 2007 11:17:12 +0200
Message-Id: <1192094232.26648.34.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure printk format strings contain no more than a single
line.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 fs/fat/inode.c |    3 ++-
 fs/fat/misc.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 4baa5f2..06a1bd9 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1301,7 +1301,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		fsinfo = (struct fat_boot_fsinfo *)fsinfo_bh->b_data;
 		if (!IS_FSINFO(fsinfo)) {
 			printk(KERN_WARNING
-			       "FAT: Did not find valid FSINFO signature.\n"
+			       "FAT: Did not find valid FSINFO signature.\n");
+			printk(KERN_WARNING
 			       "     Found signature1 0x%08x signature2 0x%08x"
 			       " (sector = %lu)\n",
 			       le32_to_cpu(fsinfo->signature1),
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 308f2b6..a4de2b8 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -55,7 +55,8 @@ void fat_clusters_flush(struct super_block *sb)
 	fsinfo = (struct fat_boot_fsinfo *)bh->b_data;
 	/* Sanity check */
 	if (!IS_FSINFO(fsinfo)) {
-		printk(KERN_ERR "FAT: Did not find valid FSINFO signature.\n"
+		printk(KERN_ERR "FAT: Did not find valid FSINFO signature.\n");
+		printk(KERN_ERR
 		       "     Found signature1 0x%08x signature2 0x%08x"
 		       " (sector = %lu)\n",
 		       le32_to_cpu(fsinfo->signature1),
-- 
1.5.2.4



