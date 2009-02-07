Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZBGXUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZBGXUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBGXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:20:45 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44641 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZBGXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=sd9wIOItYPH/Z4VpIEZyTVHgGlrGQC+y0tsmOXF1I88Vfi1q3zzF22KIeBks/8mPNG
         BstukeVfS8Bm8GRGCxQER6VfGF0/0SrQ4zOwhqWPwJtlq9Ba8nbfTPBs2vxHWaID2AuG
         m4KlBhRh56Oc4gG0qXszfFjAZ0cjd3bWOTE4E=
Message-ID: <498e1747.1f145e0a.126a.ffffdf3b@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 7 Feb 2009 20:46:45 +0100
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] tracing/blktrace: move the tracing file to kernel/trace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Move blktrace.c to kernel/trace, also move its config entry.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 block/Kconfig                      |   24 ------------------------
 block/Makefile                     |    1 -
 kernel/trace/Kconfig               |   23 +++++++++++++++++++++++
 kernel/trace/Makefile              |    1 +
 {block => kernel/trace}/blktrace.c |    2 +-
 5 files changed, 25 insertions(+), 26 deletions(-)
 rename {block => kernel/trace}/blktrace.c (99%)

diff --git a/block/Kconfig b/block/Kconfig
index 7cdaa1d..e7d1278 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -44,30 +44,6 @@ config LBD
 
 	  If unsure, say N.
 
-config BLK_DEV_IO_TRACE
-	bool "Support for tracing block io actions"
-	depends on SYSFS
-	select RELAY
-	select DEBUG_FS
-	select TRACEPOINTS
-	select TRACING
-	select STACKTRACE
-	help
-	  Say Y here if you want to be able to trace the block layer actions
-	  on a given queue. Tracing allows you to see any traffic happening
-	  on a block device queue. For more information (and the userspace
-	  support tools needed), fetch the blktrace tools from:
-
-	  git://git.kernel.dk/blktrace.git
-
-	  Tracing also is possible using the ftrace interface, e.g.:
-
-	    echo 1 > /sys/block/sda/sda1/trace/enable
-	    echo blk > /sys/kernel/debug/tracing/current_tracer
-	    cat /sys/kernel/debug/tracing/trace_pipe
-
-	  If unsure, say N.
-
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/block/Makefile b/block/Makefile
index bfe7304..e9fa4dd 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -13,6 +13,5 @@ obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
-obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 28f2644..0e920e2 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -294,6 +294,29 @@ config WORKQUEUE_TRACER
           For example it can help a developer to decide whether he should
           choose a per cpu workqueue instead of a singlethreaded one.
 
+config BLK_DEV_IO_TRACE
+	bool "Support for tracing block io actions"
+	depends on SYSFS
+	select RELAY
+	select DEBUG_FS
+	select TRACEPOINTS
+	select TRACING
+	select STACKTRACE
+	help
+	  Say Y here if you want to be able to trace the block layer actions
+	  on a given queue. Tracing allows you to see any traffic happening
+	  on a block device queue. For more information (and the userspace
+	  support tools needed), fetch the blktrace tools from:
+
+	  git://git.kernel.dk/blktrace.git
+
+	  Tracing also is possible using the ftrace interface, e.g.:
+
+	    echo 1 > /sys/block/sda/sda1/trace/enable
+	    echo blk > /sys/kernel/debug/tracing/current_tracer
+	    cat /sys/kernel/debug/tracing/trace_pipe
+
+	  If unsure, say N.
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index f76d48f..627090b 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -37,5 +37,6 @@ obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
+obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 
 libftrace-y := ftrace.o
diff --git a/block/blktrace.c b/kernel/trace/blktrace.c
similarity index 99%
rename from block/blktrace.c
rename to kernel/trace/blktrace.c
index ca6d320..3b91da0 100644
--- a/block/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -25,7 +25,7 @@
 #include <linux/time.h>
 #include <trace/block.h>
 #include <linux/uaccess.h>
-#include <../kernel/trace/trace_output.h>
+#include "trace_output.h"
 
 static unsigned int blktrace_seq __read_mostly = 1;
 
-- 
1.6.1


