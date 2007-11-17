Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXKQV7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXKQV7C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 16:59:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXKQV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 16:58:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2093 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750921AbXKQV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 16:58:53 -0500
Date: Sat, 17 Nov 2007 16:58:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
In-Reply-To: <200711172137.18784.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007, Rafael J. Wysocki wrote:

> On Saturday, 17 of November 2007, Jiri Slaby wrote:
> > On 11/16/2007 05:10 PM, Alan Stern wrote:
> > > On Thu, 15 Nov 2007, Greg KH wrote:
> > > 
> > >>> The offending -mm patch is
> > >>> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> > >>>
> > >>> 2.6.24-rc2-mm1 minus it works just fine; PROVE_LOCKING shows nothing new when
> > >>> the patch is applied.
> > >> Thanks for tracking this down.  Alan, any thoughts?
> > > 
> > > It's a driver problem somewhere.  Probably not one of the most common 
> > > drivers because I don't see the same problem here (but then I'm not 
> > > testing -mm).
> > > 
> > > The thing to do is figure out which driver is causing the problem.
> > > Jiri, try enabling CONFIG_DEBUG_DRIVER.  
> > 
> > Sadly no output.
> > 
> > > If there's also a config 
> > > option to prevent the console from being suspended, set it as well.  
> > 
> > no_suspend_console kernel parameter has no effect (why?).
> 
> I'm not sure.
> 
> Please try to set CONFIG_PM_VERBOSE.

I finally got 2.6.24-rc2-mm1 working.  Andrew, how come those two
recent patches from Greg and Kay (the ones changing alloc_disk_node()  
and system_bus_init()) aren't in your hot-fixes directory?

There's still a problem.  During bootup I get this:

	floppy0: Floppy io-port 0x03f2 in use

That's not supposed to happen; the floppy disk should be working 
perfectly.  Is this a known problem?

Back to the main topic...  My system hibernates and resumes with no
apparent problem.  Jiri, it looks like you'll have to do some debug
tracing of the routines in drivers/base/power/main.c.

Alan Stern

