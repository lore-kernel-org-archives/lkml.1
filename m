Return-Path: <linux-kernel-owner+w=401wt.eu-S1751052AbZG2EZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbZG2EZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 00:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZG2EZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 00:25:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZG2EZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 00:25:27 -0400
Message-Id: <20090729042121.727652581@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 00:21:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] sched: fixes for rt-migration-test failures
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

We've been experiencing rt-migration-test failures

 http://rostedt.homelinux.com/code/rt-migrate-test.c

Gregory Haskins and myself have been debugging this for several days.
We found three bugs so far in the code that causes the failure
of this test. The failure is that an RT task may not migrate
properly and may wait behind a lower RT prio task for the migration.

These two patches solve two of the bugs. There's also a bug that
is triggered with RT_GROUP scheduling that we will look at later.

The test can still fail after a long time running and we are still
looking into other issues. But for now this solves two of those
issues.

Please pull the latest update tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
update


Steven Rostedt (2):
      sched: check for pushing rt tasks after all scheduling
      sched: add new prio to cpupri before removing old prio

----
 kernel/sched.c        |   38 +++++++++++++++++++++++++++-----------
 kernel/sched_cpupri.c |   30 ++++++++++++++++--------------
 2 files changed, 43 insertions(+), 25 deletions(-)
-- 
