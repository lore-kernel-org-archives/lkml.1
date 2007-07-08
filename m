Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbXGHCYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbXGHCYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 22:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXGHCYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 22:24:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3667 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754813AbXGHCYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 22:24:12 -0400
Date: Sat, 7 Jul 2007 22:24:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183855362.3388.233.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707072218030.10912-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Benjamin Herrenschmidt wrote:

> > Which is exactly my point.  It _doesn't_ work fine without a freezer, 
> > because the USB stack currently relies on the freezer to prevent plug 
> > activity.
> 
> Putting on hold plug activity has nothing, NOTHING, to do with the half
> assed piece of deadlocking crap we have now we call a freezer.

You're wrong; it _does_ have something to do with the freezer.  The 
connection is that the code uses the freezer to put plug activity on 
hold.

You probably meant to say that it _should_ have nothing to do with the 
freezer.  That's a different matter.  But in any case you should write 
what you actually mean, rather than just putting down something as 
inflammatory as possible.

> As long as you guys keep mixing up all the issues and coming up with
> totally bogus solutions that cannot work, we won't have a useful suspend
> (either to RAM or to disk) in linux.

In my defense, you should realize that until Rafael's notifier chain
was added (just a few weeks ago, still not in mainline I believe) there
was no other way to do it.  Plug activity needs to be stopped before
the child devices are suspended, and the PM core does not send any
notification to drivers at that time.  All it does is activate the 
freezer.

Alan Stern

