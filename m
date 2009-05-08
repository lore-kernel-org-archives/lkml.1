Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbZEHVv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbZEHVv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZEHVvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:51:51 -0400
Received: from mail.crca.org.au ([67.207.131.56]:41265 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZEHVvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:51:50 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <200905081611.41865.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507215112.GC14611@elf.ucw.cz>
	 <1241746459.19600.246.camel@nigel-laptop>  <200905081611.41865.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 09 May 2009 07:52:49 +1000
Message-Id: <1241819569.19600.281.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

On Fri, 2009-05-08 at 16:11 +0200, Rafael J. Wysocki wrote:
> On Friday 08 May 2009, Nigel Cunningham wrote:
> > On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> > > On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > > > On Thursday 07 May 2009, Pavel Machek wrote:
> > > > > Hi!
> > > > > 
> > > > > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > > > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > > > > it can be merged) and the willingness of those who matter.
> > > ...
> > > > > To summarise disadvantages:
> > > > > 
> > > > > - only core has 8000 LoC
> > > > > - it does stuff that can be easily done in userspace
> > > > >      (and that todays distros _do_ in userspace).
> > > > > - it duplicates uswsusp functionality.
> > > > > - compared to [u]swsusp, it received little testing
> > > > 
> > > > Actually, I see advantages of working together versus fighting flame wars.
> > > > Please stop that, I'm not going to take part in it this time.
> > > 
> > > Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> > > having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> > > 
> > > If we are talking about improving mainline to allow tuxonice
> > > functionality... then yes, that sounds reasonable.
> > 
> > I'd like to see use have all three for one or two releases of vanilla,
> > just to give time to work out any issues that haven't been foreseen.
> > Once we're all that there are confident there are no regressions with
> > TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.
> 
> So this is an idea to replace our current hibernation implementation with
> TuxOnIce.

That's my ideal. I know you and Pavel don't want to see us go down that
path, but I was asked "What do you propose?" and I answered that
question.

> Which unfortunately I don't agree with.
> 
> I think we can get _one_ implementation out of the three, presumably keeping
> the user space interface that will keep the current s2disk binaries happy, by
> merging TuxOnIce code _gradually_.  No "all at once" approach, please.
> 
> And by "merging" I mean _exactly_ that.  Not adding new code and throwing
> away the old one.
> 
> While I can work on creating one hibernation implementation by taking the
> best ideas from all of the implementation we have at hand, I surely won't be
> working on replacing our current code with TuxOnIce.  If that disappoints you,
> then I'm sorry.

But who is going to do that, and how and when. You're clearly too busy
working on enhancements to the driver model - enhancements that are good
and necessary (I'm not at all meaning this is bad). I'm only doing this
in a little bit of spare time. Pavel doesn't seem to be doing it at all.

And we have different ideas about how things should be done. Userspace
vs kernel space. Providing tuning knobs vs not. And so on.

And the code includes some fundamental differences. I freeze processes
and prepare the whole image before saving anything or doing an atomic
copy whereas you just free memory before doing the atomic copy. You save
everything in one part whereas I save the image in two parts. I take a
modular approach and you have everything hardwired.

Even if we did try to merge the three implementations, there'd come a
point where we either threw away core parts of TuxOnIce or dropped the
whole of [u]swsusp and started again - or both.

It doesn't disappoint me that you don't won't to replace [u]swsusp with
TuxOnIce. I never thought you or Pavel would want to do that.

I did hold out a little hope that you at least might be supportive
anyway of getting TuxOnIce added into vanilla - if only so that users
can get a better hibernation experience while we work through merging
the three into one. I'd far rather get along well with you than have
some sort of competitive relationship.

Regards,

Nigel

