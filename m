Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXIDH1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXIDH1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbXIDH1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:27:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45640 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXIDH1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:27:45 -0400
Date: Tue, 4 Sep 2007 09:27:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com> <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl> <1188822917.3406.0.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188822917.3406.0.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2007-09-03 at 12:19 +0200, Rafael J. Wysocki wrote:
> > > Ok, so it gets weirder. I have now machine in "hung" state; other
> > > consoles still work, but there are no timers -  sleep 1 hangs forever.
> > > 
> > > sysrq-t shows kstopmachine hung in hrtimer_try_to_cancel.
> > > 
> > > So I indeed suspect difference-in-kconfig to trigger this, and will
> > > try disabling noidlehz.
> > 
> > I would unset CONFIG_HIGH_RES_TIMERS for starters.
> > 
> > Well, I guess Thomas should know about that. ;-)
> 
> What was the last known to work version ?

I'm afraid I only turned on HIGH_RES_TIMERS in 2.6.23-rc1
timeframe... so I'm not sure if it ever worked for me.

I can confirm it is working in 2.6.23-rc5 with highres disabled, and
broken with highres enabled. NOHZ turns "waits for keypress during
unplug/replug" into "just plain hangs".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
