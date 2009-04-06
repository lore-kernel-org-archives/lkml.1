Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZDFJqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZDFJqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbZDFJoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbZDFJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:36 -0400
Message-Id: <20090406094517.457320003@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/15] perf_counter: add more context information
Content-Disposition: inline; filename=perf_counter_callchain_context.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the callchain context entries to u16, so as to gain some space.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    4 ++--
 kernel/perf_counter.c        |    6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -507,10 +507,10 @@ extern void perf_counter_mmap(unsigned l
 extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
-#define MAX_STACK_DEPTH		254
+#define MAX_STACK_DEPTH		255
 
 struct perf_callchain_entry {
-	u32	nr, hv, kernel, user;
+	u16	nr, hv, kernel, user;
 	u64	ip[MAX_STACK_DEPTH];
 };
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1657,9 +1657,7 @@ void perf_counter_do_pending(void)
  * Callchain support -- arch specific
  */
 
-struct perf_callchain_entry *
-__attribute__((weak))
-perf_callchain(struct pt_regs *regs)
+__weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 {
 	return NULL;
 }
@@ -1819,7 +1817,7 @@ void perf_counter_output(struct perf_cou
 		callchain = perf_callchain(regs);
 
 		if (callchain) {
-			callchain_size = (2 + callchain->nr) * sizeof(u64);
+			callchain_size = (1 + callchain->nr) * sizeof(u64);
 
 			header.type |= __PERF_EVENT_CALLCHAIN;
 			header.size += callchain_size;

-- 

