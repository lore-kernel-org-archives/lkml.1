Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXBVBHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXBVBHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932935AbXBVBHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:07:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53489 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbXBVBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:07:47 -0500
Date: Thu, 22 Feb 2007 01:07:38 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Yaroslav Halchenko <lists@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
In-Reply-To: <1172104471.5790.57.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702220054460.17121@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com> 
 <20070219000412.acad13de.akpm@linux-foundation.org> 
 <1171876788.6046.3.camel@localhost.localdomain>  <20070221055648.GM25659@washoe.onerussian.com>
 <1172104471.5790.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, 2007-02-21 at 00:56 -0500, Yaroslav Halchenko wrote:
> > I didn't mention 2.6.20-mm1 and got to see -mm2 so it is the one which
> > Iv'e tried, but, once again, I experienced the same issue with 19-mm?
> > kernels.
> > 
> > I built 2.6.20-mm2 without backlight support
> > $> grep BACKLIGH /boot/config-2.6.20-mm2 
> > # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> > # CONFIG_FB_BACKLIGHT is not set
> > # CONFIG_FB_RIVA_BACKLIGHT is not set
> > # CONFIG_FB_RADEON_BACKLIGHT is not set
> > 
> > that "eliminated" the problem. Also I can see the screen with pure
> > 2.6.20 with backlight support (whatever it does since after
> > loading lcd, backlight modules, my /sys/class/{lcd,backlight} are empty):
> > 
> > *$> grep BACKLIGH /boot/config-2.6.20 
> > # CONFIG_FB_BACKLIGHT is not set
> > CONFIG_BACKLIGHT_LCD_SUPPORT=y
> > CONFIG_BACKLIGHT_CLASS_DEVICE=m
> > CONFIG_BACKLIGHT_DEVICE=y
> > 
> > 
> > > Also, do you normally see files under /sys/class/lcd?
> > nope... after I load lcd module, no files under :-/ regardless either it
> > is mm or not. But there are files under /sys/class/backlight/ for mm2
> > compiled with backlight support (whenever the screen is dark as per my
> > original email)
> 
> There should be no files appearing under /sys/class/lcd, so thats all
> normal. There is another report with similar symptoms which also sounds
> like enabling the following options are at fault:

Correct. LCD class was never used by anyone.
 
> # CONFIG_FB_RIVA_BACKLIGHT is not set
> # CONFIG_FB_RADEON_BACKLIGHT is not set
> 
> I suspect these options only work on certain hardware and aren't
> generic. James, any idea what hardware these do/don't work with?
> 
> Worst case, we set them to depend on PMAC_BACKLIGHT again I guess...

   Ug. Previously it did the selecting for you. If you selected 
backlight support the fbdev backlight would just come to life. This caused 
problems for the case of having ACPI backlight and a fbdev driver with 
backlight support. Two drivers controling the same hardware is not the
greatest idea. I made it so that people explictly had to pick the backlight
with a fbdev device. The other reason for this change was not every 
one is using a LCD display. I have a system at home that uses a CRT. 
   Plus their is the case of "standard" PC graphics cards being used 
in embedded devices. In this case even tho the graphics card has backlight 
support the external lcd/backlight is routed through gpio independent of 
the embedded graphics card. In such case we don't want to enable the
backlight for the graphics card but enable it.
    In a nut shell the solution is select the backlight support for your
fbdev driver if you need it.
