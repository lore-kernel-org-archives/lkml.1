Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYDNWvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYDNWvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbYDNWsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:48:15 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:1320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762082AbYDNWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H247FBaykNImiciscP/0NIkLmJl/zpWGGMqott8ai4CLOIQxkIUkAoJnlEP3GpakkEOm879OU1d9RMS/v+pNGilSEnNw0R029t0td8b5tDnp4DlC4W6L+Xeh0ny+3+4GlXMD9CloxX7tE4d3LdwEPrvFbVYPlyx2MhYEkpWCO44=
Subject: [PATCH-mm 12/15] fat: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:48:01 -0700
Message-Id: <1208213281.11920.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/fat/inode.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 53f3cf6..8476993 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1215,8 +1215,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		brelse(bh);
 		goto out_invalid;
 	}
-	logical_sector_size =
-		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
+	logical_sector_size = get_unaligned_le16(&b->sector_size);
 	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
 	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
@@ -1314,8 +1313,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
 	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
-	sbi->dir_entries =
-		le16_to_cpu(get_unaligned((__le16 *)&b->dir_entries));
+	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus directroy-entries per block"
@@ -1327,7 +1325,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	rootdir_sectors = sbi->dir_entries
 		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
 	sbi->data_start = sbi->dir_start + rootdir_sectors;
-	total_sectors = le16_to_cpu(get_unaligned((__le16 *)&b->sectors));
+	total_sectors = get_unaligned_le16(&b->sectors);
 	if (total_sectors == 0)
 		total_sectors = le32_to_cpu(b->total_sect);
 
-- 
1.5.5.144.g3e42


