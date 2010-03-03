Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0CCSxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:53:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab0CCSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:53:39 -0500
Date: Wed, 3 Mar 2010 10:52:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
In-Reply-To: <20100303184132.GA11471@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Dmitry Torokhov wrote:

> On Wed, Mar 03, 2010 at 09:03:16AM -0800, Linus Torvalds wrote:
> > 
> > What's the difference between a physical "increase screen brightness" key, 
> > and a "ambient light sensor"? Absolutely none as far as I can tell.
> 
> Because in general ambient light sensor may have nothing to do with the
> screen brightness. The fact that all current uses are tied to
> controlling screen brightness is coincidential. You could use it as well
> to turn on the lights in the kitchen if it is getting too dark...

But my point is, it acts pretty much like a key on a keyboard 
_regardless_. 

Sure, you migth use it to turn up the lights too. But how is that 
different from having a switch to do the same? Again, it doesn't sound 
that different from a key to me. 

> Yes, it is easier, but it is not necessarily the right interface. I
> still believe in using input layer for human iteraction events, and not
> as generic transport a-la netlink or uevent. Voltage measurements,
> network cable presence notifications, ambient light/temperature sensors,
> and so forth do not belong here.

The thing is, if the choice is about a whole new subsystem just for some 
silly light sensor logic, I'd _much_ rather see the much simpler - and 
more useful - approach of just considering it an input event.

It happens in the same kind of situations, it has the same kinds of timing 
issues (ie we're not talking streaming megabytes of data), and it has the 
same kind of users (ie a lightsensor really would be used along with 
something that cares about input).

I agree that that's not true in many other situations. A cable insertion 
event is about the networking, not about some independent input. The kind 
of application that cares about network cable presense is _not_ the kind 
of app that would care about keyboard input. Same goes for voltage.

That said, I'm not married to the whole "it has to be input layer". But I 
_do_ think that it's crazy to start doing new subsystems for every little 
thing. That way lies madness. 

		Linus
