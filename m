Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0CKOlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:41:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:35476 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0CKOlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:41:35 -0500
Date: Thu, 11 Mar 2010 14:41:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, ppc: Fix compile error due to new cpu notifiers
Message-ID: <tip-85cfabbcd10f8d112feee6e2ec64ee78033b6d3c@git.kernel.org>
Git-Commit-ID: 85cfabbcd10f8d112feee6e2ec64ee78033b6d3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:41:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85cfabbcd10f8d112feee6e2ec64ee78033b6d3c
Gitweb:     http://git.kernel.org/tip/85cfabbcd10f8d112feee6e2ec64ee78033b6d3c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 11 Mar 2010 13:06:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 15:21:27 +0100

perf, ppc: Fix compile error due to new cpu notifiers

Fix:

  arch/powerpc/kernel/perf_event.c:1334: error: 'power_pmu_notifier' undeclared (first use in this function)
  arch/powerpc/kernel/perf_event.c:1334: error: (Each undeclared identifier is reported only once
  arch/powerpc/kernel/perf_event.c:1334: error: for each function it appears in.)
  arch/powerpc/kernel/perf_event.c:1334: error: implicit declaration of function 'power_pmu_notifier'
  arch/powerpc/kernel/perf_event.c:1334: error: implicit declaration of function 'register_cpu_notifier'

Due to commit 3f6da390 (perf: Rework and fix the arch CPU-hotplug hooks).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c |    2 +-
 include/linux/perf_event.h       |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index fbe101d..08460a2 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1298,7 +1298,7 @@ static void power_pmu_setup(int cpu)
 }
 
 static int __cpuinit
-power_pmu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
+power_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 70cffd0..9547703 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -453,6 +453,7 @@ enum perf_callchain_context {
 #include <linux/pid_namespace.h>
 #include <linux/workqueue.h>
 #include <linux/ftrace.h>
+#include <linux/cpu.h>
 #include <asm/atomic.h>
 
 #define PERF_MAX_STACK_DEPTH		255
