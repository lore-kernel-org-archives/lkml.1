Return-Path: <linux-kernel-owner+w=401wt.eu-S1750955AbXBEQam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955AbXBEQam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXBEQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:30:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXBEQal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:30:41 -0500
Date: Mon, 5 Feb 2007 17:26:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205162635.GA755@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170692539.29759.856.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> No, it was MTD_NAND_CAFE which requires MTD_NAND, and that _is_ within 
> the same tree. I don't know why you added it to the old monolithic 
> DiskOnChip driver.

yeah, i mis-analyzed the point of breakage - and my Kconfig hack simply 
papered it over by accident. I agree that your fix is the right one.

> > btw., this whole select problem is not limited to Aunt Tillie: in a 
> > couple of cases in the past few months when i saw some weird code in 
> > a driver and tried to enable it i had to search around for many 
> > minutes and enable random options to figure out its config 
> > dependencies until i had the driver truly enabled. (if there's some 
> > easy solution to this then i'm all ears - but i exclude the easiest 
> > solution of adding me to the 'aunt' category ;-)
> 
> I come across this frequently -- and I just look at the Kconfig file 
> to see the dependencies of the option I want to enable. It's usually 
> very simple.

i come across this problem frequently, and sometimes it's far from 
simple and involves half a dozen Kconfigs. For example pick up a Fedora 
.config of your choice and disable CONFIG_I2C.

> It's got a _lot_ harder recently to turn stuff _off_, as rmk observes. 
> You don't just look at the option you're interested in; you have to 
> grep all over the rest of the tree to find the 'select' which is 
> forcing it on after you turn it off. It's no longer in one place.

yeah.

> > I think that by blaming Aunt Tillie you might be missing the real 
> > problem.
> 
> No, by arbitrarily throwing 'select' into the mix with no real 
> guidance as to when to use it and when to use normal dependencies, 
> _that's_ when we're missing the real problem.

we should not have 'select' at all - unless it's some non-code option 
that is just a convenience switch for several other config options. A 
true dependency is already expressed in one direction via the 'depend 
on' directive - no need to express it in the other direction as well, 
that only leads to redundancy and to bugs.

	Ingo
