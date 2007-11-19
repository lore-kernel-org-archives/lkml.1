Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbXKSTE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbXKSTE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXKSTET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:04:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44424 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXKSTES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:04:18 -0500
Date: Mon, 19 Nov 2007 20:03:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression from softlockup fix
Message-ID: <20071119190356.GC12650@elte.hu>
References: <20071119.012119.118043374.davem@davemloft.net> <20071119094338.GA19271@elte.hu> <4741C4BA.8010905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4741C4BA.8010905@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I thought the timer code kicked the watchdog after waking up after a 
> long sleep anyway?  At one point I was looking into a mechanism to 
> temporarily disable the watchdog during a wait for a timer event, but 
> it got complex - and I thought - unnecessary.
> 
> Specifically this in kernel/time/timekeeping.c:
> 
> 		/*
> 		 * When we are idle and the tick is stopped, we have to touch
> 		 * the watchdog as we might not schedule for a really long
> 		 * time. This happens on complete idle SMP systems while
> 		 * waiting on the login prompt. We also increment the "start of
> 		 * idle" jiffy stamp so the idle accounting adjustment we do
> 		 * when we go busy again does not account too much ticks.
> 		 */
> 		if (ts->tick_stopped) {
> 			touch_softlockup_watchdog();
> 			ts->idle_jiffies++;
> 		}
> 
> Or does this happen on the sleep path?  If so, wouldn't the right fix 
> to be this on the wakeup path?

yep, i guess this would do the trick. David, could you try it perhaps 
(let me know if i should make a patch for you).

	Ingo
