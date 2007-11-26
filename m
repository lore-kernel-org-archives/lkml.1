Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXKZSoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXKZSoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXKZSny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:43:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:58849 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbXKZSnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:43:53 -0500
Message-ID: <1618816c0711261043nfa61e63m59d242fbbd6a8d6@mail.gmail.com>
Date: Mon, 26 Nov 2007 11:43:50 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0711260958001.3987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1618816c0711252117l3348e07atfe84a321c5675889@mail.gmail.com>
	 <Pine.LNX.4.44L0.0711260958001.3987-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for responding Alan.

On 11/26/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 25 Nov 2007, Raymano Garibaldi wrote:
>
> > The device which has the root fs is a READ-ONLY device. There is no
> > way for it to change between getting detached and reattached to the
> > computer which is suspended.
>
> You might think so at first.  But suppose another device of the same
> type got plugged in instead -- with different data stored on it.  That
> would be just as bad.
>

This is possible. However I believe giving an option to the user to
allow this behavior is important. It's about choice.

> > I understand that this is currently considered a feature but I am
> > arguing here that there should also be another feature that allows
> > this  to work under suspend to ram the same as it does with suspend to
> > disk (hibernation).
> ...
> > This scenario is not currently possible with the any kernel after
> > 2.6.22. It is a very important missing feature.
>
> This has nothing to do with USB particularly; it applies to all forms
> of hot-pluggable or removable storage.  Even floppy disks.
>

True.

> > And yes. This feature does work under the 2.6.21 kernel, exactly
> > because the kernel did not have  the USB suspend and persist feature
> > available.
>
> Wait a minute.  You're saying that  USB Persist worked under 2.6.21
> because it wasn't available?  That makes no sense.  Besides, if you
> don't like USB Persist under 2.6.23, you can always eliminate it by
> turning off CONFIG_USB_PERSIST.
>

I have tried this. Simply turning off CONFIG_USB_PERSIST doesn't work.
In this case the USB drive file system is unmounted on resume, even if
the drive remained plugged in during suspend.

> > Under the 2.6.21 kernel, during suspend, the kernel is
> > totally unaware of what is happening to the USB device so nothing
> > happens when the USB device is detached and reattached while the
> > computer is suspended, hence making the described scenario above
> > possible. I currently, and very frequently, use this feature on my
> > live USB distro, FaunOS which uses kernel 2.6.21.
>
> It may be the case that _your_ particular computer wasn't aware of
> unplug or replug events during suspend, but if so then it was a bug and
> it isn't true in general.  The fact that your computer is now aware of
> these things proves this.
>

I have tried this on many different computers. Also our distro users
have successfully tried this throughout the world. Whether it was a
bug or not, the desired behavior existed in kernel 2.6.21.

> In short, you aren't reporting a bug -- you're asking for a new feature
> to be added.
>
> From the point of view of the kernel, being suspended is in some
> respects like remaining awake.  Hotplug events are detected in either
> case.  Would you also want the ability to unplug and replug your root
> fs while the computer was running?  Would it make sense to add such an
> ability?
>

Yes. I believe because of the advances in solid state drive
technology, especially detachable ones like USB flash drives, the
ability to unplug and replug a live root fs is becoming an important
feature.

> There was a time during the 2.4 kernel series when usb-storage would
> try to keep track of devices after they had been unplugged and
> recognize them when they were re-attached.  Linus himself said it was
> a bad idea and consequently it was removed.  Now you're saying you want
> it back.  I think you'll have to convince Linus before anyone else will
> pay attention.  It's worth a try -- he might think your airport
> scenario is common enough to be worth supporting.
>
> Alan Stern
>
>

Thanks again Alan. I will post a feature request.


Raymano G.
