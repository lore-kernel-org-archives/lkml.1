Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYA3Uep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYA3Uep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYA3Ueh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:34:37 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63815 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752535AbYA3Uef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:34:35 -0500
Date: Wed, 30 Jan 2008 21:34:22 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: michael <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: at91sam9260 wakeup on serial port
Message-ID: <20080130213422.504b6d53@siona>
In-Reply-To: <200801301056.13186.david-b@pacbell.net>
References: <479DB934.6090806@gandalf.sssup.it>
	<200801291944.53591.david-b@pacbell.net>
	<20080130124754.70f5b218@dhcp-252-066.norway.atmel.com>
	<200801301056.13186.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 10:56:12 -0800
David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > Yeah, although the nasty thing about UARTs is that you never know when
> > DMA really is idle.
> 
> If the UART isn't open, its DMA should be inactive.  :)
> 
> Also, after suspend() it should normally be inactive.
> (That latter is somewhat platform-specific.)

True, but can a closed or suspended UART wake the system? I guess it
could if it's really a GPIO interrupt that triggers the wakeup :-)

> > > The closest analogue to the AT91 support would map /sys/power/state:
> > > 
> > > 	standby --> to AP7 "Frozen"
> > > 	mem --> to AP7 "Stop"
> > 
> > Yes, that looks reasonable. We can also do something in between by
> > stopping most peripherals and busses. For example, keep one peripheral
> > bus and one USART running from OSC0 with everything else stopped.
> 
> Wouldn't that just be a variant of "Frozen"?  The clock API should
> be fully capable of disabling unused clocks, PLLs, and oscillators
> when the platform supports it.  It's common for lots of clocks to be
> disable even in non-suspended system states.

Yes, indeed. I was just pointing out that "Frozen" doesn't necessarily
mean what the datasheet says -- we can disable a lot of clocks manually.

> > I think we need some chip- or family-specific sleep code that knows how
> > to enter a given power state. But the specifics about how to wake the
> > system up must necessarily be board-specific (or even run-time
> > configurable.)
> 
> The sysfs wakeup attributes are the runtiime config mechanism for all
> events associated with a single device.

Right. I'm not all that familiar with the power management mechanisms
in the kernel yet, but this thread has made a few things much clearer.

Haavard
