Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYHKLi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYHKLi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYHKLir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:38:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYHKLiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:38:46 -0400
Date: Mon, 11 Aug 2008 13:38:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Witbrodt <dawitbro@sbcglobal.net>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH diagnostic] Re: HPET regression in 2.6.26 versus 2.6.25
	-- RCU problem
Message-ID: <20080811113817.GF6925@elte.hu>
References: <630464.55583.qm@web82105.mail.mud.yahoo.com> <20080810151520.GG8125@linux.vnet.ibm.com> <20080811013538.GA3958@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811013538.GA3958@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> And here is the patch.  It is still a bit raw, so the results should 
> be viewed with some suspicion.  It adds a default-off kernel parameter 
> CONFIG_RCU_CPU_STALL which must be enabled.
> 
> Rather than exponential backoff, it backs off to once per 30 seconds. 
> My feeling upon thinking on it was that if you have stalled RCU grace 
> periods for that long, a few extra printk() messages are probably the 
> least of your worries...

while this wont debug problems were timer irqs are genuinely stuck for 
long periods of time, it should find problems with RCU completion logic 
itself in the presence of correct timer irqs - and the lack of any 
messages from this debug option should point the finger more firmly in 
the direction of stalled timer irqs.

So i find this debug feature rather useful and have applied it to 
tip/core/rcu (and cleaned it up a bit). I renamed the config option to 
CONFIG_DEBUG_RCU_STALL to make it more in line with usual debug option 
names. Lets see whether -tip testing finds any false positives.

	Ingo
