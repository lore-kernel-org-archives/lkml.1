Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZJAPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZJAPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZJAPA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:00:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZJAPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:00:57 -0400
Date: Thu, 1 Oct 2009 17:00:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
	22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091001150046.GA21476@elte.hu>
References: <20090930140904.GA6150@one.firstfloor.org> <20090930194049.GA17712@liondog.tnic> <20090930204643.GA24862@elte.hu> <20090930214859.GA28638@elte.hu> <20090930223956.GE17712@liondog.tnic> <20090930230947.GA9346@elte.hu> <20091001141432.GA11410@aftab> <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain> <20091001144637.GB11410@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001144637.GB11410@aftab>
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Thu, Oct 01, 2009 at 07:34:11AM -0700, Linus Torvalds wrote:
> > > Ok, here it is, tested on two Fam10 machines here with injecting MCEs.
> > > The decoding code is now built-in by default (early_initcall requires
> > > !MODULE).
> > 
> > I don't think it has to require !MODULE. We could do what we do for the 
> > other initcalls, ie if MODULE we turn it into just a regular initcall. If 
> > that allows something like the EDAC MCE to be built as a module, and 
> > people want to, then just go ahead and add the one-liner to <linux/init.h>
> >
> > Of course, if it _requires_ being loaded early for some other reason, then
> 
> the only reason I can think of is if you want to be able to decode 
> MCEs happening as early as possible before the modules have been 
> init-ted.
> 
> Question really is, what is more important to us? But we definitely 
> can do the module stuff too and get rid of ~5K core kernel fat by 
> relocating the whole functionality completely into the module. Hmm...

I'd focus on the built-in-side initially, which is the most 
practical/debuggable/serviceable solution. It's of course not a problem 
(at all) if it is _also_ module loadable but that's not the primary 
goal.

	Ingo
