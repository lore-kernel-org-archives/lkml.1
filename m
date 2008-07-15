Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYGOIgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYGOIgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYGOIgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:36:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37777 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYGOIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:36:22 -0400
Date: Tue, 15 Jul 2008 10:36:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "David Hubbard" <david.c.hubbard@gmail.com>
Cc: "Hans de Goede" <j.w.r.degoede@hhs.nl>, linuxppc-dev@ozlabs.org,
       Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>, lm-sensors@lm-sensors.org
Subject: Re: [RFC] (almost) booting allyesconfig -- please  don't poke
 super-io without request_region
Message-ID: <20080715103613.4fbbf01f@hyperion.delvare>
In-Reply-To: <4dfa50520807141055l532caaaai700255936600e5ae@mail.gmail.com>
References: <for-27-patch1-0@bga.com>
	<48770B5E.7000308@hhs.nl>
	<20080711093650.4b98e3b7@hyperion.delvare>
	<4879A144.8060203@hhs.nl>
	<4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>
	<487A7211.7030309@hhs.nl>
	<4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>
	<20080714095914.0644ac5d@hyperion.delvare>
	<88f5162604470179b3c6ebfe729a46f5@bga.com>
	<487B8D2C.1090208@hhs.nl>
	<4dfa50520807141055l532caaaai700255936600e5ae@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 11:55:01 -0600, David Hubbard wrote:
> Hi Hans,
> 
> On Mon, Jul 14, 2008 at 11:30 AM, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> > Milton Miller wrote:
> >> I haven't done the research, but it might be keep superio as
> >> a platform driver, and keep the clients as platform drivers.  Only
> >> have the superio driver probe and discover the subcomponent
> >> addresses and then create the platform devices as children
> >> instead of having each driver create its own platform device.
> >> (This all assumes they are all platform devices in sysfs, I have
> >> not looked).
> >>
> >> This is all because in the platform bus the bus driver does not
> >> discover the addresses but relies on drivers or platform setup code.
> >
> > This sounds like a good plan, rather then add a new bus type add a superio
> > platform driver which does superio probing and registering of platform devices
> > for discovered logical devices.
> >
> > This superio platform driver then needs to also export some functions of those
> > few logical devices which need access to the superio registers for more then
> > just finding out their own base address.
> >
> > I guess that it then would be best to load this superio driver by default on
> > most systems.
> >
> > How does this all mix and match with isapnp, it feels to me we're doing
> > somewhat the same as isapnp here.
> 
> Is there any way to use lspci and start at the LPC bridge, then find
> the SuperIO chip's IO address? What about ACPI tables? Perhaps probing
> logic could look for an LPC bridge before probing certain IO addresses
> even if the addresses are not in the LPC bridge config.

I always assumed that there was no way to know in advance if a
Super-I/O (LPC) chip was present or not, let alone the exact model of
the chip. The I/O addresses are decoded by the Super-I/O chip itself,
and in general it has no relation to PCI. And I've never seen ports
0x2e/0x2f nor 0x4e/0x4f listed in /proc/ioports.

But of course if there is a way to know, we should use it. Avoiding
random access to I/O ports, even if they are relatively standard in
this case, is always good.

> A superio platform driver is a good way to go -- it fits with the way
> the platform bus does things. Also, Jim's patches are almost there
> already.

Good.

-- 
Jean Delvare
