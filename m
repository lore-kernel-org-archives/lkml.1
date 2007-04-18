Return-Path: <linux-kernel-owner+w=401wt.eu-S2992958AbXDRRvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992958AbXDRRvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992959AbXDRRvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:51:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992958AbXDRRvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:51:08 -0400
Date: Wed, 18 Apr 2007 19:50:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: [patch] CFS scheduler, v3
Message-ID: <20070418175017.GA5250@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


this is the third release of the CFS patchset (against v2.6.21-rc7), and 
can be downloaded from:
 
   http://redhat.com/~mingo/cfs-scheduler/

this is a pure "fix reported regressions" release so there's much less 
churn:

   5 files changed, 71 insertions(+), 29 deletions(-)

(the added lines are mostly debug related, not genuine increase in the 
scheduler's size)

Changes since -v2:

 - bugfix: the yield() implementation was too naive and broke xine-lib.
   (this caused the Kaffine problems. Reported by S.Çağlar Onur)

 - performance fix: increased preemption granularity from 1msec to 
   5msecs, to address the kernbench regression reported by Nick Pigging. 
   (5msecs is probably still too low. This problem has also been pointed
    out by Con Kolivas.)

 - cleanup: renamed requeue_task to yield_task. (suggested by William 
   Lee Irwin III)

 - bugfix: use constant offset factor for nice levels instead of 
   sched_granularity_ns. Thus nice levels work even if someone sets 
   sched_granularity_ns to 0. NOTE: nice support is still naive, i'll 
   address the many nice level related suggestions in -v4.

 - compiler warning fix: get rid of unused variable on UP in sched.c.
   (reported by Gene Heskett)

 - debug: new /proc/sys/kernel/sysctl_sched_delayed_wakeups flag.
   Default: off. This is to debug Gene Heskett's box.

as usual, any sort of feedback, bugreports, fixes and suggestions are 
more than welcome,

	Ingo
