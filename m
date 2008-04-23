Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYDWNhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYDWNhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYDWNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:37:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbYDWNhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:37:11 -0400
Date: Wed, 23 Apr 2008 15:36:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, a.p.zijlstra@chello.nl
Subject: Re: [patch] softlockup: fix false positives on nohz if CPU is 100%
	idle for more than 60 seconds
Message-ID: <20080423133656.GA23782@elte.hu>
References: <20080422.030519.259068348.davem@davemloft.net> <20080423085030.GA22309@elte.hu> <20080423.035544.110883549.davem@davemloft.net> <20080423.052928.142823681.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423.052928.142823681.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> > It may take some time, as each test run the verify the existence of 
> > the problem takes several minutes.
> 
> Ok, Ingo, none of your patches fix even the initial buggy changeset, 
> for reference:

as a temporary workaround please try the patch below, until we can 
reproduce and fix the bug.

	Ingo

------------------------------->
Subject: softlockup: nohz workaround
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 23 15:19:32 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -245,7 +245,7 @@ static int watchdog(void *__bind_cpu)
 	 */
 	while (!kthread_should_stop()) {
 		touch_softlockup_watchdog();
-		schedule();
+		schedule_timeout(softlockup_thresh/2);
 
 		if (kthread_should_stop())
 			break;
