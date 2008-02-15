Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbYBOBM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbYBOBM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758896AbYBOBMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:12:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbYBOBMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:12:44 -0500
Date: Fri, 15 Feb 2008 02:11:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080215011145.GA5934@elte.hu>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211221535.bc0dc9cf.akpm@linux-foundation.org> <20080212225716.cf695fe4.sfr@canb.auug.org.au> <20080214081405.GA20791@flint.arm.linux.org.uk> <20080214232229.f7bdc6ac.sfr@canb.auug.org.au> <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Feb 2008, Stephen Rothwell wrote:
> > 
> > Originally, I assumed the stable branch would be for our "usual" API 
> > changes, but it appears we are not having any more of those. :-)
> 
> It's not that we should _never_ have them, it's that they shouldn't be 
> "business as usual".
> 
> I'm happy with them being a "a couple of times a year". I'm not happy 
> with them being "once or twice for every release cycle". That's the 
> big deal for me.

very much agreed. I've yet to see a _single_ wide-scale API change that 
broke stuff left and right where that breakage was technically 
justified. I have not seen a single one.

All those cases were just plain old botched attempts. Either someone can 
do a large-scale API change like the irq_regs() cleanups with near-zero 
breakages, or someone cannot. In the latter case, gradual introduction 
and trickling it through subsystem trees is a _must_.

and if it's _hard_ to do a particular large-scale change, then i think 
the right answer is to _not do it_ in a large-scale way, but do it 
gradually.

I claim that there's just not a single valid case of doing wide-scale 
changes atomically and departing from the current to-be-stabilized 
kernel tree materially. _Every_ large-scale API change can be done in a 
staged way, with each subsystem adopting to the change at their own 
pace, it just has to be planned well and tested well enough and has to 
be executed persistently. And the moment we trickle things through 
subsystem trees, there's no integration pain, as subsystem trees are 
largely disjunct anyway.

i also fear that having an API-changes-only tree will dillute our 
testing effort of the current to-be-stabilized upstream tree, as it 
materially disrupts the flow of patches. Most maintainers should 
concentrate on stabilizing current -git with only one serial queue of 
fixes and enhancements ontop of that tree. I dont see how having a 
second queue would help - it clearly splits attention.

widescale API changes should be discouraged, and forcing them through 
the harder, "gradual, per subsystem" route is _exactly_ such a strong 
force that discourages people from doing them.

	Ingo
