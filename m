Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZCaH17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZCaH17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZCaH1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:27:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZCaH1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:27:48 -0400
Message-ID: <49D1C543.3010307@cn.fujitsu.com>
Date: Tue, 31 Mar 2009 15:24:51 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ftrace: Add check of sched_stopped for probe_sched_wakeup
References: <49D1C51C.7000407@cn.fujitsu.com>
In-Reply-To: <49D1C51C.7000407@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need check sched_stopped in probe_sched_wakeup() to stop tracing when an
user stops it.

But current code can also do the right thing(stop tracing after
echo 0 > tracing_enabled) just because tracing_sched_wakeup_trace() can return
on buffer->record_disabled.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_sched_switch.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index de35f20..9117cea 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -62,6 +62,9 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	pc = preempt_count();
 	tracing_record_cmdline(current);
 
+	if (sched_stopped)
+		return;
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
-- 
1.5.5.3


