Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZIOKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZIOKJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZIOKJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:09:29 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61804 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZIOKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:09:28 -0400
Message-ID: <4AAF6724.9080201@bk.jp.nec.com>
Date: Tue, 15 Sep 2009 19:06:28 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: [PATCH 0/2] tracing: Tracing integration - dynamic ftrace for SystemTap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, there are some tracers using in Linux. Each of them are
developed for different users and situations.

Ftrace has own probe mechanism, dynamic ftrace, and various plugins,
and it can be used without particular userland tools. It is suitable
for kernel developer. The performance counters have own userland tool
merged in the kernel tree and it's easy to trace kernel events by using
this tool. It is suitable for people who don't have enough knowledge
of internal kernel. SystemTap has own scripting language and users can
gather kernel internal information suited to their needs by customizing
the script. Since it also has features, the log rotation and the
initscript, to keep collecting information continually, it is suitable
for system administrator and enterprise users.

I think we need to use those tracers as the situation demands, since
no tracer exists to meet anyone's needs and to fit any situation.
Then, we should consider the tracing mechanisms (kprobe, dynamic ftrace
and etc. kernel tracing features) and tracers (user interface)
separately, and all tracers should be able to use each tracing mechanisms.

The mechanism of dynamic ftrace is useful for all tracers. However
only ftrace can currently use it. I think it can be used for other
tracers via register_ and unregister_ftrace_function_probe
function. By using it, the overhead of instrumentation can be reduced
and gathering information, which cannot be traced because of a large
overhead, become available. Also it can enable the performance
counters to count events for all kernel functions.

First, I sent patches to integrate ftrace and SystemTap by just exporting
ftrace API. Also I fixed minor bugs for __unregister_ftrace_function_probe.

The patches doesn't contain the performance counters integration,
since it is still in development. I think following implementations are
needed:
- add new type to perf_id (like PERF_TYPE_FTRACE)
- add event ids to struct dyn_ftrace
- add interfaces to reference event ids by user (via debugfs?)
- add probe function to count ftrace events (call do_perf_swcounter_event)

Those patches are for -tip tree.

Thanks,
Atsushi

Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
---
 kernel/trace/ftrace.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)






