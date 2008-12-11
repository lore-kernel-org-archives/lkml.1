Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYLKQtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYLKQtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYLKQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:40 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:18065 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYLKQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:39 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBQ1CM-01-7NX-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/10] oprofile: comment cleanup
Date: Thu, 11 Dec 2008 16:04:37 +0100
Message-ID: <1229007886-14362-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0792 (UTC) FILETIME=[49D64280:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the coding style of some comments.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   31 ++++++++++++++++---------------
 drivers/oprofile/cpu_buffer.c    |   25 ++++++++++++++++---------
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 5095137..fb67e19 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -65,8 +65,10 @@ static unsigned long reset_value[NUM_COUNTERS];
 #define IBS_FETCH_BEGIN 3
 #define IBS_OP_BEGIN    4
 
-/* The function interface needs to be fixed, something like add
-   data. Should then be added to linux/oprofile.h. */
+/*
+ * The function interface needs to be fixed, something like add
+ * data. Should then be added to linux/oprofile.h.
+ */
 extern void
 oprofile_add_ibs_sample(struct pt_regs *const regs,
 			unsigned int *const ibs_sample, int ibs_code);
@@ -106,7 +108,7 @@ struct ibs_op_sample {
 
 /*
  * unitialize the APIC for the IBS interrupts if needed on AMD Family10h+
-*/
+ */
 static void clear_ibs_nmi(void);
 
 static int ibs_allowed;	/* AMD Family10h and later */
@@ -223,7 +225,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 						(unsigned int *)&ibs_fetch,
 						IBS_FETCH_BEGIN);
 
-			/*reenable the IRQ */
+			/* reenable the IRQ */
 			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 			high &= ~IBS_FETCH_HIGH_VALID_BIT;
 			high |= IBS_FETCH_HIGH_ENABLE;
@@ -331,8 +333,10 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
-	/* Subtle: stop on all counters to avoid race with
-	 * setting our pm callback */
+	/*
+	 * Subtle: stop on all counters to avoid race with setting our
+	 * pm callback
+	 */
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -343,13 +347,15 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 
 #ifdef CONFIG_OPROFILE_IBS
 	if (ibs_allowed && ibs_config.fetch_enabled) {
-		low = 0;		/* clear max count and enable */
+		/* clear max count and enable */
+		low = 0;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 	}
 
 	if (ibs_allowed && ibs_config.op_enabled) {
-		low = 0;		/* clear max count and enable */
+		/* clear max count and enable */
+		low = 0;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 	}
@@ -443,10 +449,7 @@ static int pfm_amd64_setup_eilvt(void)
 	return 0;
 }
 
-/*
- * initialize the APIC for the IBS interrupts
- * if available (AMD Family10h rev B0 and later)
- */
+/* initialize the APIC for the IBS interrupts if available */
 static void setup_ibs(void)
 {
 	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
@@ -463,9 +466,7 @@ static void setup_ibs(void)
 }
 
 
-/*
- * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
- * rev B0 and later */
+/* uninitialize the APIC for the IBS interrupts if needed */
 static void clear_ibs_nmi(void)
 {
 	if (ibs_allowed)
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 01d38e7..3958107 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -127,9 +127,10 @@ void end_cpu_work(void)
 /* Resets the cpu buffer to a sane state. */
 void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf)
 {
-	/* reset these to invalid values; the next sample
-	 * collected will populate the buffer with proper
-	 * values to initialize the buffer
+	/*
+	 * reset these to invalid values; the next sample collected
+	 * will populate the buffer with proper values to initialize
+	 * the buffer
 	 */
 	cpu_buf->last_is_kernel = -1;
 	cpu_buf->last_task = NULL;
@@ -151,8 +152,10 @@ static void increment_head(struct oprofile_cpu_buffer *b)
 {
 	unsigned long new_head = b->head_pos + 1;
 
-	/* Ensure anything written to the slot before we
-	 * increment is visible */
+	/*
+	 * Ensure anything written to the slot before we increment is
+	 * visible
+	 */
 	wmb();
 
 	if (new_head < b->buffer_size)
@@ -253,8 +256,10 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	if (!oprofile_begin_trace(cpu_buf))
 		return;
 
-	/* if log_sample() fail we can't backtrace since we lost the source
-	 * of this event */
+	/*
+	 * if log_sample() fail we can't backtrace since we lost the
+	 * source of this event
+	 */
 	if (log_sample(cpu_buf, pc, is_kernel, event))
 		oprofile_ops.backtrace(regs, backtrace_depth);
 	oprofile_end_trace(cpu_buf);
@@ -338,8 +343,10 @@ void oprofile_add_trace(unsigned long pc)
 		return;
 	}
 
-	/* broken frame can give an eip with the same value as an escape code,
-	 * abort the trace if we get it */
+	/*
+	 * broken frame can give an eip with the same value as an
+	 * escape code, abort the trace if we get it
+	 */
 	if (pc == ESCAPE_CODE) {
 		cpu_buf->tracing = 0;
 		cpu_buf->backtrace_aborted++;
-- 
1.6.0.1


