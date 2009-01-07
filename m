Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZAGMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZAGMoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZAGMnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:43:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:60968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZAGMnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:43:49 -0500
Subject: [PATCH -tip 3/7] x86: smp.h move prefill_possible_map declartion
	to cpu.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 18:11:35 +0530
Message-Id: <1231332095.18558.10.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu.h |   10 ++++++++++
 arch/x86/include/asm/smp.h |    6 ------
 arch/x86/kernel/setup.c    |    2 +-
 arch/x86/kernel/smpboot.c  |    1 -
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index bae482d..29aa6d0 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -7,6 +7,16 @@
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
 
+#ifdef CONFIG_SMP
+
+extern void prefill_possible_map(void);
+
+#else /* CONFIG_SMP */
+
+static inline void prefill_possible_map(void) {}
+
+#endif /* CONFIG_SMP */
+
 struct x86_cpu {
 	struct cpu cpu;
 };
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index d2ab0ed..a151651 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -164,8 +164,6 @@ void play_dead_common(void);
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 
-extern void prefill_possible_map(void);
-
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
@@ -174,10 +172,6 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
-#else
-static inline void prefill_possible_map(void)
-{
-}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ae0d804..f41c448 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -89,7 +89,7 @@
 
 #include <asm/system.h>
 #include <asm/vsyscall.h>
-#include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
 #include <asm/dma.h>
 #include <asm/iommu.h>
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bb1a3b1..6c2b844 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -53,7 +53,6 @@
 #include <asm/nmi.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/smp.h>
 #include <asm/trampoline.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
-- 
1.5.6.6



