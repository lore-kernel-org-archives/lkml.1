Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZLIH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZLIH3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZLIH3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:29:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:45846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZLIH3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:29:15 -0500
Date: Wed, 9 Dec 2009 07:25:32 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091208220301.10142.50031.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220301.10142.50031.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Remove event suffix number _0
Message-ID: <tip-17f88fcd667a914b6f4dca146c9a09492fcd57b8@git.kernel.org>
Git-Commit-ID: 17f88fcd667a914b6f4dca146c9a09492fcd57b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17f88fcd667a914b6f4dca146c9a09492fcd57b8
Gitweb:     http://git.kernel.org/tip/17f88fcd667a914b6f4dca146c9a09492fcd57b8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:03:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:52 +0100

perf probe: Remove event suffix number _0

Remove event suffix number _0 if it is the first.
The first event has no suffix, and from the second,
each event has suffix number counted from _1. This
reduces typing cost :-).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091208220301.10142.50031.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2c4d301..31beedc 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -466,7 +466,16 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 			       struct strlist *namelist)
 {
 	int i, ret;
-	for (i = 0; i < MAX_EVENT_INDEX; i++) {
+
+	/* Try no suffix */
+	ret = e_snprintf(buf, len, "%s", base);
+	if (ret < 0)
+		die("snprintf() failed: %s", strerror(-ret));
+	if (!strlist__has_entry(namelist, buf))
+		return;
+
+	/* Try to add suffix */
+	for (i = 1; i < MAX_EVENT_INDEX; i++) {
 		ret = e_snprintf(buf, len, "%s_%d", base, i);
 		if (ret < 0)
 			die("snprintf() failed: %s", strerror(-ret));
