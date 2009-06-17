Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZFQABO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZFQABO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZFQAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:00:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbZFQAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:00:59 -0400
Date: Tue, 16 Jun 2009 20:00:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH][GIT PULL][for 2.6.31] tracing: update sample event
 documentation
Message-ID: <alpine.DEB.2.00.0906161954270.26673@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent-1


Steven Rostedt (1):
      tracing: update sample event documentation

----
 samples/trace_events/Makefile              |    8 ++++++++
 samples/trace_events/trace-events-sample.h |   27 ++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)
---------------------------
commit 44ad18e0a65e296b2e68a1452509f6222cdce743
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Jun 16 19:53:07 2009 -0400

    tracing: update sample event documentation
    
    The comments in the sample code is a bit confusing. This patch
    cleans them up a little.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/samples/trace_events/Makefile b/samples/trace_events/Makefile
index 0d428dc..0f8d921 100644
--- a/samples/trace_events/Makefile
+++ b/samples/trace_events/Makefile
@@ -1,6 +1,14 @@
 # builds the trace events example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
+# If you include a trace header outside of include/trace/events
+# then the file that does the #define CREATE_TRACE_POINTS must
+# have that tracer file in its main search path. This is because
+# define_trace.h will include it, and must be able to find it from
+# the include/trace directory.
+#
+# Here trace-events-sample.c does the CREATE_TRACE_POINTS.
+#
 CFLAGS_trace-events-sample.o := -I$(src)
 
 obj-$(CONFIG_SAMPLE_TRACE_EVENTS) += trace-events-sample.o
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 128a897..9977a75 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -19,16 +19,21 @@
  * If TRACE_SYSTEM is defined, that will be the directory created
  * in the ftrace directory under /debugfs/tracing/events/<system>
  *
- * The define_trace.h belowe will also look for a file name of
+ * The define_trace.h below will also look for a file name of
  * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
+ * In this case, it would look for sample.h
  *
- * If you want a different system than file name, you can override
- * the header name by defining TRACE_INCLUDE_FILE
+ * If the header name will be different than the system name
+ * (as in this case), then you can override the header name that
+ * define_trace.h will look up by defining TRACE_INCLUDE_FILE
  *
- * If this file was called, goofy.h, then we would define:
+ * This file is called trace-events-sample.h but we want the system
+ * to be called "sample". Therefore we must define the name of this
+ * file:
  *
- * #define TRACE_INCLUDE_FILE goofy
+ * #define TRACE_INCLUDE_FILE trace-events-sample
  *
+ * As we do an the bottom of this file.
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM sample
@@ -99,13 +104,13 @@ TRACE_EVENT(foo_bar,
  *
  * #define TRACE_INCLUDE_PATH ../../samples/trace_events
  *
- * But I chose to simply make it use the current directory and then in
- * the Makefile I added:
+ * But the safest and easiest way to simply make it use the directory
+ * that the file is in is to add in the Makefile:
  *
- * CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
+ * CFLAGS_trace-events-sample.o := -I$(src)
  *
  * This will make sure the current path is part of the include
- * structure for our file so that we can find it.
+ * structure for our file so that define_trace.h can find it.
  *
  * I could have made only the top level directory the include:
  *
@@ -115,8 +120,8 @@ TRACE_EVENT(foo_bar,
  *
  * #define TRACE_INCLUDE_PATH samples/trace_events
  *
- * But then if something defines "samples" or "trace_events" then we
- * could risk that being converted too, and give us an unexpected
+ * But then if something defines "samples" or "trace_events" as a macro
+ * then we could risk that being converted too, and give us an unexpected
  * result.
  */
 #undef TRACE_INCLUDE_PATH
