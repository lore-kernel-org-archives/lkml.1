Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbXCLT4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbXCLT4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXCLT4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:56:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56108 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752847AbXCLT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:56:53 -0400
Date: Mon, 12 Mar 2007 15:56:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45F57F94.6010502@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703121544200.4003-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Jiri Slaby wrote:

> Alan Stern napsal(a):
> > On Mon, 12 Mar 2007, Jiri Slaby wrote:
> > 
> >> Bisecting figured out the culprit:
> >> Commit: 17230acdc71137622ca7dfd789b3944c75d39404
> >> Author: Alan Stern <stern@rowland.harvard.edu> Mon, 19 Feb 2007 15:52:45 -0500
> >>
> >>      UHCI: Eliminate asynchronous skeleton Queue Headers
> [...]
> > Post it along 
> > with the usbmon log, and I'll try to figure out what happened.
> 
> Here it comes:
> USBMON:
> f7525b40 1832950485 C Ii:004:01 0 8 = 00005300 00000000
> f7525b40 1832950517 S Ii:004:01 -115 8 <
> f7525140 1832950540 S Co:004:00 s 21 09 0200 0000 0001 1 = 01
> f7525140 1832952485 C Co:004:00 0 1 >
> 
> Corresponds to numlock; 7; numlock; 7.

Actually that little piece corresponds just to pressing Numlock; it 
doesn't even include the key release.

> UHCI snapshot:
...

Leaving out the details, one thing is striking.  The usbmon trace shows an 
interrupt URB submitted for device 4 endpoint 1, but none of the URBs 
listed in the UHCI snapshot are for that device.  Instead there are 
entries for device 7 (which appears to be a hub), device 8, and device 2 
(which is low-speed, probably an HID device).  Are you certain your UHCI 
snapshot was from the correct controller?

It would help to see your /proc/bus/usb/devices.  Otherwise it's hard to
know what the various device numbers refer to.  Also, it would help to see 
UHCI snapshots for both before and after you press Numlock.

> Side note, it doesn't stop working at all, but there is something like timeout 
> or whatever, after a while, the keyboard interacts again.

I can't reproduce the problem on 2.6.21-rc3 with the UHCI patch applied.  
Can you try the same thing and see what happens?

Alan Stern

