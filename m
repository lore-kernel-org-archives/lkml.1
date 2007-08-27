Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXH0P6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXH0P6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbXH0Pzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:55:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41883 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbXH0Pzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:55:39 -0400
Message-Id: <20070827155528.896119141@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 16/28] m32r: build fix of arch/m32r/kernel/smpboot.c
Content-Disposition: inline; filename=fix-m32r-include-sched-h-in-smpboot.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for Mathieu Desnoyers's include/asm-m32r/local.h.
Applying the new include/asm-m32r/local.h, inclusion of linux/sched.h
is needed to fix a build error of arch/m32r/kernel/smpboot.c.

<--  snip  -->
  ...
  CC      arch/m32r/kernel/smpboot.o
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'do_boot_cpu':
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: error: implicit declaration of function 'fork_idle'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: warning: assignment makes pointer from integer without a cast
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:283: error: dereferencing pointer to incomplete type
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:289: error: dereferencing pointer to incomplete type
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: implicit declaration of function 'task_thread_info'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: invalid type argument of '->'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'start_secondary':
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:429: error: implicit declaration of function 'cpu_init'
make[2]: *** [arch/m32r/kernel/smpboot.o] Error 1
<--  snip  -->

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/smpboot.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/arch/m32r/kernel/smpboot.c
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/kernel/smpboot.c	2007-08-21 09:57:48.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/kernel/smpboot.c	2007-08-21 09:58:12.000000000 -0400
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/irq.h>
 #include <linux/bootmem.h>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
