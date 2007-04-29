Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbXD2MJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbXD2MJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbXD2MJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:09:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:58474 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbXD2MJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pDqAv5Mee9bhRZcnsubuwASzwZhYNgTe6vQO1RuyiidT4JOC1oUi61dOyOBF3twLRUBrH6lhLrO1AcI51b6iWK/S4Xx4SXJsH9RKX4nasA7hygUK34r3p4mIsOYMVwxU8Yg/zgBAtaEU/Az6Xw97kwrNqkfD1/2OxhKCAHQYAEY=
Message-ID: <4d8e3fd30704290509r79b7fc47i17ce286a43564259@mail.gmail.com>
Date: Sun, 29 Apr 2007 14:09:14 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [patch] CFS scheduler, -v6
Cc: "Willy Tarreau" <w@1wt.eu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Gene Heskett" <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       "Mark Lord" <lkml@rtr.ca>, "Zach Carter" <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <200704292146.15653.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704261041.04838.gene.heskett@gmail.com>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <20070429111159.GH23638@1wt.eu>
	 <200704292146.15653.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Sunday 29 April 2007 21:11, Willy Tarreau wrote:
> > On Sun, Apr 29, 2007 at 12:30:54PM +0200, Thomas Gleixner wrote:
> > > Willy,
> > >
> > > On Sun, 2007-04-29 at 09:16 +0200, Willy Tarreau wrote:
> > > > In fact, what I'd like to see in 2.6.22 is something better for
> > > > everybody and with *no* regression, even if it's not perfect. I had the
> > > > feeling that SD matched that goal right now, except for Mike who has
> > > > not tested recent versions. Don't get me wrong, I still think that CFS
> > > > is a more interesting long-term target. But it may require more time to
> > > > satisfy everyone. At least with one of them in 2.6.22, we won't waste
> > > > time comparing to current mainline.
> > >
> > > Oh no, we really do _NOT_ want to throw SD or anything else at mainline
> > > in a hurry just for not wasting time on comparing to the current
> > > scheduler.
> >
> > It is not about doing it in a hurry. I see SD as a small yet efficient
> > update to current scheduler. It's not perfect, probably not much extensible
> > but the risks of breaking anything are small given the fact that it does
> > not change much of the code or behaviour.
> >
> > IMHO, it is something which can provide users with a useful update while
> > leaving us with some more time to carefully implement the features of CFS
> > one at a time, and if it requires 5 versions, it's not a problem.
> >
> > > I agree that CFS is the more interesting target and I prefer to push the
> > > more interesting one even if it takes a release cycle longer. The main
> > > reason for me is the design of CFS. Even if it is not really modular
> > > right now, it is not rocket science to make it fully modular.
> > >
> > > Looking at the areas where people work on, e.g. containers, resource
> > > management, cpu isolation, fully tickless systems ...., we really need
> > > to go into that direction, when we want to avoid permanent tinkering in
> > > the core scheduler code for the next five years.
> > >
> > > As a sidenote: I really wonder if anybody noticed yet, that the whole
> > > CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> >
> > Contrarily to most people, I don't see them as competitors. I see SD as
> > a first step with a low risk of regression, and CFS as an ultimate
> > solution relying on a more solid framework.
> >
> > > CFS modifies the scheduler and nothing else, SD fiddles all over the
> > > kernel in interesting ways.
> >
> > Hmmm I guess you confused both of them this time. CFS touches many places,
> > which is why I think the testing coverage is still very low. SD can be
> > tested faster. My real concern is : are there still people observing
> > regressions with it ? If yes, they should be fixed before even being
> > merged. If no, why not merge it as a fix for the many known corner cases
> > of current scheduler ? After all, it's already in -mm.
> >
> > Willy
>
> Willy, you're making far too much sense. Are you replying to the correct
> mailing list?

FWIW, I strongly agree with Willy.

Ciao,
-- 
Paolo
"Tutto cio' che merita di essere fatto,merita di essere fatto bene"
Philip Stanhope IV conte di Chesterfield
