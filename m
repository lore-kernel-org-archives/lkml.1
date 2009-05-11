Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZEKKMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZEKKMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZEKKLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:11:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:50761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbZEKKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:11:48 -0400
Date: Mon, 11 May 2009 10:10:58 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: clean up throttling printk
Message-ID: <tip-8823392360dc4992f87bf4c623834d315f297493@git.kernel.org>
Git-Commit-ID: 8823392360dc4992f87bf4c623834d315f297493
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:11:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8823392360dc4992f87bf4c623834d315f297493
Gitweb:     http://git.kernel.org/tip/8823392360dc4992f87bf4c623834d315f297493
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sun, 10 May 2009 10:53:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 12:04:30 +0200

perf_counter, x86: clean up throttling printk

s/PERFMON/perfcounters for perfcounter interrupt throttling warning.

'perfmon' is the CPU feature name that is Intel-only, while we do
throttling in a generic way.

[ Impact: cleanup ]

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a6878b0..da27419 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -814,7 +814,7 @@ void perf_counter_unthrottle(void)
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING "PERFMON: max interrupts exceeded!\n");
+			printk(KERN_WARNING "perfcounters: max interrupts exceeded!\n");
 		hw_perf_restore(cpuc->throttle_ctrl);
 	}
 	cpuc->interrupts = 0;
