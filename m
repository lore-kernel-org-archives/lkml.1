Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbYDBVns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbYDBVns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbYDBVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:42:44 -0400
Received: from saeurebad.de ([85.214.36.134]:59980 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762343AbYDBVmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:42:43 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 05/22] blackfin: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:11 +0200
Message-Id: <12071688843479-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index a8cc977..589c6ac 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -526,9 +526,6 @@ config BFIN_SCRATCH_REG_CYCLES
 
 endchoice
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 endmenu
 
 
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index ec3141f..4d5326e 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -53,33 +53,6 @@ static unsigned long empty_bad_page;
 
 unsigned long empty_zero_page;
 
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	int cached = 0;
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map + i))
-			reserved++;
-		else if (PageSwapCache(mem_map + i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d free pages\n", free);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
-- 
1.5.2.2

