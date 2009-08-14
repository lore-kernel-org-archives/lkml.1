Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZHNMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZHNMnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZHNMnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:16 -0400
Received: from www.tglx.de ([62.245.132.106]:49770 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732AbZHNMnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:12 -0400
Message-Id: <20090814123548.497840636@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:43:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 07/11] isofs: cleanup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=isofs-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks and the NULLification of the pointers as the data structure
which contains the pointers is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/isofs/inode.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/fs/isofs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/isofs/inode.c
+++ linux-2.6-tip/fs/isofs/inode.c
@@ -46,10 +46,7 @@ static void isofs_put_super(struct super
 #ifdef CONFIG_JOLIET
 	lock_kernel();
 
-	if (sbi->s_nls_iocharset) {
-		unload_nls(sbi->s_nls_iocharset);
-		sbi->s_nls_iocharset = NULL;
-	}
+	unload_nls(sbi->s_nls_iocharset);
 
 	unlock_kernel();
 #endif
@@ -912,8 +909,7 @@ out_no_root:
 		printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_no_inode:
 #ifdef CONFIG_JOLIET
-	if (sbi->s_nls_iocharset)
-		unload_nls(sbi->s_nls_iocharset);
+	unload_nls(sbi->s_nls_iocharset);
 #endif
 	goto out_freesbi;
 out_no_read:


