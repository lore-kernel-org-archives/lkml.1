Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0BYDnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:43:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab0BYDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vd93jayoPehf/NdE/UQ4grJxJzuPRz152BboDvJ3aqrCRD0vZq9LTjhtNIczary+1D
         TqVbDObr1sjL0Vdq+cTMJ5pW14V81COFoCoteIjxosZOQP5myLIwCntcfkZ9knDYYCRh
         TfXozlpZYZadpM8YA9CYsKXlIvpgNCXO5hD0U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/10] perf/scripts: Tag syscall_name helper as not yet available
Date: Thu, 25 Feb 2010 04:42:41 +0100
Message-Id: <1267069361-10909-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall_name() helper, which resolves a syscall arch number to
its name, is not yet available as we first need to implement
event injection for it to work.

Remove it from the documentation or tag its references as
unavailable yet. Once it's implemented, we can just revert
the current patch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace-perl.txt   |    1 -
 tools/perf/Documentation/perf-trace-python.txt |    7 ++++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace-perl.txt b/tools/perf/Documentation/perf-trace-perl.txt
index d2206c3..d729cee 100644
--- a/tools/perf/Documentation/perf-trace-perl.txt
+++ b/tools/perf/Documentation/perf-trace-perl.txt
@@ -213,7 +213,6 @@ Various utility functions for use with perf trace:
   nsecs_nsecs($nsecs) - returns nsecs remainder given nsecs
   nsecs_str($nsecs) - returns printable string in the form secs.nsecs
   avg($total, $n) - returns average given a sum and a total number of values
-  syscall_name($id) - returns the syscall name for the specified syscall_nr
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-trace-python.txt b/tools/perf/Documentation/perf-trace-python.txt
index 119d5de..a241aca 100644
--- a/tools/perf/Documentation/perf-trace-python.txt
+++ b/tools/perf/Documentation/perf-trace-python.txt
@@ -36,7 +36,8 @@ scripts listed by that command.
 
 The syscall-counts script is a simple script, but demonstrates all the
 basic ideas necessary to create a useful script.  Here's an example
-of its output:
+of its output (syscall names are not yet supported, they will appear
+as numbers):
 
 ----
 syscall events:
@@ -270,7 +271,8 @@ calling the print_syscall_totals() function from the trace_end()
 handler called at the end of script processing.
 
 The final script producing the output shown above is shown in its
-entirety below:
+entirety below (syscall_name() helper is not yet available, you can
+only deal with id's for now):
 
 ----
 import os
@@ -617,7 +619,6 @@ Various utility functions for use with perf trace:
   nsecs_nsecs(nsecs) - returns nsecs remainder given nsecs
   nsecs_str(nsecs) - returns printable string in the form secs.nsecs
   avg(total, n) - returns average given a sum and a total number of values
-  syscall_name(id) - returns the syscall name for the specified syscall_nr
 
 SEE ALSO
 --------
-- 
1.6.2.3

