Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbZFXRrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbZFXRrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbZFXRro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:47:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761171AbZFXRrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:47:43 -0400
Date: Wed, 24 Jun 2009 19:47:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090624174734.GB7576@elte.hu>
References: <alpine.LFD.2.00.0906092252150.3351@localhost.localdomain> <20090622162631.4b4dcee4@skybase> <20090622144110.GA9771@elte.hu> <20090622165936.0bb776e1@skybase> <20090622150553.GA14363@elte.hu> <20090622171834.0df64aea@skybase> <20090622152937.GA17512@elte.hu> <20090622173611.3b583c95@skybase> <20090622154030.GA19076@elte.hu> <20090624185100.6ca7e82a@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624185100.6ca7e82a@skybase>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Mon, 22 Jun 2009 17:40:30 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > 
> > > On Mon, 22 Jun 2009 17:29:37 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > > 
> > > > > [...] And if we really want to keep things separate there will be 
> > > > > two sets of per-cpu hrtimer, one for the old style profiler and 
> > > > > one for oprofile. Any preference for the user space interface to 
> > > > > set the sample rate? A sysctl?
> > > > 
> > > > I dont think we want to keep things separate. Regarding old-style 
> > > > profiler, does anyone still use it? There's now a superior in-tree 
> > > > replacement for it, so we could phase it out.
> > > 
> > > Well, for my part I won't miss it. But to be able to remove the 
> > > profile_tick() calls from the architectures I either have to rip 
> > > out the old profiler now, or adapt it to use hrtimer as well.
> > 
> > Do we _have to_ touch it so widely right now? We could start with a 
> > deprecation warning in this cycle. Once it's deprecated we can 
> > remove all those calls.
> 
> First version of the hrtimer patch for oprofile. I did not add the 
> sysctl yet, if the sysctl is added in oprofile_timer_init it would 
> not be available if some better profiling source is available. If 
> it is added unconditionally it would only have an effect if the 
> timer fallback is used. Both cases are not exactly nice for a user 
> space interface.

looks quite sane. I've Cc:-ed Robert.

	Ingo
