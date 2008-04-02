Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbYDBVvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbYDBVvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761221AbYDBVpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:46 -0400
Received: from saeurebad.de ([85.214.36.134]:60459 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763354AbYDBVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:45 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 21/22] xtensa: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:27 +0200
Message-Id: <12071690651034-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 0e3b68c..9fc8551 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -163,9 +163,6 @@ config XTENSA_ISS_NETWORK
 	depends on XTENSA_PLATFORM_ISS
 	default y
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 
 endmenu
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 81d0560..303fa3e 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -280,33 +280,6 @@ void free_initmem(void)
 	       (&__init_end - &__init_begin) >> 10);
 }
 
-void show_mem(void)
-{
-	int i, free = 0, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n",cached);
-	printk("%d free pages\n", free);
-}
-
 struct kmem_cache *pgtable_cache __read_mostly;
 
 static void pgd_ctor(struct kmem_cache *cache, void* addr)
-- 
1.5.2.2

