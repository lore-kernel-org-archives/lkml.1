Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYHMQ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYHMQ0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYHMQ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:26:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYHMQ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:26:12 -0400
Date: Wed, 13 Aug 2008 18:25:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Message-ID: <20080813162553.GA5720@elte.hu>
References: <20080804194646.GA17390@us.ibm.com> <57C9024A16AD2D4C97DC78E552063EA30844B26C@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA30844B26C@orsmsx505.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > I'm happy to test any better patches.
> 
> Linus just took a patch from my tree that should solve this
> once and for all for ia64.
> 
> commit 10617bbe84628eb18ab5f723d3ba35005adde143
> Author: Tony Luck <tony.luck@intel.com>
> Date:   Tue Aug 12 10:34:20 2008 -0700
> 
>     [IA64] Ensure cpu0 can access per-cpu variables in early boot code
> 
> 
> When you get a chance please test with your config against this
> tree just to confirm that this is fixed.

there's also Peter's other patch upstream since yesterday (and included 
in -rc3) which should solve the same problem:

| commit c1955a3d4762e7a9bf84035eb3c4886a900f0d15
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Mon Aug 11 08:59:03 2008 +0200
|
|    sched_clock: delay using sched_clock()
|
|    Some arch's can't handle sched_clock() being called too early - delay
|    this until sched_clock_init() has been called.

so i'd be mighty surprised if this dual firepower of commits didnt at 
least weaken this bug somewhat! ;-)

	Ingo
