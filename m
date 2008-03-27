Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbYC0RL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbYC0RL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYC0RK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:10:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbYC0RK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:10:58 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 9/9] [PATCH] x86: merge smp_32.h and smp_64.h into smp.h
Date: Thu, 27 Mar 2008 14:06:04 -0300
Message-Id: <12066376013319-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge what's left from smp_32.h and smp_64.h into smp.h
By now, they're basically extern definitions.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |   11 +++++------
 include/asm-x86/smp_32.h |   12 ------------
 include/asm-x86/smp_64.h |   11 -----------
 3 files changed, 5 insertions(+), 29 deletions(-)
 delete mode 100644 include/asm-x86/smp_32.h
 delete mode 100644 include/asm-x86/smp_64.h

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 5f6ea69..bd3778d 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -19,6 +19,11 @@
 #include <asm/thread_info.h>
 
 extern cpumask_t cpu_callout_map;
+extern cpumask_t cpu_initialized;
+extern cpumask_t cpu_callin_map;
+
+extern void (*mtrr_hook)(void);
+extern void zap_low_mappings(void);
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
@@ -166,12 +171,6 @@ extern int safe_smp_processor_id(void);
 #define stack_smp_processor_id() 	0
 #endif
 
-#ifdef CONFIG_X86_32
-# include "smp_32.h"
-#else
-# include "smp_64.h"
-#endif
-
 #ifdef CONFIG_X86_LOCAL_APIC
 
 static inline int logical_smp_processor_id(void)
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
deleted file mode 100644
index d9ae5ac..0000000
--- a/include/asm-x86/smp_32.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __ASM_SMP_H
-#define __ASM_SMP_H
-
-#ifndef __ASSEMBLY__
-
-extern cpumask_t cpu_callin_map;
-
-extern void (*mtrr_hook)(void);
-extern void zap_low_mappings(void);
-
-#endif /* !ASSEMBLY */
-#endif
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
deleted file mode 100644
index 058f413..0000000
--- a/include/asm-x86/smp_64.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef __ASM_SMP_H
-#define __ASM_SMP_H
-
-extern cpumask_t cpu_initialized;
-extern cpumask_t cpu_callin_map;
-
-extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-				  void *info, int wait);
-
-#endif
-
-- 
1.5.0.6

