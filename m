Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZHNMnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZHNMnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZHNMm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:42:57 -0400
Received: from www.tglx.de ([62.245.132.106]:49731 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbZHNMm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:42:56 -0400
Message-Id: <20090814123548.253956341@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:42:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 03/11] befs: cleanup befs_put_super()
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=befs-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks and the NULLification of the pointer as the data structure
which contains the pointer is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/befs/linuxvfs.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6-tip/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6-tip.orig/fs/befs/linuxvfs.c
+++ linux-2.6-tip/fs/befs/linuxvfs.c
@@ -737,12 +737,7 @@ befs_put_super(struct super_block *sb)
 {
 	kfree(BEFS_SB(sb)->mount_opts.iocharset);
 	BEFS_SB(sb)->mount_opts.iocharset = NULL;
-
-	if (BEFS_SB(sb)->nls) {
-		unload_nls(BEFS_SB(sb)->nls);
-		BEFS_SB(sb)->nls = NULL;
-	}
-
+	unload_nls(BEFS_SB(sb)->nls);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }


