Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXCRRZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXCRRZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXCRRZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:25:07 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:52684 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXCRRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:25:04 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2007 13:25:04 EDT
Subject: Re: [linux-pm] [2/6] 2.6.21-rc2: known regressions
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Ash Milsted <thatistosayiseenem@gawab.com>,
       dmitry.torokhov@gmail.com, Arkadiusz Miskiewicz <arekm@maven.pl>,
       linux-pm@lists.osdl.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       linux-usb-devel@lists.sourceforge.net,
       Jeff Chua <jeff.chua.linux@gmail.com>, Meelis Roos <mroos@linux.ee>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas.mey@web.de>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070318160707.GC12673@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il>
	 <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
	 <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu>
	 <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
	 <20070309111957.GA3928@elf.ucw.cz>  <20070318160707.GC12673@elte.hu>
Content-Type: text/plain
Organization: OLPC
Date: Sun, 18 Mar 2007 12:40:45 -0400
Message-Id: <1174236045.6832.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 17:07 +0100, Ingo Molnar wrote:
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > Some day we may have modesetting support in the kernel for some 
> > > graphics hw, right now it's pretty damn spotty.
> > 
> > Yep, that's the way to go.
> 
> hey, i wildly supported this approach ever since 1996, when GGI came up
> :-/
> 

So wildly you wrote tons of code.... ;-).

More seriously, at the time, XFree86 would have spat in your face for
any such thing.  Thankfully, times are changing.

Also more seriously, a somewhat hybrid approach is in order for mode
setting: simple mode setting isn't much code and is required for sane
behavior on crash (it is nice to get oopses onto a screen); but the full
blown mode setting/configuration problem is so large that on some
hardware, it is likely left best left to a helper process (not the X
server).

Also key to get sane behavior out of the scheduler is to get the X
server to yield (sleep in the kernel) rather than busy waiting when the
GPU is busy; a standardized interface for this for both fbdev and dri is
in order.  Right now, X is a misbehaving compute bound process rather
than the properly interactive process it can/should/will be, releasing
the CPU whenever the hardware is busy. Needless to say, this wastes
cycles and hurts interactivity with just about any scheduler you can
devise. It isn't as if this is hard; on UNIX systems we did it in 1984
or thereabouts.

Of course, in 1996, XFree86 would have ignored any such interfaces, in
its insane quest for operating system independent user space drivers
requiring no standard kernel interfaces.... (it is the second part of
this where the true insanity lay).
                                  - Jim

-- 
Jim Gettys
One Laptop Per Child


