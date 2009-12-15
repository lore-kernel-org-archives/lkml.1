Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbZLOT3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbZLOT3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbZLOT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:29:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:50999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760972AbZLOT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:29:11 -0500
Date: Tue, 15 Dec 2009 19:25:16 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091215153128.17436.9266.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153128.17436.9266.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Check hyphen only argument
Message-ID: <tip-ce11a603ae40e0ad32aeb378cff81e3fdaec390d@git.kernel.org>
Git-Commit-ID: ce11a603ae40e0ad32aeb378cff81e3fdaec390d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce11a603ae40e0ad32aeb378cff81e3fdaec390d
Gitweb:     http://git.kernel.org/tip/ce11a603ae40e0ad32aeb378cff81e3fdaec390d
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:31:28 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:00 +0100

perf probe: Check hyphen only argument

Check hyphen only command argument, because perf-probe doesn't
support event recording feature yet.

e.g.

 # perf probe -
  Error: '-' is not supported.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091215153128.17436.9266.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 559eeb4..919037b 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -205,8 +205,13 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
-	if (argc > 0)
+	if (argc > 0) {
+		if (strcmp(argv[0], "-") == 0) {
+			pr_warning("  Error: '-' is not supported.\n");
+			usage_with_options(probe_usage, options);
+		}
 		parse_probe_event_argv(argc, argv);
+	}
 
 	if ((!session.nr_probe && !session.dellist && !session.list_events))
 		usage_with_options(probe_usage, options);
