Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbYF0MOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbYF0MOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759125AbYF0MFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:05:46 -0400
Received: from saeurebad.de ([85.214.36.134]:39011 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521AbYF0MFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:05:45 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:48 2008
Message-Id: <20080627120048.813409767@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:53:56 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 07/20] frv: use generic show_mem()
Content-Disposition: inline; filename=0008-frv-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()

where show_mem() calls show_free_areas().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/frv/Kconfig   |    1 +
 arch/frv/mm/init.c |   31 -------------------------------
 2 files changed, 1 insertion(+), 31 deletions(-)

--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -6,6 +6,7 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_GENERIC_SHOW_MEM
 
 config ZONE_DMA
 	bool
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -63,37 +63,6 @@ EXPORT_SYMBOL(empty_zero_page);
 
 /*****************************************************************************/
 /*
- *
- */
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		struct page *page = &mem_map[i];
-
-		total++;
-		if (PageReserved(page))
-			reserved++;
-		else if (!page_count(page))
-			free++;
-		else
-			shared += page_count(page) - 1;
-	}
-
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-
-} /* end show_mem() */
-
-/*****************************************************************************/
-/*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
  * The parameters are pointers to where to stick the starting and ending

-- 

