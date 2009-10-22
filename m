Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZJVL1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZJVL1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZJVL1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:27:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:35141 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZJVL1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:27:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,604,1249282800"; 
   d="scan'208";a="506140196"
From: Sheng Yang <sheng@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/1] generic-ipi: Fix misleading smp_call_function* description
Date: Thu, 22 Oct 2009 19:19:34 +0800
Message-Id: <1256210374-25354-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit:8969a5ede0f9e17da4b943712429aef2c9bcd82b "generic-ipi: remove
kmalloc()", wait = 0 can be guaranteed.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 kernel/smp.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index c9d1c78..8bd618f 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -265,9 +265,7 @@ static DEFINE_PER_CPU(struct call_single_data, csd_data);
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code. Note that @wait
- * will be implicitly turned on in case of allocation failures, since
- * we fall back to on-stack allocation.
+ * Returns 0 on success, else a negative status code.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int wait)
@@ -355,9 +353,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
  * @wait: If true, wait (atomically) until function has completed
  *        on other CPUs.
  *
- * If @wait is true, then returns once @func has returned. Note that @wait
- * will be implicitly turned on in case of allocation failures, since
- * we fall back to on-stack allocation.
+ * If @wait is true, then returns once @func has returned.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler. Preemption
@@ -443,8 +439,7 @@ EXPORT_SYMBOL(smp_call_function_many);
  * Returns 0.
  *
  * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func. In case of allocation
- * failure, @wait will be implicitly turned on.
+ * it returns just before the target cpu calls @func.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
-- 
1.5.4.5

