Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYAUWhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYAUWhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYAUWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:37:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59412 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754106AbYAUWho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:37:44 -0500
Date: Mon, 21 Jan 2008 23:37:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-ID: <20080121223756.GA15875@elf.ucw.cz>
References: <1200591411.34145.4.camel@localhost> <20080117111355.29554f38.akpm@linux-foundation.org> <200801172238.17176.rjw@sisk.pl> <20080118083610.GA19792@elte.hu> <20080118004725.dcd132ee.akpm@linux-foundation.org> <20080118121803.GF11044@elte.hu> <20080120233912.GA4844@elf.ucw.cz> <20080120234208.GA22292@elte.hu> <20080121003106.GA1618@elf.ucw.cz> <878x2k53iz.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878x2k53iz.fsf@saeurebad.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > index f7dfff2..e5693d6 100644
> > --- a/kernel/power/Makefile
> > +++ b/kernel/power/Makefile
> > @@ -5,7 +5,7 @@ endif
> >  
> >  obj-y				:= main.o
> >  obj-$(CONFIG_PM_LEGACY)		+= pm.o
> > -obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
> > +obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
> 
> Why compiling it uncoditionally?  What would be wrong with

Its part of my world domination plan ;-).

> > +extern int set_alarm(int length);
> 
> Huh?

Set alarm belongs in drivers/rtc, moved now.

> > +	alarm = now+length;
> > +	rtc_time_to_tm(alarm, &alm.time);
> > +
> > +	retval = cmos_set_alarm(rtc, &alm);
> 
> cmos_set_alarm() takes a struct device * too.

Fixed.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
