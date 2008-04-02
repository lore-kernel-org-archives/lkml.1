Return-Path: <linux-kernel-owner+w=401wt.eu-S1763061AbYDBVog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763061AbYDBVog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbYDBVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:43:07 -0400
Received: from saeurebad.de ([85.214.36.134]:60032 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759776AbYDBVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:43:05 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 07/22] frv: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:13 +0200
Message-Id: <12071689072627-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index c1a5aac..a5aac1b 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -107,9 +107,6 @@ config HIGHPTE
 	  with a lot of RAM, this can be wasteful of precious low memory.
 	  Setting this option will put user-space page tables in high memory.
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 
 choice
diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index b841ecf..f7a16d3 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
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
1.5.2.2

