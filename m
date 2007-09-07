Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbXIGQec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbXIGQec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964877AbXIGQeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:34:25 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2871 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757715AbXIGQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:34:25 -0400
Date: Fri, 7 Sep 2007 18:36:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Greg KH" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
Subject: Re: Platform device id
Message-ID: <20070907183615.3a54b8e9@hyperion.delvare>
In-Reply-To: <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
References: <20070907153559.17faf9d1@hyperion.delvare>
	<d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks for your answer.

On Fri, 7 Sep 2007 10:58:31 -0400, Dmitry Torokhov wrote:
> On 9/7/07, Jean Delvare <khali@linux-fr.org> wrote:
> > While platform_device.id is a u32, platform_device_add() handles "-1" as
> > a special id value. This has potential for confusion and bugs. One such
> > bug was reported to me by David Brownell:
> >
> > http://lists.lm-sensors.org/pipermail/i2c/2007-September/001787.html
> >
> > And since then I've found two other drivers  affected (uartlite and
> > i2c-pxa).
> >
> > Could we at least make platform_device.id an int so as to clear up the
> > confusion? I doubt that the id will ever be a large number anyway.
> >
> > To go one step further, I am questioning the real value of this naming
> > exception for these "unique" platform devices. On top of the bugs I
> > mentioned above, it has potential for compatibility breakage: adding a
> > second device of the same type will rename the first one from "foo" to
> > "foo.0". It also requires specific checks in many individual platform
> > drivers. All this, as I understand it, for a purely aesthetic reason. I
> > don't think this is worth it. Would there be any objection to simply
> > getting rid of this exception and having all platform devices named
> > "foo.%d"?
> 
> If a device has a <name>.<instance> scheme this implies possibility of
> having several instances of said device in a box.

This "allows" more than "implies".

>                                                   There are a few of
> platform devices that can only have one instance - for example i8042
> keyboard controller (the -1 special handling came from me because
> i80420 name was very confusing - there wasn't a dot separator in the
> name back then).

I agree that in general there is a single i8042 keyboard controller on
a system, but what prevents someone to build a system with several of
these (e.g. in a multi-console computer)?

I agree that "i80420" was a confusing name, but now that a dot was
inserted between the name and the id, it wouldn't be a problem to have
a device named "i8042.0", would it?

>                  Drivers that allow multiple devices should not
> attempt to use -1 for the very first instance - this should eliminate
> potential for error and special handling that you are talking about.

This isn't that easy. For a given kind of device, some systems might
have only one, it might even be strictly impossible to ever have more
than one by design, but other systems might not have this limitation
and may actually have several instances of said device. As we try to
make our drivers as platform-independent as possible, the drivers
themselves can't assume that only either scheme is used, they have to
support both.

-- 
Jean Delvare
