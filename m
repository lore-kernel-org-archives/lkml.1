Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZCTT2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZCTT2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZCTT2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:28:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:53535 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZCTT2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wmo78O5xH0KAUg3FBizi3IgHq1I7juKxI/aZNDlRGuoTghXO67KvO/6LWgdQH4aC9s
         S2ep/bUGwSh8Ilb476BHHHWjSh4vHh3Gf6/PDFtAxcUFmCzqjiiQ9qXoZ5PvOVa/EYGB
         OtA5UmOZH8EYrEBRF0pxmdsnpD0gLentzkYjg=
MIME-Version: 1.0
In-Reply-To: <1237575285.26159.2.camel@T60p>
References: <1237575285.26159.2.camel@T60p>
Date: Fri, 20 Mar 2009 15:28:18 -0400
Message-ID: <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U 
	grabbers
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mikhail Jiline <misha@epiphan.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 2:54 PM, Mikhail Jiline <misha@epiphan.com> wrote:
> From: Misha Zhilin <misha@epiphan.com>
>
> Adds support for Digitus/Plextor PX-AV200U grabbers
> Signed-off-by: Misha Zhilin <misha@epiphan.com>
> ---
>
> diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c
> --- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c  2008-10-09 18:13:53.000000000 -0400
> +++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c   2009-03-04 16:18:03.000000000 -0500
> @@ -1087,6 +1087,21 @@
>                        .amux     = EM28XX_AMUX_LINE_IN,
>                } },
>        },
> +       [EM2820_BOARD_PLEXTOR_PX_AV200U] = {
> +               .name         = "Plextor PX-AV200U",
> +               .valid        = EM28XX_BOARD_NOT_VALIDATED,
> +               .vchannels    = 2,
> +               .decoder      = EM28XX_SAA7113,
> +               .input          = { {
> +                       .type     = EM28XX_VMUX_COMPOSITE1,
> +                       .vmux     = SAA7115_COMPOSITE0,
> +                       .amux     = EM28XX_AMUX_AC97_LINE_IN,
> +               }, {
> +                       .type     = EM28XX_VMUX_SVIDEO,
> +                       .vmux     = SAA7115_SVIDEO3,
> +                       .amux     = EM28XX_AMUX_AC97_LINE_IN,
> +               } },
> +       },
>  };
>  const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
>
> Binary files linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/.em28xx-cards.c.swp and linux-2.6.27.x86_64.new/drivers/media/video/em28xx/.em28xx-cards.c.swp differ
> diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h
> --- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h        2008-10-09 18:13:53.000000000 -0400
> +++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h 2009-03-04 15:33:24.000000000 -0500
> @@ -97,6 +97,8 @@
>  #define EM2882_BOARD_PINNACLE_HYBRID_PRO         56
>  #define EM2883_BOARD_KWORLD_HYBRID_A316                  57
>  #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU     58
> +#define EM2820_BOARD_PLEXTOR_PX_AV200U            59
> +
>
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4
> diff -urN linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx
> --- linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx  2008-10-09 18:13:53.000000000 -0400
> +++ linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx   2009-03-18 11:15:00.000000000 -0400
> @@ -57,3 +57,4 @@
>  56 -> Pinnacle Hybrid Pro (2)                  (em2882)        [2304:0226]
>  57 -> Kworld PlusTV HD Hybrid 330              (em2883)        [eb1a:a316]
>  58 -> Compro VideoMate ForYou/Stereo           (em2820/em2840) [185b:2041]
> + 59 -> Plextor PX-AV200U                        (em2880)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Is this patch incomplete?  Where is the registration for the USB ID of
the device?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
