Return-Path: <linux-kernel-owner+w=401wt.eu-S2992830AbXDTOGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992830AbXDTOGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993013AbXDTOGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:06:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992830AbXDTOGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:06:18 -0400
Date: Fri, 20 Apr 2007 16:04:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: [patch] CFS scheduler, v4
Message-ID: <20070420140457.GA14017@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v4 of the CFS patchset. The patch 
against v2.6.21-rc7 can be downloaded from:

    http://redhat.com/~mingo/cfs-scheduler/
 
this CFS release too is mainly about fixing regressions and improving 
interactivity, so the rate of change is relatively low:

    11 files changed, 136 insertions(+), 72 deletions(-)

in particular the preemption fix could resolve the 'desktop slows down 
under IO load' reports and the 'firefox does not switch tabs fast 
enough' reports as well. The suspend2 crash and the yield related 
Kaffeine hangs should be resolved as well.

Changes since -v3:

 - usability fix: automatic renicing of kernel threads such as keventd, 
   OOM tasks and tasks doing privileged hardware access (such as Xorg). 
   (This is a substitute for group scheduling until the group scheduling 
    details have been worked out.)

 - bugfix: buggy yield() caused suspend2 problems

 - preemption fix: it caused desktop app latencies

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
