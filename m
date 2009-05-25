Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZEYTxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZEYTxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZEYTw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:52:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZEYTwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:52:55 -0400
Date: Mon, 25 May 2009 19:51:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525153931.494709027@chello.nl>
References: <20090525153931.494709027@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: x86: Expose INV and EDGE bits
Message-ID: <tip-ff99be573e02e9f7edc23b472c7f9a5ddba12795@git.kernel.org>
Git-Commit-ID: ff99be573e02e9f7edc23b472c7f9a5ddba12795
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 19:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff99be573e02e9f7edc23b472c7f9a5ddba12795
Gitweb:     http://git.kernel.org/tip/ff99be573e02e9f7edc23b472c7f9a5ddba12795
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 17:39:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 21:41:11 +0200

perf_counter: x86: Expose INV and EDGE bits

Expose the INV and EDGE bits of the PMU to raw configs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525153931.494709027@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 6cc1660..c14437f 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -87,11 +87,15 @@ static u64 intel_pmu_raw_event(u64 event)
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
