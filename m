Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZFVLv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZFVLv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZFVLvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:51:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZFVLvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:51:17 -0400
Date: Mon, 22 Jun 2009 13:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.3 - Multiplexing and system-wide
Message-ID: <20090622115102.GD24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3/ Multiplexing and system-wide
>
> Multiplexing is time-based and it is hooked into the timer tick.
> At every tick, the kernel tries to schedule another set of event
> groups.
>
> In tickless kernels if a CPU is idle, no timer tick is generated,
> therefore no multiplexing occurs. This is incorrect. It's not
> because the CPU is idle, that there aren't any interesting PMU
> events to measure. Parts of the CPU may still be active, e.g.,
> caches and buses. And thus, it is expected that multiplexing still
> happens.
>
> You need to hook up the timer source for multiplexing to something
> else which is not affected by tickless. You cannot simply disable
> tickless during a measurement because you would not be measuring
> the system as it actually behaves.

There is only a very small difference between inhibiting nohz and
waking up the machine using timers on the same interval.

Using the scheduler tick to round-robin counters is a first-level
approximation we use: it in essence corresponds to multiplexing
counters along a cycle cost metric. If there's sufficient interest
we can drive the round-robining by the PMU itself: this makes it HZ
and dynticks invariant.

The simplified multiplexing we offer now certainly works well enough
in practice - if there's interest we can expand it.
