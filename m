Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYKZVNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYKZVNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYKZVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:12:57 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:18154 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYKZVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QO5DjwcGVW2l04+qR3aTrFGwBzE/uI56a0L+TB4/8d1T3P36Fz9eX2f29GRvBA4vw9
         ja2nj3/6mKFu90+Q7nN3VEdQZJaYAROsdHi2f+z3zoXrt3CMN+F/Cbn4RZken4JqglRq
         ytVy8XhLLog4PoviXxcpUvLY/Ryan2Kb4MfVo=
Subject: [PATCH-mm 2/8] mtd: remove private wrapper of endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 13:12:50 -0800
Message-Id: <1227733970.5511.124.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base versions handle constant folding just fine.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the byteorder consolidation in -mm.

 drivers/mtd/rfd_ftl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index e538c0a..3101815 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -21,8 +21,6 @@
 
 #include <asm/types.h>
 
-#define const_cpu_to_le16	__constant_cpu_to_le16
-
 static int block_size = 0;
 module_param(block_size, int, 0);
 MODULE_PARM_DESC(block_size, "Block size to use by RFD, defaults to erase unit size");
@@ -297,7 +295,7 @@ static void erase_callback(struct erase_info *erase)
 		return;
 	}
 
-	magic = const_cpu_to_le16(RFD_MAGIC);
+	magic = cpu_to_le16(RFD_MAGIC);
 
 	part->blocks[i].state = BLOCK_ERASED;
 	part->blocks[i].free_sectors = part->data_sectors_per_block;
@@ -587,7 +585,7 @@ static int mark_sector_deleted(struct partition *part, u_long old_addr)
 	int block, offset, rc;
 	u_long addr;
 	size_t retlen;
-	u16 del = const_cpu_to_le16(SECTOR_DELETED);
+	u16 del = cpu_to_le16(SECTOR_DELETED);
 
 	block = old_addr / part->block_size;
 	offset = (old_addr % part->block_size) / SECTOR_SIZE -
-- 
1.6.0.4.1044.g77718


