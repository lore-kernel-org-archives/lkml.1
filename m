Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbYJOOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbYJOOKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYJOOGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:11 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32959 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbYJOOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:09 -0400
Subject: [PATCH 09/21] fat: use fat_detach() in fat_clear_inode()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:58 +0900
Message-ID: <2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
In-Reply-To: <649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use fat_detach() instead of opencoding it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/fat/inode.c~fat-use-fat_detach fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-use-fat_detach	2008-08-26 12:21:52.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-08-26 12:21:52.000000000 +0900
@@ -429,13 +429,8 @@ static void fat_delete_inode(struct inod
 
 static void fat_clear_inode(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-
-	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
-	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
-	spin_unlock(&sbi->inode_hash_lock);
+	fat_detach(inode);
 }
 
 static void fat_write_super(struct super_block *sb)
_
