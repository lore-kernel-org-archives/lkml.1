Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbZLPWUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbZLPWUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZLPWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:20:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZLPWUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:20:04 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/3] perf probe: Check debugpath is correct
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 16 Dec 2009 17:24:00 -0500
Message-ID: <20091216222400.14459.48162.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether debugpath is correct before executing command,
because perf-probe depends on the debugpath.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 7e741f5..c1e6774 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -38,6 +38,7 @@
 #include "util/strlist.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/debugfs.h"
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/session.h"
@@ -205,6 +206,9 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if ((!session.nr_probe && !session.dellist && !session.list_events))
 		usage_with_options(probe_usage, options);
 
+	if (debugfs_valid_mountpoint(debugfs_path) < 0)
+		die("Failed to find debugfs path.");
+
 	if (session.list_events) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --list with"


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
