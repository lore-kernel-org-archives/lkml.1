Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZDMVre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZDMVre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZDMVrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:47:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:59662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbZDMVrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:47:14 -0400
Date: Mon, 13 Apr 2009 21:46:27 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, arjan@linux.intel.com, zhaolei@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, arjan@linux.intel.com, zhaolei@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49E2E889.5000903@cn.fujitsu.com>
References: <49E2E889.5000903@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix power tracer header
Message-ID: <tip-a3d03ecaf9fe722bf96e4ef4a2f5e42ef652ddeb@git.kernel.org>
Git-Commit-ID: a3d03ecaf9fe722bf96e4ef4a2f5e42ef652ddeb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 21:46:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3d03ecaf9fe722bf96e4ef4a2f5e42ef652ddeb
Gitweb:     http://git.kernel.org/tip/a3d03ecaf9fe722bf96e4ef4a2f5e42ef652ddeb
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Mon, 13 Apr 2009 15:23:53 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Apr 2009 23:39:57 +0200

tracing: Fix power tracer header

Before patch:
  # tracer: power
  #
  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
  #              | |       |          |         |
  [  676.875865889] CSTATE: Going to C1 on cpu 0 for 0.005911463
  [  676.882938805] CSTATE: Going to C1 on cpu 0 for 0.104796532
  ...

After patch:
  # tracer: power
  #
  #   TIMESTAMP      STATE  EVENT
  #       |            |      |
  [  676.875865889] CSTATE: Going to C1 on cpu 0 for 0.005911463
  [  676.882938805] CSTATE: Going to C1 on cpu 0 for 0.104796532
  ...

v2: Use seq_puts instead of seq_printf

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <49E2E889.5000903@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_power.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index bae791e..1184397 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -186,6 +186,12 @@ static enum print_line_t power_print_line(struct trace_iterator *iter)
 	return TRACE_TYPE_UNHANDLED;
 }
 
+static void power_print_header(struct seq_file *s)
+{
+	seq_puts(s, "#   TIMESTAMP      STATE  EVENT\n");
+	seq_puts(s, "#       |            |      |\n");
+}
+
 static struct tracer power_tracer __read_mostly =
 {
 	.name		= "power",
@@ -194,6 +200,7 @@ static struct tracer power_tracer __read_mostly =
 	.stop		= stop_power_trace,
 	.reset		= power_trace_reset,
 	.print_line	= power_print_line,
+	.print_header	= power_print_header,
 };
 
 static int init_power_trace(void)
