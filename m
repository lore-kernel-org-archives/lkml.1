Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0CCFNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:13:22 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56835 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750746Ab0CCFNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:13:20 -0500
Date: Wed, 3 Mar 2010 06:13:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       florianschandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz, bonbons@linux-vserver.org
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
Message-ID: <20100303051311.GA4651@elf.ucw.cz>
References: <201003021848.o22ImLSS004394@mustang.cs.nmsu.edu>
 <45a44e481003021523h4a05a9bfu9691f2c0f2f053c7@mail.gmail.com>
 <24ab70ff629c48b6d10ce0cf6dc5d64b.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24ab70ff629c48b6d10ce0cf6dc5d64b.squirrel@intranet.cs.nmsu.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> +/*
> >> + * This is a default logo to be loaded upon driver initialization
> >> + * replacing the default Logitech G13 image loaded on device
> >> + * initialization. This is to provide the user a cue that the
> >> + * Linux driver is loaded and ready.
> >> + *
> >> + * This logo contains the text G13 in the center with two penguins
> >> + * on each side of the text. The penguins are a 33x40 rendition of
> >> + * the default framebuffer 80x80 monochrome image scaled down and
> >> + * cleaned up to retain something that looks a little better than
> >> + * a simple scaling.
> >> + *
> >> + * This logo is a simple xbm image created in GIMP and exported.
> >> + * To view the image copy the following two #defines plus the
> >> + * g13_lcd_bits to an ASCII text file and save with extension
> >> + * .xbm, then open with GIMP or any other graphical editor
> >> + * such as eog that recognizes the .xbm format.
> >> + */
> > ...
> >> +static unsigned char g13_lcd_bits[] = {
> >> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> >> 0x00,
> >
> > I think you'll agree above is not an elegant solution.
> 
> I could make it a config option.

You get about 10 complains already, but you are not willing to solve
it. No, config option does not help.

If you want to, make it separate patch so we can reject it separately.

> >> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
> >
> > Reading above code, it looks like this new userspace sysfs attribute
> > is for backlight control. Could that be better exposed using the
> > existing backlight class?
> >
> 
> I looked at the backlight class and it didn't seem to be a very good fit.
> 
> /* This structure defines all the properties of a backlight */
> struct backlight_properties {
> 	/* Current User requested brightness (0 - max_brightness) */
> 	int brightness;
> 	/* Maximal value for brightness (read-only) */
> 	int max_brightness;
> 	/* Current FB Power mode (0: full on, 1..3: power saving
> 	   modes; 4: full off), see FB_BLANK_XXX */
> 	int power;
> 	/* FB Blanking active? (values as for power) */
> 	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
> 	int fb_blank;
> 	/* Flags used to signal drivers of state changes */
> 	/* Upper 4 bits are reserved for driver internal use */
> 	unsigned int state;
> };
> 
> The g13's backlight doesn't support any of these properties. All you can
> set is an rgb value on the g13; no power modes, no brightness, etc. I
> could add a brightness attribute by scaling the rgb values, but I would
> prefer to do that from userspace rather than the driver since it's not
> supported in the device itself.
> 
> And, we'd still have to have the rgb attribute since the backlight class
> doesn't have color.

Or you could pretend you have 3 different backlights? ....which is
actually what you have...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
