Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZDMHBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZDMHBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZDMHBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:01:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51317 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZDMHA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:00:59 -0400
Message-ID: <49E2E317.5000002@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 15:00:39 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Make power trace display correct header
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_power.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 810a5b7..a74acdf 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -190,6 +190,12 @@ static enum print_line_t power_print_line(struct trace_iterator *iter)
 	return TRACE_TYPE_UNHANDLED;
 }
 
+static void power_print_header(struct seq_file *s)
+{
+	seq_printf(s, "#   TIMESTAMP      STATE  EVENT\n");
+	seq_printf(s, "#       |            |      |\n");
+}
+
 static struct tracer power_tracer __read_mostly =
 {
 	.name		= "power",
@@ -198,6 +204,7 @@ static struct tracer power_tracer __read_mostly =
 	.stop		= stop_power_trace,
 	.reset		= power_trace_reset,
 	.print_line	= power_print_line,
+	.print_header	= power_print_header,
 };
 
 static int init_power_trace(void)
-- 
1.5.5.3


