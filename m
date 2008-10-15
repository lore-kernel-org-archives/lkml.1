Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYJOWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYJOWwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYJOWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:50:36 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54100 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYJOWud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:50:33 -0400
Subject: [PATCH vfs-2.6 6/6] vfs: add LOOKUP_RENAME_TARGET intent
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 16 Oct 2008 07:50:29 +0900
Message-ID: <11d623e93e848f673b5620397.ps@mail.parknet.co.jp>
References: <e86c95d83e848f673b3120397.ps@mail.parknet.co.jp>
	<ef1e4d933e848f673b4220397.ps@mail.parknet.co.jp>
	<4e71a4b03e848f673b4320397.ps@mail.parknet.co.jp>
	<f5d2a7043e848f673b5420397.ps@mail.parknet.co.jp>
	<e8c7efff3e848f673b5520397.ps@mail.parknet.co.jp>
In-Reply-To: <e8c7efff3e848f673b5520397.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds LOOKUP_RENAME_TARGET intent for lookup of rename destination.

LOOKUP_RENAME_TARGET is going to be used like LOOKUP_CREATE. But since
the destination of rename() can be existing directory entry, so it has a
difference. Although that difference doesn't matter in my usage, this
tells it to user of this intent.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namei.c            |    1 +
 include/linux/namei.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/namei.c~dcache-add-rename-intent fs/namei.c
--- vfs-2.6/fs/namei.c~dcache-add-rename-intent	2008-10-16 06:57:40.000000000 +0900
+++ vfs-2.6-hirofumi/fs/namei.c	2008-10-16 06:57:40.000000000 +0900
@@ -2654,6 +2654,7 @@ asmlinkage long sys_renameat(int olddfd,
 
 	oldnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags |= LOOKUP_RENAME_TARGET;
 
 	trap = lock_rename(new_dir, old_dir);
 
diff -puN include/linux/namei.h~dcache-add-rename-intent include/linux/namei.h
--- vfs-2.6/include/linux/namei.h~dcache-add-rename-intent	2008-10-16 06:57:40.000000000 +0900
+++ vfs-2.6-hirofumi/include/linux/namei.h	2008-10-16 06:58:05.000000000 +0900
@@ -54,6 +54,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_OPEN		0x0100
 #define LOOKUP_CREATE		0x0200
 #define LOOKUP_EXCL		0x0400
+#define LOOKUP_RENAME_TARGET	0x0800
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 
_
