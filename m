Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZBZFio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZBZFio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZBZFie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:38:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZBZFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:38:34 -0500
Message-Id: <20090226053240.607719846@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:32:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 0/5] [RFC] copy_strtok_from_user
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second series of the uaccess code.

Changes in v2:

 - moved probe_kernel_* functions to lib/uaccess.c

 - renamed copy_word_from_user to copy_strtok_from_user.

 - changed copy_strtok_from_user to pass in a delimiter string.
   ftrace defines SPACE to be ' \t\r\n'.

Ingo,
I added your copy right to lib/uaccess.c since git blame shows you
as the author of the probe_kernel_* code. Also, is it OK that I
added the "GPL v2" line in that file as well?

Andrew,
Since you are, in essence, the memory maintainer, could you give
your Acked-by: to the copy_strtok_from_user code.

The probe_kernel code is still EXPORT_SYMBOL_GPL, and I added
that too to copy_strtok_from_user. Are there any objections to that?

-- Steve



The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/uaccess


Steven Rostedt (5):
      uaccess: move probe_kernel_* functions to lib/uaccess.c
      uaccess: add copy_strtok_from_user
      tracing: convert event_trace to use copy_strtok_from_user
      tracing: convert ftrace_regex_write to use copy_strtok_from_user
      tracing: convert ftrace_graph_write to use copy_strtok_from_user

----
 include/linux/uaccess.h     |    5 +
 kernel/trace/ftrace.c       |  155 +++++++++++++++---------------
 kernel/trace/trace.h        |    2 +
 kernel/trace/trace_events.c |   78 +++++++--------
 lib/Makefile                |    3 +-
 lib/uaccess.c               |  229 +++++++++++++++++++++++++++++++++++++++++++
 mm/Makefile                 |    2 +-
 mm/maccess.c                |   55 ----------
 8 files changed, 351 insertions(+), 178 deletions(-)
-- 
