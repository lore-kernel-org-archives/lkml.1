Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0BLPW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:22:57 -0500
Received: from smtp.nokia.com ([192.100.105.134]:58810 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab0BLPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:22:55 -0500
Subject: Re: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display for
 DEVKIT8000
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Thomas Weber <swirl@gmx.li>, Thomas Weber <weber@corscience.de>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <45a44e481002112155u68c806beg9fe0a3a122d09d25@mail.gmail.com>
References: <1265917278-22011-1-git-send-email-swirl@gmx.li>
	 <45a44e481002112155u68c806beg9fe0a3a122d09d25@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 12 Feb 2010 17:25:43 +0200
Message-ID: <1265988343.2433.312.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2010 15:22:45.0395 (UTC) FILETIME=[3A205630:01CAABF7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 06:55 +0100, ext Jaya Kumar wrote:
> On Fri, Feb 12, 2010 at 3:41 AM, Thomas Weber <swirl@gmx.li> wrote:

[snip]

> > +
> > +static struct omap_video_timings innolux_at_timings = {
> > +       .x_res          = 800,
> > +       .y_res          = 480,
> > +
> > +       .pixel_clock    = 40000,
> > +
> > +       .hsw            = 48,
> > +       .hfp            = 1,
> > +       .hbp            = 1,
> > +
> > +       .vsw            = 3,
> > +       .vfp            = 12,
> > +       .vbp            = 25,
> > +};
> > +
> > +static int innolux_at_panel_probe(struct omap_dss_device *dssdev)
> > +{
> > +       dssdev->panel.config = OMAP_DSS_LCD_TFT | OMAP_DSS_LCD_IVS |
> > +               OMAP_DSS_LCD_IHS;
> > +       dssdev->panel.acb = 0x28;
> > +       dssdev->panel.timings = innolux_at_timings;
> > +
> > +       return 0;
> > +}
> > +
> 
> Hi Thomas, Tomi,
> 
> Just curious, does this patch imply that code like this needs to be
> written for every single LCD type and resolution that can be connected
> to omap2? Maybe there is a better way, like a common table of timings
> and values that can be selected with a module option or even
> autodetected.

Yes, it is true that currently you need to write these for every LCD. I
have been thinking this issue, and I think we can make a common driver. 

However, it's not just selecting timings, as LCDs can have also other
characteristics than just the video timings. For example, some may have
power on/off line, some reset enable/disable, some need 50ms after
reset, some 80ms after reset etc.

But if we manage to get a sane set of those settings into the table, we
could perhaps cover most of the "dummy" LCDs with it.

This change doesn't probably need any changes to the DSS core, only for
the panel driver. Any takers for this task? =) 

 Tomi


