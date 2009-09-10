Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIJSwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIJSwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZIJSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:52:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:48104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZIJSwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:52:11 -0400
Date: Thu, 10 Sep 2009 18:51:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       realnc@arcor.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       realnc@arcor.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AA93D34.8040500@arcor.de>
References: <4AA93D34.8040500@arcor.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Disable NEW_FAIR_SLEEPERS for now
Message-ID: <tip-3f2aa307c4d26b4ed6509d0a79e8254c9e07e921@git.kernel.org>
Git-Commit-ID: 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 10 Sep 2009 18:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f2aa307c4d26b4ed6509d0a79e8254c9e07e921
Gitweb:     http://git.kernel.org/tip/3f2aa307c4d26b4ed6509d0a79e8254c9e07e921
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 10 Sep 2009 20:34:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Sep 2009 20:34:48 +0200

sched: Disable NEW_FAIR_SLEEPERS for now

Nikos Chantziaras and Jens Axboe reported that turning off
NEW_FAIR_SLEEPERS improves desktop interactivity visibly.

Nikos described his experiences the following way:

  " With this setting, I can do "nice -n 19 make -j20" and
    still have a very smooth desktop and watch a movie at
    the same time.  Various other annoyances (like the
    "logout/shutdown/restart" dialog of KDE not appearing
    at all until the background fade-out effect has finished)
    are also gone.  So this seems to be the single most
    important setting that vastly improves desktop behavior,
    at least here. "

Jens described it the following way, referring to a 10-seconds
xmodmap scheduling delay he was trying to debug:

  " Then I tried switching NO_NEW_FAIR_SLEEPERS on, and then
    I get:

    Performance counter stats for 'xmodmap .xmodmap-carl':

         9.009137  task-clock-msecs         #      0.447 CPUs
               18  context-switches         #      0.002 M/sec
                1  CPU-migrations           #      0.000 M/sec
              315  page-faults              #      0.035 M/sec

    0.020167093  seconds time elapsed

    Woot! "

So disable it for now. In perf trace output i can see weird
delta timestamps:

  cc1-9943  [001]  2802.059479616: sched_stat_wait: task: as:9944 wait: 2801938766276 [ns]

That nsec field is not supposed to be that large. More digging
is needed - but lets turn it off while the real bug is found.

Reported-by: Nikos Chantziaras <realnc@arcor.de>
Tested-by: Nikos Chantziaras <realnc@arcor.de>
Reported-by: Jens Axboe <jens.axboe@oracle.com>
Tested-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <4AA93D34.8040500@arcor.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_features.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 4569bfa..e2dc63a 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,4 +1,4 @@
-SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
+SCHED_FEAT(NEW_FAIR_SLEEPERS, 0)
 SCHED_FEAT(NORMALIZED_SLEEPER, 0)
 SCHED_FEAT(ADAPTIVE_GRAN, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
