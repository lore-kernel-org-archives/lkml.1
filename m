Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZKDPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZKDPZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZKDPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:25:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:57298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbZKDPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:25:38 -0500
Date: Wed, 4 Nov 2009 15:25:02 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20091104001221.3454.52030.stgit@harusame>
References: <20091104001221.3454.52030.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Improve error messages
Message-ID: <tip-a7f4328b91fb6e71dbe1fa4d46f3597c9555014d@git.kernel.org>
Git-Commit-ID: a7f4328b91fb6e71dbe1fa4d46f3597c9555014d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7f4328b91fb6e71dbe1fa4d46f3597c9555014d
Gitweb:     http://git.kernel.org/tip/a7f4328b91fb6e71dbe1fa4d46f3597c9555014d
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 3 Nov 2009 19:12:21 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:02:46 +0100

perf/probes: Improve error messages

Improve error messages in perf-probe so that users can figure
out problems easily.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091104001221.3454.52030.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |   20 +++++++++++++-------
 tools/perf/util/probe-finder.c |    2 +-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 8124523..65bcaed 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -294,10 +294,11 @@ static int write_new_event(int fd, const char *buf)
 {
 	int ret;
 
-	printf("Adding new event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
-		die("failed to create event.");
+		die("Failed to create event.");
+	else
+		printf("Added new event: %s\n", buf);
 
 	return ret;
 }
@@ -310,7 +311,7 @@ static int synthesize_probe_event(struct probe_point *pp)
 	int i, len, ret;
 	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
 	if (!buf)
-		die("calloc");
+		die("Failed to allocate memory by calloc.");
 	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
 	if (ret <= 0 || ret >= MAX_CMDLEN)
 		goto error;
@@ -363,7 +364,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		if (ret == -E2BIG)
 			semantic_error("probe point is too long.");
 		else if (ret < 0)
-			die("snprintf");
+			die("Failed to synthesize a probe point.");
 	}
 
 #ifndef NO_LIBDWARF
@@ -375,7 +376,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	else
 		fd = open_default_vmlinux();
 	if (fd < 0)
-		die("vmlinux/module file open");
+		die("Could not open vmlinux/module file.");
 
 	/* Searching probe points */
 	for (j = 0; j < session.nr_probe; j++) {
@@ -396,8 +397,13 @@ setup_probes:
 	/* Settng up probe points */
 	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
 	fd = open(buf, O_WRONLY, O_APPEND);
-	if (fd < 0)
-		die("kprobe_events open");
+	if (fd < 0) {
+		if (errno == ENOENT)
+			die("kprobe_events file does not exist - please rebuild with CONFIG_KPROBE_TRACER.");
+		else
+			die("Could not open kprobe_events file: %s",
+			    strerror(errno));
+	}
 	for (j = 0; j < session.nr_probe; j++) {
 		pp = &session.probes[j];
 		if (pp->found == 1) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index db96186..35d5a69 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -688,7 +688,7 @@ int find_probepoint(int fd, struct probe_point *pp)
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
 	if (ret != DW_DLV_OK)
-		die("Failed to call dwarf_init(). Maybe, not a dwarf file.\n");
+		die("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.\n");
 
 	pp->found = 0;
 	while (++cu_number) {
