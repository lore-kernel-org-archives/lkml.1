Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZHNTBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZHNTBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZHNTBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:01:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34699 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754045AbZHNTBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:01:31 -0400
Date: Fri, 14 Aug 2009 15:01:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, <linux-usb@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
In-Reply-To: <200908141913.56884.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908141500490.2659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Rafael J. Wysocki wrote:

> On Friday 14 August 2009, Rafael J. Wysocki wrote:
> > On Friday 14 August 2009, Alan Stern wrote:
> > > On Thu, 13 Aug 2009, Matthew Garrett wrote:
> > > 
> > > > On Thu, Aug 13, 2009 at 11:22:44AM -0400, Alan Stern wrote:
> ...
> > > > Though perhaps the device level runtime_idle shouldn't be void - that 
> > > > way the bus can ask the driver whether its suspend conditions have been 
> > > > satisfied? Right now there doesn't seem to be any way for the bus to ask 
> > > > that.
> > > 
> > > If you want to get the device-level runtime_idle involved, you can make
> > > _it_ responsible for scheduling the suspend.  Then the bus-level code
> > > simply has to check whether everything is okay at the bus level, and if
> > > it is, call the device-level routine.
> > > 
> > > However changing the return type wouldn't hurt anything, and it would 
> > > allow the pm_schedule_suspend call to be centralized in the bus code.  
> > > You could ask Rafael about it, or just send him a patch.
> > 
> > Well, I'm not against that, but what should pm_runtime_idle() do with the
> > result returned by it?  Just pass it to the caller?
> 
> Hm, perhaps its better to ignore it, though.

That's what I was going to say.  The return value is intended for use 
by bus-level code when calling a driver-level routine.

Alan Stern

