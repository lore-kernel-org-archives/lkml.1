Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0CDJXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:23:10 -0500
Received: from poutre.nerim.net ([62.4.16.124]:62780 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab0CDJXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:23:05 -0500
Date: Thu, 4 Mar 2010 10:22:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100304102258.75d2f356@hyperion.delvare>
In-Reply-To: <404ea8001003031508p32641b2bj8781ce2b88e1f9cb@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	<404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	<alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	<20100303184132.GA11471@core.coreip.homeip.net>
	<alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	<20100303190753.GB11471@core.coreip.homeip.net>
	<4B8EB99F.4080104@jic23.retrosnub.co.uk>
	<20100303230229.77df3ac3@hyperion.delvare>
	<404ea8001003031508p32641b2bj8781ce2b88e1f9cb@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 15:08:29 -0800, Dima Zavin wrote:
> > Honestly, I don't care. The light sensor drivers can live wherever you
> > want and use whatever interface you want, I don't give a damn. What I
> > really want is that:
> > 1* All light sensor drivers live at the same place in the kernel tree,
> >   so that people looking for them know where to look.
> > 2* drivers/i2c/chips dies. Meaning that, if the tsl2550 driver has not
> >   moved away from drivers/i2c/chips by rc1, I'll move it myself, manu
> >   militari, to drivers/misc.
> 
> Please do kill i2c/chips. I've tried to follow suite with your
> campaign and have been pushing vendors on my end to not dump their
> drivers in there. However, wanting to clean up the directory structure
> is not a good reason to create a new interface to userspace. And
> furthermore, the proposed directory structure changes are not really
> that scalable imho (e.g. drivers/sensors/als would make a lot more
> sense to me than to pollute the top level drivers/...).

I don't disagree.

> As it came up earlier in the thread, adding an ABS_AMBIENT_LIGHT_LEVEL
> or equivalent is much simpler and provides a clean, concise, and
> useful interface to userspace.
> 
> Note that for many applications, you actually get configurable
> threshold levels, and the hardware triggers an interrupt when the
> light level crosses those thresholds. This makes using an input device
> very useful, and that is in fact how we use ALS devices today. I have
> several pieces of hardware that do this, and I don't see how this new
> als subsystem helps me handle that problem. With the suggested API,
> I'll have to poll the sysfs files manually to see if they've changed
> (which is suboptimal), or still add a non-standard input device to do
> what I want.

The light sensor I have (TSL2550) is stupid and doesn't offer anything
other than slow polling. Not thresholds, no interrupts, nothing. This
is where the sysfs interface originates from. The very point of
grouping light sensor drivers together is to get a better view of what
the devices offer, and from there, of what interfaces make sense.

> > I am a little sad to see two discussions about the ALS subsystem right
> > in the middle of the merge window, one about what the interface should
> > be and one about what the subsystem should include, while discussions
> > about these two points have been ongoing publicly for 5 months now. I
> > really want things (whatever they are) happen now and not in another 5
> > months.
> 
> I'm sorry I missed the previous discussion, so please accept my
> apologies. I was very busy with work at that time, I'm sure you know
> how that goes.

Sure I know.

-- 
Jean Delvare
