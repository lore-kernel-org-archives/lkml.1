Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab0CNSPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:15:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758696Ab0CNSPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:15:14 -0400
Date: Sun, 14 Mar 2010 19:14:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes (fix:
 arch/x86/kernel/cpu/mcheck/mce.c:166: error: 'mce_read_mutex' undeclared)
Message-ID: <20100314181458.GA24622@elte.hu>
References: <20100313163556.GA14263@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313163556.GA14263@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

This fixes a PROVE_LOCKING=y && PROVE_RCU=y build bug that slipped through. 

Both options are off by default (and PROVE_RCU is new in .34) but i'd still 
expect it to trigger more commonly with debug-enabled kernels so please pull 
this fix as the first one in the morning if possible.
 
 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86/mce: Fix build bug with CONFIG_PROVE_LOCKING=y && CONFIG_X86_MCE_INTEL=y


 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd58de4..3ab9c88 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -46,6 +46,8 @@
 
 #include "mce-internal.h"
 
+static DEFINE_MUTEX(mce_read_mutex);
+
 #define rcu_dereference_check_mce(p) \
 	rcu_dereference_check((p), \
 			      rcu_read_lock_sched_held() || \
@@ -1490,8 +1492,6 @@ static void collect_tscs(void *data)
 	rdtscll(cpu_tsc[smp_processor_id()]);
 }
 
-static DEFINE_MUTEX(mce_read_mutex);
-
 static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 			loff_t *off)
 {
