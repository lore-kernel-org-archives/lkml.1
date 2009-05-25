Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZEYPld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZEYPld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZEYPk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:40:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:57147 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZEYPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:40:57 -0400
Message-Id: <20090525153931.494709027@chello.nl>
References: <20090525153902.692238765@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 17:39:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/3] perf_counter: x86: expose INV and EDGE bits
Content-Disposition: inline; filename=perf_counter-x86-masks.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the INV and EDGE bits of the PMU to raw configs.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -87,11 +87,15 @@ static u64 intel_pmu_raw_event(u64 event
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
 #define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
+#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
 #define CORE_EVNTSEL_COUNTER_MASK	0xFF000000ULL
 
 #define CORE_EVNTSEL_MASK 		\
 	(CORE_EVNTSEL_EVENT_MASK |	\
 	 CORE_EVNTSEL_UNIT_MASK  |	\
+	 CORE_EVNTSEL_EDGE_MASK  |	\
+	 CORE_EVNTSEL_INV_MASK  |	\
 	 CORE_EVNTSEL_COUNTER_MASK)
 
 	return event & CORE_EVNTSEL_MASK;
@@ -119,11 +123,15 @@ static u64 amd_pmu_raw_event(u64 event)
 {
 #define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
 #define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
+#define K7_EVNTSEL_EDGE_MASK	0x000040000ULL
+#define K7_EVNTSEL_INV_MASK	0x000800000ULL
 #define K7_EVNTSEL_COUNTER_MASK	0x0FF000000ULL
 
 #define K7_EVNTSEL_MASK			\
 	(K7_EVNTSEL_EVENT_MASK |	\
 	 K7_EVNTSEL_UNIT_MASK  |	\
+	 K7_EVNTSEL_EDGE_MASK  |	\
+	 K7_EVNTSEL_INV_MASK   |	\
 	 K7_EVNTSEL_COUNTER_MASK)
 
 	return event & K7_EVNTSEL_MASK;

-- 

