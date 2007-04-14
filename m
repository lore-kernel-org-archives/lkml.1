Return-Path: <linux-kernel-owner+w=401wt.eu-S1161133AbXDNKxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbXDNKxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 06:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161162AbXDNKxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 06:53:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161133AbXDNKxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 06:53:48 -0400
Date: Sat, 14 Apr 2007 12:53:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414105338.GB19454@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414083625.GM943@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> Forking becomes very slow above a load of 100 it seems. Sometimes, the 
> shell takes 2 or 3 seconds to return to prompt after I run "scheddos 
> &"

this might be changed/impacted by the parent-requeue fix that is in the 
updated (for real, promise! ;) patch. Right now on CFS a forking parent 
shares its own run stats with the child 50%/50%. This means that heavy 
forkers are indeed penalized. Another logical choice would be 100%/0%: a 
child has to earn its own right.

i kept the 50%/50% rule from the old scheduler, but maybe it's a more 
pristine (and smaller/faster) approach to just not give new children any 
stats history to begin with. I've implemented an add-on patch that 
implements this, you can find it at:

    http://redhat.com/~mingo/cfs-scheduler/sched-fair-fork.patch

> Those are very promising results, I nearly observe the same 
> responsiveness as I had on a solaris 10 with 10k running processes on 
> a bigger machine.

cool and thanks for the feedback! (Btw., as another test you could also 
try to renice "scheddos" to +19. While that does not push the scheduler 
nearly as hard as nice 0, it is perhaps more indicative of how a truly 
abusive many-tasks workload would be run in practice.)

	Ingo
