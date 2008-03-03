Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYCCRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYCCRO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbYCCROD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbYCCROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:00 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 02/52] merge extern function definitions
Date: Mon,  3 Mar 2008 14:12:30 -0300
Message-Id: <1204564400-17636-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-2-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move extern function definitions that are the same between smp_{32,64}.h
to smp.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |    3 +++
 include/asm-x86/smp_32.h |    4 ----
 include/asm-x86/smp_64.h |    4 ----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index f250d1c..ad7b99d 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -8,5 +8,8 @@
 # include "smp_64.h"
 #endif
 
+extern void smp_alloc_memory(void);
+extern void lock_ipi_call_lock(void);
+extern void unlock_ipi_call_lock(void);
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 56152e3..2781225 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -22,10 +22,6 @@ extern cpumask_t cpu_callin_map;
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 
-extern void smp_alloc_memory(void);
-extern void lock_ipi_call_lock(void);
-extern void unlock_ipi_call_lock(void);
-
 extern void (*mtrr_hook) (void);
 extern void zap_low_mappings (void);
 
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index e0a7551..2c21df2 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -19,10 +19,6 @@ extern cpumask_t cpu_initialized;
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 
-extern void smp_alloc_memory(void);
-extern void lock_ipi_call_lock(void);
-extern void unlock_ipi_call_lock(void);
-
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-- 
1.5.0.6

