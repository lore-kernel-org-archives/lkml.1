Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbXFFEpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbXFFEpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXFFEpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:45:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62602 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbXFFEpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:45:05 -0400
Date: Tue, 5 Jun 2007 21:43:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dwmw2@infradead.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH] MTD: use NULL for pointer
Message-Id: <20070605214336.7e53a726.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointer:
drivers/mtd/chips/cfi_cmdset_0001.c:2258:43: warning: Using plain integer as NULL pointer

Other changes by inspection.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc3-git7.orig/drivers/mtd/chips/cfi_cmdset_0001.c
+++ linux-2.6.22-rc3-git7/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1930,7 +1930,7 @@ static int cfi_intelext_lock(struct mtd_
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
 	       __FUNCTION__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	ret = cfi_varsize_frob(mtd, do_xxlock_oneblock,
@@ -1940,7 +1940,7 @@ static int cfi_intelext_lock(struct mtd_
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
 	       __FUNCTION__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	return ret;
@@ -1954,7 +1954,7 @@ static int cfi_intelext_unlock(struct mt
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
 	       __FUNCTION__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	ret = cfi_varsize_frob(mtd, do_xxlock_oneblock,
@@ -1964,7 +1964,7 @@ static int cfi_intelext_unlock(struct mt
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
 	       __FUNCTION__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	return ret;
@@ -2255,7 +2255,7 @@ static void cfi_intelext_save_locks(stru
 			adr = region->offset + block * len;
 
 			status = cfi_varsize_frob(mtd,
-					do_getlockstatus_oneblock, adr, len, 0);
+				do_getlockstatus_oneblock, adr, len, NULL);
 			if (status)
 				set_bit(block, region->lockmap);
 			else
