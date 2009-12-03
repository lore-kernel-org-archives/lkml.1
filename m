Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZLCStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZLCStw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZLCStv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:49:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49839 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbZLCStu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:49:50 -0500
Date: Thu, 3 Dec 2009 19:49:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] softlockup update for v2.6.33
Message-ID: <20091203184954.GA26076@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-softlockup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-softlockup-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      softlockup: Fix hung_task_check_count sysctl


 kernel/hung_task.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index d4e8417..0c642d5 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -144,7 +144,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 	rcu_read_lock();
 	do_each_thread(g, t) {
-		if (!--max_count)
+		if (!max_count--)
 			goto unlock;
 		if (!--batch_count) {
 			batch_count = HUNG_TASK_BATCHING;
