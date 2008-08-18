Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYHRSfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYHRSfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYHRSfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:35:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55449 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYHRSfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:35:46 -0400
Date: Mon, 18 Aug 2008 20:35:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] core kernel fixes
Message-ID: <20080818183530.GA24817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Dmitry Baryshkov (1):
      lockdep: fix spurious 'inconsistent lock state' warning


 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 77fa776..3bfb187 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2582,7 +2582,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
-	hlock->hardirqs_off = hardirqs_off;
+	hlock->hardirqs_off = !!hardirqs_off;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = sched_clock();
