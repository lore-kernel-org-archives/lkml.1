Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZHNMnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZHNMnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbZHNMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:15 -0400
Received: from www.tglx.de ([62.245.132.106]:49771 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbZHNMnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:12 -0400
Message-Id: <20090814123548.392759034@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:42:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 05/11] hfs: clenaup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=hfs-clenaup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/hfs/mdb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/fs/hfs/mdb.c
===================================================================
--- linux-2.6-tip.orig/fs/hfs/mdb.c
+++ linux-2.6-tip/fs/hfs/mdb.c
@@ -344,10 +344,8 @@ void hfs_mdb_put(struct super_block *sb)
 	brelse(HFS_SB(sb)->mdb_bh);
 	brelse(HFS_SB(sb)->alt_mdb_bh);
 
-	if (HFS_SB(sb)->nls_io)
-		unload_nls(HFS_SB(sb)->nls_io);
-	if (HFS_SB(sb)->nls_disk)
-		unload_nls(HFS_SB(sb)->nls_disk);
+	unload_nls(HFS_SB(sb)->nls_io);
+	unload_nls(HFS_SB(sb)->nls_disk);
 
 	free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
 	kfree(HFS_SB(sb));


