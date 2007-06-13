Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbXFMECU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbXFMECU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 00:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbXFMECN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 00:02:13 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:47173 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbXFMECL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 00:02:11 -0400
Subject: [PATCH]is_power_of_2-hfs/mdb.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vignesh.babu@wipro.com
To: zippel@linux-m68k.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Wed, 13 Jun 2007 09:33:13 +0530
Message-Id: <1181707393.13391.29.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
X-OriginalArrivalTime: 13 Jun 2007 04:02:12.0703 (UTC) FILETIME=[9F2FBEF0:01C7AD6F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index b4651e1..8bda11d 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -11,6 +11,7 @@
 #include <linux/cdrom.h>
 #include <linux/genhd.h>
 #include <linux/nls.h>
+#include <linux/log2.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
@@ -106,7 +107,7 @@ int hfs_mdb_get(struct super_block *sb)
 
 	size = min(HFS_SB(sb)->alloc_blksz, (u32)PAGE_SIZE);
 	/* size must be a multiple of 512 */
-	while (size & (size - 1))
+	while (!is_power_of_2(size))
 		size -= HFS_SECTOR_SIZE;
 	sect = be16_to_cpu(mdb->drAlBlSt) + part_start;
 	/* align block size to first sector */

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

