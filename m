Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbZFZOpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbZFZOpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZFZOox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:44:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbZFZOow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:44:52 -0400
Date: Fri, 26 Jun 2009 16:44:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626144445.GB19477@elte.hu>
References: <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk> <20090626110429.GB12446@elte.hu> <20090626125653.5e30bae4@lxorguk.ukuu.org.uk> <20090626122254.GA9959@elte.hu> <20090626133318.5b8de81b@lxorguk.ukuu.org.uk> <20090626125111.GA11575@elte.hu> <20090626143446.2cf061f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626143446.2cf061f5@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > We will gladly take clean x86 patches that abstract away 
> > lowlevel details of x86 platforms, and have been taking them and 
> > have been writing them for a long time. If this patch-set can 
> > shape itself in such a way (as i requested), without hindering 
> > the common case, it is certainly welcome.
> 
> Lets try again shall we. I'l repeat the relevant bits of the mail 
> you quoted bits from and ignored almost all of

Below is my reply to your above points (already sent in another 
mail) - which is really just mostly re-hashing the (rather obvious 
looking) things that have been said before.

	Ingo

---------------------->

* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > The thing is, you are trying to defend a v1 patch-set here that 
> > is really indefensible: it's ugly and deficient in numerous 
> > smaller and larger details. I outlined numerous deficiencies 
> > already - and i'll review v2 too to see what else is there to 
> > fix.
> 
> No I'm trying to understand what you actually want the thing to 
> look like.

It's a case by case thing and i pointed out a few specific 
directions in the review. The IO-APIC changes should probably go on 
top of Jeremy's IO-APIC driver-ization patches. They dont 
necessarily need their own IO-APIC driver (if the resulting line 
count increase is too much), but they should not wreck Jeremy's 
IO-APIC patches.

Bootup quirks that are small modificatons to existing PC 
initialization sequences should go into x86_quirks.

Timer related changes (the APB system timer) are mostly modular 
already by virtue of half of it being a clocksource and clockevents 
driver. The remaining bit of system timer handling should be 
abstracted out as a 'struct x86_system_timer' kind of structure, 
with ->init, ->timer_irq and ->shutdown functions.

[ Although it is beyond me why ABP was done - why wasnt HPET good
  enough? HPET can do per CPU clockevents too and it's just as 
  off-chip (and hence fundamentally slow) as ABP. ]

	Ingo
