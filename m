Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXGWOVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXGWOVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXGWOV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:21:26 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:50236 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752278AbXGWOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:21:25 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 16:23:17 +0200
User-Agent: KMail/1.9.7
Cc: Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707201820050.5241-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707201820050.5241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231623.17958.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 21 Juli 2007 schrieb Alan Stern:
> On Fri, 20 Jul 2007, Oliver Neukum wrote:
> 
> > > We already have a pre-suspend notification available for drivers that 
> > > need to allocate large amounts of memory.
> > 
> > Is that facility fine grained enough?
> 
> It's a notifier chain that gets called at several points during the 
> suspend transition.  One of those points is right at the start, while 
> userspace is still running and reasonably large amounts of memory can 
> be allocated.
> 
> Is it fine-grained enough?  I don't know -- hard to tell, since nothing 
> much is using it yet.
> 
> > > You are correct about the need to delay/stop device addition.  I don't
> > > know how this can be done in general; each code path calling
> > > device_add() may have to be treated individually.
> > 
> > What about the old API?
> 
> What old API do you mean?

The find_device() stuff.

> >  Do we have to block module loading?
> 
> No.  Registering new drivers is okay, registering new devices is bad.

What if it is a driver for virtual devices that don't need probe()
for actual hardware?

> Of course, some modules do want to register a new device in their init 
> method.  I don't know what we should do about them.  Force the 
> registration to fail, I suppose.  How often will people suspend while a 
> module is loading?
> 
> > What happens if a scsi error handler is woken? If it cannot be woken,
> > how are errors handled?
> 
> Why should the error handler wake up?  There isn't supposed to be any 
> I/O going on, hence no errors to handle.

What about shared busses? Firewire, FibreChannel? They can get external
resets, etc ...

	Regards
		Oliver
