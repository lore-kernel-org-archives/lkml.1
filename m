Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZJFFxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZJFFxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZJFFxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:53:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51549 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbZJFFxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:53:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Bernd Schmidt <bernds_cb1@t-online.de>
Subject: [PATCH] ROMFS: fix length used with romfs_dev_strnlen() function
Date: Tue,  6 Oct 2009 01:53:02 -0400
Message-Id: <1254808382-3695-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernds_cb1@t-online.de>

An interestingly corrupted romfs file system exposed a problem with the
romfs_dev_strnlen function: it's passing the wrong value to its helpers.
Rather than limit the string to the length passed in by the callers, it
uses the size of the device as the limit.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fs/romfs/storage.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/romfs/storage.c b/fs/romfs/storage.c
index b3208ad..71e2b4d 100644
--- a/fs/romfs/storage.c
+++ b/fs/romfs/storage.c
@@ -253,11 +253,11 @@ ssize_t romfs_dev_strnlen(struct super_block *sb,
 
 #ifdef CONFIG_ROMFS_ON_MTD
 	if (sb->s_mtd)
-		return romfs_mtd_strnlen(sb, pos, limit);
+		return romfs_mtd_strnlen(sb, pos, maxlen);
 #endif
 #ifdef CONFIG_ROMFS_ON_BLOCK
 	if (sb->s_bdev)
-		return romfs_blk_strnlen(sb, pos, limit);
+		return romfs_blk_strnlen(sb, pos, maxlen);
 #endif
 	return -EIO;
 }
-- 
1.6.5.rc2

