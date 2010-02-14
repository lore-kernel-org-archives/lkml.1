Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0BNS2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:28:00 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53656 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0BNS17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:27:59 -0500
Date: Sun, 14 Feb 2010 19:27:58 +0100
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100214182758.GA31849@rhlx01.hs-esslingen.de>
References: <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain> <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain> <20100208205105.GA16990@rhlx01.hs-esslingen.de> <20100208210219.GA22039@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002091034500.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002091034500.2811@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 09, 2010 at 11:02:02AM +0100, Thomas Gleixner wrote:
> On Mon, 8 Feb 2010, Andreas Mohr wrote:
> 
> > On Mon, Feb 08, 2010 at 09:51:05PM +0100, Andreas Mohr wrote:
> > > Looks like it:
> > > - another bootup also had lockup message
> > > - all /var/log/dmesg* have lockup message, oldest is:
> > > 2010-02-07 20:00 dmesg.4.gz
> > > 
> > > Linux version 2.6.33-rc6 (root@note) (gcc version 4.3.4 (Debian 4.3.4-6)) #3 Sun Jan 31 23:47:51 CET 2010
> > 
> > -rc4 and 2.6.32.3 don't show lockup message, instant bootup without any
> > visible delay.
> 
> Just verified, that there is no timekeeping related patch after
> 2.6.33-rc4 except the kgdb lockup prevention patch, which is
> not touching any code which is relevant  at boot time.
> 
> So bisecting between rc4 and now is probably the best thing to do.

Frankly I'm now through so many different attempts
(cold-boot test, 4.3 compile, switch both lines to -O0 in Makefile,
use unmodified .config, restart with cleanly extracted tree,
revert several low-level compiler libraries, check for other
relevant package upgrades - it's not a LILO upgrade or
parameter problem either -, ...) without any improvement
that I'm about to give up (remember: 1+ hours per rebuild).
I simply don't have any idea what else could have broken it.
The only thing remaining is either some low-level compiler support library
that I didn't downgrade or actual hardware damage.

The one thing that might be the cause for my reboot-on-boot issues
is http://marc.info/?l=linux-kernel&m=126611098225127&w=2
(blank boot on Dell machines due to video mode issues - maybe this
increases chances of a reboot on other Dells such as mine).
Will do some verification via vga=ask or so.

At the moment I'm very tempted to simple deafly ignore the issue
until some or another enlightenment comes my way or future upgrades
of gcc/kernel happen to fix it.

Note that after reinstalling old custom kernel packages it does boot properly
(all recent build tests done using -rc4, and with old package reinstalled
-rc4 then did boot).


The lockup warning by NMI watchdog does seem to be more persistent
than my recent reboot issue, however,
but I might have easily missed that in earlier kernel packages.
----> we're dearly missing a suitable user-space kernel warning
notification layer that goes all the way to the desktop.
There's a netlink userspace thingy or so but it's just not
well-established.

Andreas Mohr
