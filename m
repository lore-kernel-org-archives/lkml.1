Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYJOOJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYJOOJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYJOOE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45130 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYJOOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:49 -0400
Subject: [PATCH 6/6] vfs: add LOOKUP_RENAME_NEW intent
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:11 +0900
Message-ID: <a9ddfd693e848f5f6f3626623.ps@mail.parknet.co.jp>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
	<f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
In-Reply-To: <f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds LOOKUP_RENAME_NEW intent for lookup of rename destination.

LOOKUP_RENAME_NEW is going to be used like LOOKUP_CREATE. But since
the destination of rename() can be existing directory entry, so it has a
difference. Although that difference doesn't matter in my usage, this
tells it to user of this intent.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namei.c            |    1 +
 include/linux/namei.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/namei.c~dcache-add-rename-intent fs/namei.c
--- linux-2.6/fs/namei.c~dcache-add-rename-intent	2008-08-26 11:13:32.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2008-08-26 11:13:32.000000000 +0900
@@ -2660,6 +2660,7 @@ asmlinkage long sys_renameat(int olddfd,
 
 	oldnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags |= LOOKUP_RENAME_NEW;
 
 	trap = lock_rename(new_dir, old_dir);
 
diff -puN include/linux/namei.h~dcache-add-rename-intent include/linux/namei.h
--- linux-2.6/include/linux/namei.h~dcache-add-rename-intent	2008-08-26 11:13:32.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/namei.h	2008-08-26 11:13:32.000000000 +0900
@@ -53,6 +53,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
  */
 #define LOOKUP_OPEN		(0x0100)
 #define LOOKUP_CREATE		(0x0200)
+#define LOOKUP_RENAME_NEW	(0x0400)
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 
_
