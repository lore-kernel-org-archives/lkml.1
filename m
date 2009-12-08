Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbZLHT5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbZLHT5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZLHT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:57:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbZLHT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:57:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=Mjnsj-nqntgA:10 a=VwQbUJbxAAAA:8 a=oucFqDjQXLSq3mRFSdkA:9 a=a8Ui4mX3SXyM8wp7XmFkQsid8_4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091208195405.653797300@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Dec 2009 14:54:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/2][RFC] [RFC] tracing: separate out buffer from trace_seq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patch set. The trace_seq currently has its buffer
within the structure itself. But this limits its ability and efficiency.

This patch set separates it out, but now it requires the callers
to supply their own buffer. But this helps out the splice code because
it can now write directly into the splice pages.

This may be too much for 33? But it is a nice fix.

Thoughs?

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/tracing/core


Steven Rostedt (2):
      tracing: Change trace_seq to use separate buffer
      tracing: Write directly into splice page for trace_pipe

----
 include/linux/ftrace_event.h |    6 ++++-
 include/linux/trace_seq.h    |   22 +++++++++++++++-
 include/trace/ftrace.h       |   20 +++++++++++----
 kernel/trace/ftrace.c        |    3 +-
 kernel/trace/trace.c         |   54 ++++++++++++++++-------------------------
 kernel/trace/trace_events.c  |   45 +++++++++++++++++++++++++++++++----
 kernel/trace/trace_ksym.c    |   10 +++++++-
 kernel/trace/trace_output.c  |   24 ++++++++++--------
 8 files changed, 125 insertions(+), 59 deletions(-)

