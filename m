Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZLNMMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZLNMMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZLNMMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:12:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37106 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757080AbZLNMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:12:50 -0500
Date: Mon, 14 Dec 2009 12:12:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091214121247.GB22388@rakim.wolfsonmicro.main>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
 <20091207165628.GA24981@rakim.wolfsonmicro.main>
 <20091213132413.GB1437@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091213132413.GB1437@ucw.cz>
X-Cookie: The worst is enemy of the bad.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 02:24:14PM +0100, Pavel Machek wrote:

> > actual charger hardware.  My main concern here is that battery
> > performance monitoring has no pressing need to be in kernel and that
> > pushing it into the kernel creates a barrier to implementing more
> > advanced schemes in userspace, which is especially serious given how
> > involved this needs to be in order to be accurate.  

> Well, kernel provides /proc/apm emulation and many systems still rely
> on it. So it would be nice to provide something halfway-decent there.

Unfortunately that's really painful in kernel since you really need to
do state tracking over reboots, and even if you do that it's really
not trivial.

> Plus you need to shutdown/suspend machine on battery critical. That
> has to be in kernel and already needs those tricky parts.

Power failure detection based on voltage drop is much more reasonable
but it's a very different thing to general battery capacity estimation.

Normally you'd want to do the power failure detection separately anyway,
monitoring the system supply voltage rather than the battery voltage.
Supply failure is not only an issue in battery operation, it's also an
issue for example in systems systems powered over USB which may be
drawing more than the 500mA that USB delivers and need to supplement the
USB supply with the battery.

> > I'm not sure how familiar you are with the issues surrounding trying to
> > do a voltage to charge mapping for a battery but it's much more complex
> > than a simple table if you want to get it accurate.  There's a lot
> > of

> Well... current zaurus kernels use _huge_ table that maps voltage to
> battery %... and that table is linear function :-(.

> Do you have some papers on that?

Something like "Measure Battery Capacity Precisely in Medical Design"
by Bernd Krafthoefer in Power Electronics Technology Jan 2005 might be
useful here.
