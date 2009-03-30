Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZC3W6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZC3W6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZC3W6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:58:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbZC3W6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:58:35 -0400
Date: Mon, 30 Mar 2009 15:55:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net,
       Luca Cappa <lcappa@gmail.com>
Subject: Re: axes conversion for hp compaq 8710w for HP_ACCEL linux kernel
 module (fwd)
Message-Id: <20090330155533.ee3e6dae.akpm@linux-foundation.org>
In-Reply-To: <20090321230819.GF12291@elf.ucw.cz>
References: <20090321230819.GF12291@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009 00:08:19 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!

hi to you too.

> It seems like Luca has one  more whitelist entry...
> 								Pavel
> 
> 
> Subject: axes conversion for hp compaq 8710w for HP_ACCEL linux kernel module
> From: Luca Cappa <lcappa@gmail.com>
> 
> 
> Hello,
> 
> I have a laptop HP Compaq 8710W, I compiled into my kernel the
> LIS3LV02DL and HP_ACCEL module drivers. While loading it cannot
> recognize the laptop
> model, so i am sending the necessary information to update the
> database of Axes Orientations.
> 
> >When the laptop is horizontal the position reported is about 0 for X and Y
> >and a positive value for Z
> Yes, it is about 0,0,1000, the actual reading says: (-17,-26,1018);
> 
> > If the left side is elevated, X increases (becomes positive)
> Yes, X goes toward to positive 1000.
> 
> >If the front side (where the touchpad is) is elevated, Y decreases (becomes negative)
> No, Y goes toward to positive 1000.
> 
> >If the laptop is put upside-down, Z becomes negative
> Yes, the laptop on a table Z gives 1000, and if upsidedown the Z reads
> -1000.
> 
> So in few words the Y axis is inverted,  I paste here below the very
> simple patch to configure properly the axis conversion. The patch is
> against the file hp_accel.c of 2.6.29-rc8, i.e. the one shown here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/hwmon/hp_accel.c;h=29c83b5b96974bb88cbeb67d896ba46ee71469f2;hb=HEAD
> 
> Greetings,
> Luca
> 
> 
> --- /home/luca/Desktop/hp_accel.c	2009-03-21 19:28:54.000000000 +0100
> +++ hp_accel.c	2009-03-21 19:31:05.000000000 +010
> @@ -201,6 +201,7 @@
>  			PRODUCT_NAME, "HP Pavilion dv5",
>  			BOARD_NAME, "3600",
>  			y_inverted),
> +    AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
>  	{ NULL, }
>  /* Laptop models witho

- changelog is a mess
- originator wasn't cc'ed
- originator's signed-off-by: is missing
- your signed-off-by: is missing
- patch isn't in `patch -p1' form
- patch is whitespace-mangled

I fixed some of that up.  It'd be nice to get some Signed-off-by:s,
please.

