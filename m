Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYGETbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYGETbu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 15:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYGETbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 15:31:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYGETbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 15:31:43 -0400
Date: Sat, 5 Jul 2008 21:31:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: [git pull] softlockup: print a module list on being stuck
Message-ID: <20080705193124.GA21028@elte.hu>
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

Please pull the "softlockup: print a module list on being stuck" commit 
from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

this change is already in the Fedora kernel and it already was useful in 
narrowing down sources of soft lockups.

Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      softlockup: print a module list on being stuck

 kernel/softlockup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index c828c23..a272d78 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -120,6 +120,7 @@ void softlockup_tick(void)
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
+	print_modules();
 	if (regs)
 		show_regs(regs);
 	else
