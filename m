Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbZJFPh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbZJFPh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbZJFPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:37:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbZJFPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:37:27 -0400
Date: Tue, 6 Oct 2009 17:36:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006153632.GA29795@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 Oct 2009, Ingo Molnar wrote:
> > 
> > We can ignore that and say "hehe, you dont understand non-linear 
> > trees and ran git remote update blindly, too bad for you", or we 
> > might do something to make things more transparent and reduce the 
> > confusion.
> 
> You are missing the point.
> 
> The only thing we can do is to teach people that the Makefile version 
> isn't too important, and that it really doesn't tell very much.
> 
> Trying to tweak it to make it somehow "more meaningful" is a BAD 
> THING, because it continues to spoon-feed people a lie.
> 
> The cake is a lie. In between kernel versions, you can't rely on the 
> Makefile.  You should teach yourself (and others) THAT, rather than 
> trying to teach people to believe the lie even more.
> 
> Once you start believing the lie, suddenly all the subtrees will start 
> thinking that now _their_ kernel versions are bad, so now they'll 
> start to want to make the same idiotic changes to their Makefiles, or 
> maybe they'll decide that they don't want to pull tagged releases, but 
> the "one after the tag so that they'll get the updated Makefile".
> 
> And even if they don't do that idiocy, the whole "the version number 
> is meaningful outside of releases" thing leads to brain damage.

hm, i think you ignored (or missed, or found irrelevant) my first 
suggested variant:

 v2.6.31
 v2.6.31+
 v2.6.32-rc1
 v2.6.32-rc1+
 ..
 v2.6.32-rc9
 v2.6.32-rc9+
 v2.6.32

The '+' sign says that it's more than .31.

That defuses the 'lie' of trying to linerize a multi-thousand-node graph 
down into some catchy human-readable string pretty efficiently i think. 
It doesnt tell us precisely what that '+' means - it could be goodness 
or it could be badness.

_That_ i think is a lot harder to confuse with the real .31 than a 
v2.6.31-1234-g16123c4 version string.

My tweak #2, adding -rc0 indeed brings in problems, it's too artificial 
to do it right after .31 gets released - and if we dont do it then we 
cannot do it later either. (so we cannot really do it)

[ It might bring in some advantages too btw. A pull request to you for a 
  tree that is -rc0 based means it got rebased straight in the merge 
  window => bad. Such a thing would be apparent at a glance. 'Good' 
  trees should be based on some known good version of the previous 
  stable kernel cycle. ]

	Ingo
