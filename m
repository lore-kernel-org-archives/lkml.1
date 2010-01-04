Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013Ab0ADWYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0ADWYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947Ab0ADWX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:23:59 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:52773 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0ADWXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:23:54 -0500
Message-ID: <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
    <20091216103423.GE1377@ucw.cz>
    <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
Date: Mon, 4 Jan 2010 15:23:36 -0700
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, "Oliver Neukum" <oliver@neukum.org>,
       linux-input@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 16 Dec 2009, Pavel Machek wrote:
>
>> > Although identified as a HID, the device does not support standard HID
>> > input messages. As a result, a sub-input device is allocated and
>> > registered separately in g13_probe(). The raw events are monitored and
>> > key presses/joystick activity is reported through the input device
>> > after referencing an indexed keymap.
>> >
>> > Additionally, this device contains a 160x43 monochrome LCD display. A
>> > registered framebuffer device manages this display. The design of this
>> > portion of the driver was based on the design of the hecubafb driver
>> > with deferred framebuffer I/O since there is no real memory to map.
>> >
>> > This patch is against the torvalds/linux-2.6.git tree.
>>
>> Should this use auxdisplay framework and be located there?
>
> Well, the device is still primarily HID device in its nature, so either
> keeping the whole driver in drivers/hid, or separating it into two
> drivers, one for the HID part and second for the framebuffer part should
> be acceptable.

The framebuffer part uses the same interrupt endpoint for both HID and
display. IIRC there were issues with two drivers using the same interrupt
endpoint.


>
>> > --- /dev/null
>> > +++ b/drivers/hid/hid-g13-logo.xbm
>> > @@ -0,0 +1,75 @@
>> > +#define g13_lcd_width 160
>> > +#define g13_lcd_height 43
>> > +static unsigned char g13_lcd_bits[] = {
>> > +   0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> 0x00,
>> > +   0x00, 0x00, 0x00, 0x28, 0x03, 0x00, 0x40, 0x01, 0x00, 0xc0, 0x3f,
>> 0x00,
>> > +   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> 0xa1,
>> > +   0x08, 0x00, 0x08, 0x00, 0x00, 0xe0, 0x7f, 0x00, 0x00, 0x00,
>> > 0x00, 0x00,
>>
>> I'd prefer to go without another logo. Just make sure default penguin
>> gets
>> there or something.
>
> What logo is this, BTW? :)
>

It's similar to the default G13 load image, but with tux on the left and
the GNU gnu on the right.

I tried to particularly clean up tux a bit since the default monochrome
logo is 80x80 and the display is 160x43.

The only alternatives I could think of were to use the default logo and
load it at 80x43 which cuts off Tux at the nipples, resample in the
driver, or leave the logo off.

I didn't like the first because it didn't look like tux without his belly
and feet, the second seemed overly complex, and the third doesn't provide
a visual cue to the user that it's plugged in and all is well.

The visual cue is particularly necessary because the device displays a G13
logo on initialization even when no working driver is present. It's
problematic because it appears as if the device is ready, so the use of a
penguin provides a Linux specific cue.

> I will proceed with reviewing the driver soon, sorry for slightly higher
> latencies these days.
>

No problem... as you can see my latency responding is rather high.


