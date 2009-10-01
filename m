Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZJAPdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZJAPdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZJAPdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:33:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZJAPdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:33:01 -0400
Date: Thu, 1 Oct 2009 17:32:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
	22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091001153250.GA25885@elte.hu>
References: <20090930194049.GA17712@liondog.tnic> <20090930204643.GA24862@elte.hu> <20090930214859.GA28638@elte.hu> <20090930223956.GE17712@liondog.tnic> <20090930230947.GA9346@elte.hu> <20091001141432.GA11410@aftab> <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain> <20091001144637.GB11410@aftab> <20091001150046.GA21476@elte.hu> <20091001152140.GC11410@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001152140.GC11410@aftab>
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

> On Thu, Oct 01, 2009 at 05:00:46PM +0200, Ingo Molnar wrote:
> > > > Of course, if it _requires_ being loaded early for some other reason, then
> > > 
> > > the only reason I can think of is if you want to be able to decode 
> > > MCEs happening as early as possible before the modules have been 
> > > init-ted.
> > > 
> > > Question really is, what is more important to us? But we definitely 
> > > can do the module stuff too and get rid of ~5K core kernel fat by 
> > > relocating the whole functionality completely into the module. Hmm...
> > 
> > I'd focus on the built-in-side initially, which is the most 
> > practical/debuggable/serviceable solution. It's of course not a problem 
> > (at all) if it is _also_ module loadable but that's not the primary 
> > goal.
> 
> How about a CONFIG_EDAC_DECODE_MCE which depends on CONFIG_CPU_SUP_AMD 
> and defaults to yes with a config text saying something in the likes 
> of
> 
> "... Select Y here if you want to decode MCEs happening early before 
> the modules framework has been initialized...."

Yeah, that would be good. It should also obviously depend on 
CONFIG_X86_MCE - so only visible if MCE support is enabled.

	Ingo
