Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZAIKok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZAIKok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZAIKod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:44:33 -0500
Received: from ozlabs.org ([203.10.76.45]:47480 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZAIKoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:44:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.10887.914801.853834@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:44:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/9] perf_counter: Fix return value from dummy hw_perf_counter_init
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix oops-causing bug

Currently, if you try to use perf_counters on an architecture that has
no hardware support, and you select an event that doesn't map to any of
the defined software counters, you get an oops rather than an error.
This is because the dummy hw_perf_counter_init returns ERR_PTR(-EINVAL)
but the caller (perf_counter_alloc) only tests for NULL.

This makes the dummy hw_perf_counter_init return NULL instead.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
[re-sent with [PATCH 1/9] in subject]

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 37f7716..4be1a8d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -41,7 +41,7 @@ static DEFINE_MUTEX(perf_resource_mutex);
 extern __weak const struct hw_perf_counter_ops *
 hw_perf_counter_init(struct perf_counter *counter)
 {
-	return ERR_PTR(-EINVAL);
+	return NULL;
 }
 
 u64 __weak hw_perf_save_disable(void)		{ return 0; }
