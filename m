Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbZLQKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbZLQKxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbZLQKxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:53:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:54004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760243AbZLQKxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:53:37 -0500
Date: Thu, 17 Dec 2009 10:51:31 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091216222400.14459.48162.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216222400.14459.48162.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Check whether debugfs path is correct
Message-ID: <tip-96c96612e952f63cc0055db9df7d8b5b1ada02be@git.kernel.org>
Git-Commit-ID: 96c96612e952f63cc0055db9df7d8b5b1ada02be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96c96612e952f63cc0055db9df7d8b5b1ada02be
Gitweb:     http://git.kernel.org/tip/96c96612e952f63cc0055db9df7d8b5b1ada02be
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 16 Dec 2009 17:24:00 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 09:42:43 +0100

perf probe: Check whether debugfs path is correct

Check whether the debugfs path is correct before executing
a command, because perf-probe depends on debugfs.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091216222400.14459.48162.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
