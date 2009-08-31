Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZHaU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZHaU1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZHaU1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:27:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45453 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752854AbZHaU1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:27:49 -0400
Date: Mon, 31 Aug 2009 16:27:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Walleij <linus.ml.walleij@gmail.com>, <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] AB3100 regulator support v1
In-Reply-To: <20090830190102.GA4235@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908311623490.2646-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Aug 2009, Mark Brown wrote:

> On Sun, Aug 30, 2009 at 12:27:32PM -0400, Alan Stern wrote:
> > On Sun, 30 Aug 2009, Mark Brown wrote:
> 
> > > On the face of it (and without having actually looked at a running
> > > system or anything yet) I'm rather surprised that platform based MFD
> > > drivers aren't running into this issue more often.  CCing in Alan who
> > > made the change.
> 
> > I'm not at all familiar with the detailed issues involved here.  
> > Perhaps because of this, I don't see why there's any reason for
> > deadlocking.  __driver_attach() is invoked when a new driver is
> > registered; to avoid problems all you have to do is make sure you
> > aren't holding any device locks when you register a driver.
> 
> Ah, it's platform_driver_probe() that's causing issues.  When it is used
> the devices need to have been registered previously since the driver
> probe function isn't kept around.  In order to do this for the child
> device the driver for the subdevice has to be registered from within the
> probe function of the parent, which is itself happening within the
> parent device registration.

I see.  Well, in the absence of any more sophisticated solutions,
unlocking the parent's semaphore before registering the driver (and
then re-locking it afterward) should work.

Alan Stern

