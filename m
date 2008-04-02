Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbYDBVvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbYDBVvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbYDBVpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:35 -0400
Received: from saeurebad.de ([85.214.36.134]:60418 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761072AbYDBVpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 20/22] v850: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:26 +0200
Message-Id: <12071690544083-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index a4d8e72..4379f43 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -56,9 +56,6 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 # Turn off some random 386 crap that can affect device config
 config ISA
 	bool
diff --git a/arch/v850/kernel/setup.c b/arch/v850/kernel/setup.c
index a0a8456..5751709 100644
--- a/arch/v850/kernel/setup.c
+++ b/arch/v850/kernel/setup.c
@@ -298,33 +298,3 @@ init_mem_alloc (unsigned long ram_start, unsigned long ram_len)
 	free_area_init_node (0, NODE_DATA(0), zones_size,
 			     ADDR_TO_PAGE (PAGE_OFFSET), 0);
 }
-
-
-
-/* Taken from m68knommu */
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk(KERN_INFO "\nMem-info:\n");
-    show_free_areas();
-    i = max_mapnr;
-    while (i-- > 0) {
-	total++;
-	if (PageReserved(mem_map+i))
-	    reserved++;
-	else if (PageSwapCache(mem_map+i))
-	    cached++;
-	else if (!page_count(mem_map+i))
-	    free++;
-	else
-	    shared += page_count(mem_map+i) - 1;
-    }
-    printk(KERN_INFO "%d pages of RAM\n",total);
-    printk(KERN_INFO "%d free pages\n",free);
-    printk(KERN_INFO "%d reserved pages\n",reserved);
-    printk(KERN_INFO "%d pages shared\n",shared);
-    printk(KERN_INFO "%d pages swap cached\n",cached);
-}
-- 
1.5.2.2

