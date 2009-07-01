Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZGAJto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZGAJto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZGAJtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:52643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbZGAJtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:49:20 -0400
Subject: [PATCH 6/6 -tip] perf_counter: Add hardware interrupt events for
 nehalem, core2 and atom
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246441137.3403.11.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam>
	 <1246441094.3403.10.camel@hpdv5.satnam>
	 <1246441137.3403.11.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:10:11 +0530
Message-Id: <1246441211.3403.12.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add hardware interrupt events for nehalem, core2 and atom

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 8f05226..4ef1838 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -394,6 +394,20 @@ static const u64 nehalem_hw_vector_event_ids[] =
 
 static u64 __read_mostly hw_interrupt_event_ids[PERF_COUNT_HW_INTERRUPT_MAX];
 
+static const u64 nehalem_hw_interrupt_event_ids[] =
+{
+  [PERF_COUNT_HW_INTERRUPT]		= 0x011D, /* HW_INT.RCV              */
+  [PERF_COUNT_HW_INTERRUPT_MASK]	= 0x021D, /* HW_INT.CYCLES_MASKED    */
+  [PERF_COUNT_HW_INTERRUPT_PENDING_MASK]= 0x041D, /* HW_INT.CYCLES_PENDING_AND_MASKED*/
+};
+
+static const u64 core2_atom_hw_interrupt_event_ids[] =
+{
+  [PERF_COUNT_HW_INTERRUPT]		= 0x00C8, /* HW_INT_RCV              */
+  [PERF_COUNT_HW_INTERRUPT_MASK]	= 0x01C6, /* CYCLES_INT_MASKED.CYCLES_INT_MASKED*/
+  [PERF_COUNT_HW_INTERRUPT_PENDING_MASK]= 0x02C6, /* CYCLES_INT_MASKED.CYCLES_INT_PENDING_AND_MASKED*/
+};
+
 static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
@@ -1506,6 +1520,8 @@ static int intel_pmu_init(void)
 	case 29: /* six-core 45 nm xeon "Dunnington" */
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_interrupt_event_ids, core2_atom_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Core2 events, ");
 		break;
@@ -1515,12 +1531,16 @@ static int intel_pmu_init(void)
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_vector_event_ids, nehalem_hw_vector_event_ids,
 		       sizeof(hw_vector_event_ids));
+		memcpy(hw_interrupt_event_ids, nehalem_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_interrupt_event_ids, core2_atom_hw_interrupt_event_ids,
+		       sizeof(hw_interrupt_event_ids));
 
 		pr_cont("Atom events, ");
 		break;
-- 
1.6.0.6



