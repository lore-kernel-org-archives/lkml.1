Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZJNHef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZJNHef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZJNHee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:34:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33586 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZJNHed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:34:33 -0400
Date: Wed, 14 Oct 2009 09:33:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Message-ID: <20091014073306.GB22778@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain> <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com> <20091014065941.GH784@elte.hu> <alpine.DEB.1.00.0910140014490.26562@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910140014490.26562@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> On Wed, 14 Oct 2009, Ingo Molnar wrote:
> 
> > > I don't think you want to do that because it would require the .config 
> > > to be posted on bug reports, for example, to determine the setting of 
> > > CONFIG_LOCALVERSION_AUTO before you can interpret the kernel version.  
> > > In other words, you wouldn't know that "2.6.32-rc4" is actually 200 
> > > commits beyond the actual release unless you also know that the 
> > > .config has CONFIG_LOCALVERSION_AUTO="none".
> > 
> > We've come a full circle ...
> > 
> > That's the current !CONFIG_LOCALVERSION_AUTO status quo ... That was 
> > being asked to be preserved for (unspecified) packaging reasons. So
> > your suggestion is to do away with that behavior altogether?
> > 
> 
> I don't think it's helpful to specify a version as "2.6.32-rc4" when 
> in reality it has 200 commits beyond the release and I like the 
> addition of `+' for !CONFIG_LOCALVERSION_AUTO if we're not at a tagged 
> commit.  That's what my two patches do so the only time you could get 
> a "2.6.32-rc4" version string is for when it's the equivalent of 
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.32-rc4.tar.bz2 
> (and you would actually get that regardless of whether you're using 
> CONFIG_LOCALVERSION_AUTO or not).
> 
> There's another possible extension that could be made: we could allow 
> LOCALVERSION= as passed to "make" to override the added `+' since it 
> is used to identify kernel versions by a string anyway; so make 
> LOCALVERSION=-slub_fixes would become v2.6.32-rc4-slub_fixes if 
> CONFIG_LOCALVERSION_AUTO were disabled, regardless of what commit 
> we're at, and v2.6.32-rc4-slub_fixes-00094-g80f5069 if it were 
> enabled.
> 
> Regardless of future improvements, I think my two patches allow the 
> kernel version to more accurately describe what is running.  That is 
> predicated on my belief that "v2.6.32-rc4", though, should never 
> describe _anything_ except the kernel.org v2.6.32-rc4 kernel.

I agree with all that - in fact i started this thread by stating that 
view and suggesting the '+' extension to the short version name.

But there's been packaging related objections from Frans and others, and 
i suspect you'll need to answer/address those instead of further 
detailing the virtues of proper version names (which i still 100% agree 
with).

Btw., i only minimally agree with the packaging objections: there's 
certainly no harm in enabling for folks to still keep things as they 
were for years. But we can definitely change the default and we can make 
it difficult to choose the faulty short-name scheme.

Thanks,

	Ingo
