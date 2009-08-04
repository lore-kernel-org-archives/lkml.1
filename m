Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbZHDO72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbZHDO72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbZHDO70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:59:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbZHDO7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:59:23 -0400
Date: Tue, 4 Aug 2009 16:59:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses
	fromkgdb
Message-ID: <20090804145909.GO7746@elte.hu>
References: <4A6E0825.3020604@windriver.com> <1248725893.6987.2055.camel@twins> <4A6F139C.6070806@windriver.com> <20090804141623.GD7746@elte.hu> <4A784B78.2020801@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A784B78.2020801@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> Ingo Molnar wrote:
> > * Jason Wessel <jason.wessel@windriver.com> wrote:
> > 
> >> -----
> >> From: Jason Wessel <jason.wessel@windriver.com>
> >> Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
> >>
> >> When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set sched_clock() gets the
> >> time from hardware, such as from TSC.  In this configuration kgdb will
> >> report a softlock warning messages on resuming or detaching from a
> >> debug session.
> >>
> > 
> > Hm, this looks quite ugly. Peter, Thomas, can you think of a 
> > cleaner solution?
> > 
> 
> Below was a more specific test case I received from Dongdong Deng 
> which did not require kgdb.  The test case is not something to 
> merge, it is just a simple module to build to demonstrate the 
> problem outside of kgdb.
> 
> The patch I submitted might have been on the "ugly" side, but 
> there was not an obvious way to solve the problem without making 
> changes in kernel/sched*.  I opted for something that was entirely 
> self contained to the softlockup code.

it's not really the fault of your patch really - all these 
integrations along dynticks, scheduler time and softlockup feel a 
bit awkward. Wondering whether there's some nicer way.

	Ingo
