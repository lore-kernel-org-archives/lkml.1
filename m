Return-Path: <linux-kernel-owner+w=401wt.eu-S1763162AbZEHWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763162AbZEHWrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZEHWr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:47:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbZEHWr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:47:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Sat, 9 May 2009 00:46:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop>
In-Reply-To: <1241819569.19600.281.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905090046.21282.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Nigel Cunningham wrote:
> Hi Rafael.

Hi,

> On Fri, 2009-05-08 at 16:11 +0200, Rafael J. Wysocki wrote:
> > On Friday 08 May 2009, Nigel Cunningham wrote:
> > > On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> > > > On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > > > > On Thursday 07 May 2009, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > > > > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > > > > > it can be merged) and the willingness of those who matter.
> > > > ...
> > > > > > To summarise disadvantages:
> > > > > > 
> > > > > > - only core has 8000 LoC
> > > > > > - it does stuff that can be easily done in userspace
> > > > > >      (and that todays distros _do_ in userspace).
> > > > > > - it duplicates uswsusp functionality.
> > > > > > - compared to [u]swsusp, it received little testing
> > > > > 
> > > > > Actually, I see advantages of working together versus fighting flame wars.
> > > > > Please stop that, I'm not going to take part in it this time.
> > > > 
> > > > Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> > > > having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> > > > 
> > > > If we are talking about improving mainline to allow tuxonice
> > > > functionality... then yes, that sounds reasonable.
> > > 
> > > I'd like to see use have all three for one or two releases of vanilla,
> > > just to give time to work out any issues that haven't been foreseen.
> > > Once we're all that there are confident there are no regressions with
> > > TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.
> > 
> > So this is an idea to replace our current hibernation implementation with
> > TuxOnIce.
> 
> That's my ideal. I know you and Pavel don't want to see us go down that
> path, but I was asked "What do you propose?" and I answered that
> question.

So you could also easily anticipate my reaction. :-)

Quite frankly, I don't really think this is realistic.

First, because it is technically too difficult to have all of the code reviewed
and _agreed_ _upon_ by everyone at once.  And if it's not agreed upon, you'll
have to modify it and it won't be the same thing any more once you've done
that.  Which I'd say is guaranteed, having had a quick look at the code.

Second, because realistically you shouldn't expect _anyone_ (be it me or Pavel
or just about anybody else) to throw away his own code and replace it with
yours just because *you* think your code is better.  You really should have
listened to the HPA's talk at the OLS last year (here's a link to the paper
http://ols.fedoraproject.org/OLS/Reprints-2008/anvin-reprint.pdf, please see
Section 10) which was about merging open source projects, among other things. :-)

> > Which unfortunately I don't agree with.
> > 
> > I think we can get _one_ implementation out of the three, presumably keeping
> > the user space interface that will keep the current s2disk binaries happy, by
> > merging TuxOnIce code _gradually_.  No "all at once" approach, please.
> > 
> > And by "merging" I mean _exactly_ that.  Not adding new code and throwing
> > away the old one.
> > 
> > While I can work on creating one hibernation implementation by taking the
> > best ideas from all of the implementation we have at hand, I surely won't be
> > working on replacing our current code with TuxOnIce.  If that disappoints you,
> > then I'm sorry.
> 
> But who is going to do that, and how and when. You're clearly too busy
> working on enhancements to the driver model - enhancements that are good
> and necessary (I'm not at all meaning this is bad). I'm only doing this
> in a little bit of spare time. Pavel doesn't seem to be doing it at all.

I think I can find some time to work on that.  I've spent a lot of time
recently on improving the allocation of memory for hibernation images and I
think I can work on the other hibernation-related things either.  The most
important thing to me is whether or not to put that into my todo list.  If I
decide to do it, I'll find the time too.

> And we have different ideas about how things should be done. Userspace
> vs kernel space. Providing tuning knobs vs not. And so on.

This isn't _that_ important.  Actually, I'm not against an entirely in-kernel
solution, as there are some clear benefits of doing it this way.  We only
need to be careful enough not to break the existing setups.

> And the code includes some fundamental differences. I freeze processes
> and prepare the whole image before saving anything or doing an atomic
> copy whereas you just free memory before doing the atomic copy. You save
> everything in one part whereas I save the image in two parts.

IMO the differences are not that fundamental.  The whole problem boils down
to using the same data structures for memory management and I think we can
reach an agreement here.

> I take a modular approach and you have everything hardwired.

That's because using modules woudn't really make sense for us. :-)

> Even if we did try to merge the three implementations, there'd come a
> point where we either threw away core parts of TuxOnIce or dropped the
> whole of [u]swsusp and started again - or both.

I would be for starting again, really, using the experience we've collected so
far.  How we technically do it is another matter.  I personally would prefer
adding new code in such a way that it's useable from the start, so that it gets
tested and integrated with all of the subsystems we're touching.

> It doesn't disappoint me that you don't won't to replace [u]swsusp with
> TuxOnIce. I never thought you or Pavel would want to do that.
> 
> I did hold out a little hope that you at least might be supportive
> anyway of getting TuxOnIce added into vanilla - 

That would take lot of work and we'd also have to ask many other busy people
to do a lot of work for us.  I think it's better to just avoid it at this point.

> if only so that users can get a better hibernation experience while we work
> through merging the three into one. I'd far rather get along well with you
> than have some sort of competitive relationship.

Great, let's do our best to be productive.

Best,
Rafael
