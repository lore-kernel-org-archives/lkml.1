Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXBKWhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXBKWhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbXBKWhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:37:36 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:33251 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbXBKWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:37:35 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Tilman Schmidt <tilman@imap.cc>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45CE5934.3020801@imap.cc>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz>  <200702102320.39531.rjw@sisk.pl>
	 <1171147026.19894.16.camel@nigel.suspend2.net>  <45CE5934.3020801@imap.cc>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 09:37:34 +1100
Message-Id: <1171233454.4493.74.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-02-11 at 00:45 +0100, Tilman Schmidt wrote:
> Am 10.02.2007 23:37 schrieb Nigel Cunningham:
> > If your device requires power management, and you know it requires power
> > management, why not just implement power management? Doing -ENOSYS
> > instead is like saying -ESPAMMEBECAUSEIMLAZY.
> 
> Like it or not, power management is far from trivial, and people
> writing device drivers have limited resources. Calling them lazy
> does not help that in the least. If you try to put pressure on them
> by refusing to merge their work as long as it doesn't provide this
> or that functionality, you *may* end up with a few drivers having
> that functionality which otherwise wouldn't, but you *will* also
> end up with a number of drivers never making it into the kernel
> because their authors just have to give up.

It's not that complex. All we're really talking about is a bit of extra
code to cleanup and configure hardware state; things that the driver
author already knows how to do. S3 might require a bit more
initialisation if firmware needs to be reloaded or more extensive
configuration needs to be done, but if there's firmware to be loaded,
there is a reasonably good probability that we loaded it from Linux to
start with anyway.

> Also, in your argument you neglected a few cases:
> - What if my device does not require power management?

Then you as a generic routine that does nothing but return success
(potentially shared with other drivers that are in the same situation).

> - What if I don't know whether my device requires power management?

The questions are straight forward: Is there hardware state that needs
to be configured if you've just booted the computer and nothing else has
touched it? If so, that needs to be done in a resume method. Do you need
to clean up state prior to doing the things in the resume method, or
otherwise do things to quiesce the driver? If so, they will need to be
done in the suspend method. The result will be roughly similar to what
you do for module load/unload, except maybe less complete in some cases.

> - What if I know my device would require power management, but don't
>   know how to implement it?

I've just told you above :) Now you know!

> > Let me put it another way: People keep talking about Linux being ready
> > for the desktop. To me at least (but I dare say for lots of other people
> > too), being ready for the desktop means that things just work, without
> > having to recompile kernels or bug driver authors or wait twelve
> > months. 
> 
> Exactly.
> 
> > And it means that doing a bare minimum isn't enough. We keep claiming
> > that Open Source is better than Proprietary software. If we accept
> > half-pie jobs of implementing support for anything - driver power
> > management support or hibernation support or whatever - as 'good
> > enough', we're undercutting that argument. Linux's power management
> > support should - as far as we're able - be at least as good as that
> > other operating system's and preferably way, way better.
> > 
> > -ENOSYS is just not acceptable.
> 
> Your argument falls down the moment you consider the alternative:
> not merging the driver means that the device won't work at all.
> (Given that out-of-tree drivers are actively discouraged, to put
> it mildly.) That's arguably farther from "desktop readiness" than
> a device not supporting power management.

I disagree (but I would, of course!). If we apply your logic
consistently, we should merge the driver as soon as any code is written
for it (anything is better than nothing). I'm simply arguing that a
driver that handling suspend and resume should be as much of a
requirement as not causing memory corruption or such like are.

Regards,

Nigel

