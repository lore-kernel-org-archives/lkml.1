Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXCEIjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXCEIjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbXCEIjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:39:32 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2512 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbXCEIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:39:31 -0500
Date: Mon, 5 Mar 2007 08:39:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Message-ID: <20070305083918.GA26436@flint.arm.linux.org.uk>
Mail-Followup-To: Robin Getz <rgetz@blackfin.uclinux.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <20070304194632.GC30345@flint.arm.linux.org.uk> <200703041542.25633.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703041542.25633.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 03:42:25PM -0500, Robin Getz wrote:
> On Sun 4 Mar 2007 14:46, Russell King pondered:
> > On Thu, Mar 01, 2007 at 07:03:02PM -0500, Mike Frysinger wrote:
> >  > the console= bootcmd allows for controlling of the initial state of
> >  > flow control by adding/omitting the 'r' suffix ...
> >
> >  The console command *only* sets the state for the kernel's use of one
> >  serial port.  It does not affect any other serial port, so tying
> >  random RTS behaviours into that command line option is absolutely
> >  silly.
> 
> I have one serial port in the system, it shares console, and the 
> communications port for the application. (But I guess that is besides the 
> point).

In which case communications over that port could be unreliable.
What if the kernel decides to spit out a message in the middle of
your applications data transfer?

If you're using a serial port for a data application, don't make it
the kernel console.

> When the common serial core initialises the UART, and sees that it has the 
> capability to do HW flow control - it enables it, asserting the pin, even if 
> I don't want it at that moment in time.
> 
> The real issue is that there is some legacy equipment, which gets confused if 
> it sees glitches on RTS (which happens today, when serial core init asserts 
> RTS, and then the the main application turns it off)...
> 
> How do I set the set up the UART, so RTS is avaliable, but not enabled?

No idea, sorry.  It's not something any Linux kernel version has ever
supported, and since I no longer do serial support it's not something
I'd be involved with anymore.

All I will say is that thinking about keying such a decision off the
kernel console= parameter is absolutely silly - the console= parameter
has nothing to do with the serial port's userspace settings.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
