Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZEZCFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZEZCFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZEZCEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:04:53 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34158 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZEZCEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MfkiHAy0JauJ301jZBV0b7raAcz08Y/LNdn/Git1ckMpLzpOZRsR4Yx06BrS4AH9Ii
         9RNKFrDPoaWVhYBeWGMCefXK1n6rHfLwbs2xtXIhV/nrbwSGAfNZkdHuejjq6LtyKgAV
         NWOS0GA2fgs4DwHdQk8Q8Ut1AsGDodS9MyxLQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 0/5] tracing/core: various fixes
Date: Tue, 26 May 2009 04:04:45 +0200
Message-Id: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steven,

I've gathered various tracing fixes that were posted recently.

Note: the commit b11c53e12f94a46b50bccc7a1a953d7ca1d54a31
	(ftrace: Add task_comm support for trace_event)
      looks good to me. This v3 solves the two following unhandled
      dependencies in v1:

ENABLE_EVENT_TRACING -> CONTEXT_SWITCH_TRACER
EVENT_TRACING -> CONTEXT_SWITCH_TRACER

The latter is tricky because CONTEXT_SWITCH_TRACER depends
on CONFIG_FTRACE (the tracers menu) from which EVENT_TRACING
is excluded. A build error can then occur if something selects
CONFIG_TRACING elsewhere.

The fix written by Zhaolei follows the {ENABLE_}EVENT_TRACING
view: we now have CONTEXT_SWITCH_TRACER and ENABLE_CONTEXT_SWITCH_TRACER.

The former is used by EVENT_TRACING to record cmdlines.
The latter selects CONTEXT_SWITCH_TRACER plus CONFIG_TRACING.
To sum up, ENABLE_CONTEXT_SWITCH_TRACER acts only as a "relay".

It looks good to me, tell me and Zhaolei if you have doubts
about it.

Thanks.

The following changes since commit 5537937696c55530447c20aa27daccb8d0d29b33:
  Ming Lei (1):
        ftrace: fix check for return value of register_module_notifier in event_trace_init

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Lai Jiangshan (1):
      tracing: add trace_event_read_lock()

Li Zefan (1):
      tracing/events: change the type of __str_loc_item to unsigned short

Pekka Enberg (1):
      kmemtrace: fix kernel parameter documentation

Zhaolei (2):
      ftrace: Add task_comm support for trace_event
      ftrace: clean up of using ftrace_event_enable_disable()

 Documentation/kernel-parameters.txt |   10 --------
 include/trace/ftrace.h              |    2 +-
 kernel/trace/Kconfig                |    9 +++++-
 kernel/trace/trace.c                |    8 ++++++
 kernel/trace/trace_events.c         |   42 +++++++++++++---------------------
 kernel/trace/trace_output.c         |   25 +++++++++++++++-----
 kernel/trace/trace_output.h         |    2 +
 7 files changed, 52 insertions(+), 46 deletions(-)
