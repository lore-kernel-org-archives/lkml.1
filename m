Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZERQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZERQ4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZERQ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:56:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbZERQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:56:25 -0400
Date: Mon, 18 May 2009 18:55:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL, v2] scheduler fixes
Message-ID: <20090518165553.GA23871@elte.hu>
References: <20090518142707.GA24142@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518142707.GA24142@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest sched-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus-2

This excludes the "sched: avoid flexible array member inside struct 
(gcc extension)" commit you objected to. Did a test-build and a 
test-boot of this, just in case...

 Thanks,

	Ingo

------------------>
Ron (1):
      sched: Fix fallback sched_clock()'s offset when using jiffies


 kernel/sched_clock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 819f17a..e1d16c9 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -38,7 +38,8 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
+					* (NSEC_PER_SEC / HZ);
 }
 
 static __read_mostly int sched_clock_running;
