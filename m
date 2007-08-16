Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbXHPXj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbXHPXj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXHPXjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:39:49 -0400
Received: from deeprooted.net ([216.254.16.51]:37510 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754519AbXHPXjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:39:48 -0400
Message-Id: <20070816233931.552072046@mvista.com>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 16:39:31 -0700
From: Kevin Hilman <khilman@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: RT-Users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.23-rc2-rt2] misc. compile fixes for UP builds
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Hilman <khilman@mvista.com>
---
 include/linux/percpu_list.h |    2 +-
 include/linux/smp.h         |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: dev/include/linux/percpu_list.h
===================================================================
--- dev.orig/include/linux/percpu_list.h
+++ dev/include/linux/percpu_list.h
@@ -84,7 +84,7 @@ void percpu_list_fold(struct percpu_list
 
 struct percpu_list {
 	struct lock_list_head list;
-}
+};
 
 static inline
 void percpu_list_init(struct percpu_list *pcl)
Index: dev/include/linux/smp.h
===================================================================
--- dev.orig/include/linux/smp.h
+++ dev/include/linux/smp.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/cpumask.h>
 
 extern void cpu_idle(void);
 
@@ -116,7 +117,7 @@ static inline int up_smp_call_function(v
 	})
 static inline void smp_send_reschedule(int cpu) { }
 static inline void smp_send_reschedule_allbutself(void) { }
-static inline void smp_send_reschedule_allbutself_cpumask(cpumask_t) { }
+static inline void smp_send_reschedule_allbutself_cpumask(cpumask_t mask) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
 #define smp_call_function_single(cpuid, func, info, retry, wait) \
--
