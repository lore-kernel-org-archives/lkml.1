Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYI2W2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYI2W2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYI2W2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:28:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYI2W2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:28:45 -0400
Date: Mon, 29 Sep 2008 18:27:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/2] revert: x86: move prefill_possible_map calling early,
 fix
Message-ID: <20080929182756.4e33b06b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

revert: x86: move prefill_possible_map calling early, fix

revert 4a7017370aa0a94a00ae5b5705e9169cdcae5fb8

This is the wrong fix: prefill_possible_map() needs to be available
even when CONFIG_HOTPLUG_CPU is not set. A followon patch will do that.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---

--- b/include/asm-x86/smp.h
+++ a/include/asm-x86/smp.h
@@ -116,6 +116,8 @@
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 
+extern void prefill_possible_map(void);
+
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
@@ -124,15 +126,11 @@
 {
 	return cpus_weight(cpu_callout_map);
 }
-#endif /* CONFIG_SMP */
-
-#if defined(CONFIG_SMP) && defined(CONFIG_HOTPLUG_CPU)
-extern void prefill_possible_map(void);
 #else
 static inline void prefill_possible_map(void)
 {
 }
+#endif /* CONFIG_SMP */
-#endif
 
 extern unsigned disabled_cpus __cpuinitdata;
 
