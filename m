Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYKGFuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYKGFuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYKGFo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:32777 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbYKGFop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:45 -0500
Message-Id: <20081107053348.728366811@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [RFC patch 01/18] get_cycles() : kconfig HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-kconfig-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:22 +0000
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

Index: linux.trees.git/init/Kconfig
===================================================================
--- linux.trees.git.orig/init/Kconfig	2008-11-07 00:06:07.000000000 -0500
+++ linux.trees.git/init/Kconfig	2008-11-07 00:07:23.000000000 -0500
@@ -330,6 +330,16 @@ config CPUSETS
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
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
