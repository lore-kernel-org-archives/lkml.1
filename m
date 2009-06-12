Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbZFLNB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbZFLNB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762485AbZFLM7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:20 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:5115 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762226AbZFLM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:17 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQJ-04-6AC-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/23] Revert "oprofile: discover counters for op ppro too"
Date: Fri, 12 Jun 2009 14:35:18 +0200
Message-ID: <1244810140-20595-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0686 (UTC) FILETIME=[912C5F60:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 59512900baab03c5629f2ff5efad1d5d4e682ece.

arch_perfmon_setup_counters() is actually never called for ppro, so
there is no code that changes the numbers in op_ppro_spec. The patch
as it is has no effect.

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_ppro.c |    8 +++-----
 arch/x86/oprofile/op_x86_model.h  |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 10131fb..2a12399 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -213,9 +213,9 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 }
 
 
-struct op_x86_model_spec op_ppro_spec = {
-	.num_counters		= 2,	/* can be overriden */
-	.num_controls		= 2,	/* dito */
+struct op_x86_model_spec const op_ppro_spec = {
+	.num_counters		= 2,
+	.num_controls		= 2,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
 	.check_ctrs		= &ppro_check_ctrs,
@@ -251,8 +251,6 @@ void arch_perfmon_setup_counters(void)
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
-	op_ppro_spec.num_counters = num_counters;
-	op_ppro_spec.num_controls = num_counters;
 }
 
 struct op_x86_model_spec op_arch_perfmon_spec = {
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 825e790..2317149 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -45,7 +45,7 @@ struct op_x86_model_spec {
 	void (*shutdown)(struct op_msrs const * const msrs);
 };
 
-extern struct op_x86_model_spec op_ppro_spec;
+extern struct op_x86_model_spec const op_ppro_spec;
 extern struct op_x86_model_spec const op_p4_spec;
 extern struct op_x86_model_spec const op_p4_ht2_spec;
 extern struct op_x86_model_spec const op_amd_spec;
-- 
1.6.3.1


