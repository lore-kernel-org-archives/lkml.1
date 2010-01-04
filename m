Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124Ab0AEAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0AEAF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674Ab0AEAF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:05:27 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:48517 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0AEAF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:05:26 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2010 19:05:26 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qX1dXsa05KQSaarTER4O2gK3sSz2yS5nHc9uGZd/ryIYIiVh6aMNqM4rnRn13nL6Em
         CJ4wDeU7kYbEqk/2tRnF0TxJl4rLlezc+sBZRI7E5YZEqfP6hp10BcJMm7euAeQBJLNi
         9XacCM9eCdvdrnJKoowB4LGrY8RxqlVzHeDfA=
MIME-Version: 1.0
In-Reply-To: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
Date: Tue, 5 Jan 2010 07:57:44 +0800
Message-ID: <45a44e481001041557t1f87f8d4i959abbbee0c4346@mail.gmail.com>
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 5:22 AM, Rick L. Vinyard Jr.
<rvinyard@cs.nmsu.edu> wrote:
> Additionally, this device contains a 160x43 monochrome LCD display.
> A registered framebuffer device manages this display. The design
> of this portion of the driver was based on the design of the
> hecubafb driver with deferred framebuffer I/O since there is
> no real memory to map.

Hi Rick,

Interesting work. I recommend CCing linux-fbdev@vger.kernel.org too
since it contains a fbdev interface.

> +config LOGITECH_G13
> +       tristate "Logitech G13 gameboard support"
> +       depends on HID_LOGITECH
> +       depends on FB
> +       select FB_SYS_FILLRECT
> +       select FB_SYS_COPYAREA
> +       select FB_SYS_IMAGEBLIT
> +       select FB_SYS_FOPS

Does this need to select FB_DEFERRED_IO?

> --- /dev/null
> +++ b/drivers/hid/hid-g13-logo.xbm
> @@ -0,0 +1,75 @@
> +#define g13_lcd_width 160
> +#define g13_lcd_height 43
> +static unsigned char g13_lcd_bits[] = {
> +   0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

Was there a reason for having a new logo file? If so, you might want
to put it in the comments and also put it together with the standard
kernel logo.

> +/* 160*43 rounded to nearest whole byte which is 160*48 since bytes are
> +   vertical the y component must be a multiple of 8 */
> +#define G13FB_SIZE (160*48/8)

Minor nit, I think there is a macro for this, DIV_ROUND_UP, or maybe
this could be better done in the function that uses this value.

> +static ssize_t g13_set_mled(struct hid_device *hdev, unsigned mled);

Does this need to be here or can the code be reordered?

> +static struct fb_var_screeninfo g13fb_var = {
> +       .xres = G13FB_WIDTH,
> +       .yres = G13FB_HEIGHT,
> +       .xres_virtual = G13FB_WIDTH,
> +       .yres_virtual = G13FB_HEIGHT,
> +       .bits_per_pixel = 1,
> +       .nonstd = 1,
> +};

I think the nonstd is a bug. Yes, hecubafb and metronomefb seem to
have the same bug as well. nonstd is used if you want something like
FB_NONSTD_HAM or FB_NONSTD_REV_PIX_IN_B, which I don't think is what
you want.

Hope this helps.

Best regards,
jaya
