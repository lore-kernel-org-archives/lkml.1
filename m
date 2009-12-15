Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbZLOT2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbZLOT2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933503AbZLOT2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:28:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:50952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502AbZLOT2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:28:32 -0500
Date: Tue, 15 Dec 2009 19:26:26 GMT
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
In-Reply-To: <20091215153203.17436.52039.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153203.17436.52039.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Use strlist__for_each macros in probe-event.c
Message-ID: <tip-adf365f486280e4577c9eabd7d8e118e5994a03e@git.kernel.org>
Git-Commit-ID: adf365f486280e4577c9eabd7d8e118e5994a03e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adf365f486280e4577c9eabd7d8e118e5994a03e
Gitweb:     http://git.kernel.org/tip/adf365f486280e4577c9eabd7d8e118e5994a03e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:32:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:02 +0100

perf probe: Use strlist__for_each macros in probe-event.c

Use strlist__for_each macros instead of using strlist__entry()
and index variable.

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
LKML-Reference: <20091215153203.17436.52039.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index eab25d6..3e30be9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -404,7 +404,6 @@ static void show_perf_probe_event(const char *group, const char *event,
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
-	unsigned int i;
 	int fd, nr;
 	char *group, *event;
 	struct probe_point pp;
@@ -415,8 +414,7 @@ void show_perf_probe_events(void)
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);
 
-	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
-		ent = strlist__entry(rawlist, i);
+	strlist__for_each(ent, rawlist) {
 		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
 		/* Synthesize only event probe point */
 		nr = pp.nr_args;
@@ -436,7 +434,6 @@ void show_perf_probe_events(void)
 /* Get current perf-probe event names */
 static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
-	unsigned int i;
 	char *group, *event;
 	char buf[128];
 	struct strlist *sl, *rawlist;
@@ -445,8 +442,7 @@ static struct strlist *get_perf_event_names(int fd, bool include_group)
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 
 	sl = strlist__new(true, NULL);
-	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
-		ent = strlist__entry(rawlist, i);
+	strlist__for_each(ent, rawlist) {
 		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
 		if (include_group) {
 			if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
@@ -561,7 +557,6 @@ static void del_trace_kprobe_event(int fd, const char *group,
 void del_trace_kprobe_events(struct strlist *dellist)
 {
 	int fd;
-	unsigned int i;
 	const char *group, *event;
 	char *p, *str;
 	struct str_node *ent;
@@ -571,8 +566,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 	/* Get current event names */
 	namelist = get_perf_event_names(fd, true);
 
-	for (i = 0; i < strlist__nr_entries(dellist); i++) {
-		ent = strlist__entry(dellist, i);
+	strlist__for_each(ent, dellist) {
 		str = strdup(ent->s);
 		if (!str)
 			die("Failed to copy event.");
