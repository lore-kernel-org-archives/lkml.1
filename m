Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622Ab0BZRjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:39:40 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39741 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513Ab0BZRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:05 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7R-01-R6I-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 15/15] perf, x86: rename macro in ARCH_PERFMON_EVENTSEL_ENABLE
Date: Fri, 26 Feb 2010 18:30:07 +0100
Message-ID: <1267205407-6523-16-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0679 (UTC) FILETIME=[21B8B6F0:01CAB70A]
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
 arch/x86/oprofile/op_model_amd.c       |    6 +++---
 arch/x86/oprofile/op_model_ppro.c      |    6 +++---
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 237c3d9..4ac9118 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -18,7 +18,7 @@
 #define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
-#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			  (1 << 22)
 #define ARCH_PERFMON_EVENTSEL_ANY			  (1 << 21)
 #define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
 #define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8c1c070..ee526df 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1069,7 +1069,7 @@ static void p6_pmu_disable_all(void)
 
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
@@ -1111,9 +1111,9 @@ static void amd_pmu_disable_all(void)
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
@@ -1138,7 +1138,7 @@ static void p6_pmu_enable_all(void)
 
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
@@ -1184,7 +1184,7 @@ static void amd_pmu_enable_all(void)
 			continue;
 
 		val = event->hw.config;
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 }
@@ -1213,7 +1213,7 @@ static inline void intel_pmu_ack_status(u64 ack)
 static inline void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	(void)checking_wrmsrl(hwc->config_base + idx,
-			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
+			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
@@ -1241,7 +1241,7 @@ p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
 	u64 val = P6_NOP_EVENT;
 
 	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
@@ -1366,7 +1366,7 @@ static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 
 	val = hwc->config;
 	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 898df97..b2c7814 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -691,7 +691,7 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	cpu_nmi_set_wd_enabled();
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	evntsel |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
 	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 8ddb9fa..090cbbe 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -171,7 +171,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 			continue;
 		}
 		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
@@ -398,7 +398,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 
@@ -418,7 +418,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 5d1727b..2bf90fa 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -88,7 +88,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 			continue;
 		}
 		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
@@ -166,7 +166,7 @@ static void ppro_start(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 			wrmsrl(msrs->controls[i].addr, val);
 		}
 	}
@@ -184,7 +184,7 @@ static void ppro_stop(struct op_msrs const * const msrs)
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


