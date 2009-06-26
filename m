Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZFZSwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZFZSwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZFZSwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:52:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:49182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZFZSwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:52:18 -0400
Date: Fri, 26 Jun 2009 18:51:44 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4A448FB6.5000302@cn.fujitsu.com>
References: <4A448FB6.5000302@cn.fujitsu.com>
Subject: [tip:tracing/urgent] trace_export: Repair missed fields
Message-ID: <tip-82d5308127c3e3404ffbf41e503853c68660b18b@git.kernel.org>
Git-Commit-ID: 82d5308127c3e3404ffbf41e503853c68660b18b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 26 Jun 2009 18:51:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82d5308127c3e3404ffbf41e503853c68660b18b
Gitweb:     http://git.kernel.org/tip/82d5308127c3e3404ffbf41e503853c68660b18b
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Fri, 26 Jun 2009 17:07:02 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Jun 2009 20:48:40 +0200

trace_export: Repair missed fields

Some fields for struct ftrace_graph_ret are missed
when they are exported to user.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A448FB6.5000302@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_event_types.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

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
