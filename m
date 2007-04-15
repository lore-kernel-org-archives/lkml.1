Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXDOTug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXDOTug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXDOTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:50:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXDOTuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:50:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: [linux-pm] Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 21:54:07 +0200
User-Agent: KMail/1.9.5
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       pavel@suse.cz, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704151837.40756.rjw@sisk.pl> <20070415194023.GA2538@melchior.yamamaya.is-a-geek.org>
In-Reply-To: <20070415194023.GA2538@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704152154.09212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 April 2007 21:40, Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 15 April 2007 17:14, David Brownell wrote:
> > > On Sunday 15 April 2007 4:16 am, Rafael J. Wysocki wrote:
> > > > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> > > 
> > > > > > > > Yes, it's a Asus M2N-SLI-Deluxe Mainboard with a Athlon64 3200+
> > > > > > > > single core CPU.
> > > 
> > > And NVidia southbridge, so OHCI not UHCI (plus EHCI) ... one experiment
> > > would be to disable the EHCI (high speed USB) support in BIOS, to make
> > > for a simpler hardware configuration, and see if that makes BIOS happier.
> > > (Or better, just take EHCI out of your Linux config.)  Likewise, taking
> > > the 8042 drivers out of Linux.
> > > 
> > > I wouldn't be surprised if those factors didn't matter, but it'd be good
> > > to rule them out.
> > 
> > I think the disabling of i8042 support might help.
> 
> Still hangs with "# CONFIG_SERIO_I8042 is not set".
> 
> > > > Dmitry, could you please have a look?
> > > > 
> > > > > And I can now confirm that unpatched 2.6.21-rc6 works fine as long
> > > > > as USB legacy support is disabled (however without legacy support I
> > > > > can't use the USB keyboard to control grub).
> > > > 
> > > > I think using the 'shutdown' mode of suspend would be better.  There's a little
> > > > point in using 'platform' on desktop systems anyway.
> > > > 
> > > > Frankly, I don't know what to do about it.  If we move platform_finish() after
> > > > device_resume(), some systems may be broken ...
> > > 
> > > What I'm curious about is exactly why the patch matters.  What ACPI
> > > magic is being invoked to confuse, or unconfuse, those controllers?
> > 
> > I think the patch helps, because it makes the ACPI magic be done while the
> > i8042's .resume() is being executed.
> > 
> > Which makes me think the following patch might help:
> 
> Unfortunately not, I tried this before disabling CONFIG_SERIO_I8042.

Well, this means i8042 can be ruled out, so the problem probably is related
to the ACPI resume which makes it _much_ more difficult to debug.

Can you compile the ACPI drivers: processor, thermal, fan, battery, etc. as
modules, boot the kernel with init=/bin/bash and see if the problem is still
present (please keep CONFIG_SERIO_I8042 unset just in case)?

Rafael
