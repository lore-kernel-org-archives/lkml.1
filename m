Return-Path: <linux-kernel-owner+w=401wt.eu-S964875AbXBTHvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbXBTHvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964866AbXBTHvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:51:41 -0500
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:32818 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875AbXBTHvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:51:40 -0500
Subject: [KJ][PATCH] is_power_of_2 in fat
From: Vignesh Babu BM <vignesh.babu@wipro.com>
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Feb 2007 13:19:54 +0530
Message-Id: <1171957794.6127.65.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 20 Feb 2007 07:51:38.0925 (UTC) FILETIME=[F3D0C5D0:01C754C3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index a9e4688..8437190 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -25,6 +25,7 @@
 #include <linux/parser.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/log2.h>
 #include <asm/unaligned.h>
 
 #ifndef CONFIG_FAT_DEFAULT_IOCHARSET
@@ -1216,8 +1217,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	}
 	logical_sector_size =
 		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
-	if (!logical_sector_size
-	    || (logical_sector_size & (logical_sector_size - 1))
+	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
 	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
 		if (!silent)
@@ -1227,8 +1227,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		goto out_invalid;
 	}
 	sbi->sec_per_clus = b->sec_per_clus;
-	if (!sbi->sec_per_clus
-	    || (sbi->sec_per_clus & (sbi->sec_per_clus - 1))) {
+	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus sectors per cluster %u\n",
 			       sbi->sec_per_clus);

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"
