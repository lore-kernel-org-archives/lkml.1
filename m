Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178Ab0BZPg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:36:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128Ab0BZPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:36:27 -0500
Subject: [PATCH] perf_event: Fix preempt warning in perf_clock()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 16:36:23 +0100
Message-ID: <1267198583.22519.684.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A recent commit introduced a preemption warning for perf_clock(), use
raw_smp_processor_id() to avoid this, it really doesn't matter which cpu
we use here.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: stable@kernel.org
LKML-Reference: <new-submission>
---
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -249,7 +249,7 @@ static void perf_unpin_context(struct pe
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return cpu_clock(raw_smp_processor_id());
 }
 
 /*


