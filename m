Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYDBVrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYDBVrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbYDBVoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:44:16 -0400
Received: from saeurebad.de ([85.214.36.134]:60213 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760691AbYDBVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:44:14 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 13/22] mn10300: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:19 +0200
Message-Id: <1207168975499-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index a20b8f6..6a6409a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -353,9 +353,6 @@ config MN10300_TTYSM2_CTS
 
 endmenu
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 
 menu "Power management options"
diff --git a/arch/mn10300/mm/pgtable.c b/arch/mn10300/mm/pgtable.c
index a477038..baffc58 100644
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -27,33 +27,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
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
  * Associate a large virtual page frame with a given physical page frame
  * and protection flags for that frame. pfn is for the base of the page,
-- 
1.5.2.2

