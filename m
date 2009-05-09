Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZEINzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZEINzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZEINzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:55:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58679 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZEINzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:55:00 -0400
Date: Sat, 9 May 2009 15:54:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090509135452.GE10859@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop> <200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241825408.19600.384.camel@nigel-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > I'd like to see use have all three for one or two releases of vanilla,
> > > > > just to give time to work out any issues that haven't been foreseen.
> > > > > Once we're all that there are confident there are no regressions with
> > > > > TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.
> > > > 
> > > > So this is an idea to replace our current hibernation implementation with
> > > > TuxOnIce.
> > > 
> > > That's my ideal. I know you and Pavel don't want to see us go down that
> > > path, but I was asked "What do you propose?" and I answered that
> > > question.
> > 
> > So you could also easily anticipate my reaction. :-)
> > 
> > Quite frankly, I don't really think this is realistic.
> > 
> > First, because it is technically too difficult to have all of the code reviewed
> > and _agreed_ _upon_ by everyone at once.  And if it's not agreed upon, you'll
> > have to modify it and it won't be the same thing any more once you've done
> > that.  Which I'd say is guaranteed, having had a quick look at the code.
> 
> I think you're putting unrealistic barriers in the way. Does all code
> that goes into the kernel get "reviewed and agreed upon by everyone at
> once"? No! That's why bugs get in that have to be fixed and why things
> go in despite the disagreement of some people. If there are good,

I don't think Rafael is putting any barriers in your way.

> This is going to sound arrogant, but please don't take it that way: I
> can't see any other way of putting it. I don't *think* my code is
> better. It is better. swsusp has essentially stood still since Pavel
> first forked the code and got it merged. Yes, you have done some
> great

I don't think _I_ forked anything.

> work on improving the code too and yes, you've done your work on the
> version that was already merged. But your changes been more in the area
> of fixing/improving what's already there than adding new and useful
> features. On the other side, I've continued to improve the code,

Yes, that's fair. We kept incremental fixing, improving. On the other
hand, you added new features.

> new features (support for multiple swap partitions & files, for writing
> to ordinary files, for mulithreaded I/O etc etc) making it more useful
> and more reliable. There are some new features that have been put in
> swsusp, but in just about every case (I think there might be an
> exception or two), they're things TuxOnIce had for ages before. eg: SMP
> support came with cpu hotplugging in 2.6.12 or so. TuxOnIce had SMP
> support in 2.4.

You were moving faster because you did not have to move in small
incremental steps, and you were allowed to add temporary hacks into
the code. Is that surprising? Not to me.

[Please update http://www.tuxonice.net/features pages. They are
misleading; yes, uswsusp supports threaded writes, can be reconfigured
without rebooting and yes we did test failure paths, it can be
scripted, and it supports checksums. I don't know what you mean by
kexec support, but kexec/kjump could be used as whole another method
of hibernating a machine, basically adding fourth row to your table.]

> > > I take a modular approach and you have everything hardwired.
> > 
> > That's because using modules woudn't really make sense for us. :-)
> 
> I'm not saying modules but modular. TuxOnIce has support for compression
> neatly abstracted into one file, for swap in another and so on.
> [u]swsusp doesn't.

uswsusp has compression neatly abstracted into userland. I still
believe that's superior to kernel module.

> > > It doesn't disappoint me that you don't won't to replace [u]swsusp with
> > > TuxOnIce. I never thought you or Pavel would want to do that.
> > > 
> > > I did hold out a little hope that you at least might be supportive
> > > anyway of getting TuxOnIce added into vanilla - 
> > 
> > That would take lot of work and we'd also have to ask many other busy people
> > to do a lot of work for us.  I think it's better to just avoid it at this point.
> 
> I just don't see why you think that. As I said in another reply, there's
> no work for arch maintainers, very little for mm people and nothing for
> filesystem maintainers in what I've sent.

Mainline [u]swsusp does not have ability to save all the memory,
because that code was deemed too hard to review by mm people. At that
time, that piece of code was nicely separated 300 line diff.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
