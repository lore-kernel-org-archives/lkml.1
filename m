Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbZFIVyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbZFIVyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:54:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbZFIVxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56668 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 0/8] [GIT PULL] simplify the print fmt in the event format files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Changes since my RFC:

 - Rebased against my last tip/tracing/ftrace push
 - Added ifmask and uint (will be adding more tags soon)
 - Added memory clean up on error
 - Added locking for module unload
 - Added memory clean up of formats on module unload
 - Added lockdep update
 - Add entry size to iterator (will be used soon)

Please pull the latest tip/tracing/event-print-format tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/event-print-format


Steven Rostedt (8):
      tracing: add trace_seq_vprint interface
      tracing: add protection around module events unload
      tracing/events: nicer print format for parsing
      tracing/events: modify irq print to new format
      tracing/events: modify sched print to new format
      tracing/events: modify kmem print to new format
      tracing/events: modify lockdep print to new format
      tracing: add entry size to iterator

----
 include/linux/ftrace_event.h     |   12 +
 include/linux/trace_seq.h        |    2 +
 include/trace/events/irq.h       |   38 +-
 include/trace/events/kmem.h      |   98 +++---
 include/trace/events/lockdep.h   |   12 +-
 include/trace/events/sched.h     |   49 +--
 include/trace/ftrace.h           |   22 +-
 kernel/trace/Makefile            |    1 +
 kernel/trace/trace.c             |   39 ++-
 kernel/trace/trace_events.c      |    5 +-
 kernel/trace/trace_output.c      |   47 +++-
 kernel/trace/trace_output.h      |    4 +
 kernel/trace/trace_read_binary.c |  766 ++++++++++++++++++++++++++++++++++++++
 13 files changed, 962 insertions(+), 133 deletions(-)
-- 
