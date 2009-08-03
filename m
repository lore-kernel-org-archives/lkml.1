Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZHCQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZHCQLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZHCQLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:11:45 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57221 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755371AbZHCQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:11:44 -0400
Date: Mon, 3 Aug 2009 18:11:42 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Drop superfluous casts in nr_free_pages() callers
Message-ID: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 96177299416dbccb73b54e6b344260154a445375 ("Drop free_pages()")
modified nr_free_pages() to return 'unsigned long' instead of 'unsigned int'.
This made the casts to 'unsigned long' in most callers superfluous, hence
remove them.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Tested on ppc64 only

 arch/alpha/mm/init.c      |    2 +-
 arch/alpha/mm/numa.c      |    2 +-
 arch/arm/mm/init.c        |    4 ++--
 arch/avr32/mm/init.c      |    2 +-
 arch/cris/mm/init.c       |    2 +-
 arch/ia64/mm/init.c       |    2 +-
 arch/m32r/mm/init.c       |    2 +-
 arch/m68k/mm/init.c       |    2 +-
 arch/microblaze/mm/init.c |    2 +-
 arch/mips/mm/init.c       |    2 +-
 arch/mn10300/mm/init.c    |    2 +-
 arch/parisc/mm/init.c     |    2 +-
 arch/powerpc/mm/mem.c     |    2 +-
 arch/s390/mm/init.c       |    2 +-
 arch/sh/mm/init.c         |    2 +-
 arch/sparc/mm/init_32.c   |    2 +-
 arch/um/kernel/mem.c      |    2 +-
 arch/x86/mm/init_32.c     |    2 +-
 arch/x86/mm/init_64.c     |    2 +-
 arch/xtensa/mm/init.c     |    2 +-
 20 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index af71d38..a0902c2 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -299,7 +299,7 @@ printk_memory_info(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, %luk data, %luk init)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       max_mapnr << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
index 0eab557..10b4035 100644
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -349,7 +349,7 @@ void __init mem_init(void)
 
 	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, "
 	       "%luk data, %luk init)\n",
-	       (unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8277802..bc927ee 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -536,8 +536,8 @@ void __init mem_init(void)
 
 	printk(KERN_NOTICE "Memory: %luKB available (%dK code, "
 		"%dK data, %dK init, %luK highmem)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		codesize >> 10, datasize >> 10, initsize >> 10,
+		nr_free_pages() << (PAGE_SHIFT-10), codesize >> 10,
+		datasize >> 10, initsize >> 10,
 		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
 
 	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index e819fa6..376f18c 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -141,7 +141,7 @@ void __init mem_init(void)
 
 	printk ("Memory: %luk/%luk available (%dk kernel code, "
 		"%dk reserved, %dk data, %dk init)\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
+		nr_free_pages() << (PAGE_SHIFT - 10),
 		totalram_pages << (PAGE_SHIFT - 10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT - 10),
diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index 514f46a..ff68b9f 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -54,7 +54,7 @@ mem_init(void)
         printk(KERN_INFO
                "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, "
 	       "%dk init)\n" ,
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       max_mapnr << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index b115b3b..1d28624 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -655,7 +655,7 @@ mem_init (void)
 	initsize =  (unsigned long) __init_end - (unsigned long) __init_begin;
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%luk code, %luk reserved, "
-	       "%luk data, %luk init)\n", (unsigned long) nr_free_pages() << (PAGE_SHIFT - 10),
+	       "%luk data, %luk init)\n", nr_free_pages() << (PAGE_SHIFT - 10),
 	       num_physpages << (PAGE_SHIFT - 10), codesize >> 10,
 	       reserved_pages << (PAGE_SHIFT - 10), datasize >> 10, initsize >> 10);
 
diff --git a/arch/m32r/mm/init.c b/arch/m32r/mm/init.c
index 24d429f..9f581df 100644
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -171,7 +171,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 		"%dk reserved, %dk data, %dk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 0007b2a..774549a 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -126,7 +126,7 @@ void __init mem_init(void)
 #endif
 
 	printk("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init)\n",
-	       (unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       totalram_pages << (PAGE_SHIFT-10),
 	       codepages << (PAGE_SHIFT-10),
 	       datapages << (PAGE_SHIFT-10),
diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 8d92c4e..506df16 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -204,7 +204,7 @@ void __init mem_init(void)
 	totalram_pages += free_all_bootmem();
 
 	printk(KERN_INFO "Memory: %luk/%luk available\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT-10));
 #ifdef CONFIG_MMU
 	mem_init_done = 1;
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 0e82050..1f9fced 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -417,7 +417,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       ram << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 8cee387..ec14205 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -112,7 +112,7 @@ void __init mem_init(void)
 	       "Memory: %luk/%luk available"
 	       " (%dk kernel code, %dk reserved, %dk data, %dk init,"
 	       " %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT - 10),
+	       nr_free_pages() << (PAGE_SHIFT - 10),
 	       max_mapnr << (PAGE_SHIFT - 10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT - 10),
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index b0831d9..d5aca31 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -506,7 +506,7 @@ void __init mem_init(void)
 #endif
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init)\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 579382c..0e5c59b 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -372,7 +372,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%luk kernel code, "
 	       "%luk reserved, %luk data, %luk bss, %luk init)\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index c634dfb..19f73cb 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -105,7 +105,7 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
         printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, %ldk data, %ldk init)\n",
-                (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+                nr_free_pages() << (PAGE_SHIFT-10),
                 max_mapnr << (PAGE_SHIFT-10),
                 codesize >> 10,
                 reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index fe532ae..3161a27 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -224,7 +224,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		datasize >> 10,
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 26bb391..ef05f5e 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -468,7 +468,7 @@ void __init mem_init(void)
 			reservedpages++;
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT - 10),
 	       codepages << (PAGE_SHIFT-10),
 	       reservedpages << (PAGE_SHIFT - 10),
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 61d7e61..a5d5e70 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -77,7 +77,7 @@ void __init mem_init(void)
 	num_physpages = totalram_pages;
 	max_pfn = totalram_pages;
 	printk(KERN_INFO "Memory: %luk available\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10));
+	       nr_free_pages() << (PAGE_SHIFT-10));
 	kmalloc_ok = 1;
 
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3cd7711..95e877f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -892,7 +892,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6176fe8..44f82a6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -687,7 +687,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		max_pfn << (PAGE_SHIFT-10),
 		codesize >> 10,
 		absent_pages << (PAGE_SHIFT-10),
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 427e14f..cdbc27c 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -203,7 +203,7 @@ void __init mem_init(void)
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
 	       "%ldk data, %ldk init %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       ram << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
-- 
1.6.2.4

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village � Da Vincilaan 7-D1 � B-1935 Zaventem � Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 � RPR Brussels
Fortis � BIC GEBABEBB � IBAN BE41293037680010
