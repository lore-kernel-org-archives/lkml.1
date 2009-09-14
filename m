Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbZINUrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbZINUrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZINUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbZINUrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:47:14 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 0/6] tracing/kprobes: kprobe-based event
	tracer update and perf support
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 14 Sep 2009 16:48:47 -0400
Message-ID: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are bugfixes for kprobe-based event tracer. Thank you for review
and reporting bugs! I fixed it. And also I decided to disable
kprobe event when defining, since the events outputs may suddenly
mess up the ftrace ring_buffer.

Frederic, could you see the patch 4/6? which is what I said on the
previous threads.


Thank you,

---

Masami Hiramatsu (6):
      tracing/kprobes: Disable kprobe events by default
      tracing/kprobes: Fix profiling alignment for perf_counter buffer
      tracing/kprobes: Add probe handler dispatcher for support perf and ftrace
      ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
      ftrace: Fix trace_add_event_call() to initialize list
      tracing/kprobes: Fix trace_probe registration order


 Documentation/trace/kprobetrace.txt |   11 ++-
 kernel/trace/trace_events.c         |   11 ++-
 kernel/trace/trace_kprobe.c         |  146 +++++++++++++++++++++++------------
 3 files changed, 114 insertions(+), 54 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
