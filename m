Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXBJWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXBJWhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXBJWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:37:10 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:46513 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXBJWhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:37:09 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200702102320.39531.rjw@sisk.pl>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz>  <200702102320.39531.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 11 Feb 2007 09:37:06 +1100
Message-Id: <1171147026.19894.16.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-02-10 at 23:20 +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> On Saturday, 10 February 2007 20:38, Pavel Machek wrote:
> > Hi!
> > 
> > > > I don't think this is already done (feel free to correct me if I'm
> > > > wrong)..
> > > > 
> > > > Can we start to NAK new drivers that don't have proper power management
> > > > implemented? There really is no excuse for writing a new driver and not
> > > > putting .suspend and .resume methods in anymore, is there?
> > > 
> > > to a large degree, a device driver that doesn't suspend is better than
> > > no device driver at all, right?
> > > now.. if you want to make the core warn about it, that's very fair
> > 
> > Well, driver that is broken on SMP is arguably better than no driver
> > at all, yet we'd probably avoid merging that. It would be nice to
> > start including suspend in 'must work' list...
> 
> What about this:
> 
> "If the device requires that, implement .suspend and .resume or at least
> define .suspend that will always return -ENOSYS (then people will know they
> have to unload the driver before the suspend).  Similarly, if you aren't sure
> whether or not the device requires .suspend and .resume, define .suspend that
> will always return -ENOSYS."

If your device requires power management, and you know it requires power
management, why not just implement power management? Doing -ENOSYS
instead is like saying -ESPAMMEBECAUSEIMLAZY.

Let me put it another way: People keep talking about Linux being ready
for the desktop. To me at least (but I dare say for lots of other people
too), being ready for the desktop means that things just work, without
having to recompile kernels or bug driver authors or wait twelve
months. 

And it means that doing a bare minimum isn't enough. We keep claiming
that Open Source is better than Proprietary software. If we accept
half-pie jobs of implementing support for anything - driver power
management support or hibernation support or whatever - as 'good
enough', we're undercutting that argument. Linux's power management
support should - as far as we're able - be at least as good as that
other operating system's and preferably way, way better.

-ENOSYS is just not acceptable.

Regards,

Nigel

