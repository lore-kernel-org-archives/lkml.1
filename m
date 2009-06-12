Return-Path: <linux-kernel-owner+w=401wt.eu-S1764346AbZFLQtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764346AbZFLQtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZFLQsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:48:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZFLQsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:48:52 -0400
Date: Fri, 12 Jun 2009 18:48:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when
	feature is disabled
Message-ID: <20090612164815.GA30773@elte.hu>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu> <alpine.LFD.2.01.0906120827020.3237@localhost.localdomain> <20090612153501.GA5737@elte.hu> <4A328444.3010301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A328444.3010301@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> > 
> > So i think hwpoison simply does not affect our ability to get 
> > log messages out - but it sure allows crappier hardware to be 
> > used. Am i wrong about that for some reason?
> 
> Crappy hardware isn't the kind of hardware that is likely to have 
> the hwpoison features, just like crappy hardware generally doesn't 
> even have ECC -- or even basic parity checking (I personally think 
> non-ECC memory should be considered a crime against humanity in 
> this day and age.)
> 
> You're making the fundamental assumption that failover and 
> hardware replacement is a relatively cheap and fast operation.  In 
> high reliability applications, of course, failover is always an 
> option -- it *HAS* to be an option -- but that doesn't mean that 
> hardware replacement is cheap, fast or even possible -- and now 
> you've blown your failover option.
> 
> These kinds of features are used when extremely high reliability 
> is required, think for example a telco core router.  A page error 
> may have happened due to stray radiation or through power supply 
> glitches (which happen even in the best of systems), but if they 
> are a pattern, a box needs to be replaced.  *How quickly* a box 
> can be taken out of service and replaced can vary greatly, and its 
> urgency depend on patterns; furthermore, in the meantime the 
> device has to work the best it can.
> 
> Consider, for example, a control computer on the Hubble Space 
> Telescope -- the only way to replace it is by space shuttle, and 
> you can safely guarantee that *that* won't happen in a heartbeat.  
> On the new Herschel Space Observatory, not even the space shuttle 
> can help: if the computers die, *or* if bad data gets fed to its 
> control system, the spacecraft is lost.  As such, it's of 
> paramount importance for the computers to (a) continue to provide 
> service at the level the hardware is capable of doing, (b) as 
> accurately as possible continually assess and report that level of 
> service, and (c) not allow a failure to pass undetected.  A lot of 
> failures are simple one-time events (especially in space, a 
> high-rad environment), others reflect decaying hardware but can be 
> isolated (e.g. a RAM cell which has developed a short circuit, or 
> a CPU core which has a damaged ALU), while others yet reflect a 
> general ill health of the system that cannot be recovered.
> 
> What these kinds of features do is it gives the overall-system 
> designers and the administrators more options.

Ok, these arguments are pretty convincing - thanks everyone for the
detailed explanation.

	Ingo
