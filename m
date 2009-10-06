Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZJFI4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZJFI4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZJFI4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbZJFI4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:56:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] ROMFS: fix length used with romfs_dev_strnlen() function
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bernd Schmidt <bernds_cb1@t-online.de>,
       Mike Frysinger <vapier@gentoo.org>, David Howells <dhowells@redhat.com>
Date: Tue, 06 Oct 2009 09:55:26 +0100
Message-ID: <20091006085525.15959.23053.stgit@warthog.procyon.org.uk>
In-Reply-To: <1254808382-3695-1-git-send-email-vapier@gentoo.org>
References: <1254808382-3695-1-git-send-email-vapier@gentoo.org>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Signed-off-by: David Howells <dhowells@redhat.com>
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

