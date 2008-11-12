Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYKLM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYKLM2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYKLM1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:27:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39783 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYKLM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:27:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20081112145.328971960@firstfloor.org>
In-Reply-To: <20081112145.328971960@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: [PATCH] [3/4] SCHED: don't inline idle_balance into schedule()
Message-Id: <20081112124511.6A2933E660F@basil.firstfloor.org>
Date: Wed, 12 Nov 2008 13:45:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This function is not called under load, so it makes sense to out of line
it to get better register allocation in schedule() and make the assembler
easier to read.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.28-rc4-test/kernel/sched.c
===================================================================
--- linux-2.6.28-rc4-test.orig/kernel/sched.c	2008-11-12 12:52:52.000000000 +0100
+++ linux-2.6.28-rc4-test/kernel/sched.c	2008-11-12 13:07:53.000000000 +0100
@@ -3696,7 +3696,7 @@
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-static void idle_balance(int this_cpu, struct rq *this_rq)
+static void noinline idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = -1;
