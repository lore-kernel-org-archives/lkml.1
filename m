Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYCYO3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYCYO3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCYO3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:29:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34873 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312AbYCYO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:29:36 -0400
Date: Tue, 25 Mar 2008 10:29:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 3)
In-Reply-To: <200803251340.55210.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803251024120.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Rafael J. Wysocki wrote:

> On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > Am Montag 24 März 2008 schrieb Rafael J. Wysocki:
> > > -/*
> > > +/**
> > > + * struct pm_ops - device PM callbacks
> > > + *
> > >   * Several driver power state transitions are externally visible, affecting
> > >   * the state of pending I/O queues and (for drivers that touch hardware)
> > >   * interrupts, wakeups, DMA, and other hardware state.  There may also be
> > > @@ -122,6 +124,254 @@ typedef struct pm_message {
> > >   * to the rest of the driver stack (such as a driver that's ON gating off
> > >   * clocks which are not in active use).
> > >   *
> > > + * The externally visible transitions are handled with the help of the following
> > > + * callbacks included in this structure:
> > > + *
> > > + * @prepare: Prepare the device for the upcoming transition, but do NOT change
> > > + *     its hardware state.  Prevent new children of the device from being
> > > + *     registered and prevent new calls to the probe method from being made
> > 
> > How is a driver supposed to prevent calls to probe()? You can block in probe()
> > or you can fail it, but how do you prevent it from being called? User space
> > can trigger probe via sysfs.
> 
> I overlooked that.

The driver isn't supposed to prevent calls to its own probe().  The
comment means that the subsystem -- or the rest of the kernel generally
-- is supposed to avoid binding a driver to the device (thereby calling
the probe routine), assuming the device isn't already bound.

I don't expect this sort of thing to be very common.  Mostly it happens
when new kernel modules are loaded and new drivers are registered; we
will have to block module loading during a sleep transition.  It also
happens when the user writes to a driver's "bind" attribute in sysfs;  
the code there will have to block during a sleep transition.

Alan Stern

