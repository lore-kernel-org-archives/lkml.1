Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbYDBVsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbYDBVsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763207AbYDBVov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:44:51 -0400
Received: from saeurebad.de ([85.214.36.134]:60302 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763164AbYDBVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:44:48 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 16/22] ppc: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:22 +0200
Message-Id: <1207169009616-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index db5e6a1..abc877f 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -924,9 +924,6 @@ config HIGHMEM
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
 source "mm/Kconfig"
diff --git a/arch/ppc/mm/init.c b/arch/ppc/mm/init.c
index 7444df3..132031a 100644
--- a/arch/ppc/mm/init.c
+++ b/arch/ppc/mm/init.c
@@ -101,37 +101,6 @@ unsigned long __max_memory;
 /* max amount of low RAM to map in */
 unsigned long __max_low_memory = MAX_LOW_MEM;
 
-void show_mem(void)
-{
-	int i,free = 0,total = 0,reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageHighMem(mem_map+i))
-			highmem++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 /* Free up now-unused memory */
 static void free_sec(unsigned long start, unsigned long end, const char *name)
 {
-- 
1.5.2.2

