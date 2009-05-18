Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZEROXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZEROXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZEROXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:23:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZEROXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:23:36 -0400
Date: Mon, 18 May 2009 16:23:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20090518142301.GA22765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
Ingo Molnar (1):
      lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS

Thomas Gleixner (1):
      futex: futex mapping needs to be writable


 kernel/futex.c             |    2 +-
 kernel/lockdep_internals.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index eef8cd2..09db3ae 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -235,7 +235,7 @@ static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 	}
 
 again:
-	err = get_user_pages_fast(address, 1, 0, &page);
+	err = get_user_pages_fast(address, 1, 1, &page);
 	if (err < 0)
 		return err;
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2cc7e9..699a2ac 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -54,9 +54,9 @@ enum {
  * table (if it's not there yet), and we check it for lock order
  * conflicts and deadlocks.
  */
-#define MAX_LOCKDEP_ENTRIES	8192UL
+#define MAX_LOCKDEP_ENTRIES	16384UL
 
-#define MAX_LOCKDEP_CHAINS_BITS	14
+#define MAX_LOCKDEP_CHAINS_BITS	15
 #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
 
 #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
