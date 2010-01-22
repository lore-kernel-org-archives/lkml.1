Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828Ab0AVOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0AVOzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178Ab0AVOzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:33 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:43013
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932151Ab0AVOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:27 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i87h6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFJ-02-1LD-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/12] perf/core, x86: rename macro in ARCH_PERFMON_EVENTSEL_ENABLE
Date: Fri, 22 Jan 2010 15:22:02 +0100
Message-ID: <1264170127-17402-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0533 (UTC) FILETIME=[DC22DDD0:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency reasons this patch renames
ARCH_PERFMON_EVENTSEL0_ENABLE to ARCH_PERFMON_EVENTSEL_ENABLE.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h      |    2 +-
 arch/x86/kernel/cpu/perf_event.c       |   16 ++++++++--------
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
 arch/x86/oprofile/op_model_amd.c       |    4 ++--
 arch/x86/oprofile/op_model_ppro.c      |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 1f50cfc..c7f723a 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -18,7 +18,7 @@
 #define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
-#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			  (1 << 22)
 #define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
 #define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
 #define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1863cda..96cbfe6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1051,7 +1051,7 @@ static void p6_pmu_disable_all(void)
 
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
@@ -1093,9 +1093,9 @@ static void amd_pmu_disable_all(void)
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
+		if (!(val & ARCH_PERFMON_EVENTSEL_ENABLE))
 			continue;
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 }
@@ -1120,7 +1120,7 @@ static void p6_pmu_enable_all(void)
 
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
@@ -1166,7 +1166,7 @@ static void amd_pmu_enable_all(void)
 			continue;
 
 		val = event->hw.config;
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 }
@@ -1195,7 +1195,7 @@ static inline void intel_pmu_ack_status(u64 ack)
 static inline void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	(void)checking_wrmsrl(hwc->config_base + idx,
-			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
+			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
@@ -1223,7 +1223,7 @@ p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
 	u64 val = P6_NOP_EVENT;
 
 	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
@@ -1341,7 +1341,7 @@ static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 
 	val = hwc->config;
 	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 74f4e85..fb329e9 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -680,7 +680,7 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	cpu_nmi_set_wd_enabled();
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	evntsel |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
 	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 39686c2..729e361 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -314,7 +314,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 
@@ -334,7 +334,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 4899215..be7f787 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -161,7 +161,7 @@ static void ppro_start(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 			wrmsrl(msrs->controls[i].addr, val);
 		}
 	}
@@ -179,7 +179,7 @@ static void ppro_stop(struct op_msrs const * const msrs)
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
-- 
1.6.6


