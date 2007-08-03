Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbXHCOlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbXHCOlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXHCOlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:41:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45551 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751029AbXHCOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:41:14 -0400
Date: Fri, 3 Aug 2007 10:41:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: David Brownell <david-b@pacbell.net>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain
 device classes
In-Reply-To: <20070803143338.GA19713@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0708031038170.2597-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Matthew Garrett wrote:

> Windows will autosuspend hubs, bluetooth devices, HID devices and CDC 
> devices, so I think we're safe suspending those by default.

And we know that we're not safe suspending scanners and many printers 
by default.  But that leaves plenty of other device classes unaccounted 
for.

> I'm not so 
> enthusiastic about the "Increase the timeout case" - it doesn't avoid 
> any races, just makes them less likely. USB is likely to get loaded in 
> the initramfs, but we may not have a full set of udev rules until the 
> root fs is up and that can take an effectively arbitrarily large amount 
> of time.

If it takes longer than 15 minutes, something is wrong.  At that point 
the user will have worse things to worry about than whether some USB 
devices got suspended.

And 15 minutes is a perfectly reasonable autosuspend timeout for 
devices that might be plugged in all day long.

Alan Stern

