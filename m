Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZHKL7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZHKL7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZHKL7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:59:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZHKL7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:32 -0400
Date: Tue, 11 Aug 2009 11:34:08 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu, js@sig21.net
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu, js@sig21.net
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter, x86: Fix generic cache events on P6-mobile CPUs
Message-ID: <tip-f64ccccb8afa43abdd63fcbd230f818d6ea0883f@git.kernel.org>
Git-Commit-ID: f64ccccb8afa43abdd63fcbd230f818d6ea0883f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 11 Aug 2009 11:34:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f64ccccb8afa43abdd63fcbd230f818d6ea0883f
Gitweb:     http://git.kernel.org/tip/f64ccccb8afa43abdd63fcbd230f818d6ea0883f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 11 Aug 2009 10:26:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Aug 2009 11:35:26 +0200

perf_counter, x86: Fix generic cache events on P6-mobile CPUs

Johannes Stezenbach reported that 'perf stat' does not count
cache-miss and cache-references events on his Pentium-M based
laptop.

This is because we left them blank in p6_perfmon_event_map[],
fill them in.

Reported-by: Johannes Stezenbach <js@sig21.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 40e233a..fffc126 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -72,8 +72,8 @@ static const u64 p6_perfmon_event_map[] =
 {
   [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
