Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbXHTUZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbXHTUZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbXHTUUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:20:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51061 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761160AbXHTUUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:20:52 -0400
Date: Mon, 20 Aug 2007 22:19:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Jean Delvare <khali@linux-fr.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_SUSPEND and power consumption
Message-ID: <20070820201910.GA5877@elf.ucw.cz>
References: <20070819153259.2c96b904@hyperion.delvare> <200708201211.34698.oliver@neukum.org> <20070820172907.GC3975@ucw.cz> <200708202108.35674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708202108.35674.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > If I rmmod "ehci-hcd" then the power consumption is back to 69 W. This
> > > > confirms that this is really USB-related. I have to admit that I did
> > > > not expect an external drive to eat that much power from the system,
> > > > especially when not used. I am told that VIA chips are notoriously bad
> > > > at this kind of things. I'll try the same external drive on an Intel
> > > > system later today.
> > > > 
> > > > The last mystery remaining is how USB "activity" can cause my CPU to
> > > > heat. I would expect the south bridge to heat, not the CPU.
> > > 
> > > USB, or strictly speaking EHCI, OHCI and UHCI, use DMA. To allow
> > > that the cache coherency logic has to be active. Therefore your CPU
> > > cannot go to C3. Therefore it draws more power. The problem we are
> > > facing in USB is that to get great savings, our coverage has to be perfect.
> > > One device that cannot be autosuspended and we lose most savings.
> > 
> > Ok.. but CONFIG_USB_SUSPEND should not really have anything to do with
> > CONFIG_SUSPEND (= s2ram). Perhaps it should depend on CONFIG_PM
> > instead?
> 
> CONFIG_USB_SUSPEND doesn't depend on CONFIG_SUSPEND.

Strange... what is going on here, then?

config USB_SUSPEND
        bool "USB selective suspend/resume and wakeup (EXPERIMENTAL)"
        depends on USB && PM && EXPERIMENTAL
        help
          If you say Y here, you can use driver calls or the sysfs
          "power/state" file to suspend or resume individual USB
          peripherals.

          Also, USB "remote wakeup" signaling is supported, whereby
some
          USB devices (like keyboards and network adapters) can wake
up
          their parent hub.  That wakeup cascades up the USB tree, and
          could wake the system from states like suspend-to-RAM.

          If you are unsure about this, say N here.

config USB_OTG
        bool
        depends on USB && EXPERIMENTAL
        select USB_SUSPEND
        default n

hmmm, it looks like USB_OTG can be selected without CONFIG_PM, but it
selects USB_SUSPEND. Is that okay?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
