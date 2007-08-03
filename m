Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXHCCrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXHCCrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 22:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXHCCqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 22:46:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1473 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753587AbXHCCqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 22:46:54 -0400
Date: Thu, 2 Aug 2007 22:46:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Greg KH <gregkh@suse.de>, <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default
 on certain device classes
In-Reply-To: <20070803014756.GA10392@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Matthew Garrett wrote:

> On Thu, Aug 02, 2007 at 06:15:05PM -0700, Greg KH wrote:
> 
> > Well, if you do this, then you can pretty much delete the whole quirk
> > table we have, right?
> 
> At the moment, yes.
> 
> > And personally, I want to do better than Windows XP when it comes to
> > power management.  This patch is only going to suspend a very tiny
> > subset of devices, including a whole bunch of ones that do not even have
> > drivers in Linux, causing our power footprint to be bigger than needed.
> 
> I agree. I'd much rather see us suspending devices whenever possible - 
> it's just that I have concerns over the scalability of the blacklist, 
> given the number of devices that seem to have issues.

While I agree in general, perhaps a different approach would work
better.  For instance, we could blacklist a few known-bad device
classes (maybe even using the existing blacklist) rather than
whitelisting a few known-good ones -- or trying to blacklist each 
member of the bad classes!

Also, building something this sweeping into a kernel driver feels like
a mistake.  It ought to be more easily configurable from userspace, say
via a sysfs file.  Although this wouldn't be so important if we take
the blacklist-classes route.

Alan Stern

