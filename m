Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXLJXEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXLJXEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXLJXEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:04:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41425 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbXLJXEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:04:42 -0500
Date: Tue, 11 Dec 2007 00:04:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210230425.GA641@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071210204212.GA5502@elte.hu> <20071210125923.37bd2f10.akpm@linux-foundation.org> <20071210224508.GB27178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210224508.GB27178@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > what do you think? Right now i've got them queued up for 2.6.25 in 
> > > both the scheduler-devel and the x86-devel git trees - but can 
> > > submit them for 2.6.24 if it's better if we did them there. I've got 
> > > no strong opinion either way.
> > 
> > printk_clock() doesn't seem terribly important but what's this stuff 
> > about effects on udelay/mdelay?  That can be serious if they're 
> > getting shortened.
> 
> since udelay depends on loops_per_jiffy, which is fixed up 
> time_cpufreq_notifier(), i dont see how it could be affected by 
> frequency changes. (but that's the theory - practice might be 
> different)

Stefano Brivio reported udelay()/mdelay() effects in the b43 driver. 
(and it caused driver failures for him.)

Stefano, could you please try to sum up your experiences with that 
issue? Is it reproducable, and the 5 patches i did fix it? (if yes, 
could you try to re-do the mdelay verifications perhaps, to make sure 
it's not some other effect interacting here. In theory sched-clock 
scaling has no effect on udelay behavior.)

	Ingo
