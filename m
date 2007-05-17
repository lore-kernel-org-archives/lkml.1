Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXEQRsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXEQRsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760187AbXEQRru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:47:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167AbXEQRrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:47:48 -0400
Date: Thu, 17 May 2007 19:45:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] CFS scheduler, -v13
Message-ID: <20070517174533.GA538@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


i'm pleased to announce release -v13 of the CFS scheduler patchset.

The CFS patch against v2.6.22-rc1, v2.6.21.1 or v2.6.20.10 can be 
downloaded from the usual place:
  
     http://people.redhat.com/mingo/cfs-scheduler/

-v13 is a fixes-only release. It fixes a smaller accounting bug, so if 
you saw small lags during desktop use under certain workloads then 
please re-check that workload under -v13 too. It also tweaks SMP 
load-balancing a bit. (Note: the load-balancing artifact reported by 
Peter Williams is not a CFS-specific problem and he reproduced it in 
v2.6.21 too. Nevertheless -v13 should be less prone to such artifacts.)

I know about no open CFS regression at the moment, so please re-test 
-v13 and if you still see any problem please re-report it. Thanks!

Changes since -v12:

 - small tweak: made the "fork flow" of reniced tasks zero-sum

 - debugging update: /proc/<PID>/sched is now seqfile based and echoing
   0 to it clears the maximum-tracking counters.

 - more debugging counters

 - small rounding fix to make the statistical average of rounding errors
   zero

 - scale both the runtime limit and the granularity on SMP too, and make
   it dependent on HZ

 - misc cleanups

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
