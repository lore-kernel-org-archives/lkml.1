Return-Path: <linux-kernel-owner+w=401wt.eu-S967678AbYCTAlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967678AbYCTAlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763509AbYCTAeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:34:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43077 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967533AbYCTAeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:34:11 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 20:34:10 EDT
Message-Id: <20080320002834.448782178@polymtl.ca>
References: <20080320002737.918213455@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 19 Mar 2008 20:27:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       David Smith <dsmith@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Adrian Bunk <adrian.bunk@movial.fi>
Subject: [patch 1/4] Markers - depends on not PREEMPT_RCU
Content-Disposition: inline; filename=markers-depends-on-not-preempt-rcu.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 20 Mar 2008 00:28:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markers do not mix well with CONFIG_PREEMPT_RCU because it uses
preempt_disable/enable() and not rcu_read_lock/unlock for minimal
intrusiveness. We would need call_sched and sched_barrier primitives.

This should be in for 2.6.25.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@osdl.org>
CC: Mike Mason <mmlnx@us.ibm.com>
CC: Dipankar Sarma <dipankar@in.ibm.com>
CC: David Smith <dsmith@redhat.com>
CC: "Paul E. McKenney" <paulmck@us.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Adrian Bunk <adrian.bunk@movial.fi>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-03-19 18:26:47.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2008-03-19 18:27:43.000000000 -0400
@@ -742,6 +742,7 @@ config PROFILING
 
 config MARKERS
 	bool "Activate markers"
+	depends on !PREEMPT_RCU
 	help
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
