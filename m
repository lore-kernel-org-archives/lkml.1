Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919Ab0APWZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0APWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587Ab0APWZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:25:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab0APWZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:25:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sat, 16 Jan 2010 23:26:09 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Stanislav Brabec <utx@penguin.cz>, Eric Miao <eric.y.miao@gmail.com>,
       "Bart?omiej Zimo?" <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001162305.56972.rjw@sisk.pl> <20100116221929.GB8425@elf.ucw.cz>
In-Reply-To: <20100116221929.GB8425@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001162326.09092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 January 2010, Pavel Machek wrote:
> On Sat 2010-01-16 23:05:56, Rafael J. Wysocki wrote:
> > On Saturday 16 January 2010, Pavel Machek wrote:
> > > On Sat 2010-01-16 18:00:58, Stanislav Brabec wrote:
> > > > Eric Miao wrote:
> > > > 
> > > > > And the other way we may need to look into what API the current userland
> > > > > apps on zaurus is depending on this 2.4 compatibility and make changes
> > > > > slowly to those apps.
> > > > 
> > > > I guess that 2.4 compatibility is not an issue. Most modern Zaurus
> > > > distributions are even unable to run Sharp ROM compatible binaries.
> > > > 
> > > > Distributions either stay on 2.4 kernel or use modern systems based on
> > > > modern kernel 2.6 API.
> > > > 
> > > > Distributions that decided to migrate to kernel 2.6 are far from
> > > > finished state. Any change that allows to use modern applications using
> > > > standard kernel API is welcome.
> > > 
> > > There is no API involved. It is just ... if you leave zaurus in
> > >  init=/bin/bash mode, it must not kill the battery. Smart and
> > >  currently implemented way to do that is to suspend.
> > 
> > IMHO it should just plain shutdown in that case.  Suspending doesn't really
> > solve the problem, because the battery is going to drain still.  Unless you
> > mean suspend=hibernate, but I guess you don't.
> 
> As I explained before, power consumption on suspend and hibernate and
> poweroff is equivalent on zaurus (7mA in all the cases -- sorry if I
> said uA before). And because it has 1800mAh battery, it means that
> even empty battery is going to last for a while. In practice, it works
> very well.
> 
> (There are other reasons, having to do with internal li-ion resistances
> in aged and cold batteries.)
> 
> > > That's counterexample to rjw, but it does not matter -- reasonable
> > > userland should never ever hit that, in a same way PCs should not hit
> > > emergency power cut...
> > 
> > I don't really understand what you mean.  The user space doesn't know the
> > battery state if the kernel doesn't tell it, AFAICS, so how exactly can it
> > predict the critical battery condition without the kernel notifying it?
> 
> That was not the point I was trying to discuss. Yes, we need
> kernel<->user notification of battery critical. 
> 
> But on zaurus, correct action is to suspend (not hibernate and not
> poweroff) when battery is no longer able to supply enough power to
> keep system alive.

Why not to poweroff (just asking, I don't know that hardware)?

I guess we should at least do our best to keep filesystems in a consistent
state and suspend doesn't really guarantee this if the system remains on
battery power afterwards.

Rafael
