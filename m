Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYKNXD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYKNXD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYKNXAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:25 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52202 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYKNXAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:21 -0500
Message-Id: <20081114224947.336246671@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: [patch 01/16] RCU read sched notrace
Content-Disposition: inline; filename=rcu-read-sched-notrace.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add _notrace version to rcu_read_*_sched().

Impact: new API, useful for tracepoints and markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: akpm@linux-foundation.org
---
 include/linux/rcupdate.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/linux/rcupdate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/rcupdate.h	2008-10-08 10:27:57.000000000 -0400
+++ linux-2.6-lttng/include/linux/rcupdate.h	2008-10-08 10:40:48.000000000 -0400
@@ -142,6 +142,7 @@ struct rcu_head {
  * on the write-side to insure proper synchronization.
  */
 #define rcu_read_lock_sched() preempt_disable()
+#define rcu_read_lock_sched_notrace() preempt_disable_notrace()
 
 /*
  * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
@@ -149,6 +150,7 @@ struct rcu_head {
  * See rcu_read_lock_sched for more information.
  */
 #define rcu_read_unlock_sched() preempt_enable()
+#define rcu_read_unlock_sched_notrace() preempt_enable_notrace()
 
 
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
