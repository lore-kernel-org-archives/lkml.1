Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087Ab0ADWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0ADWin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619Ab0ADWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:37:10 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46109 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0ADWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:37:04 -0500
Message-Id: <20100104223555.553439762@quilx.com>
References: <20100104223439.228028923@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 16:34:42 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V9 3/7] Move local.h include to ringbuffer.c and ring_buffer_benchmark.c
Content-Disposition: inline; filename=percpu_move_include_local.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ringbuffer*.c are the last users of local.h.

Remove the include from modules.h and add it to ringbuffer files.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/module.h               |    1 -
 kernel/trace/ring_buffer.c           |    1 +
 kernel/trace/ring_buffer_benchmark.c |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2010-01-04 16:21:31.000000000 -0600
+++ linux-2.6/include/linux/module.h	2010-01-04 16:21:33.000000000 -0600
@@ -17,7 +17,6 @@
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
 
-#include <asm/local.h>
 #include <linux/percpu.h>
 #include <asm/module.h>
 
Index: linux-2.6/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer.c	2010-01-04 16:21:20.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer.c	2010-01-04 16:22:30.000000000 -0600
@@ -20,6 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/fs.h>
 
+#include <asm/local.h>
 #include "trace.h"
 
 /*
Index: linux-2.6/kernel/trace/ring_buffer_benchmark.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer_benchmark.c	2010-01-04 16:21:47.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer_benchmark.c	2010-01-04 16:21:57.000000000 -0600
@@ -8,6 +8,7 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/time.h>
+#include <asm/local.h>
 
 struct rb_page {
 	u64		ts;

-- 
