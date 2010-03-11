Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0CKHdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:33:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57005 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0CKHdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:33:08 -0500
Message-ID: <4B989C1B.2090407@cn.fujitsu.com>
Date: Thu, 11 Mar 2010 15:30:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: export perf_trace_regs and perf_arch_fetch_caller_regs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export perf_trace_regs and perf_arch_fetch_caller_regs since module will
use these

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kernel/cpu/perf_event.c |    1 +
 kernel/trace/trace_event_perf.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4a0514d..8700643 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1697,3 +1697,4 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
+EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index f315b12..af4621b 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -10,6 +10,7 @@
 #include "trace.h"
 
 DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
+EXPORT_SYMBOL_GPL(perf_trace_regs);
 
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
-- 
1.6.4

