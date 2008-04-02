Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYDBVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYDBVqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762837AbYDBVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:43:41 -0400
Received: from saeurebad.de ([85.214.36.134]:60118 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762830AbYDBVnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:43:40 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 10/22] m68k: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:16 +0200
Message-Id: <1207168941186-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 53b36a8..65db226 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -396,9 +396,6 @@ config NODES_SHIFT
 	default "3"
 	depends on !SINGLE_MEMORY_CHUNK
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 
 endmenu
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index f42caa7..19eb3ae 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -70,37 +70,6 @@ void __init m68k_setup_node(int node)
 
 void *empty_zero_page;
 
-void show_mem(void)
-{
-	pg_data_t *pgdat;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-	int cached = 0;
-	int i;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	for_each_online_pgdat(pgdat) {
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat->node_mem_map + i;
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 extern void init_pointer_table(unsigned long ptable);
 
 /* References to section boundaries */
-- 
1.5.2.2

