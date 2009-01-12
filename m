Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZALEwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZALEwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 23:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZALEwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 23:52:30 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:54375 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZALEw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:52:29 -0500
From: Christian Couder <chriscool@tuxfamily.org>
To: Pierre Habouzit <madcoder@debian.org>
Subject: Re: current git kernel has strange problems during bisect
Date: Mon, 12 Jan 2009 05:51:56 +0100
User-Agent: KMail/1.9.9
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200901111602.53082.borntraeger@de.ibm.com> <f19298770901111147t625a2161t779bfcfc0317225c@mail.gmail.com> <20090111230240.GA27489@artemis.corp>
In-Reply-To: <20090111230240.GA27489@artemis.corp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901120551.56791.chriscool@tuxfamily.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 janvier 2009, Pierre Habouzit a écrit :
> On Sun, Jan 11, 2009 at 07:47:18PM +0000, Alexey Zaytsev wrote:
> > On Sun, Jan 11, 2009 at 22:42, Sam Ravnborg <sam@ravnborg.org> wrote:
> > >> For bisect, it's indeed somewhat annoying, and we could have perhaps
> > >> done some things a bit differently, but it's about the closest you
> > >> can get to "real history" without making the first btrfs merge-point
> > >> a _total_ disaster.
> > >>
> > >> For bisect purposes, if you know you're not chasing down a btrfs
> > >> issue, you can do
> > >>
> > >>       git bisect good 34353029534a08e41cfb8be647d734b9ce9ebff8
> > >>
> > >> where that commit 34353029 is the last one which has _just_ the
> > >> btrfs files. The next commit is when it does "Merge Btrfs into
> > >> fs/btrfs", and that one has the whole kernel tree again.
> > >
> > > The cost of moving this piece of history from one git tree to another
> > > git tree is that we make it harder to debug the kernel for the
> > > advanced user that knows how to do bisect.
> >
> > And wasn't is trivial to avoid? Just exporting the commits as
> > patches and importing them into the kernel tree would preserve
> > the history, and not break bisection.
>
> And would have brought a whole history of totally irrelevant stuff that
> never exited for real, with probably a lot of non-compiling sub-steps
> which would be even worse.
>
> No, the two possible choices were to squash the whole stuff at once, or
> do what has been done IMNSHO.  People have to grok how to take shortcuts
> with git-bisect.  I know that git-bisect puts people on the brainless
> course of actions where they git-bisect; configure; compile; boot; test;
> mark as good/bad and retry.  And that's what I sometimes don't like with
> it.  Because people trust git-bisect too much and forget how to think
> right.

Well "git bisect" can be more usefull if it can be fully automated (with git 
bisect run) because then you can make the computer do all the boring work. 
So I think putting people on the "brainless course of actions" can often be 
a good thing.

Anyway it looks to me that this kind of problem could be avoided if one 
could "replace" some commits only when bisecting. In this case what could 
be done is that one could "replace" the commit where btrfs is merged with 
one commit that cuts off the btrfs history. If the merge commit is only 
replaced when bisecting, then you get the best of both worlds:

_ when you bisect, you don't see the btrfs history that breaks the kernel 
build,
_ when you don't bisect, you see the full real history.

Of course if the bisection process finds out that the "replaced" commit is 
the culprit, then you need to understand what this means...

Regards,
Christian.
