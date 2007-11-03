Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbXKCIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbXKCIb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXKCIbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 04:31:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbXKCIbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 04:31:22 -0400
Date: Sat, 3 Nov 2007 09:31:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: delayacct regression in 2.6.24 git
Message-ID: <20071103083109.GD10760@elte.hu>
References: <472B2908.7020507@linux.vnet.ibm.com> <20071102152529.GB20134@elte.hu> <472B501E.9000307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472B501E.9000307@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >> Am I missing something?
> > 
> > delay accounting was causing context-switch slowdown because it 
> > called sched_clock() explicitly - but indeed my fix to that is wrong 
> > ...
> > 
> > how about reverting the change but also using rq->clock instead of 
> > sched_clock()?
> 
> Hmm... I think that might work, I find that schedule() calls 
> __update_rq_clock() which in turn calls sched_clock(), so it might be 
> a worthwhile optimization.

yep, that's the idea - in general rq->clock is updated for almost every 
scheduling event so you can rely on it instead of calling sched_clock() 
directly.

	Ingo
