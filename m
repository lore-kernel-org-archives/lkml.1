Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXBEQVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXBEQVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXBEQVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:21:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbXBEQVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:21:49 -0500
Date: Mon, 5 Feb 2007 17:17:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205161744.GA31740@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <20070205161227.GB4563@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205161227.GB4563@flint.arm.linux.org.uk>
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


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Mon, Feb 05, 2007 at 04:56:27PM +0100, Ingo Molnar wrote:
> > btw., this whole select problem is not limited to Aunt Tillie: in a 
> > couple of cases in the past few months when i saw some weird code in a 
> > driver and tried to enable it i had to search around for many minutes 
> > and enable random options to figure out its config dependencies until i 
> > had the driver truly enabled. (if there's some easy solution to this 
> > then i'm all ears - but i exclude the easiest solution of adding me to 
> > the 'aunt' category ;-) I think that by blaming Aunt Tillie you might be 
> > missing the real problem.
> 
> Adding a 'select' statement might solve that particular problem:
> 
>  "What config symbols do I need to turn on to enable FOO"
> 
> but it creates another problem which is at precisely the same level. 
> IOW:
> 
>  "What config symbols do I need to turn off to disable FOO"
> 
> Both require the use of grep to solve it.  Both are as bad as each 
> other.  'select' only moves the problem - it doesn't actually solve 
> anything.

yes, in the example above i only outlined that the problem is real and 
not limited to Aunt Tillie's.

> The real problem is that "band-aiding" the problem is all too easy, so 
> we just bung a select in.  We're actually storing up bigger problems 
> for the future, making the kernel configuration system more and more 
> complex, sometimes creating circular dependencies through 
> select/depends, basically turning it into something several orders of 
> magnitude worse than the original shell scripts.

circular dependencies are nicely detected, warned about and worked 
around by the Kconfig system. I fixed one such bug recently. I have to 
say the Kconfig code has improved very significantly during the past few 
years and i dont want any of what i'm writing to be understood as a 
criticism. It's more in the direction of: 'ok, things are pretty nice 
and the config tree works currently, now lets make it even cleaner'.

> The only real way I see the problem truely getting solved is if folk 
> start standing up against throwing "select" in so there's some 
> motivation to actually fix the underlying problem.

the solution is i think two-fold and goes along the lines i outlined in 
the previous mail:

 - make dependencies as tree-alike as possible

note that the MTD problem was caused by those drivers not being part of 
a clean tree.

But even with a 100% clean tree structure there's a legitimate desire to 
select modules several layers down from the current 'leaf' nodes of the 
config tree:

 - provide a tool mode (not a Kconfig language feature) to navigate the
   complete tree of features (including currently disabled ones) and
   enable the selection of components (by automatically selecting all
   dependent features).

	Ingo
