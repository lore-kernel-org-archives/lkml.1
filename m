Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZDMHY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZDMHY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZDMHYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:24:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63964 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZDMHYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:24:16 -0400
Message-ID: <49E2E889.5000903@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 15:23:53 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] tracing: Make power trace display correct header
References: <49E2E317.5000002@cn.fujitsu.com>
In-Reply-To: <49E2E317.5000002@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog:
v1: Make power trace display correct header
v2: Use seq_puts instead of seq_printf

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
index 810a5b7..8a30d98 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -190,6 +190,12 @@ static enum print_line_t power_print_line(struct trace_iterator *iter)
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
@@ -198,6 +204,7 @@ static struct tracer power_tracer __read_mostly =
 	.stop		= stop_power_trace,
 	.reset		= power_trace_reset,
 	.print_line	= power_print_line,
+	.print_header	= power_print_header,
 };
 
 static int init_power_trace(void)
-- 
1.5.5.3



