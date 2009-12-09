Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZLIH1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZLIH1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbZLIH1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:27:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:45723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079AbZLIH1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:27:00 -0500
Date: Wed, 9 Dec 2009 07:25:04 GMT
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
In-Reply-To: <20091208220247.10142.91642.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220247.10142.91642.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Change probe-added message more user-friendly
Message-ID: <tip-a9b495b0d35859971d6896293f6d0a0d880c7dfb@git.kernel.org>
Git-Commit-ID: a9b495b0d35859971d6896293f6d0a0d880c7dfb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9b495b0d35859971d6896293f6d0a0d880c7dfb
Gitweb:     http://git.kernel.org/tip/a9b495b0d35859971d6896293f6d0a0d880c7dfb
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:02:47 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:51 +0100

perf probe: Change probe-added message more user-friendly

Change probe-added message more user-friendly expression and
show usage of new events.

Before:
Added new event: p:probe/schedule_0 schedule+10 prev=%ax cpu=%bx

After:
Added new event:
  probe:schedule_1                         (on schedule+1 with prev cpu)

You can now use it on all perf tools, such as:

        perf record -e probe:schedule_1 -a sleep 1

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
LKML-Reference: <20091208220247.10142.91642.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a20e382..2c4d301 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -453,17 +453,13 @@ static struct strlist *get_perf_event_names(int fd)
 	return sl;
 }
 
-static int write_trace_kprobe_event(int fd, const char *buf)
+static void write_trace_kprobe_event(int fd, const char *buf)
 {
 	int ret;
 
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
 		die("Failed to create event.");
-	else
-		printf("Added new event: %s\n", buf);
-
-	return ret;
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
@@ -503,10 +499,19 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 				 PERFPROBE_GROUP, event,
 				 pp->probes[i]);
 			write_trace_kprobe_event(fd, buf);
+			printf("Added new event:\n");
+			/* Get the first parameter (probe-point) */
+			sscanf(pp->probes[i], "%s", buf);
+			show_perf_probe_event(PERFPROBE_GROUP, event,
+					      buf, pp);
 			/* Add added event name to namelist */
 			strlist__add(namelist, event);
 		}
 	}
+	/* Show how to use the event. */
+	printf("\nYou can now use it on all perf tools, such as:\n\n");
+	printf("\tperf record -e %s:%s -a sleep 1\n\n", PERFPROBE_GROUP, event);
+
 	strlist__delete(namelist);
 	close(fd);
 }
