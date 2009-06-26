Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZFZJFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZFZJFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZFZJFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:05:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59230 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758195AbZFZJFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:05:05 -0400
Message-ID: <4A448FB6.5000302@cn.fujitsu.com>
Date: Fri, 26 Jun 2009 17:07:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace_export: repair missed fields
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some fields for struct ftrace_graph_ret are missed
when they are exported to user.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 5e32e37..6db005e 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -26,6 +26,9 @@ TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
 		   ftrace_graph_ret_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ret.func, func)
+		TRACE_FIELD(unsigned long long, ret.calltime, calltime)
+		TRACE_FIELD(unsigned long long, ret.rettime, rettime)
+		TRACE_FIELD(unsigned long, ret.overrun, overrun)
 		TRACE_FIELD(int, ret.depth, depth)
 	),
 	TP_RAW_FMT("<-- %lx (%d)")


