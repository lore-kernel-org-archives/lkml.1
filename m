Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYDDNCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYDDNCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbYDDM5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:57:09 -0400
Received: from saeurebad.de ([85.214.36.134]:44769 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760239AbYDDM5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:57:07 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:31 2008
Message-Id: <20080404115231.602003363@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:44 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 07/22 -v2] frv: Use generic show_mem()
Content-Disposition: inline; filename=frv-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()

where show_mem() calls show_free_areas().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: David Howells <dhowells@redhat.com>
---

Index: tree-linus/arch/frv/Kconfig
===================================================================
--- tree-linus.orig/arch/frv/Kconfig
+++ tree-linus/arch/frv/Kconfig
@@ -6,7 +6,6 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config ZONE_DMA
 	bool
Index: tree-linus/arch/frv/mm/init.c
===================================================================
--- tree-linus.orig/arch/frv/mm/init.c
+++ tree-linus/arch/frv/mm/init.c
@@ -60,37 +60,6 @@ unsigned long empty_zero_page;
 
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

