Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbXK1Shl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbXK1Shl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXK1ShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:37:24 -0500
Received: from alephnull.demon.nl ([83.160.184.112]:32897 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbXK1ShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:37:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=dmLe/QiF9SJYopygfZK5LUD1icTgIq20PNZ4i9PBeeL0Sn1c5ROTQN+GlxkBG
	zivaN5/PPDh2i1eRA1mk7C78g==
Date: Wed, 28 Nov 2007 19:37:20 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Adrian Bunk <bunk@kernel.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128183720.GB697@xi.wantstofly.org>
References: <20071024162528.GX30533@stusta.de> <20071024164347.GN4003@csclub.uwaterloo.ca> <20071128112357.3828d469@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128112357.3828d469@hyperion.delvare>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 11:23:57AM +0100, Jean Delvare wrote:

> > > 6a8e0e37019c0ffeb0071fae30210baf2c3bdd75 
> > > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > > index 2af3835..9114379 100644
> > > --- a/Documentation/feature-removal-schedule.txt
> > > +++ b/Documentation/feature-removal-schedule.txt
> > > @@ -218,14 +218,6 @@ Who:	Len Brown <len.brown@intel.com>
> > >  
> > >  ---------------------------
> > >  
> > > -What:	i2c-ixp2000, i2c-ixp4xx and scx200_i2c drivers
> > > -When:	September 2007
> > > -Why:	Obsolete. The new i2c-gpio driver replaces all hardware-specific
> > > -	I2C-over-GPIO drivers.
> > > -Who:	Jean Delvare <khali@linux-fr.org>
> > > -
> > > ----------------------------
> > 
> > Did anyone ever write a driver that does i2c on the scx200 using the new
> > i2c-gpio method?  I sure haven't seen it, although I am still running
> > 2.6.18 (since that is what debian stable uses) on my scx200 systems.  I
> > certainly haven't found any useful instructions on how to use the new
> > i2c-gpio driver on an scx200.
> 
> There's no driver to write (i2c-gpio is the driver). Instead, the
> scx200 platform needs to implement the standard GPIO API. I don't think
> that it has happened yet, and last time this was discussed, someone
> (can't remember who, sorry), complained that the GPIO API "sucked" and
> that the scx200 platform would not be updated to use it. I didn't buy
> the claim due to a lack of argumentation and the fact that the GPIO
> infrastructure seems to work well enough for many other platforms.

I expressed some concerns about the GPIO API some time ago, but
that was in the context of ep93xx.


> As far as I can see, the ixp2000 platform also doesn't implement the
> standard GPIO API yet, so of the 3 drivers that are about to be
> removed, only i2c-ixp4xx can be removed without functionality loss at
> the moment. Lennert, Russell, are there any plans to convert the
> ixp2000 platform to use the generic GPIO layer?

No plans at this point from my side.

I'm not entirely sold on the GPIO API, but nevertheless I expect
that ixp2000 will be converted sooner rather than later.

If you don't want people to use i2c-ixp2000 as an example for new
code, maybe you can stick in a comment at the top of the file that
says that what i2c-ixp2000 does isn't the Preferred(TM) way of doing
it?


> Maybe I shouldn't have added this entry in feature-removal-schedule.txt
> in the first place: these drivers should ideally be dropped in favor of
> i2c-gpio, but it can only happen for platforms that implement the
> standard GPIO API. As I am not the one who will convert these
> platforms, and some of them might as well never be converted (I don't
> know how active they are nowadays), there's not much I can do.

Sorry, I seem to have missed the addition of i2c-ixp2000 to
feature-removal-schedule.txt.  I would have spoken up earlier if I
had been aware of it being in there.

It seems odd to me to advocate removal of something which works fine
and for which no functional replacement is available just because it
doesn't conform to the Latest And Greatest API(TM).  That's like
suggesting that Jan 1st 2009 we should rm -f all .c files that still
reference the big kernel lock, or rm -f all ARM ports that don't
use the clocksource/clockevent mechanism yet (which includes
ixp2000 as well.)

Let's just remove i2c-ixp2000 when the GPIO API conversion happens, ok?
