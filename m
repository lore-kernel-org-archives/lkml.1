Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZIZM1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZIZM1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZIZM13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:27:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZIZM13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:27:29 -0400
Date: Sat, 26 Sep 2009 14:27:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [GIT PULL] timer fix
Message-ID: <20090926122724.GA18331@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Martin Schwidefsky (1):
      clocksource: Resume clocksource without taking the clocksource mutex


 kernel/time/clocksource.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0911334..5e18c6a 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -394,15 +394,11 @@ void clocksource_resume(void)
 {
 	struct clocksource *cs;
 
-	mutex_lock(&clocksource_mutex);
-
 	list_for_each_entry(cs, &clocksource_list, list)
 		if (cs->resume)
 			cs->resume();
 
 	clocksource_resume_watchdog();
-
-	mutex_unlock(&clocksource_mutex);
 }
 
 /**
