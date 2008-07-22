Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYGVTZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYGVTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYGVTXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:55 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:15938 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYGVTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:52 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VA-01-8PI-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/24] x86/oprofile: Renaming athlon_*() into op_amd_*()
Date: Tue, 22 Jul 2008 21:08:50 +0200
Message-ID: <1216753748-11261-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0261 (UTC) FILETIME=[71D7C2D0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions contain code for all AMD CPUs. The new names fit
better.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c         |    8 ++++----
 arch/x86/oprofile/op_model_athlon.c |   28 ++++++++++++++--------------
 arch/x86/oprofile/op_x86_model.h    |    2 +-
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b96cfd3..4e42b50 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -411,21 +411,21 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		default:
 			return -ENODEV;
 		case 6:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "i386/athlon";
 			break;
 		case 0xf:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			/* Actually it could be i386/hammer too, but give
 			 user space an consistent name. */
 			cpu_type = "x86-64/hammer";
 			break;
 		case 0x10:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "x86-64/family10";
 			break;
 		case 0x11:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "x86-64/family11h";
 			break;
 		}
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index d25d7f1..40ecb02 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -45,9 +45,9 @@
 
 static unsigned long reset_value[NUM_COUNTERS];
 
-/* functions for op_athlon_spec */
+/* functions for op_amd_spec */
 
-static void athlon_fill_in_addresses(struct op_msrs * const msrs)
+static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
 
@@ -67,7 +67,7 @@ static void athlon_fill_in_addresses(struct op_msrs * const msrs)
 }
 
 
-static void athlon_setup_ctrs(struct op_msrs const * const msrs)
+static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
@@ -116,7 +116,7 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 }
 
 
-static int athlon_check_ctrs(struct pt_regs * const regs,
+static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
@@ -137,7 +137,7 @@ static int athlon_check_ctrs(struct pt_regs * const regs,
 }
 
 
-static void athlon_start(struct op_msrs const * const msrs)
+static void op_amd_start(struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
@@ -151,7 +151,7 @@ static void athlon_start(struct op_msrs const * const msrs)
 }
 
 
-static void athlon_stop(struct op_msrs const * const msrs)
+static void op_amd_stop(struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
@@ -167,7 +167,7 @@ static void athlon_stop(struct op_msrs const * const msrs)
 	}
 }
 
-static void athlon_shutdown(struct op_msrs const * const msrs)
+static void op_amd_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
@@ -190,15 +190,15 @@ static void op_amd_exit(void)
 {
 }
 
-struct op_x86_model_spec const op_athlon_spec = {
+struct op_x86_model_spec const op_amd_spec = {
 	.init = op_amd_init,
 	.exit = op_amd_exit,
 	.num_counters = NUM_COUNTERS,
 	.num_controls = NUM_CONTROLS,
-	.fill_in_addresses = &athlon_fill_in_addresses,
-	.setup_ctrs = &athlon_setup_ctrs,
-	.check_ctrs = &athlon_check_ctrs,
-	.start = &athlon_start,
-	.stop = &athlon_stop,
-	.shutdown = &athlon_shutdown
+	.fill_in_addresses = &op_amd_fill_in_addresses,
+	.setup_ctrs = &op_amd_setup_ctrs,
+	.check_ctrs = &op_amd_check_ctrs,
+	.start = &op_amd_start,
+	.stop = &op_amd_stop,
+	.shutdown = &op_amd_shutdown
 };
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index ee9ca96..05a0261 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -48,6 +48,6 @@ struct op_x86_model_spec {
 extern struct op_x86_model_spec const op_ppro_spec;
 extern struct op_x86_model_spec const op_p4_spec;
 extern struct op_x86_model_spec const op_p4_ht2_spec;
-extern struct op_x86_model_spec const op_athlon_spec;
+extern struct op_x86_model_spec const op_amd_spec;
 
 #endif /* OP_X86_MODEL_H */
-- 
1.5.5.4


