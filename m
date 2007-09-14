Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbXINI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbXINI4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXINI4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:56:31 -0400
Received: from twin.jikos.cz ([213.151.79.26]:43857 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbXINI4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:56:30 -0400
Date: Fri, 14 Sep 2007 10:55:46 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <Pine.LNX.4.44L0.0709131421130.7406-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0709141047580.24429@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0709131421130.7406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Alan Stern wrote:

> > Btw, this is in no way just an AUTOSUSPEND issue. The USB layer has a 
> > *lot* of these quirks. They are often called "UNUSUAL_DEV()", but the 
> > thing is, some of those things seem to be so usual that the naming is 
> > dubious, and thus calling it a "quirk" or "unusual" is pretty dubious 
> > too.
> You have concentrated your attention on the list for usb-storage,
> but the usbhid driver also has an impressively long quirks list.

This is true. First, there are HID_QUIRK_RDESC_* quirks, which we use to 
fix up badly broken report descriptor of certain devices before it enters 
the HID parser. There is nothing much we can do about them - these are 
just workarounds for really broken devices that don't follow the HID 
specification, but we can easily fix the things on the fly. Usually, these 
devices are handled in Windows by specialized driver, but if we fix the 
descriptor, we can use usbhid to handle them.

For the rest of the HID quirks -- most of them are also workarounds for 
broken classess of devices. Usually, they claim to be HID-compliant device 
in their file descriptor, but they do not follow the spec (they send 
inverted axes values, send usage codes that violate the specification, 
etc), but we can easily work around these bugs by a few lines of code and 
let the devices to be handled by usbhid flawlessly. I guess this is worth 
it.

Probably the only quirk entry that might be considered to be removed is 
HID_QUIRK_NOGET, I'd say.

Thanks,

-- 
Jiri Kosina
