Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXDQIUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXDQIUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXDQIUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:20:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33035 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXDQIUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:20:51 -0400
Date: Tue, 17 Apr 2007 10:20:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417082036.GC5076@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu> <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com>
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


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > ok - fortunately the delta between -v2-rc0 and -v2-final is pretty 
> > small. One difference is the child-runs-first fix. To restore the 
> > parent-runs-first logic, do this:
> > 
> > 	echo 0 > /proc/sys/kernel/sched_child_runs_first
> 
> Sorry, I did not follow the latest developments, but how many tunables 
> we have so far in CFS? Are those for debug only or they're supposed to 
> stay?

yeah, debug only. I strongly suspect the Kaffeine breakage for example 
was related to child-runs-first, so userspace developers might be 
interested in a switch to turn this on/off.

while reviewing the upstream scheduler it occured to me that we are 
probably _not_ doing child-runs-first there due to the list_add_tail() 
[it should be a list_add() for it to be child-first. But i havent 
instrumented this heavily and this portion of the mainline scheduler is 
pretty fragile.]. So via this flag we could also see the performance 
impact, besides the compatibility impact.

> Weren't those listed inside the Axis of Evil (just to remain in topic
> :) till yesterday?

heh ;)

	Ingo
