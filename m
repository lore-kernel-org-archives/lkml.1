Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbZHDTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbZHDTES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933136AbZHDTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:04:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933123AbZHDTER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:04:17 -0400
Date: Tue, 4 Aug 2009 21:04:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] timer fix
Message-ID: <20090804190409.GA980@elte.hu>
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
Hiroshi Shimamoto (1):
      posix-timers: Fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW


 kernel/posix-timers.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 052ec4d..d089d05 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -202,6 +202,12 @@ static int no_timer_create(struct k_itimer *new_timer)
 	return -EOPNOTSUPP;
 }
 
+static int no_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsave, struct timespec __user *rmtp)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -254,6 +260,7 @@ static __init int init_posix_timers(void)
 		.clock_get = posix_get_monotonic_raw,
 		.clock_set = do_posix_clock_nosettime,
 		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
