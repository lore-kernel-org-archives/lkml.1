Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbXFLHcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbXFLHcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXFLHcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:32:07 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52933 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751527AbXFLHcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:32:04 -0400
Message-Id: <466E6842.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:32:50 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] kill vmalloc_earlyreserve
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This symbol got orphaned quite a while ago.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 include/asm-i386/pgtable.h |    2 +-
 include/linux/mm.h         |    1 -
 mm/memory.c                |    2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.22-rc4/include/asm-i386/pgtable.h	2007-06-11 18:10:43.000000000 +0200
+++ 2.6.22-rc4-vmalloc_earlyreserve/include/asm-i386/pgtable.h	2007-06-01 17:45:08.000000000 +0200
@@ -79,7 +79,7 @@ void paging_init(void);
  * area for the same reason. ;)
  */
 #define VMALLOC_OFFSET	(8*1024*1024)
-#define VMALLOC_START	(((unsigned long) high_memory + vmalloc_earlyreserve + \
+#define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
--- linux-2.6.22-rc4/include/linux/mm.h	2007-06-11 18:10:49.000000000 +0200
+++ 2.6.22-rc4-vmalloc_earlyreserve/include/linux/mm.h	2007-06-04 09:52:46.000000000 +0200
@@ -27,7 +27,6 @@ extern unsigned long max_mapnr;
 
 extern unsigned long num_physpages;
 extern void * high_memory;
-extern unsigned long vmalloc_earlyreserve;
 extern int page_cluster;
 
 #ifdef CONFIG_SYSCTL
--- linux-2.6.22-rc4/mm/memory.c	2007-06-11 18:10:51.000000000 +0200
+++ 2.6.22-rc4-vmalloc_earlyreserve/mm/memory.c	2007-06-01 17:45:08.000000000 +0200
@@ -78,11 +78,9 @@ unsigned long num_physpages;
  * and ZONE_HIGHMEM.
  */
 void * high_memory;
-unsigned long vmalloc_earlyreserve;
 
 EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
-EXPORT_SYMBOL(vmalloc_earlyreserve);
 
 int randomize_va_space __read_mostly = 1;
 



