Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZCMNDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZCMNDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZCMNB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:01:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:54009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758128AbZCMNB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:01:58 -0400
Date: Fri, 13 Mar 2009 13:01:15 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.477871320@chello.nl>
References: <20090313112301.477871320@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: x86: use ULL postfix for 64bit constants
Message-ID: <tip-c93ccc55a700595a5522a65e5338adcdd76aeeb0@git.kernel.org>
Git-Commit-ID: c93ccc55a700595a5522a65e5338adcdd76aeeb0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:01:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c93ccc55a700595a5522a65e5338adcdd76aeeb0
Gitweb:     http://git.kernel.org/tip/c93ccc55a700595a5522a65e5338adcdd76aeeb0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:31 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 13:59:09 +0100

perf_counter: x86: use ULL postfix for 64bit constants

Fix a build warning on 32bit machines by explicitly marking the
constants as 64-bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.477871320@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a2e3b76..22dab06 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -84,9 +84,9 @@ static u64 pmc_intel_event_map(int event)
 
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
