Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYD2GUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYD2GUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYD2GUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:20:40 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:33719 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYD2GUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:20:39 -0400
Date: Mon, 28 Apr 2008 23:17:16 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: Ben Nizette <bn@niasdigital.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
In-Reply-To: <200804282044.00706.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804282251420.8286@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net> <200804281744.11564.david-b@pacbell.net>
 <1209434284.14631.71.camel@moss.renham> <200804282044.00706.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, David Brownell wrote:
> On Monday 28 April 2008, Ben Nizette wrote:
>>
>> Ah well we're backwards there, though now I think of it I can't think of
>> a great many valid use-cases on my side.  Just for funzies I'll post on
>> the avrfreaks AVR32 support forum and see how many I can actually dig
>> up.
>
> Use cases would always help clarify things.  I've seen just
> enough to make me understand this is a useful feature, and
> for more reasons than just "feature equality" letting us
> obsolete three drivers/i2c/chips/*.c drivers and help vanish
> half a dozen (at least!) out-of-tree drivers doing that.

If you want use cases, how about mine?  I didn't write the code originally for
fun, I wrote it for a real product.

We have a flash chip with a hardware write protected boot block controlled by
a gpio.  If we want to flash this block, we need a way to change the gpio. 
patching the mtd driver to do this automatically would require maintaining an
out-of-tree patch, I like to avoid those.  We'd also rather mtd didn't
automatically un-write-protect the boot block; kinda defeats the purpose.

The device may have a daughtercard installed in it.  There is a gpio used as a
presence detect.  We want to be able, from userspace (any maybe kernel too),
to print out "card installed" or "no card installed".  There is also certain
stuff that should run if the card is present when the machine boots.

We have some PCA9557 I2C gpio expanders that encode a device version number. 
We want to print this number out in userspace (e.g.  show it in the web
interface, various other application specific interfaces, etc.).  Maybe the
kernel will need to know too, we'll see what happens when there is a version
two.  The daughter card also has a PCA9557 expander, but of course it might
not be connected, the pca9557 driver can probe the bus for this.

>>> 	0-15	gpio
>>> 	16-31	gpio
>>> 	32-47	gpio
>>> 	48-63	gpio
>>> 	192-207	mpuio
>>> 	208-213	tps65010
>>>
>>> (Matching a stock OMAP 5912 OSK board, for what it's worth.)
>>
>> Yeah that's the kind of a thing.  Would be well worth having that info
>> especially for dynamically allocated chip bases.
>
> I'd have no problem with that.  Some people surely would though;
> it has more than one value in that file!  OMG, it's readable! We
> can't have any of that!!  The Earth will turn in its grave!  And
> Slashdot will be decorated in Pink!  Teh End Daze arrive!  :)

Suppose I want line 5 from the mpuio gpios?  I'd make it so this was: 
/sys/class/gpio/mpuio:5

How would you get the sysfs location, with an automatic shell script running
on a lightweight embedded system (no perl!)?

> OK.  In that case, I think I should plan to rename the "direction"
> attribute as "configuration" or something a bit broader ... so that
> writing "irq" (or maybe "rising", "falling", "bothedges", "poll")
> would eventually configure it as an input with an IRQ handler.

Why not have an irq file for that?
