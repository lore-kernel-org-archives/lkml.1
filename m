Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYKONjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYKONjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYKONiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:38:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbYKONiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:38:05 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20081115237.317953894@firstfloor.org>
In-Reply-To: <20081115237.317953894@firstfloor.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [2/3] SCHED: Mark all frequently used sysctls __read_mostly
Message-Id: <20081115133801.5904D3E661A@basil.firstfloor.org>
Date: Sat, 15 Nov 2008 14:38:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are more optimizations possible here, but that's for another
patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.28-rc4-test/kernel/sched.c
===================================================================
--- linux-2.6.28-rc4-test.orig/kernel/sched.c	2008-11-12 12:32:52.000000000 +0100
+++ linux-2.6.28-rc4-test/kernel/sched.c	2008-11-12 12:52:52.000000000 +0100
@@ -686,7 +686,7 @@
 #define SCHED_FEAT(name, enabled)	\
 	(1UL << __SCHED_FEAT_##name) * enabled |
 
-const_debug unsigned int sysctl_sched_features =
+const_debug unsigned int sysctl_sched_features __read_mostly =
 #include "sched_features.h"
 	0;
 
@@ -809,26 +809,26 @@
  * Number of tasks to iterate in a single balance run.
  * Limited because this is done with IRQs disabled.
  */
-const_debug unsigned int sysctl_sched_nr_migrate = 32;
+const_debug unsigned int sysctl_sched_nr_migrate __read_mostly = 32;
 
 /*
  * ratelimit for updating the group shares.
  * default: 0.25ms
  */
-unsigned int sysctl_sched_shares_ratelimit = 250000;
+unsigned int sysctl_sched_shares_ratelimit __read_mostly = 250000;
 
 /*
  * Inject some fuzzyness into changing the per-cpu group shares
  * this avoids remote rq-locks at the expense of fairness.
  * default: 4
  */
-unsigned int sysctl_sched_shares_thresh = 4;
+unsigned int sysctl_sched_shares_thresh __read_mostly = 4;
 
 /*
  * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
-unsigned int sysctl_sched_rt_period = 1000000;
+unsigned int sysctl_sched_rt_period __read_mostly = 1000000;
 
 static __read_mostly int scheduler_running;
 
