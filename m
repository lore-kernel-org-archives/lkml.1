Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZCYFUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZCYFUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZCYFU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:20:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZCYFU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:20:26 -0400
Message-Id: <20090325051920.406564281@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 01:19:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 0/5] [PATCH][GIT PULL] remove unnecessary (un)likelys
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I guess this can go through you. This is a start of clean ups to
get rid of (un)likelys that are at least 50% incorrect. This series
has some that are 100% incorrect.

The branch profiler used is from 2.6.29 which does not have the
fixed header that is in tip. This branch is also based off of
2.6.29 and not tip.

Perhaps, since some of these cases are 100% wrong they can simply
be reversed. I'm choosing to just remove the annotation, and then
later I'll be using the full branch profiler to look for candidates
for adding (un)likelys.  That way each added annotation can be
scrutinized individually.

Please pull the latest annotate-branch/cleanups tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
annotate-branch/cleanups


Steven Rostedt (5):
      ptrace: remove incorrect unlikelys
      mm: remove unlikly NULL from kfree
      sched: remove unlikely in pre_schedule_rt
      sched: remove unlikelys from sched_move_task
      mm: remove unlikelys for unlock in rmap.c

----
 arch/x86/kernel/ptrace.c |    4 ++--
 kernel/sched.c           |    4 ++--
 kernel/sched_rt.c        |    2 +-
 mm/rmap.c                |    8 ++++----
 mm/slab.c                |    2 +-
 mm/slob.c                |    2 +-
 mm/slub.c                |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)
-- 
