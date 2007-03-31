Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbXCaWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbXCaWkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXCaWkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 18:40:32 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:44258 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXCaWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 18:40:32 -0400
Date: Sun, 1 Apr 2007 00:40:21 +0200
From: Eduard Bloch <edi@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070331224021.GA6488@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org> <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de> <20070330191038.067c346b@the-village.bc.nu> <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de> <20070331232002.7b478f37@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331232002.7b478f37@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>
* Alan Cox [Sat, Mar 31 2007, 11:20:02PM]:
> > But the desktop needs some means to deal with that. AFAICS the only
> > feasible way for applications to communicate about device usage policy
> > is locking with O_EXCL. Many people do not realize that even read-only
> 
> serial ports and mail both use fcntl file locking , which is much more
> flexible.

Again, what does that have to do with the problem at hand? Our problem is
not about locking on a single file (no matter which mechanism is used)
but the coordination of locks _behind_ the userspace access. Or
alternatively reassigning all access to one device file.

> > > The kernel does not have sufficient information to handle /dev/sg locking
> > 
> > But the kernel knows already that there is a block device behind it. It
> > is displayed in sysfs. It shall "just" reuse the lock mechanism of that
> > device, not more and not less. Naturally this "just" definition is
> > bendable and that is why I initially asked here.
> 
> This doesn't help. There are legitimate reasons to use /dev/sg on a
> device which is active. For most subsystems this actually makes a lot of
> sense when doing things like enclosure control.

For such uses one can omit the locking. Problem solved.

> > The sad thing is, this is just another assumption. At least on Debian
> > /dev/sgX belongs to the cdrom group when it's a cdrom device and the
> > permissions do just invite to work with it.
> 
> Which means it is privilegded.

So? Then let's make /etc/shadow privilegded too: chmod a+r /etc/shadow

> > > The desktop user space should really know what it is doing with the CD
> > > device if it wants to do things like CD burning. If the serial port
> > > people could get this right in 1977 then there is no excuse fo the CD
> > 
> > Serial port? Do we have multiple drivers with multiple interfaces
> > accessing the same hardware simultaneously and independently? I don't
> > think so.
> 
> getty/modem/uucp/terminal emulator/slip/ppp/.. 
> 
> I do think so.

Nice try, but where are the different conflicting drivers with different
userspace interfaces? Do you have some more flawed comparisons of that
kind?

> > The use of /dev/sg* is still common practice, its invention predates
> 
> The /dev/sg interface cannot do the locking. If you use /dev/sg you are

Again, it doesn't have to. It can pass the locking operations to the
related block device driver.

The alternative is finding a mapping to the correct block device and act
on this one (with O_EXCL or with fcntl, or both). Sysfs looks like a
good method to get information for such mapping but unfortunately you
(kernel developers) are going to cut even this last path soon (see
CONFIG_SYSFS_DEPRECATED and its bold description).

Is there any other way I need to know about? Some Voodoo ioctl?

Regards,
Eduard.

-- 
<alphascorpii> hm, was kann man denn so aus brot machen ...
<maxx> knusprige ente (mit etwas geduld)
