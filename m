Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZG1RSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZG1RSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZG1RSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:31 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9627 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753489AbZG1RSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DR-03-BM4-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 17/26] x86/oprofile: Remove const qualifier from struct op_x86_model_spec
Date: Tue, 28 Jul 2009 19:07:17 +0200
Message-ID: <1248800846-25422-18-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:50.0134 (UTC) FILETIME=[5577A560:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the const qualifier from struct
op_x86_model_spec to make model parameters changable.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    4 ++--
 arch/x86/oprofile/op_model_amd.c  |    2 +-
 arch/x86/oprofile/op_model_p4.c   |    4 ++--
 arch/x86/oprofile/op_model_ppro.c |    2 +-
 arch/x86/oprofile/op_x86_model.h  |    8 ++++----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 998c7dc..826f391 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -27,7 +27,7 @@
 #include "op_counter.h"
 #include "op_x86_model.h"
 
-static struct op_x86_model_spec const *model;
+static struct op_x86_model_spec *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
@@ -542,7 +542,7 @@ module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
-	struct op_x86_model_spec const *spec = &op_ppro_spec;	/* default */
+	struct op_x86_model_spec *spec = &op_ppro_spec;	/* default */
 
 	if (force_arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 644980f..39604b4 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -526,7 +526,7 @@ static void op_amd_exit(void) {}
 
 #endif /* CONFIG_OPROFILE_IBS */
 
-struct op_x86_model_spec const op_amd_spec = {
+struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
 	.num_virt_counters	= NUM_VIRT_COUNTERS,
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 65b9237..40df028 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -695,7 +695,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 
 
 #ifdef CONFIG_SMP
-struct op_x86_model_spec const op_p4_ht2_spec = {
+struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
 	.num_controls		= NUM_CONTROLS_HT2,
 	.num_virt_counters	= NUM_COUNTERS_HT2,
@@ -709,7 +709,7 @@ struct op_x86_model_spec const op_p4_ht2_spec = {
 };
 #endif
 
-struct op_x86_model_spec const op_p4_spec = {
+struct op_x86_model_spec op_p4_spec = {
 	.num_counters		= NUM_COUNTERS_NON_HT,
 	.num_controls		= NUM_CONTROLS_NON_HT,
 	.num_virt_counters	= NUM_COUNTERS_NON_HT,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 098cbca..659f3b6 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -203,7 +203,7 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 }
 
 
-struct op_x86_model_spec const op_ppro_spec = {
+struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
 	.num_virt_counters	= 2,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index e874dc3..0c886fa 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -62,10 +62,10 @@ extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 			   struct op_counter_config *counter_config);
 extern int op_x86_phys_to_virt(int phys);
 
-extern struct op_x86_model_spec const op_ppro_spec;
-extern struct op_x86_model_spec const op_p4_spec;
-extern struct op_x86_model_spec const op_p4_ht2_spec;
-extern struct op_x86_model_spec const op_amd_spec;
+extern struct op_x86_model_spec op_ppro_spec;
+extern struct op_x86_model_spec op_p4_spec;
+extern struct op_x86_model_spec op_p4_ht2_spec;
+extern struct op_x86_model_spec op_amd_spec;
 extern struct op_x86_model_spec op_arch_perfmon_spec;
 
 #endif /* OP_X86_MODEL_H */
-- 
1.6.3.3


