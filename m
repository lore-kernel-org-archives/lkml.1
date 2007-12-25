Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbXLYNsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbXLYNsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 08:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXLYNsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 08:48:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXLYNsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 08:48:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: ACPI:  _PTS ordering needs fixing for pre ACPI 3.0 systems (was: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM)
Date: Tue, 25 Dec 2007 15:07:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-acpi@vger.kernel.org
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <200712250241.49753.carlos@strangeworlds.co.uk> <200712251436.52246.rjw@sisk.pl>
In-Reply-To: <200712251436.52246.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251507.24144.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of December 2007, Rafael J. Wysocki wrote:
> On Tuesday, 25 of December 2007, Carlos Corbacho wrote:
> > Adding Linux-ACPI to CC.
> > 
> > On Tuesday 25 December 2007 00:03:25 Carlos Corbacho wrote:
> > > According to the earlier versions of the ACPI spec, Linux is doing the
> > > wrong thing - we should call _PTS() before we start powerding down devices,
> > > or notifying device drivers to start suspending.
> > >
> > > So, my limited understanding of what we currently do for ACPI
> > > suspend-to-RAM is:
> > >
> > > 1) Freeze processes/ devices
> > > 2) Put all devices into low power mode
> > > 3) Execute _PTS()
> > > 4) Suspend system
> > >
> > > So the problem is - our current suspend order is fine for ACPI 3.0 and
> > > above, but for pre-3.0 systems, this violates the older specs, where 2) and
> > > 3) should be reversed.
> > 
> > The following is a hack to illustrate what I'm getting at (this is
> > tested on x86-64) (it's a hack since it does all the ACPI prepare bits
> > during set_target() for the pre ACPI 3.0 systems, rather than prepare() -
> > whether this can be cleaned up to move out just the _PTS() call, I don't
> > know).
> > 
> > It abuses suspend_ops->set_target(), but was the easiest way to quickly
> > demonstrate this (since the kerneldoc for set_target() says it will always
> > be executed before we suspend the devices).
> 
> Please, don't do that.

OK, sorry, the approach is generally reasonable, IMO, but it needs to be a bit
more fine grained.

I'll try to prepare some patches along these lines soon.

Thanks,
Rafael
