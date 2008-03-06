Return-Path: <linux-kernel-owner+w=401wt.eu-S935369AbYCFSIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369AbYCFSIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935276AbYCFSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:07:52 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:44324 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935264AbYCFSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:07:50 -0500
Date: Thu, 6 Mar 2008 19:07:34 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev-devel@lists.sourceforge.net
cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       Randy Dunlap <randy.dunlap@oracle.com>, adaplas@gmail.com,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/1 try#2] [VIDEO/FRAMEBUFFER]: add
 BF52x EZkit Display driver
In-Reply-To: <386072610803060850i2e0b6e35q7e05448d5fd39bca@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803061906210.20407@anakin>
References: <1201686800-31739-1-git-send-email-bryan.wu@analog.com>
 <20080130083820.c1bcbc14.randy.dunlap@oracle.com> <1201711783.6463.11.camel@roc-laptop>
 <20080305230223.920765e9.akpm@linux-foundation.org>
 <386072610803060850i2e0b6e35q7e05448d5fd39bca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Bryan Wu wrote:
> On Wed, Mar 5, 2008 at 11:02 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 31 Jan 2008 00:49:43 +0800 Bryan Wu <bryan.wu@analog.com> wrote:
> >  > +     fbinfo =
> >  > +         framebuffer_alloc(sizeof(struct bfin_t350mcqbfb_info), &pdev->dev);
> >  > +     if (!fbinfo) {
> >  > +             ret = -ENOMEM;
> >  > +             goto out2;
> >  > +     }

    [...]

> >  > +     fbinfo->pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
> >  > +     if (!fbinfo->pseudo_palette) {
> >  > +             printk(KERN_ERR DRIVER_NAME
> >  > +                    "Fail to allocate pseudo_palette\n");
> >  > +
> >  > +             ret = -ENOMEM;
> >  > +             goto out4;
> >  > +     }
> >  > +
> >  > +     memset(fbinfo->pseudo_palette, 0, sizeof(u32) * 16);
> >
> >  You just invented kzalloc!
> >
> 
> Right

Alternatively, you could embed the pseudo palette inside struct
bfin_t350mcqbfb_info, so it's allocated by the framebuffer_alloc() call
above.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
