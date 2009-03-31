Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZCaHSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZCaHSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZCaHSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:18:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:4169 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZCaHSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KmJqsWfbRHAT6WUo80Eex/aTDxMfkFLC2Q1ObHmCNQlOYV4Ekn29EZK+vacWDBJCTO
         yMc6n+5CUjv996xVK+FIrFYwM7tt/xCT41Ic0LKHbZmNSL+Wk2xS19rF8opBZRyGV6WR
         pUpwQSkcXxh8VkSERLcCp7klq+2odAFhca5/I=
MIME-Version: 1.0
In-Reply-To: <20090330220007.GC6540@spock.one.pl>
References: <20090330220007.GC6540@spock.one.pl>
Date: Tue, 31 Mar 2009 09:18:09 +0200
X-Google-Sender-Auth: eb6d9c9cdfa66d8f
Message-ID: <10f740e80903310018v7e12de88m696f07e40dc617e3@mail.gmail.com>
Subject: Re: [PATCH] fbdev: fix color component field length documentation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
       linux-fbdev-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 00:00, Michal Januszewski <spock@gentoo.org> wrote:
> The documentation about the meaning of the color component bitfield lengths
> in pseudocolor modes is inconsistent.  Fix it, so that it indicates the
> correct interpretation everywhere, i.e. that the 1 << length is the number
> of palette entries.
>
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> Cc: Ville Syrjälä <syrjala@sci.fi>
> Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Except for this:

> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -172,8 +172,11 @@ struct fb_fix_screeninfo {
>  /* Interpretation of offset for color fields: All offsets are from the right,
>  * inside a "pixel" value, which is exactly 'bits_per_pixel' wide (means: you
>  * can use the offset as right argument to <<). A pixel afterwards is a bit
> - * stream and is written to video memory as that unmodified. This implies
> - * big-endian byte order if bits_per_pixel is greater than 8.
> + * stream and is written to video memory as that unmodified.
> + *
> + * For pseudocolor, offset is always 0 and length, which should be the same
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is not correct. Offset can be non-zero, e.g. for a 8 bpp frame buffer with
64 palette entries, where the palette index is stored in the upper 6 bits of the
8-bit pixel value, offset would be 2, and length would be 6.
Not that I've seen that (so far)...

> + * for all color components, indicates the number of available palette entries
> + * (i.e. # of entries = 1 << length).
>  */
>  struct fb_bitfield {
>        __u32 offset;                   /* beginning of bitfield        */
>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
