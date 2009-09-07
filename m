Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbZIGINP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbZIGINP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZIGINO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:13:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61449 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZIGINN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:13:13 -0400
Message-ID: <4AA4C04D.1050201@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:11:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] perf trace: Add filter support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds filter support for perf counter, so not all
profile events are recorded but only those match the filters
we set.

An example:

 #./perf record -f -e irq:irq_handler_entry:irq==18:record
 or
 #./perf record -f -e irq:irq_handler_entry:irq==18 -R
 ^C
 # ./perf trace
 version = 0.5
            perf-4303  ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0

---
 include/linux/ftrace_event.h       |   19 +++-
 include/linux/perf_counter.h       |    1 +
 include/linux/syscalls.h           |   14 ++-
 include/trace/ftrace.h             |   10 +-
 kernel/perf_counter.c              |   40 ++++++-
 kernel/trace/trace.h               |    9 +-
 kernel/trace/trace_event_profile.c |   18 +++
 kernel/trace/trace_events_filter.c |  247 +++++++++++++++++++++---------------
 kernel/trace/trace_syscalls.c      |    9 +-
 tools/perf/builtin-record.c        |   12 ++
 tools/perf/util/parse-events.c     |   48 ++++++-
 tools/perf/util/parse-events.h     |    1 +
 12 files changed, 303 insertions(+), 125 deletions(-)

