Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab0CKOnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:43:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:35590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab0CKOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:43:18 -0500
Date: Thu, 11 Mar 2010 14:41:34 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B989C1B.2090407@cn.fujitsu.com>
References: <4B989C1B.2090407@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: export perf_trace_regs and perf_arch_fetch_caller_regs
Message-ID: <tip-639fe4b12f92b54c9c3b38c82cdafaa38cfd3e63@git.kernel.org>
Git-Commit-ID: 639fe4b12f92b54c9c3b38c82cdafaa38cfd3e63
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:41:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  639fe4b12f92b54c9c3b38c82cdafaa38cfd3e63
Gitweb:     http://git.kernel.org/tip/639fe4b12f92b54c9c3b38c82cdafaa38cfd3e63
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 11 Mar 2010 15:30:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 15:21:29 +0100

perf: export perf_trace_regs and perf_arch_fetch_caller_regs

Export perf_trace_regs and perf_arch_fetch_caller_regs since module will
use these.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
[ use EXPORT_PER_CPU_SYMBOL_GPL() ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4B989C1B.2090407@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    1 +
 kernel/trace/trace_event_perf.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5fb490c..7645fae 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1713,3 +1713,4 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
+EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index f315b12..0709e4f 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -10,6 +10,7 @@
 #include "trace.h"
 
 DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
+EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
 
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
