Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbYDCPvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbYDCPvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYDCPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:51:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42478 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbYDCPvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:51:07 -0400
Subject: [PATCH] btrfs - replace div_long_long_rem()
From: Badari Pulavarty <pbadari@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       btrfs-devel@oss.oracle.com
In-Reply-To: <200802211609.50563.chris.mason@oracle.com>
References: <200802211609.50563.chris.mason@oracle.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 08:51:36 -0800
Message-Id: <1207241496.30407.51.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

While compiling btrfs against 2.6.25-rc8-mm1, ran into this.
div_long_long_rem() is removed in -mm. Replace with div_u64_rem().

Thanks,
Badari

div_long_long_rem() API is being removed (patch in -mm).
Replace div_long_long_rem() with div_u64_rem().

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 extent-tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: btrfs-0.13/extent-tree.c
===================================================================
--- btrfs-0.13.orig/extent-tree.c	2008-02-21 11:54:12.000000000 -0800
+++ btrfs-0.13/extent-tree.c	2008-04-03 07:18:04.000000000 -0800
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/crc32c.h>
 #include <linux/pagemap.h>
+#include <linux/math64.h>
 #include "hash.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -2653,7 +2654,7 @@
 	u64 nr = 0;
 	u64 cur_byte;
 	u64 old_size;
-	unsigned long rem;
+	u32 rem;
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_block_group_item *item;
 	struct btrfs_fs_info *info = root->fs_info;
@@ -2691,7 +2692,7 @@
 				      struct btrfs_block_group_item);
 
 		btrfs_set_disk_block_group_used(leaf, item, 0);
-		div_long_long_rem(nr, 3, &rem);
+		div_u64_rem(nr, 3, &rem);
 		if (rem) {
 			btrfs_set_disk_block_group_flags(leaf, item,
 						 BTRFS_BLOCK_GROUP_DATA);


