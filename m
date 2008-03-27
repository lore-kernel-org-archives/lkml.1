Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbYC0RNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbYC0RNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760052AbYC0RLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759874AbYC0RLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:09 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 5/9] [PATCH] x86: merge includes in smp.h
Date: Thu, 27 Mar 2008 14:06:00 -0300
Message-Id: <12066375851799-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move all include directives from smp_{32,64}.h to smp.h.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |   13 +++++++++++++
 include/asm-x86/smp_32.h |   13 -------------
 include/asm-x86/smp_64.h |   16 ----------------
 3 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index eb05804..1cd434d 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -5,6 +5,19 @@
 #include <linux/init.h>
 #include <asm/percpu.h>
 
+/*
+ * We need the APIC definitions automatically as part of 'smp.h'
+ */
+#ifdef CONFIG_X86_LOCAL_APIC
+# include <asm/mpspec.h>
+# include <asm/apic.h>
+# ifdef CONFIG_X86_IO_APIC
+#  include <asm/io_apic.h>
+# endif
+#endif
+#include <asm/pda.h>
+#include <asm/thread_info.h>
+
 extern cpumask_t cpu_callout_map;
 
 extern int smp_num_siblings;
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 53432db..694d324 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -2,19 +2,6 @@
 #define __ASM_SMP_H
 
 #ifndef __ASSEMBLY__
-#include <linux/cpumask.h>
-#include <linux/init.h>
-
-/*
- * We need the APIC definitions automatically as part of 'smp.h'
- */
-#ifdef CONFIG_X86_LOCAL_APIC
-# include <asm/mpspec.h>
-# include <asm/apic.h>
-# ifdef CONFIG_X86_IO_APIC
-#  include <asm/io_apic.h>
-# endif
-#endif
 
 extern cpumask_t cpu_callin_map;
 
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index b83151d..eead92e 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -1,22 +1,6 @@
 #ifndef __ASM_SMP_H
 #define __ASM_SMP_H
 
-#include <linux/cpumask.h>
-#include <linux/init.h>
-
-/*
- * We need the APIC definitions automatically as part of 'smp.h'
- */
-#ifdef CONFIG_X86_LOCAL_APIC
-#  include <asm/mpspec.h>
-#  include <asm/apic.h>
-#  ifdef CONFIG_X86_IO_APIC
-#   include <asm/io_apic.h>
-#  endif
-#endif
-#include <asm/pda.h>
-#include <asm/thread_info.h>
-
 extern cpumask_t cpu_initialized;
 extern cpumask_t cpu_callin_map;
 
-- 
1.5.0.6

