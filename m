Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZJFPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZJFPoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZJFPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:44:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757520AbZJFPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:44:19 -0400
Date: Tue, 6 Oct 2009 08:42:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Linus Torvalds wrote:
> 
> It's the "let's make that meaningful and misleading number be even _more_ 
                            ^^^^^^^^^^
> misleading by making people think it has meaning" magical thinking that I 
> hate.

That 'meaningful' was supposed to be a 'meaningless' of course.

The point really is that we have about 1 new version number per week, but 
at the same time we have an average of one _thousand_ commits merged per 
week. So at a glance, the Makefile version number doesn't mean very much.

But if the thousand commits we merged actually were nicely spread out in 
between those version numbers, it would all work really beautifully. Sure, 
the top-level version number would only give you a 1/1000 of the real 
commit information, but hey, that's kind of what you'd want, isn't it? So 
then the top-level Makefile version number would be meaningful and useful!

But that's not how it works. In fact, if we actually followed our own 
release rules ("merge window is for merging code that was written before 
the merge window even started"), no commits except for my merge commits 
should actually have that last release in their Makefile at all! 

Now, that's not actually true, because (a) people rebase and (b) even in 
the absense of rebases I do merge with people like Andrew by email, so we 
actually end up having statistics like these:

	git rev-list v2.6.31..v2.6.32-rc1 |
		while read a
		do
			git show $a:Makefile | grep SUBLEVEL.=
		done | sort | uniq -c

resulting in

     32 SUBLEVEL = 29
    383 SUBLEVEL = 30
   8795 SUBLEVEL = 31
      1 SUBLEVEL = 32

which is actually a bit sad in itself (showing just _how_ many people 
rebased their work on top of a release), but is still showing that we 
actually had 32 new commits in there that were based on a 2.6.29 kernel

And what people are suggesting with a 2.6.32-rc0 would just lead to people 
now rebasing their work NOT EVEN ON A RELEASE. They'd want to rebase it on 
top of that made-up commit (2.6.32-rc0), so now from a development 
standpoint that commit suddenly becomes more important than the release 
itself. 

Do you not see the insanity? We should have _less_ of this kind of 
thinking, not more. At least rebasing on top of a release sounds sane. Not 
this kind of "rebase on top of a magic Linus-commit" crap.

			Linus
