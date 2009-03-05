Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZCENLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZCENLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZCENIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:43 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39717 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZCENIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:39 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/17] x86: move function and variable declarations to asm/init.h
Date: Thu,  5 Mar 2009 14:55:08 +0200
Message-Id: <1236257708-27269-17-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/include/asm/init.h |   18 ++++++++++++++++++
 arch/x86/mm/init.c          |   10 +---------
 arch/x86/mm/init_32.c       |    6 +-----
 arch/x86/mm/init_64.c       |    5 +----
 4 files changed, 21 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/include/asm/init.h

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
new file mode 100644
index 0000000..36fb1a6
--- /dev/null
+++ b/arch/x86/include/asm/init.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_INIT_32_H
+#define _ASM_X86_INIT_32_H
+
+#ifdef CONFIG_X86_32
+extern void __init early_ioremap_page_table_range_init(void);
+#endif
+
+extern unsigned long __init
+kernel_physical_mapping_init(unsigned long start,
+			     unsigned long end,
+			     unsigned long page_size_mask);
+
+
+extern unsigned long __initdata e820_table_start;
+extern unsigned long __meminitdata e820_table_end;
+extern unsigned long __meminitdata e820_table_top;
+
+#endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6475693..6d63e3d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -3,21 +3,13 @@
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
+#include <asm/init.h>
 #include <asm/page.h>
 #include <asm/page_types.h>
 #include <asm/sections.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
 
-#ifdef CONFIG_X86_32
-extern void __init early_ioremap_page_table_range_init(void);
-#endif
-
-extern unsigned long __init
-kernel_physical_mapping_init(unsigned long start,
-			     unsigned long end,
-			     unsigned long page_size_mask);
-
 unsigned long __initdata e820_table_start;
 unsigned long __meminitdata e820_table_end;
 unsigned long __meminitdata e820_table_top;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5ca9c6c..1669693 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -49,6 +49,7 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
+#include <asm/init.h>
 
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
@@ -58,11 +59,6 @@ unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
 
-
-extern unsigned long __initdata e820_table_start;
-extern unsigned long __meminitdata e820_table_end;
-extern unsigned long __meminitdata e820_table_top;
-
 static __init void *alloc_low_page(void)
 {
 	unsigned long pfn = e820_table_end++;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f441ae3..7dd7ce4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -48,6 +48,7 @@
 #include <asm/kdebug.h>
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
+#include <asm/init.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -283,10 +284,6 @@ void __init cleanup_highmap(void)
 	}
 }
 
-extern unsigned long __initdata e820_table_start;
-extern unsigned long __meminitdata e820_table_end;
-extern unsigned long __meminitdata e820_table_top;
-
 static __ref void *alloc_low_page(unsigned long *phys)
 {
 	unsigned long pfn = e820_table_end++;
-- 
1.5.4.3

