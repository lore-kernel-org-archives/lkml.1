Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbYD3R65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbYD3R65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbYD3R6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:58:47 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:23969 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755512AbYD3R6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:58:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=31S5S16h5u1EUN2tDioup1XYNChakG3n3b+1WZa2XL+TJ7HdYyDDMYlF9XUfU4ZXyuDgqnwMeFx7cFm5OxRhtMkH9MA2XKE9+4NKJNfyQKiLyJm67VPvAZi6GxjUZaITpgmt9brMbiy5ZczxpjXCxaW9YUEyt/AcO6Zx4wyKI1I=  ;
X-YMail-OSG: SqijDHYVM1mmyay10Ky1vcjoDOQxFqbggqsOcansJSccBYqwTPIhrDPJGaE_kRiYqmlmV7t_VKBLMA3Xh4oWanu9Iq3PnlycAltatywiPb8mEGUAowAIXrzYnBkSX6_d4UI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Wed, 30 Apr 2008 10:42:42 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804291804.19518.david-b@pacbell.net> <1209521291.311.99.camel@moss.renham>
In-Reply-To: <1209521291.311.99.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301042.42513.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Ben Nizette wrote:
> 
> On Tue, 2008-04-29 at 18:04 -0700, David Brownell wrote:
> > On Tuesday 29 April 2008, Ben Nizette wrote:
> > > I guess one last option (which is made hard by chip label non-uniqueness
> > > but I'll throw out anyway) would be
> > > 
> > > /sys/class/gpio
> > >         /chipa
> > >                 /gpio-n
> > >                         /value
> > >                         /direction
> > >                 /control
> > >         /chipb
> > >                 :
> > >                 :
> > > 
> > 
> > Or maybe:
> > 
> >   /sys/class/gpio
> > 	/gpiochip-X			<-- range X..(X+ngpio)

Make that range X to X + ngpio - 1, of course.  :)

> > 		/device			<-- symlink, if it's known
> > 		/ngpio
> > 		/label
> > 		/start			<-- maybe; start == X
> > 
> > with the gpio-N links probably going where you showed.  That'd be
> > best in terms of Purity Of Essence.
> 
> So you're suggesting that the gpio-N links and control file live inside
> the gpiochip-X folder along with info about the chip to which they're
> attached?  I don't mind this, sounds good.  Certainly feels most
> sysfsish.

What I have working right now is like the original patch,
but with "gpiochipN" (and "gpioN") nodes.  The "*-N" style
doesn't match other sysfs usage.

So the "control" and "gpioN" files aren't nesting like that.

It could be argued which feels more natural.  For external
gpiochips it might feel more natural to nest the gpioN nodes.
On some SOCs, that also true of the integrated GPIOs (docs
refer to "PB29" highlighting port B bit 29).  But on many
others (OMAP and PXA for starters), they're referenced in
docs by a number 0..hundreds, ignoring details like which
register bank holds the relevant control bits.

That's why I decided not to use nesting.  Either choice can
seem a bit odd on some platform; this way is easier and takes
less kernel code.

- Dave
