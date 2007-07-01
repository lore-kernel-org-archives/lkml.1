Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXGAHng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXGAHng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbXGAHim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:38:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59604 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbXGAHij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:38:39 -0400
Subject: [EXT4 set 9][PATCH 2/5]Morecleanups: use is_power_of_2 () in
	fill_super
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:38:37 -0400
Message-Id: <1183275518.4010.138.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: is_power_of_2: ext4/super.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) in the context of power of 2 checks with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
---

 fs/ext4/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/super.c~is_power_of_2-ext4-superc fs/ext4/super.c
--- a/fs/ext4/super.c~is_power_of_2-ext4-superc
+++ a/fs/ext4/super.c
@@ -36,6 +36,7 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/log2.h>

 #include <asm/uaccess.h>

@@ -1662,7 +1663,7 @@ static int ext4_fill_super (struct super
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    (!is_power_of_2(sbi->s_inode_size)) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk (KERN_ERR
 				"EXT4-fs: unsupported inode size: %d\n",
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

git-ubi.patch
use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
use-is_power_of_2-in-myri10ge-myri10gec.patch
is_power_of_2-ext3-superc.patch
is_power_of_2-ext4-superc.patch
is_pwoer_of_2-jbd.patch



