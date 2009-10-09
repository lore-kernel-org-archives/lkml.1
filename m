Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbZJIUXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbZJIUXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761421AbZJIUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:23:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49422 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761422AbZJIUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:23:34 -0400
Date: Fri, 9 Oct 2009 22:22:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mroth@nessie.de,
       bn@niasdigital.com, eric.miao@marvell.com
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: ads7846 touchscreen: fix pressure
Message-ID: <20091009202250.GA2040@elf.ucw.cz>
References: <20091006195413.GA1469@ucw.cz>
 <5d5443650910072209t63e3fa9dvff7ab2fee7bb2f88@mail.gmail.com>
 <20091008092433.GA26837@elf.ucw.cz>
 <20091009163506.GE1092@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091009163506.GE1092@core.coreip.homeip.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-10-09 09:35:07, Dmitry Torokhov wrote:
> On Thu, Oct 08, 2009 at 11:24:33AM +0200, Pavel Machek wrote:
> > On Thu 2009-10-08 10:39:39, Trilok Soni wrote:
> > > Hi Pavel,
> > > 
> > > On Wed, Oct 7, 2009 at 1:24 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > > >
> > > > On Zaurus, pressure is reported inverted -- the lighter the pressure,
> > > > the bigger numerical value. This should fix it.
> > > >
> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > >
> > > > --- linux-rc/drivers/input.ofic/touchscreen/ads7846.c   2009-10-06 13:49:56.000000000 +0200
> > > > +++ linux-rc/drivers/input/touchscreen/ads7846.c        2009-10-06 21:18:25.000000000 +0200
> > > > @@ -608,12 +609,12 @@
> > > >
> > > >                input_report_abs(input, ABS_X, x);
> > > >                input_report_abs(input, ABS_Y, y);
> > > > -               input_report_abs(input, ABS_PRESSURE, Rt);
> > > > +               input_report_abs(input, ABS_PRESSURE, ts->pressure_max-Rt);
> > > 
> > > but same behavior is seen by others using this chip on different
> > > boards? If not, this has to be done through platform data.
> > 
> > Well, I'd expect the chip to behave in similar way on all
> > platforms. Of course, it would be good if someone with different hw
> > tested it, but I do not have that hw...
> > 
> > So I guess the best way is to make it go in early and see how it does
> > in testing....
> 
> No, this is not how it works. Please do
> 
> 	git log -- drivers/input/touchscreen/ads7846.c
> 
> and try to check with people who were working on this driver. I somehow
> doubt that they'd overlook such obvious issue as inverted pressure
> readings.

Well, it was certainly not obvious to the one who switched zaurus to
ads7846, thus causing regression.

Anyway, people, can you please test ads7846, to see if it has normal
or inverted pressure readings? I could only find 3 people contributing
to ads7846 in last year or so, and Eric was one of them... 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
