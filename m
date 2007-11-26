Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbXKZPQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbXKZPQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXKZPQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:16:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36115 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875AbXKZPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:16:01 -0500
Date: Mon, 26 Nov 2007 10:16:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Raymano Garibaldi <raymano@faunos.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
In-Reply-To: <1618816c0711252117l3348e07atfe84a321c5675889@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711260958001.3987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007, Raymano Garibaldi wrote:

> The device which has the root fs is a READ-ONLY device. There is no
> way for it to change between getting detached and reattached to the
> computer which is suspended.

You might think so at first.  But suppose another device of the same 
type got plugged in instead -- with different data stored on it.  That 
would be just as bad.

> I understand that this is currently considered a feature but I am
> arguing here that there should also be another feature that allows
> this  to work under suspend to ram the same as it does with suspend to
> disk (hibernation).
...
> This scenario is not currently possible with the any kernel after
> 2.6.22. It is a very important missing feature.

This has nothing to do with USB particularly; it applies to all forms
of hot-pluggable or removable storage.  Even floppy disks.

> And yes. This feature does work under the 2.6.21 kernel, exactly
> because the kernel did not have  the USB suspend and persist feature
> available.

Wait a minute.  You're saying that USB Persist worked under 2.6.21
because it wasn't available?  That makes no sense.  Besides, if you
don't like USB Persist under 2.6.23, you can always eliminate it by
turning off CONFIG_USB_PERSIST.

> Under the 2.6.21 kernel, during suspend, the kernel is
> totally unaware of what is happening to the USB device so nothing
> happens when the USB device is detached and reattached while the
> computer is suspended, hence making the described scenario above
> possible. I currently, and very frequently, use this feature on my
> live USB distro, FaunOS which uses kernel 2.6.21.

It may be the case that _your_ particular computer wasn't aware of
unplug or replug events during suspend, but if so then it was a bug and
it isn't true in general.  The fact that your computer is now aware of
these things proves this.

In short, you aren't reporting a bug -- you're asking for a new feature 
to be added.

>From the point of view of the kernel, being suspended is in some
respects like remaining awake.  Hotplug events are detected in either
case.  Would you also want the ability to unplug and replug your root
fs while the computer was running?  Would it make sense to add such an
ability?

There was a time during the 2.4 kernel series when usb-storage would 
try to keep track of devices after they had been unplugged and 
recognize them when they were re-attached.  Linus himself said it was 
a bad idea and consequently it was removed.  Now you're saying you want 
it back.  I think you'll have to convince Linus before anyone else will 
pay attention.  It's worth a try -- he might think your airport 
scenario is common enough to be worth supporting.

Alan Stern

