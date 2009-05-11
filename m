Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbZEKFui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbZEKFui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 01:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZEKFu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 01:50:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46707 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZEKFu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 01:50:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18951.48285.270311.981806@drongo.ozlabs.ibm.com>
Date: Mon, 11 May 2009 15:50:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf_counter: call atomic64_set for counter->count
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a compile warning where we are calling
atomic_set(&counter->count).  Since counter->count is an atomic64_t,
we have to use atomic64_set.

[ Impact: fix type mismatch bug ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7373b96..5ea0240 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1281,7 +1281,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 static void perf_counter_reset(struct perf_counter *counter)
 {
 	(void)perf_counter_read(counter);
-	atomic_set(&counter->count, 0);
+	atomic64_set(&counter->count, 0);
 	perf_counter_update_userpage(counter);
 }
 
