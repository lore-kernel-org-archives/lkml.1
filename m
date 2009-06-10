Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZFJRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZFJRAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZFJQ77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:59:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZFJQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:59:57 -0400
Message-Id: <20090610165306.794813861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 12:53:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 00/11] [GIT PULL][for 2.6.32] new event print tag language
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Note, this work is aimed at 2.6.32 and not this merge window,
    except for maybe the first patch.
]

Ingo,

I rebased against tip/tracing/core and folded a lot of the fix ups into
their corresponding patches. I still kept some of the tags out of
the main patch since they explain those changes nicely and also
demonstrates how to add new tags.

The first patch "tracing: add entry size to iterator" is something that
was lacking in the trace output, and I would recommend for this
merge window. Just because it is low impact and it would be a nice thing
to have for those that are working on enhancing ftrace.

The rest, could you make a separate branch for, so we can experiment
with. I'll keep the event-print-format* branches around too.

Please pull the latest tip/tracing/event-print-format-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/event-print-format-1


Steven Rostedt (11):
      tracing: add entry size to iterator
      tracing/events: nicer print format for parsing
      tracing: add nsec2sec print formats
      tracing: add major and minor tags for print format
      tracing: add func and symfunc to tag format
      tracing: update sample code with new tag format
      tracing/events: modify irq print to new format
      tracing/events: modify sched print to new format
      tracing/events: modify kmem print to new format
      tracing/events: modify lockdep print to new format
      tracing: convert the block trace points to use the new tag format

----
 include/linux/ftrace_event.h               |   13 +
 include/trace/events/block.h               |  101 +--
 include/trace/events/irq.h                 |   40 +-
 include/trace/events/kmem.h                |  100 ++--
 include/trace/events/lockdep.h             |   18 +-
 include/trace/events/sched.h               |   49 +-
 include/trace/ftrace.h                     |   22 +-
 kernel/trace/Makefile                      |    1 +
 kernel/trace/trace.c                       |   39 +-
 kernel/trace/trace_events.c                |    1 +
 kernel/trace/trace_output.c                |    2 +-
 kernel/trace/trace_output.h                |    4 +
 kernel/trace/trace_read_binary.c           |  973 ++++++++++++++++++++++++++++
 samples/trace_events/trace-events-sample.c |   21 +-
 samples/trace_events/trace-events-sample.h |   66 ++
 15 files changed, 1247 insertions(+), 203 deletions(-)
-- 
