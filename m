Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbXGTWZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbXGTWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbXGTWZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:25:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33338 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758328AbXGTWZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:25:17 -0400
Date: Fri, 20 Jul 2007 18:25:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707202335.05519.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707201820050.5241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Oliver Neukum wrote:

> > We already have a pre-suspend notification available for drivers that 
> > need to allocate large amounts of memory.
> 
> Is that facility fine grained enough?

It's a notifier chain that gets called at several points during the 
suspend transition.  One of those points is right at the start, while 
userspace is still running and reasonably large amounts of memory can 
be allocated.

Is it fine-grained enough?  I don't know -- hard to tell, since nothing 
much is using it yet.

> > You are correct about the need to delay/stop device addition.  I don't
> > know how this can be done in general; each code path calling
> > device_add() may have to be treated individually.
> 
> What about the old API?

What old API do you mean?

>  Do we have to block module loading?

No.  Registering new drivers is okay, registering new devices is bad.

Of course, some modules do want to register a new device in their init 
method.  I don't know what we should do about them.  Force the 
registration to fail, I suppose.  How often will people suspend while a 
module is loading?

> What happens if a scsi error handler is woken? If it cannot be woken,
> how are errors handled?

Why should the error handler wake up?  There isn't supposed to be any 
I/O going on, hence no errors to handle.

Alan Stern

