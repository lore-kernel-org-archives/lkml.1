Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbYFYQhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbYFYQhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYFYQhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:37:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYFYQhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:37:05 -0400
Date: Wed, 25 Jun 2008 18:36:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: [patch] softlockup: print a module list on being stuck
Message-ID: <20080625163651.GA26706@elte.hu>
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

Arjan has been observing lots of softlockup reports on kerneloops.org 
and would like to have the patch below in v2.6.26 to narrow the real 
source of it down some more, and has asked for this patch to be applied 
sooner than planned.

The patch is queued up for the next merge window at the moment. It's 
well-tested and obvious. The module list is printed here the same way 
it's printed for oopses.

Discard it if you feel in any way nervous about it.

	Ingo

---------------->
commit 688c91755dc3d3c03d8c67c1df13c02be258768e
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:       Mon Jun 16 15:51:08 2008 -0700
CommitDate: Wed Jun 18 15:26:54 2008 +0200

    softlockup: print a module list on being stuck
    
    Most places in the kernel that go BUG: print a module list
    (which is very useful for doing statistics and finding patterns),
    however the softlockup detector does not do this yet.
    
    This patch adds the one line change to fix this gap.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 6b682d8..f2bf5de 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -143,6 +143,7 @@ void softlockup_tick(void)
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
+	print_modules();
 	if (regs)
 		show_regs(regs);
 	else
