Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0BVWuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:50:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab0BVWuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:50:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 2/9] perf probe: Update perf probe document
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 17:53:34 -0500
Message-ID: <20100222225334.20686.87266.stgit@localhost6.localdomain6>
In-Reply-To: <20100222225320.20686.17645.stgit@localhost6.localdomain6>
References: <20100222225320.20686.17645.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update perf-probe.txt to suit to current perf-probe command
and add some examples.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
