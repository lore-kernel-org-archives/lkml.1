Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbXHCO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbXHCO23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762158AbXHCO2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:28:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54130 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761955AbXHCO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:28:21 -0400
Date: Fri, 3 Aug 2007 10:28:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: David Brownell <david-b@pacbell.net>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain
 device classes
In-Reply-To: <20070803140909.GA19245@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Matthew Garrett wrote:

> This patch is exactly that - a way of getting most of the benefits of 
> autosuspend without any real probability of breaking hardware. If you 
> mean "Are the distributions willing to pop up dialogs asking users to 
> start caring about obscure aspects of the USB spec", then I don't think 
> that's actually making things better.

Quite aside from issues involving desktop ease-of-use and distribution 
intentions, there is a technical matter to consider.  With the default 
autosuspend timeout set to 2 seconds, as it is now, it can often happen 
that userspace isn't able to respond in time to prevent a device from 
being suspended.  At bootup especially, the system is so busy running 
lots of tasks that response to a newly-detected device can be delayed 
for tens of seconds.  Even loading the device driver's module can take 
so long that the device gets autosuspended first.

There are two possible solutions, both involving the kernel (since
userspace can't respond in time).  One is to change the default timeout
to something larger, or even disable it completely.  Then people would
need to rely on userspace tools to enable autosuspend on known-good
devices.  The other possibility is to have a fairly reliable blacklist
or whitelist and again rely on userspace to manage edge cases.  This is 
of course more flexible than a blanket default setting, but it's still 
pretty rigid.  On the other hand, a blacklist can't be changed without 
rebuilding the kernel whereas the default timeout can be adjusted on 
the boot command line.

I don't know what the "best" approach is, but I can't see any
alternative to these two.  Furthermore, whatever approach we settle on
_has_ to be able to handle devices which simply die upon being 
suspended.

Alan Stern

