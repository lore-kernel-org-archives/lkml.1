Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbZLPKek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbZLPKek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbZLPKef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:34:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739AbZLPKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:34:33 -0500
Date: Wed, 16 Dec 2009 11:34:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
Message-ID: <20091216103423.GE1377@ucw.cz>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a driver for the Logitech G13 gamepad, and contains three
> key parts. In the USB reports the device identifies itself as a
> HID, and as a result this driver is under the HID framework.
> 
> There are two primary sub-components to this driver; an input
> device and a framebuffer device.
> 
> Although identified as a HID, the device does not support standard
> HID input messages. As a result, a sub-input device is allocated and
> registered separately in g13_probe(). The raw events are monitored 
> and key presses/joystick activity is reported through the input device 
> after referencing an indexed keymap.
> 
> Additionally, this device contains a 160x43 monochrome LCD display.
> A registered framebuffer device manages this display. The design
> of this portion of the driver was based on the design of the
> hecubafb driver with deferred framebuffer I/O since there is
> no real memory to map.
> 
> This patch is against the torvalds/linux-2.6.git tree.

Should this use auxdisplay framework and be located there?

> --- /dev/null
> +++ b/drivers/hid/hid-g13-logo.xbm
> @@ -0,0 +1,75 @@
> +#define g13_lcd_width 160
> +#define g13_lcd_height 43
> +static unsigned char g13_lcd_bits[] = {
> +   0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +   0x00, 0x00, 0x00, 0x28, 0x03, 0x00, 0x40, 0x01, 0x00, 0xc0, 0x3f, 0x00,
> +   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa1,
> +   0x08, 0x00, 0x08, 0x00, 0x00, 0xe0, 0x7f, 0x00, 0x00, 0x00,
> 0x00, 0x00,

I'd prefer to go without another logo. Just make sure default penguin gets
there or something.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
