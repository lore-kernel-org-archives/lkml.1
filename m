Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbZCTTza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbZCTTza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZCTTzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:55:19 -0400
Received: from epiphany.epiphan.com ([217.160.251.166]:55795 "EHLO
	epiphany.epiphan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbZCTTzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:55:18 -0400
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U
	 grabbers
From: Mikhail Jiline <misha@epiphan.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
In-Reply-To: <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
References: <1237575285.26159.2.camel@T60p>
	 <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 15:55:12 -0400
Message-Id: <1237578912.26159.13.camel@T60p>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-03-20 at 15:28 -0400, Devin Heitmueller wrote:
> On Fri, Mar 20, 2009 at 2:54 PM, Mikhail Jiline <misha@epiphan.com> wrote:
> > From: Misha Zhilin <misha@epiphan.com>
> >
> > Adds support for Digitus/Plextor PX-AV200U grabbers
> > Signed-off-by: Misha Zhilin <misha@epiphan.com>
> > ---
> >
> > diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c
> > --- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c  2008-10-09 18:13:53.000000000 -0400
> > +++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c   2009-03-04 16:18:03.000000000 -0500
> > @@ -1087,6 +1087,21 @@
> >                        .amux     = EM28XX_AMUX_LINE_IN,
> >                } },
> >        },
> > +       [EM2820_BOARD_PLEXTOR_PX_AV200U] = {
> > +               .name         = "Plextor PX-AV200U",
> > +               .valid        = EM28XX_BOARD_NOT_VALIDATED,
> > +               .vchannels    = 2,
> > +               .decoder      = EM28XX_SAA7113,
> > +               .input          = { {
> > +                       .type     = EM28XX_VMUX_COMPOSITE1,
> > +                       .vmux     = SAA7115_COMPOSITE0,
> > +                       .amux     = EM28XX_AMUX_AC97_LINE_IN,
> > +               }, {
> > +                       .type     = EM28XX_VMUX_SVIDEO,
> > +                       .vmux     = SAA7115_SVIDEO3,
> > +                       .amux     = EM28XX_AMUX_AC97_LINE_IN,
> > +               } },
> > +       },
> >  };
> >  const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
> >
> > Binary files linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/.em28xx-cards.c.swp and linux-2.6.27.x86_64.new/drivers/media/video/em28xx/.em28xx-cards.c.swp differ
> > diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h
> > --- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h        2008-10-09 18:13:53.000000000 -0400
> > +++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h 2009-03-04 15:33:24.000000000 -0500
> > @@ -97,6 +97,8 @@
> >  #define EM2882_BOARD_PINNACLE_HYBRID_PRO         56
> >  #define EM2883_BOARD_KWORLD_HYBRID_A316                  57
> >  #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU     58
> > +#define EM2820_BOARD_PLEXTOR_PX_AV200U            59
> > +
> >
> >  /* Limits minimum and default number of buffers */
> >  #define EM28XX_MIN_BUF 4
> > diff -urN linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx
> > --- linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx  2008-10-09 18:13:53.000000000 -0400
> > +++ linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx   2009-03-18 11:15:00.000000000 -0400
> > @@ -57,3 +57,4 @@
> >  56 -> Pinnacle Hybrid Pro (2)                  (em2882)        [2304:0226]
> >  57 -> Kworld PlusTV HD Hybrid 330              (em2883)        [eb1a:a316]
> >  58 -> Compro VideoMate ForYou/Stereo           (em2820/em2840) [185b:2041]
> > + 59 -> Plextor PX-AV200U                        (em2880)
> >
> > --
> 
> Is this patch incomplete?  Where is the registration for the USB ID of
> the device?

The patch is complete. This device (as many others) doesn't have unique
VID/PID, it uses generic eb1a:2821, which is already associated with
ex28xx (see drivers/media/video/em28xx/em28xx-cards.c:1103)

Regards,
Misha.


