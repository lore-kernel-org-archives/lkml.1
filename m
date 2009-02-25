Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbZBYUfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbZBYUfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbZBYUed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:34:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbZBYUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:34:30 -0500
Message-Id: <20090225203007.582030664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 15:30:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [git pull] for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch series implements copy_word_from_user. I found three open
coded locations in ftrace that implemented this. It basically allows
the kernel to read a space delimited word from user space.

This change is a nice clean up to the code. It also fixes a minor
bug that was in one of the implementations. That is, if there was
too much space between the words, it could cause another unneeded
iteration back to userspace. The result was the same, but the
implementation was not clean.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      uaccess: add copy_word_from_user
      tracing: convert event_trace to use copy_word_from_user
      tracing: convert ftrace_regex_write to use copy_word_from_user
      tracing: convert ftrace_graph_write to use copy_word_from_user

----
 include/linux/uaccess.h     |    4 +
 kernel/trace/ftrace.c       |  155 ++++++++++++++++++++++---------------------
 kernel/trace/trace_events.c |   78 ++++++++++------------
 lib/Makefile                |    3 +-
 lib/uaccess.c               |  134 +++++++++++++++++++++++++++++++++++++
 5 files changed, 252 insertions(+), 122 deletions(-)

-- 
