Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042Ab0ASHfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0ASHfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959Ab0ASHfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0ASHfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:10 -0500
Message-ID: <4B556056.2080101@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:33:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] tracing: separate out buffer from trace_seq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quote from Steven:
"""
This is an RFC patch set. The trace_seq currently has its buffer
within the structure itself. But this limits its ability and efficiency.

This patch set separates it out, but now it requires the callers
to supply their own buffer. But this helps out the splice code because
it can now write directly into the splice pages.
"""

Lai Jiangshan (4)
      tracing: bug fix, remove partial zeroed out
      tracing: event_id_read() uses simple buffer instead of trace_seq
      tracing: tracing_stats_read() uses simple buffer instead of trace_seq
      tracing: reduce latency and remove percpu trace_seq

Steven Rostedt (2):
      tracing: Change trace_seq to use separate buffer
      tracing: Write directly into splice page for trace_pipe

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    9 +++-
 include/linux/trace_seq.h    |   22 +++++++++++-
 include/trace/ftrace.h       |   18 +++------
 kernel/trace/ftrace.c        |    3 +
 kernel/trace/trace.c         |   72 +++++++++++----------------------------
 kernel/trace/trace_events.c  |   78 ++++++++++++++++++++-----------------------
 kernel/trace/trace_ksym.c    |   12 +++---
 kernel/trace/trace_output.c  |   25 ++++++-------
 8 files changed, 110 insertions(+), 129 deletions(-)


