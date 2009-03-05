Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbZCENoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbZCENoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZCENjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:39:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:50082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZCENja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:39:30 -0500
Date: Thu, 5 Mar 2009 13:38:58 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-17-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-17-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: move function and variable declarations to asm/init.h
Message-ID: <tip-4fcb208391be5cf82c6fe2779c5eb9245ac97e91@git.kernel.org>
Git-Commit-ID: 4fcb208391be5cf82c6fe2779c5eb9245ac97e91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:39:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fcb208391be5cf82c6fe2779c5eb9245ac97e91
Gitweb:     http://git.kernel.org/tip/4fcb208391be5cf82c6fe2779c5eb9245ac97e91
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:55:08 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:18 +0100

x86: move function and variable declarations to asm/init.h

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-17-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/init.h |   18 ++++++++++++++++++
 arch/x86/mm/init.c          |   10 +---------
 arch/x86/mm/init_32.c       |    6 +-----
 arch/x86/mm/init_64.c       |    5 +----
 4 files changed, 21 insertions(+), 18 deletions(-)

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
