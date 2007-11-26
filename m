Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbXKZFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbXKZFRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXKZFRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:17:06 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:25803 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbXKZFRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:17:05 -0500
Message-ID: <1618816c0711252117l3348e07atfe84a321c5675889@mail.gmail.com>
Date: Sun, 25 Nov 2007 22:17:04 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0711251052430.22777-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071124223903.6c72f527.akpm@linux-foundation.org>
	 <Pine.LNX.4.44L0.0711251052430.22777-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The device which has the root fs is a READ-ONLY device. There is no
way for it to change between getting detached and reattached to the
computer which is suspended. In such a case there is no possibility of
hibernation because there is nothing to write back to.

I understand that this is currently considered a feature but I am
arguing here that there should also be another feature that allows
this  to work under suspend to ram the same as it does with suspend to
disk (hibernation).

Here's a scenario:

1) You are at the airport working on a laptop without a hard drive,
which you have booted up using a live USB distro on a read-only USB
key drive.

2) You want to board your plane so you suspend your laptop. You can't
keep the USB stick in your laptop because you can not fit the laptop
back in the bag with the USB stick still attached. So you detach the
USB stick while the laptop is still suspended.

3) You get on the plane and after some time when you are allowed to
work again you stick back in the USB stick, resume the laptop and
continue work where you left off.

This scenario is not currently possible with the any kernel after
2.6.22. It is a very important missing feature.

And yes. This feature does work under the 2.6.21 kernel, exactly
because the kernel did not have  the USB suspend and persist feature
available. Under the 2.6.21 kernel, during suspend, the kernel is
totally unaware of what is happening to the USB device so nothing
happens when the USB device is detached and reattached while the
computer is suspended, hence making the described scenario above
possible. I currently, and very frequently, use this feature on my
live USB distro, FaunOS which uses kernel 2.6.21.


Thank you,

Raymano G.







On 11/25/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 24 Nov 2007, Andrew Morton wrote:
>
> > On Tue, 20 Nov 2007 17:04:32 -0700 "Raymano Garibaldi" <raymano@faunos.com> wrote:
> >
> > > Is there any other information that I can provide which might help in
> > > resolving this bug?
> >
> > Let's cc the USB developers.
> >
> > > On 11/18/07, Raymano Garibaldi <raymano@faunos.com> wrote:
> > > > The last time I tried this and it worked was 2.6.21. Below is a
>
> Sorry, that's not possible.  2.6.21 doesn't include USB Persist
> support.  Nor does 2.6.22.
>
> There were some experimental patches with early versions of USB Persist
> for those kernels.  They are different from what eventually went into
> 2.6.23.
>
> > > > On 11/18/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > > > > On Sunday 18 November 2007 20:14, Raymano Garibaldi wrote:
> > > > > > In kernel 2.6.23.8 USB_PERSIST feature does not work if the same USB
> > > > > > device is detached and reattached while computer is suspended. The
> > > > > > mount points for the USB storage device mounted before suspend are
> > > > > > lost and the device has to be remounted after resume.
>
> USB Persist was never meant to allow you to detach and reattach a
> device while the computer is suspended; it was meant to deal with
> hibernation.  So what you observed is the correct behavior, not a bug.
> Detaching and reattaching a device while the computer is suspended
> should result in exactly the same behavior as detaching and reattaching
> the device while the computer is awake.
>
> If you try doing the same thing but with the computer in hibernation
> instead of suspended, you may find it more in line with what you
> expect.
>
> Alan Stern
>
>
