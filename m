Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYBJVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYBJVby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYBJVbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:31:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbYBJVbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:31:45 -0500
Date: Sun, 10 Feb 2008 22:31:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [patch] kgdb light, v6
Message-ID: <20080210213120.GD29507@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210093128.GA11350@infradead.org> <20080210171742.GF7088@elte.hu> <200802102043.58895.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802102043.58895.bzolnier@gmail.com>
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


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> > no. These are not DocBook comments, if you look carefully at the 
> > format [it's not a leading '/**' comment block]. But obviously 
> > documenting this in the include file is very useful, because that's 
> > where people look first, so i kept it. (the APIs will not deviate 
> > across architectures)
> 
> comments and variable names in include files have a tendency for going 
> out-of-sync in the long term so IMO having a DocBook to point people 
> at would be a better solution (+ it would shrink <linux/kgdb.h> by 122 
> lines)

yes, i very much agree in general, but this is a _SPECIAL CASE_, and i 
already tried to point that out to Christoph but he's not the type of 
guy who listens to others all that easily when it comes to his pet 
peeves ;-)

this is a special case because it's an _architecture facility_.

read: right now we have 25 architectures, and this means that in a year 
we'll have 25 arch/*/kernel/kgdb.c files. What will be more likely to 
get out of sync, 25 full sets of DocBook entries of the same thing, 
spread across 25 architectures - or that lone single 
include/linux/kgdb.h file that is looked at by everyone? And what will 
be easier to update if we extend any of the APIs?

so the DocBook rules are fine, but in this SPECIAL CASE they cause the 
possibly worst solution: total information anarchy!

the correct approach is to put the _arch specific_ details into the 
arch/*/kernel/kgdb.c files, and to keep the generic bits in 
include/linux/kgdb.h. KGDB did exactly that and it's by far the cleanest 
and most maintainable approach.

If DocBook does not pick that up then it's a _DocBook problem_. I dont 
mind adding some dummy weak aliases to kernel/kgdb.c for DocBook to pick 
up, to help solve this DocBook problem - but to blame it on KGDB is way 
off the mark. It used to be the crappiest piece of sh*t everyone would 
laugh about when looking at (right before suffering permanent brain 
damage), but now it's one of the cleanest and most CodingStyle conform 
kernel subsystems :-)

case in point:

                             errors   lines of code   errors/KLOC
  kernel/kgdb.c                   0            1839             0
  fs/xfs/                      2102          106019          19.8

right, XFS has more than 2 thousand bona fide CodingStyle violations! 

But yeah, it has the luxory of upstream integration ... ;-)

[ not that i want to pick on XFS - it's a very clean codebase in my 
  opinion, considering its fundamental complexity. It's just that anyone 
  who wants to find a style error in KGDB now has to search _hard_ ;-) ]

	Ingo
