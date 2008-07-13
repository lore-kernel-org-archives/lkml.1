Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYGMBtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYGMBtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYGMBt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:49:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:42261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYGMBt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:49:28 -0400
Subject: [PATCH] x86-rest: fix sparse warnings
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Sun, 13 Jul 2008 07:18:50 +0530
Message-Id: <1215913730.2711.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CHECK   arch/x86/mm/init_32.c
arch/x86/mm/init_32.c:290:13: warning: symbol 'add_one_highpage_init' was not declared. Should it be static?
arch/x86/mm/init_32.c:437:6: warning: symbol 'zap_low_mappings' was not declared. Should it be static?
arch/x86/mm/init_32.c:774:6: warning: symbol 'free_initmem' was not declared. Should it be static?

CHECK   arch/x86/mm/fault.c
arch/x86/mm/fault.c:581:16: warning: symbol 'do_page_fault' was not declared. Should it be static?

CHECK   arch/x86/mm/pat.c
arch/x86/mm/pat.c:566:6: warning: symbol 'map_devmem' was not declared. Should it be static?
arch/x86/mm/pat.c:583:6: warning: symbol 'unmap_devmem' was not declared. Should it be static?

CHECK   arch/x86/mm/pgtable_32.c
arch/x86/mm/pgtable_32.c:115:6: warning: symbol 'set_pmd_pfn' was not declared. Should it be static?

CHECK   arch/x86/mach-default/setup.c
arch/x86/mach-default/setup.c:19:5: warning: symbol 'no_broadcast' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/mach-default/setup.c |    2 +-
 include/asm-x86/pat.h         |    3 +++
 include/asm-x86/pgtable_32.h  |    6 ++++++
 include/asm-x86/setup.h       |    1 +
 4 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index 0c28a07..dac2bd9 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -16,7 +16,7 @@
 #define DEFAULT_SEND_IPI	(0)
 #endif
 
-int no_broadcast=DEFAULT_SEND_IPI;
+int no_broadcast = DEFAULT_SEND_IPI;
 
 /**
  * pre_intr_init_hook - initialisation prior to setting up interrupt vectors
diff --git a/include/asm-x86/pat.h b/include/asm-x86/pat.h
index 88f60cc..e17830e 100644
--- a/include/asm-x86/pat.h
+++ b/include/asm-x86/pat.h
@@ -20,5 +20,8 @@ extern int free_memtype(u64 start, u64 end);
 
 extern void pat_disable(char *reason);
 
+extern void map_devmem(unsigned long, unsigned long, pgprot_t);
+extern void unmap_devmem(unsigned long, unsigned long, pgprot_t);
+
 #endif
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 32ca031..2f3322c 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -31,6 +31,12 @@ static inline void pgtable_cache_init(void) { }
 static inline void check_pgt_cache(void) { }
 void paging_init(void);
 
+void __init add_one_highpage_init(struct page *, int pfn, int);
+void zap_low_mappings(void);
+void free_initmem(void);
+void do_page_fault(struct pt_regs *regs, unsigned long error_code);
+
+void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
 
 /*
  * The Linux x86 paging architecture is 'compile-time dual-mode', it
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index b9b6494..1997ee6 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -8,6 +8,7 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
+extern int no_broadcast;
 char *machine_specific_memory_setup(void);
 
 extern unsigned long saved_video_mode;
-- 
1.5.5.1



