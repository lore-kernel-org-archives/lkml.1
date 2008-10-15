Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYJOOHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYJOOHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYJOOE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:56 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45129 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYJOOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:48 -0400
Subject: [PATCH 4/6] vfs: remove unnecessary fsnotify_d_instantiate()
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:11 +0900
Message-ID: <524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
In-Reply-To: <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This calls d_move(), so fsnotify_d_instantiate() is unnecessary like
rename path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/dcache.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/dcache.c~dcache-cleanup-4 fs/dcache.c
--- linux-2.6/fs/dcache.c~dcache-cleanup-4	2008-08-26 11:13:29.000000000 +0900
+++ linux-2.6-hirofumi/fs/dcache.c	2008-08-26 11:13:29.000000000 +0900
@@ -1209,7 +1209,6 @@ struct dentry *d_splice_alias(struct ino
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
-			fsnotify_d_instantiate(new, inode);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
_
