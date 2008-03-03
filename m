Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbYCCRQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbYCCRQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYCCROQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758508AbYCCROJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:09 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 03/52] merge extern variables definitions
Date: Mon,  3 Mar 2008 14:12:31 -0300
Message-Id: <1204564400-17636-4-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-3-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move extern definitions that are the same between smp_{32,64}.h
to smp.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |    6 ++++++
 include/asm-x86/smp_32.h |    4 ----
 include/asm-x86/smp_64.h |    4 ----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index ad7b99d..c130a87 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_X86_SMP_H_
 #define _ASM_X86_SMP_H_
 #ifndef __ASSEMBLY__
+#include <linux/cpumask.h>
+
+extern cpumask_t cpu_callout_map;
+
+extern int smp_num_siblings;
+extern unsigned int num_processors;
 
 #ifdef CONFIG_X86_32
 # include "smp_32.h"
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 2781225..9a4057d 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -16,12 +16,8 @@
 # endif
 #endif
 
-extern cpumask_t cpu_callout_map;
 extern cpumask_t cpu_callin_map;
 
-extern int smp_num_siblings;
-extern unsigned int num_processors;
-
 extern void (*mtrr_hook) (void);
 extern void zap_low_mappings (void);
 
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 2c21df2..284f701 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -13,12 +13,8 @@
 #include <asm/pda.h>
 #include <asm/thread_info.h>
 
-extern cpumask_t cpu_callout_map;
 extern cpumask_t cpu_initialized;
 
-extern int smp_num_siblings;
-extern unsigned int num_processors;
-
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-- 
1.5.0.6

