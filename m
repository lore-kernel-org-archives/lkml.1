Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZGAJtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZGAJtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZGAJtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:49:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:52632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbZGAJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:49:00 -0400
Subject: [PATCH 5/6 -tip] perf_counter: Add hardware vector events for
 nehalem
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246441094.3403.10.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam>
	 <1246441094.3403.10.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:08:57 +0530
Message-Id: <1246441137.3403.11.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add hardware vector events for nehalem

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 487df5c..8f05226 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -378,6 +378,16 @@ static const u64 atom_hw_cache_event_ids
 
 static u64 __read_mostly hw_vector_event_ids[PERF_COUNT_HW_VECTOR_MAX];
 
+static const u64 nehalem_hw_vector_event_ids[] =
+{
+  [PERF_COUNT_HW_VECTOR_ADD]		= 0x01B1, /* UOPS_EXECUTED.PORT0     */
+  [PERF_COUNT_HW_VECTOR_MULTIPLY]	= 0x0214, /* ARITH.MUL               */
+  [PERF_COUNT_HW_VECTOR_DIVIDE]		= 0x0114, /* ARITH.CYCLES_DIV_BUSY   */
+  [PERF_COUNT_HW_VECTOR_IDLE_CYCLES]	= 0x0,
+  [PERF_COUNT_HW_VECTOR_STALL_CYCLES]	= 0x60A2, /* RESOURCE_STALLS.FPCW|MXCSR*/
+  [PERF_COUNT_HW_VECTOR_OPS]		= 0x0710, /* FP_COMP_OPS_EXE.X87|MMX|SSE_FP*/
+};
+
 /*
  * Generalized hw interrupt event table
  */
@@ -1503,6 +1513,8 @@ static int intel_pmu_init(void)
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_vector_event_ids, nehalem_hw_vector_event_ids,
+		       sizeof(hw_vector_event_ids));
 
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
-- 
1.6.0.6



