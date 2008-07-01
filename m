Return-Path: <linux-kernel-owner+w=401wt.eu-S1751124AbYGAC5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124AbYGAC5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYGAC5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:07 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52156 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYGAC5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:06 -0400
Subject: [PATCH 1/7] fat: Fix parse_options()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:02 +0900
Message-ID: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current parse_options() exits too early. We need to run the code of
bottom in this function even if users doesn't specify options.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat_default_opt-fix fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_default_opt-fix	2008-06-08 23:05:53.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-06-08 23:05:53.000000000 +0900
@@ -950,7 +950,7 @@ static int parse_options(char *options, 
 	*debug = 0;
 
 	if (!options)
-		return 0;
+		goto out;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -1104,10 +1104,13 @@ static int parse_options(char *options, 
 			return -EINVAL;
 		}
 	}
+
+out:
 	/* UTF-8 doesn't provide FAT semantics */
 	if (!strcmp(opts->iocharset, "utf8")) {
 		printk(KERN_ERR "FAT: utf8 is not a recommended IO charset"
-		       " for FAT filesystems, filesystem will be case sensitive!\n");
+		       " for FAT filesystems, filesystem will be "
+		       "case sensitive!\n");
 	}
 
 	/* If user doesn't specify allow_utime, it's initialized from dmask. */
_
