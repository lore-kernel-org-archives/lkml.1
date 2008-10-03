Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYJCE4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYJCE4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYJCE4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:56:10 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:51521 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYJCE4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:56:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAHg/5UhMQWq+/2dsb2JhbACBcbo0gWg
Date: Fri, 3 Oct 2008 00:56:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] x86 Topology cpu_to_node parameter check
Message-ID: <20081003045607.GA5940@Krystal>
References: <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:54:23 up 120 days,  9:34,  8 users,  load average: 0.09, 0.24,
	0.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare NUMA-less cpu_to_node with a check that the cpu parameter exists so
people without NUMA test configs (namely Steven Rostedt and myself who ran into
this error both in the same day with different implementations) stop doing this
trivial mistake.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/topology.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/topology.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/topology.h	2008-10-03 00:37:05.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/topology.h	2008-10-03 00:45:52.000000000 -0400
@@ -182,9 +182,9 @@ extern int __node_distance(int, int);
 
 #else /* !CONFIG_NUMA */
 
-#define numa_node_id()		0
-#define	cpu_to_node(cpu)	0
-#define	early_cpu_to_node(cpu)	0
+#define	numa_node_id()		0
+#define	cpu_to_node(cpu)	((void)(cpu),0)
+#define	early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
 static inline const cpumask_t *_node_to_cpumask_ptr(int node)
 {
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
