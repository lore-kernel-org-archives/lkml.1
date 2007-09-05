Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXIEMvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXIEMvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXIEMvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:51:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbXIEMvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:51:21 -0400
Date: Wed, 5 Sep 2007 14:51:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [pull request] scheduler updates
Message-ID: <20070905125114.GA17460@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

8 changes: 6 fixes and 2 preparatory cleanups to one of the fixes. The 
most serious fix is the one from Suresh Siddha - we still under-balanced 
tasks on multi-core systems - this should be the only user-noticeable 
fix. Plus there are 2 debug-only fixes, one build warning fix, one fix 
affecting the granularity of reniced tasks (it was inconsistent with the 
sched_latency goal) and a reniced-tasks granularity code fix that did 
not appear to have visible effects (that anyone noticed) but is correct 
and simple nevertheless.

	Ingo

------------------>
Ingo Molnar (4):
      sched: fix niced_granularity() shift
      sched: debug: fix cfs_rq->wait_runtime accounting
      sched: debug: fix sum_exec_runtime clearing
      sched: fix xtensa build warning

Peter Zijlstra (3):
      sched: simplify __check_preempt_curr_fair()
      sched: improve prev_sum_exec_runtime setting
      sched: fix ideal_runtime calculations for reniced tasks

Suresh Siddha (1):
      sched: fix MC/HT scheduler optimization, without breaking the FUZZ logic.

 sched.c       |   15 +++++---------
 sched_debug.c |    1 
 sched_fair.c  |   59 ++++++++++++++++++++++++++++++----------------------------
 3 files changed, 38 insertions(+), 37 deletions(-)
