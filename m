Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601Ab0AUN4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0AUN4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581Ab0AUN4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:56:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:46441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0AUN4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:56:15 -0500
Date: Thu, 21 Jan 2010 13:55:45 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: x86: Add support for the ANY bit
Message-ID: <tip-b27d515a49169e5e2a92d621faac761074a8c5b1@git.kernel.org>
Git-Commit-ID: b27d515a49169e5e2a92d621faac761074a8c5b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:55:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b27d515a49169e5e2a92d621faac761074a8c5b1
Gitweb:     http://git.kernel.org/tip/b27d515a49169e5e2a92d621faac761074a8c5b1
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 18 Jan 2010 10:58:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:41 +0100

perf: x86: Add support for the ANY bit

Propagate the ANY bit into the fixed counter config for v3 and higher.

Signed-off-by: Stephane Eranian <eranian@google.com>
[a.p.zijlstra@chello.nl: split from larger patch]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h |    1 +
 arch/x86/kernel/cpu/perf_event.c  |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8d9f854..1380367 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -19,6 +19,7 @@
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
 #define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_ANY			  (1 << 21)
 #define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
 #define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
 #define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d616c06..8c1c070 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1343,6 +1343,13 @@ intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
 		bits |= 0x2;
 	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
 		bits |= 0x1;
+
+	/*
+	 * ANY bit is supported in v3 and up
+	 */
+	if (x86_pmu.version > 2 && hwc->config & ARCH_PERFMON_EVENTSEL_ANY)
+		bits |= 0x4;
+
 	bits <<= (idx * 4);
 	mask = 0xfULL << (idx * 4);
 
