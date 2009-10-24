Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZJXBE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZJXBE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZJXBE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:51749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZJXBEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:53 -0400
Date: Sat, 24 Oct 2009 01:04:13 GMT
From: tip-bot for Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, npiggin@suse.de,
       tglx@linutronix.de, sheng@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, npiggin@suse.de,
       tglx@linutronix.de, sheng@linux.intel.com, mingo@elte.hu
In-Reply-To: <1256210374-25354-1-git-send-email-sheng@linux.intel.com>
References: <1256210374-25354-1-git-send-email-sheng@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] generic-ipi: Fix misleading smp_call_function*() description
Message-ID: <tip-72f279b256d520e321a850880d094bc0bcbf45d6@git.kernel.org>
Git-Commit-ID: 72f279b256d520e321a850880d094bc0bcbf45d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72f279b256d520e321a850880d094bc0bcbf45d6
Gitweb:     http://git.kernel.org/tip/72f279b256d520e321a850880d094bc0bcbf45d6
Author:     Sheng Yang <sheng@linux.intel.com>
AuthorDate: Thu, 22 Oct 2009 19:19:34 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 13:51:45 +0200

generic-ipi: Fix misleading smp_call_function*() description

After commit:8969a5ede0f9e17da4b943712429aef2c9bcd82b
"generic-ipi: remove kmalloc()", wait = 0 can be guaranteed.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
LKML-Reference: <1256210374-25354-1-git-send-email-sheng@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
