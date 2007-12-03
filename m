Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbXLCQ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbXLCQ0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXLCQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:26:14 -0500
Received: from hera.cwi.nl ([192.16.191.8]:45228 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbXLCQ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:26:13 -0500
X-Greylist: delayed 2401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 11:26:13 EST
Date: Mon, 3 Dec 2007 16:54:55 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]
Message-ID: <20071203155451.GA2594@mette>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it turns out, the kernel divides by EXT3_INODES_PER_GROUP(s)
when mounting an ext3 filesystem. If that number is zero,
a crash follows. Below a patch.

This crash was reported by Joeri de Ruiter, Carst Tankink and Pim Vullers.

Andries

diff -uprN -X /linux/dontdiff a/fs/ext3/super.c b/fs/ext3/super.c
--- a/fs/ext3/super.c	2007-10-13 19:51:45.000000000 +0200
+++ b/fs/ext3/super.c	2007-12-03 16:00:36.802510904 +0100
@@ -1596,7 +1596,7 @@ static int ext3_fill_super (struct super
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
 	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
-	if (EXT3_INODE_SIZE(sb) == 0)
+	if (EXT3_INODE_SIZE(sb) == 0 || EXT3_INODES_PER_GROUP(sb) == 0)
 		goto cantfind_ext3;
 	sbi->s_inodes_per_block = blocksize / EXT3_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0)
diff -uprN -X /linux/dontdiff a/fs/ext4/super.c b/fs/ext4/super.c
--- a/fs/ext4/super.c	2007-10-13 19:51:45.000000000 +0200
+++ b/fs/ext4/super.c	2007-12-03 16:05:14.722260680 +0100
@@ -1678,7 +1678,7 @@ static int ext4_fill_super (struct super
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
 	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
-	if (EXT4_INODE_SIZE(sb) == 0)
+	if (EXT4_INODE_SIZE(sb) == 0 || EXT4_INODES_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 	sbi->s_inodes_per_block = blocksize / EXT4_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0)

