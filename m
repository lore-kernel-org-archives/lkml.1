Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab0BYTb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:31:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:33975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab0BYTbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:31:49 -0500
Date: Thu, 25 Feb 2010 19:30:36 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       ananth@in.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       ananth@in.ibm.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133519.6725.58816.stgit@localhost6.localdomain6>
References: <20100225133519.6725.58816.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf probe: Update perf probe document
Message-ID: <tip-ee391de876ae4272926b8632be04ed4a460321e3@git.kernel.org>
Git-Commit-ID: ee391de876ae4272926b8632be04ed4a460321e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:30:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee391de876ae4272926b8632be04ed4a460321e3
Gitweb:     http://git.kernel.org/tip/ee391de876ae4272926b8632be04ed4a460321e3
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:35:19 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:27 +0100

perf probe: Update perf probe document

Update perf-probe.txt to suit to current perf-probe command
and add some examples.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133519.6725.58816.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-probe.txt |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 2de3407..5fe63c0 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -41,7 +41,8 @@ OPTIONS
 
 -d::
 --del=::
-	Delete a probe event.
+	Delete probe events. This accepts glob wildcards('*', '?') and character
+	classes(e.g. [a-z], [!A-Z]).
 
 -l::
 --list::
@@ -50,7 +51,11 @@ OPTIONS
 -L::
 --line=::
 	Show source code lines which can be probed. This needs an argument
-	which specifies a range of the source code.
+	which specifies a range of the source code. (see LINE SYNTAX for detail)
+
+-f::
+--force::
+	Forcibly add events with existing name.
 
 PROBE SYNTAX
 ------------
@@ -76,6 +81,25 @@ and 'ALN2' is end line number in the file. It is also possible to specify how
 many lines to show by using 'NUM'.
 So, "source.c:100-120" shows lines between 100th to l20th in source.c file. And "func:10+20" shows 20 lines from 10th line of func function.
 
+EXAMPLES
+--------
+Display which lines in schedule() can be probed:
+
+ ./perf probe --line schedule
+
+Add a probe on schedule() function 12th line with recording cpu local variable:
+
+ ./perf probe schedule:12 cpu
+ or
+ ./perf probe --add='schedule:12 cpu'
+
+ this will add one or more probes which has the name start with "schedule".
+
+Delete all probes on schedule().
+
+ ./perf probe --del='schedule*'
+
+
 SEE ALSO
 --------
 linkperf:perf-trace[1], linkperf:perf-record[1]
