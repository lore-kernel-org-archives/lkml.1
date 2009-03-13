Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbZCMLZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbZCMLZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZCMLXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZCMLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:46 -0400
Message-Id: <20090313112301.477871320@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/11] perf_counter: x86: use ULL postfix for 64bit constants
Content-Disposition: inline; filename=perf_counter-x86-32.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a build warning on 32bit machines by explicitly marking the constants 
as 64bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -84,9 +84,9 @@ static u64 pmc_intel_event_map(int event
 
 static u64 pmc_intel_raw_event(u64 event)
 {
-#define CORE_EVNTSEL_EVENT_MASK		0x000000FF
-#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00
-#define CORE_EVNTSEL_COUNTER_MASK	0xFF000000
+#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define CORE_EVNTSEL_COUNTER_MASK	0xFF000000ULL
 
 #define CORE_EVNTSEL_MASK 		\
 	(CORE_EVNTSEL_EVENT_MASK |	\
@@ -116,9 +116,9 @@ static u64 pmc_amd_event_map(int event)
 
 static u64 pmc_amd_raw_event(u64 event)
 {
-#define K7_EVNTSEL_EVENT_MASK	0x7000000FF
-#define K7_EVNTSEL_UNIT_MASK	0x00000FF00
-#define K7_EVNTSEL_COUNTER_MASK	0x0FF000000
+#define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
+#define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
+#define K7_EVNTSEL_COUNTER_MASK	0x0FF000000ULL
 
 #define K7_EVNTSEL_MASK			\
 	(K7_EVNTSEL_EVENT_MASK |	\

-- 

