Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbYBZWcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbYBZWcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbYBZWcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:32:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbYBZWcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:32:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Date: Tue, 26 Feb 2008 23:31:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <20080225225820.GP2659@elf.ucw.cz> <20080226215641.GE10280@elf.ucw.cz> <20080226222337.GA22172@codemonkey.org.uk>
In-Reply-To: <20080226222337.GA22172@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262331.20651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Dave Jones wrote:
> On Tue, Feb 26, 2008 at 10:56:41PM +0100, Pavel Machek wrote:
> 
>  > Seems like pm-utils is just a thin wrapper around s2ram, at least in
>  > version debian ships. It does not seem to have its own whitelist.
> 
> The actual whitelists still live in hal (or specifically hal-data),
> rather than pm-utils.  /usr/share/hal/fdi/information/10freedesktop/20-video-quirk-pm-*
> for example.  This gets passed down to pm-utils by hal.
> 
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

Well, pm-utils seems to be a bunch of shell scripts that run some addtional
utilities, such as vbetool, to actually do the quirks.  In s2ram we have all
these additional utilities put together in one package and you need not
use the whiltelist it contains.  You can just very well make pm-utils use
s2ram for doing the low-level work, just build the appropriate command line
for it on the basis of the HAL whitelist.

Frankly, I don't see any conflict between pm-utils and s2ram at a technical
level.

Thanks,
Rafael
