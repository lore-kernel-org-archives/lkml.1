Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXETGjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXETGjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbXETGi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:38:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759342AbXETGi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:38:58 -0400
Date: Sun, 20 May 2007 08:38:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] CFS scheduler, -v13
Message-ID: <20070520063804.GA25058@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub> <20070518102607.GA23151@elte.hu> <200705200246.22444.kernel@prachanda.hub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705200246.22444.kernel@prachanda.hub>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Anant Nitya <kernel@prachanda.info> wrote:

> Hi Ingo,
> 
> Please ignore my last report about lag problem while using CFS-v13, it 
> is working perfectly fine with 2.6.21.1 and the lag I used to see in 
> v12 is not there with v13 anymore. [...]

ah, great - i was looking over your debug data and couldnt find the 
problem! This moves CFS into the "no open regressions" state again ;-)

> [...] After digging in a bit I found that problem is only occurring in 
> 2.6.22-rc1 and it get fired by network usage while transmitting data 
> upstream. I don't have any evidence that CFS is involved in lag 
> problem since 2.6.22-rc1 with stock scheduler is also having same lag 
> problem and it seems directly proportional with upstream speed while 
> downstream doesn't shows any misbehavior { at lower upstream speed lag 
> is less but with higher upstream speed system starts crawling and 
> system load hitting to 70/75}. Lets see how 2.6.22-rc2 is doing.

if that lag still occurs with rc2 then please repeat the following 
debugging steps under CFS [which has more instrumentation than the stock 
scheduler]:

  cat /proc/`pidof firefox-bin`/sched > sched1.txt
  echo 0 > /proc/`pidof firefox-bin`/sched

  < reproduce the lag in firefox >

  cat /proc/`pidof firefox-bin`/sched > sched2.txt

this way we'll be able to tell what nature this delay has. Also, could 
you send me your kernel's .config (off-list)?

	Ingo
