Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYBBMrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYBBMrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 07:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYBBMrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 07:47:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47281 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753597AbYBBMrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 07:47:41 -0500
Date: Sat, 2 Feb 2008 13:47:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202124759.GB25773@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <200801311755.33899.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801311755.33899.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > --- a/drivers/rtc/rtc-cmos.c
> > +++ b/drivers/rtc/rtc-cmos.c
> > @@ -78,7 +78,7 @@ static inline int is_intr(u8 rtc_intr)
> >  
> >  /*----------------------------------------------------------------*/
> >  
> > -static int cmos_read_time(struct device *dev, struct rtc_time *t)
> > +int cmos_read_time(struct device *dev, struct rtc_time *t)
> >  {
> >
> >	... etc ...
> 
> You should be using the standard RTC library calls, exported
> from drivers/rtc/interface.c ... and making sure this mechanism
> will work with any wakeup-capable RTC.  Otherwise you'll end
> being needlessly x86-specific, or reinventing those calls.
> 
> Plus, the way you're doing it now is violating the locking
> protocol used by that driver.

Yep, you are right, but that is the easy issue to fix. There's hard
issue: I need 

struct rtc_device *rtc

for the rtc that can be used for system resume, and I'd like to get it
without violating too many layers. How to do that?

Ideally, I need 

set_alarm(int)

...that will magically pick the right rtc device to talk to, and set
alarm on it. I don't see how to implement it with current code.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
