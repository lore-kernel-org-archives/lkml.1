Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXLCKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXLCKR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXLCKRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:17:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbXLCKRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:17:20 -0500
Date: Mon, 3 Dec 2007 11:17:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203101702.GB30050@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200711301429.15664.nickpiggin@yahoo.com.au> <20071130100845.GB2201@elte.hu> <200712031527.57129.nickpiggin@yahoo.com.au> <20071203084557.GA13156@elte.hu> <1196674869.25646.142.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196674869.25646.142.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > as far as desktop apps such as firefox goes, the exact opposite is 
> > true. We had two choices basically: either a "more agressive" yield 
> > than before or a "less agressive" yield. Desktop apps were reported 
> > to hurt from a "more agressive" yield (firefox for example gets some 
> > pretty bad delays),
>
> Why not to change source codes of firefox? [...]

because we care a heck of a lot more about a widely used open-source 
package's default "user experience" than we care about closed-source 
volanomark scores...

do you realize the absurdity of that suggestion: in essence we'd punish 
firefox _because it is open-source and can be changed_. So basically 
firefox would get a more preferential treatment if it was closed-source 
and could not be changed? That's totally backwards.

> If the sched_compat_yield=0, the sys_sched_yield almost does nothing 
> but returns, so firefox could just do not call sched_yield. I assume 
> 'sched_compat_yield=0' ~ no_call_to_sched_yield.
> 
> It's easier to delete calls to sched_yield in applications than to 
> tune calls to sched_yield.

We are not at all worried about punishing silly benchmark behavior - and 
volanomark's call to Thread.yield (if that's indeed what is happening - 
could you try to trace it to make sure?) is outright silly. There are 
other chatroom benchmarks such as hackbench.c and hackbench_pth.c that i 
test frequently, and they are not affected by any yield details. (and 
even then it's still taken with a grain of salt - remember dbench)

	Ingo
