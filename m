Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXKDWIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXKDWIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 17:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXKDWIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 17:08:30 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:40815 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbXKDWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 17:08:29 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] FAT: Fix printk format strings.
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 05 Nov 2007 07:08:22 +0900
Message-ID: <87lk9dpstl.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>

This makes sure printk format strings contain no more than a single
line.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
[the message was tweaked.]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    6 ++----
 fs/fat/misc.c  |    5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat_fix-printk-format-str fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_fix-printk-format-str	2007-11-05 05:43:31.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2007-11-05 05:43:31.000000000 +0900
@@ -1295,10 +1295,8 @@ int fat_fill_super(struct super_block *s
 
 		fsinfo = (struct fat_boot_fsinfo *)fsinfo_bh->b_data;
 		if (!IS_FSINFO(fsinfo)) {
-			printk(KERN_WARNING
-			       "FAT: Did not find valid FSINFO signature.\n"
-			       "     Found signature1 0x%08x signature2 0x%08x"
-			       " (sector = %lu)\n",
+			printk(KERN_WARNING "FAT: Invalid FSINFO signature: "
+			       "0x%08x, 0x%08x (sector = %lu)\n",
 			       le32_to_cpu(fsinfo->signature1),
 			       le32_to_cpu(fsinfo->signature2),
 			       sbi->fsinfo_sector);
diff -puN fs/fat/misc.c~fat_fix-printk-format-str fs/fat/misc.c
--- linux-2.6/fs/fat/misc.c~fat_fix-printk-format-str	2007-11-05 05:43:31.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/misc.c	2007-11-05 05:59:53.000000000 +0900
@@ -55,9 +55,8 @@ void fat_clusters_flush(struct super_blo
 	fsinfo = (struct fat_boot_fsinfo *)bh->b_data;
 	/* Sanity check */
 	if (!IS_FSINFO(fsinfo)) {
-		printk(KERN_ERR "FAT: Did not find valid FSINFO signature.\n"
-		       "     Found signature1 0x%08x signature2 0x%08x"
-		       " (sector = %lu)\n",
+		printk(KERN_ERR "FAT: Invalid FSINFO signature: "
+		       "0x%08x, 0x%08x (sector = %lu)\n",
 		       le32_to_cpu(fsinfo->signature1),
 		       le32_to_cpu(fsinfo->signature2),
 		       sbi->fsinfo_sector);
_
