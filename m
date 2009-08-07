Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZHGCeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZHGCeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZHGCeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:34:07 -0400
Received: from [222.73.24.84] ([222.73.24.84]:62446 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756486AbZHGCeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:34:06 -0400
Message-ID: <4A7B9242.7010204@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 10:32:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2 0/3] tracing/filters: Support specifying filter hook to
 a TRACE_EVENT field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: no big changes, but addressed Steven's comments

Currently only static strings and dynamic strings have their
own filter functions, other types of field are treated as
integers.

This patchset allows assigning a specific filter type to a
field, so a field which is defined as:

	__field_ext(const char *, str, FILTER_PTR_STR)

will be treated as a string but not a plain pointer, and then
we can set the filter like this:

	# echo 'str == foo' > filter

And it's easy to add more filter functions for different types
to turn these into valid operations:

	(dev is of type dev_t)
	# echo 'dev == 8:0' > filter

	(callsite is of type void * or unsigned long)
	# echo 'callsite == skb_free' > filter

[PATCH 1/3] tracing/filters: Add filter_type to struct ftrace_event_field
[PATCH 2/3] tracing/filters: Add __field_ext() to TRACE_EVENT
[PATCH 3/3] tracing/filters: Support filtering for char * strings
---
 include/linux/ftrace_event.h       |   12 +++++++-
 include/trace/ftrace.h             |   31 ++++++++++++++++++-----
 kernel/trace/trace.h               |    2 +
 kernel/trace/trace_events.c        |    9 ++++++-
 kernel/trace/trace_events_filter.c |   47 +++++++++++++++++++++++++----------
 kernel/trace/trace_export.c        |    8 ++++--
 6 files changed, 82 insertions(+), 27 deletions(-)



