Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZAGMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZAGMBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZAGMBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:01:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:47339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZAGMA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:00:59 -0500
Subject: [PATCH -tip 2/7] x86: smp.h move zap_low_mappings declartion to
	tlbflush.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 17:26:35 +0530
Message-Id: <1231329395.17961.31.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/smp.h      |    2 --
 arch/x86/include/asm/tlbflush.h |    2 ++
 arch/x86/mm/init_32.c           |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 643a3a0..d2ab0ed 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -39,8 +39,6 @@ extern cpumask_t cpu_sibling_setup_map;
 
 #endif /* CONFIG_X86_32 */
 
-extern void zap_low_mappings(void);
-
 extern int __cpuinit get_local_pda(int cpu);
 
 extern int smp_num_siblings;
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0e7bbb5..aed0b70 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -175,4 +175,6 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
+extern void zap_low_mappings(void);
+
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index e47efd9..6b1bedc 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -49,7 +49,6 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
-#include <asm/smp.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
-- 
1.5.6.6



