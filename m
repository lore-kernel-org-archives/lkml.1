Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab0BZKxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:53:44 -0500
Received: from legolas.restena.lu ([158.64.1.34]:56408 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab0BZKxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:53:42 -0500
Date: Fri, 26 Feb 2010 11:53:05 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>, linux-kernel@vger.kernel.org,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
Message-ID: <20100226115305.3dcc1f5a@neptune.home>
In-Reply-To: <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
	<45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

On Fri, 26 February 2010 Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> On Fri, Feb 26, 2010 at 6:15 AM, Rick L. Vinyard Jr.
> <rvinyard@cs.nmsu.edu> wrote:
> > This patch adds support for examining and modifying the fbdefio
> > delay parameter through sysfs. It also adds two driver definable
> > minimum and maximum bounds.
> 
> Thanks for posting this. I've now read through this patch and your
> past patches, but I couldn't get a good understanding of how this
> userspace exposed defio delay would interact with most existing
> systems.

In the case of my PicoLCD driver, the hardware can barely do 2 full
redraws of the display per second but in case only a single tile is
affected it can do more refreshes of such a single tile per second.

> > +               Set the deferred I/O delay of the framebuffer in ms.
> > +               This value can be used to throttle deferred I/O updates.
> 
> Please help us understand how userspace should use the ability to set
> this delay. Who in userspace is intended to use it? Would this be the
> X server, cairo, or papyrus? A separate daemon? Human interaction?
> When should said userspace entity throttle updates? How would this
> entity know when throttling is needed? Could this throttling possibly
> or should this possibly be done automatically by the driver itself?

For me the driver would start with a default delay that matches the
full-redraw throughput of the device but userspace could reduce the
delay when it knows it will mostly just refresh small parts of the
display (one or two tiles) and would like those done at a higher rate.

A sample application would be displaying a media player interface
like the one of XMMS and clones where Umeter (the part displaying
volume per frequency range) could be refreshed ten times a second,
the current position once a second and all the rest only on song
change.

Knowing the size of the display, probability that it's being used
directly by X server is very small, it would rather be some application
using it as a sideport display.

> > +               Most framebuffer devices do not have or need support for
> > +               deferred I/O. Accessing a framebuffer without deferred I/O
> > +               support will return -ENODEV. Can be read but not modified if
> > +               /sys/class/graphics/<fb>/defio_delay_max is 0. When modifying,
> > +               the value must be greater than or equal to
> > +               /sys/class/graphics/<fb>/defio_delay_min and less than or equal
> > +               to /sys/class/graphics/<fb>/defio_delay_max.
> 
> Please help the reader of above understand the sequence of userspace
> changing the defio delay, and how and when that would affect the
> associated drivers. Will the delay behaviour be standard for all defio
> client drivers? What happens in all the various timing scenarios, eg:
> if a defio delay is changed in the middle of a display update or a
> defio page clean or before? The sysfs parameter description mentioning
> min/max above could use some elaboration as reading it doesn't make
> clear if userspace can also affect min/max or if it is completely
> owned by the driver.

Thanks,
Bruno
