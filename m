Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYBSOkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYBSOkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYBSOkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:40:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40770 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYBSOke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:40:34 -0500
Date: Tue, 19 Feb 2008 15:40:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] suspend/resume self-test
Message-ID: <20080219144005.GC21176@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <200802180240.47510.david-b@pacbell.net> <20080218130914.GC17697@elte.hu> <200802181216.25350.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802181216.25350.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> > And, at least to me, there seems to be a rather apparent correlation 
> > between "suspend/resume regressions caught as early as possible" and 
> > the future, desired state of: "STR working sanely on x86" ;-)
> 
> Thing is, this will catch not just regressions ... but cases where STR 
> never worked in the first place.  Video problems, etc.  Also various 
> system startup races, as in the PCMCIA and MMC/SD/SDIO cases I noted.

yes, but that's not your problem, that's the STR folks' problem.

> Right, and the best way to ensure that it's only *regressions* that 
> break things is to expect someone to have configured the kernel 
> command line appropriately (in grub or whatever).

a simple .config flag is perfectly fine for that, as long as it's 
default disabled and properly demarked. We have literally _dozens_ of 
"dangerous" test options and _nobody_ complains about them being 
dangerous ... They do their primary job of triggering bugs sooner, 
faster and harder, resulting in bugs getting fixed sooner, faster and 
harder.

> Another way to achieve that is to include the test code based on one 
> config option, and change the test *mode* based on another one.  That 
> way a distro could include that in standard kernels with "no test" 
> mode as the default, but it would be easy to enable only for oneshot 
> tests or field troubleshooting ... while developers could turn on the 
> more dangerous "always test STR" (or standby, or hibernate) mode, if 
> they were helping to find and fix problems surfaced by such tests.

no distro would enable this option, it just adds a needless 5-6 seconds 
delay to the bootup, and a needless "s2ram blows up sooner than it 
should" risk. _I_ want to enable this option, and want to see it trigger 
more often than just once out of a hundred randconfig setups.

really, you are making rookie mistakes in this area and you are doing 
injustice to the code you wrote and maintain :-) As i said it before, 
externally it looks like as if you intentionally avoided your code from 
being used, from people who _want_ to use your code. _I_ had to fight 
for almost an hour (!) until i figured out the zillions of .config 
variants that were finally able to get my test-system to boot-time 
suspend and resume all by itself. It's totally non-obvious. As far as 
the general Linux community goes, it's almost as if your code did not 
even exist, so well hidden and obscured it is.

	Ingo
