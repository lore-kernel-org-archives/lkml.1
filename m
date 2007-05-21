Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbXEUH70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbXEUH70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXEUH7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:59:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbXEUH7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:59:17 -0400
Date: Mon, 21 May 2007 09:58:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521075824.GA11198@elte.hu>
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

> Please ignore my last report about lag problem while using CFS-v13, it 
> is working perfectly fine with 2.6.21.1 and the lag I used to see in 
> v12 is not there with v13 anymore. After digging in a bit I found that 
> problem is only occurring in 2.6.22-rc1 and it get fired by network 
> usage while transmitting data upstream. I don't have any evidence that 
> CFS is involved in lag problem since 2.6.22-rc1 with stock scheduler 
> is also having same lag problem and it seems directly proportional 
> with upstream speed while downstream doesn't shows any misbehavior { 
> at lower upstream speed lag is less but with higher upstream speed 
> system starts crawling and system load hitting to 70/75}. Lets see how 
> 2.6.22-rc2 is doing.

ok, i got your -rc2 debug numbers (off-list), and it doesnt look pretty:

before-lag:

 sleep_max                :           259502076
 block_max                :            27690921
 wait_max                 :            16381558

after-lag:

 sleep_max                :           584186160
 block_max                :           261780071
 wait_max                 :           881255577

ouch! a nearly 1 second delay got observed by the scheduler - something 
is really killing your system!

what does 'top' show during an upload? Is any system related task out of 
whack? Could you try to get a readprofile or an oprofile output from the 
kernel, so that we can see what is slowing it down so much? It could be 
something networking related in v2.6.22-rc2.

	Ingo
