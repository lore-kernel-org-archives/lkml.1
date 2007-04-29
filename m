Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXD2LBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXD2LBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbXD2LBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:51221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbXD2Kw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@codemonkey.org.uk>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/48] x86_64: fix x86_64-mm-sched-clock-share
Message-Id: <20070429105248.A4C2B151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

Fix for the following patch. Provide dummy cpufreq functions when
CPUFREQ is not compiled in. 

Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/linux/cpufreq.h |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux/include/linux/cpufreq.h
===================================================================
--- linux.orig/include/linux/cpufreq.h
+++ linux/include/linux/cpufreq.h
@@ -32,7 +32,15 @@
  *                     CPUFREQ NOTIFIER INTERFACE                    *
  *********************************************************************/
 
+#ifdef CONFIG_CPU_FREQ
 int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
+#else
+static inline int cpufreq_register_notifier(struct notifier_block *nb,
+						unsigned int list)
+{
+	return 0;
+}
+#endif
 int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 
 #define CPUFREQ_TRANSITION_NOTIFIER	(0)
@@ -261,17 +269,22 @@ int cpufreq_set_policy(struct cpufreq_po
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 
-/* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
-unsigned int cpufreq_get(unsigned int cpu);
 
-/* query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it */
+/*
+ * query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it
+ */
 #ifdef CONFIG_CPU_FREQ
 unsigned int cpufreq_quick_get(unsigned int cpu);
+unsigned int cpufreq_get(unsigned int cpu);
 #else
 static inline unsigned int cpufreq_quick_get(unsigned int cpu)
 {
 	return 0;
 }
+static inline unsigned int cpufreq_get(unsigned int cpu)
+{
+	return 0;
+}
 #endif
 
 
