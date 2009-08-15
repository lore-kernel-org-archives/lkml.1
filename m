Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZHOORW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZHOORW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZHOORV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:17:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbZHOORU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:17:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Date: Sat, 15 Aug 2009 16:18:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0908141032070.2987-100000@iolanthe.rowland.org> <200908142205.20093.rjw@sisk.pl> <20090814222157.GA20015@srcf.ucam.org>
In-Reply-To: <20090814222157.GA20015@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908151618.10169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 August 2009, Matthew Garrett wrote:
> On Fri, Aug 14, 2009 at 10:05:19PM +0200, Rafael J. Wysocki wrote:
> 
> > Well, sometimes the user may want a device to be power managed at run time
> > and not to be able to wake up the system from sleep states.  For example,
> > I'd like the USB controller in my box to be suspended at run time whenever it's
> > not used, but surely I wouldn't like it to do system-wide wakeup, because it
> > does that when I move the mouse which is a cordless one.  Simply turning the
> > mouse on causes the system to wake up. :-)
> 
> Right, so clearly my code is broken right now.
> 
> > Why don't we add a flag indicating whether or not the device is allowed to
> > be power managed at run time, something like runtime_forbidden, that the
> > user space will be able to set through sysfs?
> 
> I think even having a runtime_wakeup flag (which defaults to on) would 
> be sufficient.

Perhaps it would, but then unsetting runtime_wakeup would effectively disable
runtime PM for devices that need it to be power managed at run time (probably
all input devices).  Also there may be situations in which user space may
really want to disable runtime PM for some devices (think of broken hardware
for one example).

> If the worst case is scenario is that we have to resume 
> devices in order to apply the correct policy when going into a 
> systemwide suspend state, I think that's acceptable.

I agree.

Thanks,
Rafael
