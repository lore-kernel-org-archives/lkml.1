Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXDPVGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXDPVGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXDPVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:06:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXDPVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:06:08 -0400
Date: Mon, 16 Apr 2007 23:05:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416210556.GA25637@elte.hu>
References: <20070413202100.GA9957@elte.hu> <p73tzvg56ag.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73tzvg56ag.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > i'm pleased to announce the first release of the "Modular Scheduler 
> > Core and Completely Fair Scheduler [CFS]" patchset:
> > 
> >    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> 
> I would suggest to drop the tsc.c change. The "small errors" can be 
> really large on some systems and you can also see large backward 
> jumps.

actually, i designed the CFS code assuming a per-CPU TSC (with no global 
synchronization), not assuming any globally sync TSC. In fact i wrote it 
on such systems: a CoreDuo2 box that has stops the TSC in C3 and the 
different cores have wildly different TSC values and a dual-core 
Athlon64 that quickly drifts its TSC. So i'll keep the sched_clock() 
change for now.

> BTW with all this CPU time measurement it would be really nice to 
> report it to the user too. It seems a bit bizarre that the scheduler 
> keeps track of ns, but top only knows jiffies with large sampling 
> errors.

yeah - i'll fix that too if someone doesnt beat me at it.

	Ingo
