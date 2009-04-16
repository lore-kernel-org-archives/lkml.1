Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZDPQSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZDPQSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZDPQSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:18:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbZDPQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:18:06 -0400
Message-Id: <20090416161543.199331330@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 12:15:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] updates for event tester and lockdep tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I did not add your delay.h fix, since I was not sure if you added it 
(I saw a commit sha1 in the email).

I actually wrote the function trace event tester last night. But because
it would sometimes lock up the system on bootup I held off.

But I also found that the lockdep trace points where they are would lock up
my system too. If I placed them inside the current->lockdep_recursion,
everything ran stable.

I ran the lockdep trace points enabled all night with the second patch.
Without the second patch, it would lockup within a few minutes.

Please pull the latest tip/tracing/core-v2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-v2


Steven Rostedt (2):
      tracing/events: perform function tracing in event selftests
      tracing/events/lockdep: move tracepoints within recursive protection

----
 kernel/lockdep.c            |   14 ++++----
 kernel/trace/trace_events.c |   80 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 80 insertions(+), 14 deletions(-)
-- 
