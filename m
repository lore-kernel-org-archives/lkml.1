Return-Path: <linux-kernel-owner+w=401wt.eu-S1762493AbYDDNNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762493AbYDDNNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbYDDNHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:07:22 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:35303 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761977AbYDDNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:07:21 -0400
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: <hannes@saeurebad.de>, "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "Mikael Starvik" <mikael.starvik@axis.com>
Subject: RE: [patch 06/22 -v2] cris: Use generic show_mem()
Date: Fri, 4 Apr 2008 15:07:17 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C40594@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66805CE3BBA@exmail1.se.axis.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: hannes@saeurebad.de [mailto:hannes@saeurebad.de] 
Sent: Friday, April 04, 2008 1:52 PM
To: LKML
Cc: Mikael Starvik
Subject: [patch 06/22 -v2] cris: Use generic show_mem()


Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Mikael Starvik <starvik@axis.com>
---

Index: tree-linus/arch/cris/Kconfig
===================================================================
--- tree-linus.orig/arch/cris/Kconfig
+++ tree-linus/arch/cris/Kconfig
@@ -55,7 +55,6 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config HZ
 	int
Index: tree-linus/arch/cris/mm/init.c
===================================================================
--- tree-linus.orig/arch/cris/mm/init.c
+++ tree-linus/arch/cris/mm/init.c
@@ -19,36 +19,6 @@ unsigned long empty_zero_page;
 extern char _stext, _edata, _etext; /* From linkerscript */
 extern char __init_begin, __init_end;
 
-void 
-show_mem(void)
-{
-	int i,free = 0,total = 0,cached = 0, reserved = 0, nonshared = 0;
-	int shared = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else if (page_count(mem_map+i) == 1)
-			nonshared++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages nonshared\n",nonshared);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 void __init
 mem_init(void)
 {

-- 

