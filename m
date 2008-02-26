Return-Path: <linux-kernel-owner+w=401wt.eu-S1765806AbYBZWu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765806AbYBZWu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbYBZWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:50:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55942 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbYBZWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:50:48 -0500
Date: Tue, 26 Feb 2008 23:51:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226225114.GH10280@elf.ucw.cz>
References: <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz> <20080226174613.GA26259@codemonkey.org.uk> <20080226175954.GA5707@elf.ucw.cz> <20080226181001.GA7714@codemonkey.org.uk> <20080226181611.GB6030@elf.ucw.cz> <20080226182241.GB7714@codemonkey.org.uk> <20080226215641.GE10280@elf.ucw.cz> <20080226222337.GA22172@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226222337.GA22172@codemonkey.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-26 17:23:37, Dave Jones wrote:
> On Tue, Feb 26, 2008 at 10:56:41PM +0100, Pavel Machek wrote:
> 
>  > Seems like pm-utils is just a thin wrapper around s2ram, at least in
>  > version debian ships. It does not seem to have its own whitelist.
> 
> The actual whitelists still live in hal (or specifically hal-data),
> rather than pm-utils.  /usr/share/hal/fdi/information/10freedesktop/20-video-quirk-pm-*
> for example.  This gets passed down to pm-utils by hal.

Well... you can keep the whitelist where you prefer it -- it may make
sense for support of desktops...

>  > /usr/lib/pm-utils/functions
>  > 
>  > ... 
>  > 
>  >         if [ -x /usr/sbin/s2ram ]; then
>  >                 if [ -n "$S2RAM_OPTS" ]; then
>  >                         # Trust HAL or the user to pass the correct
>  > options
>  >                         /usr/sbin/s2ram $S2RAM_OPTS
>  >                 elif /usr/sbin/s2ram --test > /dev/null ; then
>  >                         # Trust s2ram's internal whitelist
>  >                         /usr/sbin/s2ram
>  >                 else
>  >                         # Unknown machine
>  >                         echo "This machine is unkown, please try to
>  > find out how to suspend this machine. See s2ram(8)."
>  >                 fi
>  >         else
>  >                 echo -n "mem" > /sys/power/state
>  >         fi
> 
> Seems to be a debian specific change, the variant in Fedora, nor upstream
> pm-utils doesn't have any of that.  Possibly because it's a dumb idea
> to have two separate sources of the same information.
> 
>  > ...so it is ready to use s2ram, but will fall back to
>  > echo. Unfortunately, that will mean no video resume on _many_
>  > machines.
>  > 
>  > To give some numbers: according to s2ram whitelist, we can restore
>  > video on 410 machines. On 74 of them, s2ram is not needed. So
>  > approximately 80% of machines need s2ram (at least in configuration
>  > without X running)....
>  > 
>  > Pretty please, can we get s2ram for Fedora, so that video is restored
>  > there?
>  
> I'm not the gatekeeper of what goes into Fedora userspace, but I'm pretty
> certain the path forward has already been decided.  Running a modern
> Fedora desktop installation without hal just isn't feasible.

Unfortunately, your decision means few things:

1) we can't debug it easily: I can no longer tell Andrew to boot into
init=/bin/bash , and run s2ram. For debugging, trying with minimal
system is very important.

2) you use bunch of shellscripts. If your SATA does not wake up, you
get no video, and probably no chance to pull debug info out of that
box. s2ram is pagelocked for that reason.

...plus, you could easily keep your whitelist in HAL and just call
s2ram, unless user is running it manually.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
