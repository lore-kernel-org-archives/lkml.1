Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYEANyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYEANyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYEANyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:54:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50421 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbYEANyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:54:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 15:53:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011353.19335.rjw@sisk.pl> <200805011516.43159.bzolnier@gmail.com>
In-Reply-To: <200805011516.43159.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011553.55948.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 01 May 2008, Rafael J. Wysocki wrote:
> > On Thursday, 1 of May 2008, Willy Tarreau wrote:
> > > On Wed, Apr 30, 2008 at 06:19:56PM -0700, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > > > > 
> > > > > > I do _not_ want to slow down development by setting some kind of "quality 
> > > > > > bar" - but I do believe that we should keep our quality high, not because 
> > > > > > of any hoops we need to jump through, but because we take pride in the 
> > > > > > thing we do.
> > > > > 
> > > > > Well, we certainly should, but do we always remeber about it?  Honest, guv?
> > > > 
> > > > Hey, guv, do you _honestly_ believe that some kind of ISO-9000-like 
> > > > process generates quality?
> > > > 
> > > > And I dislike how people try to conflate "quality" and "merging speed" as 
> > > > if there was any reason what-so-ever to believe that they are related.
> > > > 
> > > > You (and Andrew) have tried to argue that slowing things down results in 
> > > > better quality, and I simply don't for a moment believe that. I believe 
> > > > the exact opposite.
> > > 
> > > Note that I'm not necessarily arguing for slowing down, but for reduced
> > > functional conflicts (which slow down may help but it's not the only
> > > solution). I think that refining the time resolution might achieve the
> > > same goal. Instead of merging 10000 changes which each have 1% chance
> > > of breaking any other area, and have all developers try to hunt bugs
> > > caused by unrelated changes, I think we could do that in steps.
> > > 
> > > To illustrate, instead of changing 100 areas with one of them causing
> > > breaking in the other ones, and having 100 victims try to hunt the
> > > bug in 99 other areas, then theirs, and finally insult the faulty
> > > author, we could merge 50 areas in version X and 50 in X+1 (or 3*33
> > > or 4*25, etc...). That way, we would only have 50 victims trying to
> > > find the bug in 49 other areas (or 32 or 24). Less people wasting
> > > their time will mean faster validation of changes, and possibly
> > > faster release cycle with better quality.
> > > 
> > > People send you their crap every two months. If you accept half of
> > > it every month, they don't have to sleep on their code, and at the
> > > same time at most half of them are in trouble during half the time
> > > (since bugs are found faster).
> > 
> > Well, as far as I'm concerned, that will work too.
> > 
> > > > So if we can get the discussion *away* from the "let's slow things down", 
> > > > then I'm interested. Because at that point we don't have to fight made-up 
> > > > arguments about something irrelevant.
> > > 
> > > well, is "let's split changes" ok ?
> > 
> > How about:
> > 
> > (1) Merge a couple of trees at a time (one tree at a time would be ideal, but
> >     that's impossible due to the total number of trees).
> > (2) After (1) give testers some time to report problems introduced by the
> >     merge.
> > (3) Wait until the most urgent problems are resolved.  Revert the offending
> >     changes if there's no solution within given time.
> > (4) Repeat for another couple of trees.
> > (5) Arrange things so that every tree gets merged once every two months.
> > 
> > This would also give us an idea of which trees introduce more problems.
> 
> ...and what would you do with such information?
> 
> I'm not actually worried about my tree but if (theoretically) it happens to
> be amongst the "problematic" ones I would be a bit pissed by blame shifting,
> especially given that it is very difficult to compare different trees as
> they (usually) deal with quite different areas of the code (some are messy
> and problematic, yet critical while others can be more forgiving).
> 
> Also slowing down things to focus on quality is really a bad idea.  You can
> trust me on this one, I've tried it once on the smaller scale and it was a
> big disaster cause people won't focus on quality just because you want them
> to.  They'll continue to operate in the usual way and try to workaround you
> instead (which in turn causes extra tensions which may become quiet warfare).
> In the end you will have a lot more problems to deal with...

Well, I won't discuss with your experience.

> Same goes for any other kind of improvement by incorporating "punishment" as
> the part of the process.  You are much better helping people and trying them
> to understand that they should apply some changes to their way of work because
> it would be also beneficial for _them_, not only for _you_.

I agree.

> Now regarding the development model - I think that there is really no need
> for a revolution yet, instead we should focus on refining the current process
> (which works great IMO), just to summarize various ideas given by people:
> 
> - try to persuade few black sheeps that skipping linux-next completely for
>   whole patch series is a really bad idea and that they should try to spend
>   a bit more time on planning for merge instead of LastMinute assembly+push
>   (by doing it right they could spend more time after merge to prepare for
>   the next one or fixing old bugs instead of chasing new regressions, overall
>   they should have _more_ time for development by doing it right)
> 
> - encourage flatting of merges during the merge window so instead of 1-2 big
>   merges per tree at the beginning of the merge you have few smaller ones
>   (majority of maintainers do it this way already)
> 
> - more testing for linux-next, distros may be of a great help here (-mm and
>   -next often catches bugs that you wouldn't have ever imagined in the first
>   place and they get fixed before the problem propagates into Linus' tree)

There still are too many bugs of this kind that make it to the Linus' tree and
they are the source of this thread.

> - more documentation for lowering the entry barrier for people who would like
>   to review the code (what Al has mentioned in this thread is a great idea
>   so no need for me to repeat it here)

Agreed.

> - more co-operation between people from different areas of the code
>   (i.e. testing linux-next instead of your own tree)

Agreed.

> and just not to forget - changes happen by people actually putting the work
> into them not by endless discussions.

Well, I'm not sure what that's supposed to mean, so I won't comment.

Thanks,
Rafael
