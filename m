Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbXGCQsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbXGCQsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761267AbXGCQqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:46:04 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45944 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761221AbXGCQqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:46:01 -0400
Message-Id: <20070703164514.682667810@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 05/10] Immediate Values - kprobe header fix
Content-Disposition: inline; filename=immediate-values-kprobes-headers.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:45:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the immediate values depend on the same int3 handler as kprobes implements
for i386, we have to get architecture specific defines available for the kprobes
trap handler (especially restore_interrupts()) wven when CONFIG_KPROBES is not
selected.

That kind of ifdef around a whole header does not make sense in the first place
anyway.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 include/linux/kprobes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/kprobes.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kprobes.h	2007-06-17 13:41:35.000000000 -0400
+++ linux-2.6-lttng/include/linux/kprobes.h	2007-06-17 13:41:55.000000000 -0400
@@ -37,9 +37,9 @@
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
 
-#ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
 
+#ifdef CONFIG_KPROBES
 /* kprobe_status settings */
 #define KPROBE_HIT_ACTIVE	0x00000001
 #define KPROBE_HIT_SS		0x00000002

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
