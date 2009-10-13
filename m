Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbZJMWoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbZJMWoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbZJMWoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:44:02 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:40164 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761362AbZJMWoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=LdiVjmBOQpoJi5w3OSix8mo6p6n6Dh4BGS4YLD6U2fe3L+AiDOJYHLcMTTICG6GqUx
         6HAgZ/H2ApnFy13sKtgdrxL5rSbJLUcvzeLraxkeDFw3u6OAavPI2WsgU8cJxLR1PJ3i
         Q/Lxxl1oHEVrLG+3MZkVRT+znjjscW9NJ3uxU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Wed, 14 Oct 2009 00:42:39 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910132357.57094.bzolnier@gmail.com> <1255472698.11695.75.camel@localhost.localdomain>
In-Reply-To: <1255472698.11695.75.camel@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200910140042.39800.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 00:24:58 Dan Williams wrote:
> On Tue, 2009-10-13 at 23:57 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 13 October 2009 22:15:40 Dan Williams wrote:
> > > On Tue, 2009-10-13 at 21:21 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Tuesday 13 October 2009 20:17:47 Ivo van Doorn wrote:
> > > > > On Tuesday 13 October 2009, Bartlomiej Zolnierkiewicz wrote:
> > > > > > On Tuesday 13 October 2009 17:52:52 Ivo van Doorn wrote:
> > > > > > 
> > > > > > > I am going to merge rt2800pci soon as well and after that I'll send a patch
> > > > > > 
> > > > > > Great, I've been waiting for this for a long time.
> > > > > > 
> > > > > > > to remove all Ralink drivers from the staging tree.
> > > > > > 
> > > > > > Till new drivers obtain support for all hardware currently covered by
> > > > > > the unified staging drivers the latter shouldn't be removed as they
> > > > > > serve well their role as a temporary solution allowing real Linux users
> > > > > > to user their real hardware and as a reference material for developers
> > > > > > willing to work on adding the missing bits to new drivers.
> > > > > 
> > > > > The rt2800pci and rt2800usb drivers cover support for rt2860/rt2870/rt3070 devices,
> > > > > which are present as individual drivers in the staging tree. So far it only managed
> > > > 
> > > > There are no longer individual drivers.
> > > > 
> > > > Instead there is one shared source code and two device drivers:
> > > > 
> > > > - rt2860 covering RT2860 and RT3090 devices
> > > > 
> > > > - rt2870 covering RT2870 and RT3070 devices
> > > > 
> > > > In comparison rt2800usb currently lacks RT3070 support and rt2800pci's
> > > > RT3090 support is basic at best (not to mention that it didn't work for
> > > > RT2860 last time that I tried)..
> > > > 
> > > > > to confuse developers which wanted to work on Ralink support, so I haven't found
> > > > 
> > > > I bet they are truly grateful for being shown "the one and only way"..
> > > 
> > > There *is* only one way: mac80211.  If the driver is softmac, but does
> > > not use mac82011, then it *is* the wrong way.  We will not have multiple
> > > 802.11 stacks in the mainstream kernel.  If a softmac driver uses
> > > mac80211, hey, that's great!  Lets add it!
> > 
> > Nobody never ever suggested merging Ralink drivers as they are into
> > kernel proper.
> > 
> > > If it doesn't, then that driver needs to be updated to use mac80211.
> > > Period.
> > > 
> > > > > a benefit for having those drivers in the staging tree yet. But I am sure there are plenty
> > > > 
> > > > I was able to use my Eee 901 successfully with them for a last year and I'm
> > > > pretty sure that I'm not the only.  I understand my sin now -- I should have
> > > > had help in fixing the proper and clean code before using my hardware.. [*]
> > > 
> > > That's nice, and everyone appreciates the work that you've done.  Nobody
> > > can tell you what to work on, but it would be nice to get more people
> > > working on the *mac80211* versions of the various drivers.  Imagine how
> > > much better rt2x00 would be if all the effort that had gone into cleanup
> > > up the ralink vendor drivers had instead gone into making rt2x00 work on
> > > the new hardware.  Then you'd have cfg80211 support, background
> > > scanning, etc all for free with no effort on your part.
> > 
> > No effort, right.  Debugging things is the hardest part of any project..
> > 
> > > Maybe it would have taken 6 months longer to get good support for your
> > > hardware but at least the work would have a future.  But now we're stuck
> > 
> > You miss one tiny and irrelevant detail.  Until the work is finished
> > I cannot use the hardware and real testers/users are using the vendor
> > driver anyway for the simple fact that it exists and works.
> > 
> > > in a situation where either:
> > > 
> > > 1) the vendor driver never gets converted to cfg80211/mac80211, and
> > > stays in staging forever, or finally gets booted out of staging because
> > > nobody is working on converting it to mac80211.  mac80211/cfg80211 is a
> > > hard requirement for being an accepted wireless driver.  And drivers do
> > > have a shelf-life in staging.
> > > 
> > > 2) the vendor driver starts getting converted to use mac80211.  But I
> > > would argue that a better use of *anyone's* time is to make rt2x00
> > > better, instead of porting the ralink vendor drivers to mac80211.  It
> > > would probably take less time to fix up rt2x00 for new hardware than to
> > > port the ralink vendor drivers to mac80211.
> > 
> > Nobody is saying anything about porting the vendor drivers to mac80211.
> > 
> > 3) After the vendor driver gets cleaned up to the point that people are
> > able to make any sense out of it the missing bits will get added to rt2x00.
> > Several months later (after all current users are happy with the improved
> > drivers) the old drivers will be removed from staging..
> > 
> > > > > of people who like the idea of having the original Ralink drivers inside the staging tree,
> > > > > so they can continue debugging that, so I won't talk about the staging downsides further.
> > > > 
> > > > Well, it would be much more productive if people concentrate on improving
> > > > _their_ projects and looking at downsides of _their_ code instead of going
> > > > around and looking at _obvious_ downsides of other people's projects.
> > > > 
> > > > 
> > > > [*] [Slightly off-topic but it shows the same problem with the approach]
> > > > 
> > > > I now also see why some distributions keep pushing some known non-working
> > > > things on their users (Fedora maintainers -- I'm talking to you), the best
> > > > example is PulseAudio -- it simply doesn't work reliably even on modern
> > > > hardware and/or using all scheduler tricks (it seems that making Linux into
> > > > full RT OS is a prerequisite for fixing latency issues observed)..
> > > 
> > > Pulseaudio works for many, many people.  The most productive use of your
> > 
> > Yeah, I trust you on both points..
> > 
> > > time here is to file a bug report with the specific details of your
> > > audio chipset, let upstream diagnose whether it's a Pulseaudio-specific
> > > problem, a codec driver problem, or an ALSA problem.
> > 
> > Right..
> > 
> > I see no point BTW -- time make proper bug-report is much bigger than
> > throwing in few local hacks and since my experience with upstream so far
> > was that my bug-reports end up in some black-hole I deal with issues in
> > the most pragmatic and productive for everybody way..
> > 
> > > You can wait until the cows come home to deploy new technology, and then
> > > of course you'll still have to fix up all the bugs because you waited
> > > too long and nobody was testing it, or you can deploy new technology
> > > that works for most people and fix those bugs much earlier.  Release
> > > early, release often.  The tricky thing is how early.
> > 
> > It was new technology in F8 days..  It was included in F9 (released on
> > 13th May 2008) and the current rawhide is still broken (no chance it will
> > get fixed for F12)..  Getting stereo sound to play skip-lessly on standard
> > AC97 or HDA cards on a freshly installed system is impossible..
> 
> Really?  That's not my experience with F11 or F12 on any of 5 different
> laptops from 5 different vendors.  HP 2530p, Thinkpad T42, Dell D410,
> Fujitsu Lifebook P7230, Apple iBook G3/800.  Sound just works, and I can
> switch between USB speakers, internal, headphone jack without manually
> screwing around with module parameters for the alsa default device and
> reloading them just to redirect sound where I want it to go.  I can
> listen to Pandora via flash all day and that doesn't skip (except when
> the 3G dies, of course).
> 
> The point here is, often stuff works for some and not for others.  That
> doesn't mean it's "broken".  It's broken for you, and that should get
> fixed, but the whole system is by no means a loss and its pretty stupid
> to generalize things like "play skip-lessly on standard AC97/HDA cards
> is impossible" when it clearly isn't.

Interesting, do you mean that you are able to get skipless mp3 playback
under i.e. audacious (using the default pulseaudio output plugin) under
heavy load (i.e. kernel build) with internal speakers (or headphones)?

If so must by my luck then -- F11 on old Acer laptop (Intel 8x0 in ICH4M)
and fedora-rawhide on new Asus K50AB one (Intel HDA in AMD/ATI SB710)..
