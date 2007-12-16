Return-Path: <linux-kernel-owner+w=401wt.eu-S933197AbXLPLZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbXLPLZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764502AbXLPLZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:25:30 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:44543 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXLPLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:25:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sun, 16 Dec 2007 12:23:00 +0100
User-Agent: KMail/1.9.6
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, stefano.brivio@polimi.it,
       Ray Lee <ray-lk@madrabbit.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       kjwinchester@gmail.com, jonathan@jonmasters.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <20071215214300.GC3096@tuxdriver.com> <20071216092243.GB27280@elte.hu>
In-Reply-To: <20071216092243.GB27280@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161223.01374.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 December 2007 10:22:43 Ingo Molnar wrote:
> 
> * John W. Linville <linville@tuxdriver.com> wrote:
> 
> > > It's not that simple.  For example, regression testing will be a 
> > > major PITA if one needs to switch back and forth from the new driver 
> > > to the old one in the process.
> > 
> > Not really true -- a single system can easily have firmware installed 
> > for b43, b43legacy, and bcm43xx at the same time and switch back and 
> > forth between them.
> 
> as long as the version 4 firmware blob is present in the system, will 
> testers have a fully fluid test- and work-flow when migrating across 
> from bcm43xx to b43, without any other changes to an existing Linux 
> installation? (i.e. no udev tweaks, no forced upgrades of components, 
> etc.)
> 
> Will it Just Work in bisection as well, when a tester's kernel 
> flip/flops between bcm43xx and b43 - like it does for the other 3000+ 
> drivers in the kernel?
> 
> Note that we are _NOT_ interested in "might" or "can" scenarios. We are 
> interested in preserving the _existing_ bcm43xx installed base and how 
> much of a seemless migration the b43 transition will be. _THAT_ is what 
> the "no regressions" upstream rule is about, not the "ideal distro" 
> scenario you outline above. It is YOUR total obligation as a kernel 
> maintainer to ensure that you dont break old installations. How hard is 
> that to understand? This is not rocket science.

I see no reason for b43 to break, if the firmware is properly installed.
In fact, almost all installation related bugreports we receive are
caused by missing or incorrectly installed firmware.
I would really _like_ to make installing firmware easier or make the
whole need for it vanish, but I simply can not at this point.
But anyway, installing it is not rocket science, either. The only thing
you have to know is where your distribution stores the firmware image files.
If you know that it's a matter of invoking one b43-fwcutter command
to install it. This process can be automated in the distribution's rpm
or deb package scripts.

b43lagacy/ssb is completely featured with module autoload support.
So if you have firmware installed it will automatically load all required
modules and create the network device(s) for it without any user interaction.

If that doesn't work, then stupid distributions are shipping braindamaged
udev scripts that pin a mac address to a specific driver name (see another
mail in this thread). I can _not_ fix this from within the kernel and
I will absolutely shift all responsibility and blame for this to the
maintainers of the distribution's udev scripts.
That's not a b43 specific problem then. Other drivers do break with these
scripts, too.

-- 
Greetings Michael.
