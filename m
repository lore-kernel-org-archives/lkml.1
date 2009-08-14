Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZHNMne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZHNMne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZHNMnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:32 -0400
Received: from www.tglx.de ([62.245.132.106]:49791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbZHNMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:17 -0400
Message-Id: <20090814123548.439872308@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:43:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 06/11] hfsplus: cleanup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=hfsplus-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/hfsplus/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/fs/hfsplus/super.c
===================================================================
--- linux-2.6-tip.orig/fs/hfsplus/super.c
+++ linux-2.6-tip/fs/hfsplus/super.c
@@ -229,8 +229,7 @@ static void hfsplus_put_super(struct sup
 	iput(HFSPLUS_SB(sb).alloc_file);
 	iput(HFSPLUS_SB(sb).hidden_dir);
 	brelse(HFSPLUS_SB(sb).s_vhbh);
-	if (HFSPLUS_SB(sb).nls)
-		unload_nls(HFSPLUS_SB(sb).nls);
+	unload_nls(HFSPLUS_SB(sb).nls);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 
@@ -464,8 +463,7 @@ out:
 
 cleanup:
 	hfsplus_put_super(sb);
-	if (nls)
-		unload_nls(nls);
+	unload_nls(nls);
 	return err;
 }
 


