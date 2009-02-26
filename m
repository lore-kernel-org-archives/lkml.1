Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZBZS7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZBZS7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBZS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:59:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZBZS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:59:05 -0500
Message-Id: <20090226185419.371469287@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 13:54:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 0/6] [RFC] copy_strtok_from_user
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v3:

 - created strtok_r for kernel.

 - Simplified copy_strtok_from_user by using strtok_r

 - updated the rest of the code to handle the above changes

I tested both the strtok_r and copy_strtok_from_user with this user app:

 http://www.kernel.org/pub/linux/kernel/people/rostedt/copy_strtok_from_user.c

Results of the test are here:

 http://www.kernel.org/pub/linux/kernel/people/rostedt/copy_strtok_test.txt

I added a "#undef strtok_r" after the strtok_r function and ran it again
to make sure the output was still the same, and it was.

Andrew, If this version is fine with you, could you ack the patches that
create the strtok_r and copy_strtok_from_user functions.

Thanks,

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/uaccess


Steven Rostedt (6):
      uaccess: move probe_kernel_* functions to lib/uaccess.c
      string: add strtok_r to kernel
      uaccess: add copy_strtok_from_user
      tracing: convert event_trace to use copy_strtok_from_user
      tracing: convert ftrace_regex_write to use copy_strtok_from_user
      tracing: convert ftrace_graph_write to use copy_strtok_from_user

----
 include/linux/string.h      |    3 +
 include/linux/uaccess.h     |    4 +
 kernel/trace/ftrace.c       |  149 ++++++++++++++++---------------
 kernel/trace/trace.h        |    2 +
 kernel/trace/trace_events.c |   69 +++++---------
 lib/Makefile                |    3 +-
 lib/string.c                |   43 +++++++++
 lib/uaccess.c               |  205 +++++++++++++++++++++++++++++++++++++++++++
 mm/Makefile                 |    2 +-
 mm/maccess.c                |   55 ------------
 10 files changed, 361 insertions(+), 174 deletions(-)
-- 
