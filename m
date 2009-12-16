Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbZLPWxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbZLPWxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762891AbZLPWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:53:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52942 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZLPWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:53:39 -0500
Date: Wed, 16 Dec 2009 23:53:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091216225328.GG21102@elf.ucw.cz>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
 <20091207165628.GA24981@rakim.wolfsonmicro.main>
 <20091213132413.GB1437@ucw.cz>
 <20091214121247.GB22388@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214121247.GB22388@rakim.wolfsonmicro.main>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 12:12:47, Mark Brown wrote:
> On Sun, Dec 13, 2009 at 02:24:14PM +0100, Pavel Machek wrote:
> 
> > > actual charger hardware.  My main concern here is that battery
> > > performance monitoring has no pressing need to be in kernel and that
> > > pushing it into the kernel creates a barrier to implementing more
> > > advanced schemes in userspace, which is especially serious given how
> > > involved this needs to be in order to be accurate.  
> 
> > Well, kernel provides /proc/apm emulation and many systems still rely
> > on it. So it would be nice to provide something halfway-decent there.
> 
> Unfortunately that's really painful in kernel since you really need to
> do state tracking over reboots, and even if you do that it's really
> not trivial.

No, I do not want to get _that_ advanced. But I'd really like to get
beyond "battery %age is linear function of measured battery voltage".

> > Plus you need to shutdown/suspend machine on battery critical. That
> > has to be in kernel and already needs those tricky parts.
> 
> Power failure detection based on voltage drop is much more reasonable
> but it's a very different thing to general battery capacity
> estimation.

Not sure...

> Normally you'd want to do the power failure detection separately anyway,
> monitoring the system supply voltage rather than the battery voltage.

Well, that way you'll discharge batteries too much and kill them
rather quickly, no? What is "system supply voltage" for PDA class
system, anyway? I don't think zaurus has ADCs on anything else than
thermistor, AC in voltage, battery voltage...

> Something like "Measure Battery Capacity Precisely in Medical Design"
> by Bernd Krafthoefer in Power Electronics Technology Jan 2005 might be
> useful here.

Thanks, it looks interesting. I'm not sure if it will be possible to
apply on zaurus, but... (While measuring voltage my underestimate the
old battery, I'm afraid they may overestimate it in bad conditions;
energy left is battery is useless if battery can't supply enough
current to keep CPU happy, because its too cold).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
