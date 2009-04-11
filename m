Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZDKHvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZDKHvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZDKHvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:51:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZDKHvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:51:32 -0400
Message-ID: <49E04C22.4040608@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:52:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] tracing: bug fixes for tracing/filters
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes some bugs in tracing/filters. Most of the change
goes to the last patch, and others are small ones.

Maybe 3rd to 6th patches can be regarded as small enhancements instead
of bug fixes? But they are behavioural changes.


[PATCH 1/7] tracing/filters: NUL-terminate user input filter
[PATCH 2/7] tracing/filters: fix NULL pointer dereference
[PATCH 3/7] tracing/filters: allow user input integer to be oct or hex
[PATCH 4/7] tracing/filters: allow user to specify a filter val to be string
[PATCH 5/7] tracing/filters: disallow newline as delimeter
[PATCH 6/7] tracing/filters: return proper error code when writing filter file
[PATCH 7/7] tracing/filters: make filter preds RCU safe

 kernel/trace/trace.h                |    6 +-
 kernel/trace/trace_events.c         |   16 +++--
 kernel/trace/trace_events_filter.c  |  131 ++++++++++++++++++++++++++---------
 kernel/trace/trace_events_stage_3.h |   10 +++-
 4 files changed, 121 insertions(+), 42 deletions(-)
---
