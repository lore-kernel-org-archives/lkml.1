Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbYJPX6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbYJPX6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYJPXzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48860 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYJPXzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:42 -0400
Message-Id: <20081016234655.575507109@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>
Subject: [RFC patch 01/15] get_cycles() : kconfig HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-kconfig-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new "HAVE_GET_CYCLES" architecture option to specify which
architectures provide 64-bits TSC counters readable with get_cycles(). It's
principally useful to only enable high-precision tracing code only on such
architectures and don't even bother building it on architectures which lack such
support.

It also requires architectures to provide get_cycles_barrier() and
get_cycles_rate().

I mainly use it for the "priority-sifting rwlock" latency tracing code, which
traces worse-case latency induced by the locking. It also provides the basic
changes needed for the LTTng timestamping infrastructure.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 init/Kconfig |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-10-16 11:25:07.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2008-10-16 11:32:26.000000000 -0400
@@ -323,6 +323,16 @@ config CPUSETS
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+#
+# Architectures with a 64-bits get_cycles() should select this.
+# They should also define
+# get_cycles_barrier() : instruction synchronization barrier if required
+# get_cycles_rate() : cycle counter rate, in HZ. If 0, TSC are not synchronized
+# across CPUs or their frequency may vary due to frequency scaling.
+#
+config HAVE_GET_CYCLES
+	def_bool n
+
 config GROUP_SCHED
 	bool "Group CPU scheduler"
 	depends on EXPERIMENTAL

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
