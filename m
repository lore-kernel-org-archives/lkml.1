Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZJODVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZJODVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZJODVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:21:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbZJODVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:21:08 -0400
Message-ID: <4AD694B8.2020206@cn.fujitsu.com>
Date: Thu, 15 Oct 2009 11:19:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] perf trace: Add filter Suppport, V3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds filter support for perf event, so not all
profile events are recorded but only those match the filters
we set.

An example:

 #./perf record -R -f -e irq:irq_handler_entry --filter irq==18
 ^C
 # ./perf trace
            perf-4303  ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0
            init-0     ... irq_handler_entry: irq=18 handler=eth0

The syntax of filter expressions can be found in
Documentation/trace/events.txt.

Major changes since V2:

- Remove struct perf_event::filter_active.

Major changes since V1:

- Make filters per perf event, instead of per tracepoint.

- Use "--filter" to set a filter for a trace event, instead of
  mixing it into "-e" option.

---
 include/linux/ftrace_event.h       |   11 ++-
 include/linux/perf_counter.h       |    1 +
 include/linux/perf_event.h         |    6 +
 kernel/perf_event.c                |   80 +++++++++-
 kernel/trace/trace.h               |    6 +-
 kernel/trace/trace_events_filter.c |  302 +++++++++++++++++++++---------------
 tools/perf/builtin-record.c        |   15 ++-
 tools/perf/util/parse-events.c     |   26 +++-
 tools/perf/util/parse-events.h     |    2 +
 9 files changed, 306 insertions(+), 143 deletions(-)


