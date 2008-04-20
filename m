Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbYDTS0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbYDTS0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbYDTSYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:41 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45912 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbYDTSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:36 -0400
Subject: [PATCH 1/9] fat: kill is_bad_inode() check
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:22 +0900
Message-ID: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FAT doesn't need to check bad inode anymore.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat-cleanup-bad-inode fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-cleanup-bad-inode	2008-02-15 17:44:56.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-02-15 17:44:56.000000000 +0900
@@ -433,11 +433,8 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 static void fat_delete_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-
-	if (!is_bad_inode(inode)) {
-		inode->i_size = 0;
-		fat_truncate(inode);
-	}
+	inode->i_size = 0;
+	fat_truncate(inode);
 	clear_inode(inode);
 }
 
@@ -445,8 +442,6 @@ static void fat_clear_inode(struct inode
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 
-	if (is_bad_inode(inode))
-		return;
 	lock_kernel();
 	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
_
