Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbXBVJqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbXBVJqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXBVJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:46:35 -0500
Received: from tim.rpsys.net ([194.106.48.114]:36027 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXBVJqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:46:34 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: James Simmons <jsimmons@infradead.org>
Cc: Yaroslav Halchenko <lists@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0702220054460.17121@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <20070221055648.GM25659@washoe.onerussian.com>
	 <1172104471.5790.57.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702220054460.17121@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:46:05 +0000
Message-Id: <1172137565.5837.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 01:07 +0000, James Simmons wrote:
> > # CONFIG_FB_RIVA_BACKLIGHT is not set
> > # CONFIG_FB_RADEON_BACKLIGHT is not set
> > 
> > I suspect these options only work on certain hardware and aren't
> > generic. James, any idea what hardware these do/don't work with?
> > 
> > Worst case, we set them to depend on PMAC_BACKLIGHT again I guess...
> 
>    Ug. Previously it did the selecting for you. If you selected 
> backlight support the fbdev backlight would just come to life. This caused 
> problems for the case of having ACPI backlight and a fbdev driver with 
> backlight support. Two drivers controling the same hardware is not the
> greatest idea. I made it so that people explictly had to pick the backlight
> with a fbdev device. The other reason for this change was not every 
> one is using a LCD display. I have a system at home that uses a CRT. 
>    Plus their is the case of "standard" PC graphics cards being used 
> in embedded devices. In this case even tho the graphics card has backlight 
> support the external lcd/backlight is routed through gpio independent of 
> the embedded graphics card. In such case we don't want to enable the
> backlight for the graphics card but enable it.
>     In a nut shell the solution is select the backlight support for your
> fbdev driver if you need it.

This is ugly for distribution maintainers as pick the wrong Kconfig
options and your device breaks. You need a different build depending on
the hardware you have. 

I understand some people need to be able to turn these things on but it
sounds like the majority of users don't need it and it will break things
for them. The config option sounds tempting to them though...

In case anyone else is wondering, the commit in question is
http://git.o-hand.com/?p=linux-rpurdie-backlight;a=commitdiff;h=e0e34ef7f02915cfe50e501e9f32c24217177a96
and previously, all the appropriate entries had "depends PMAC_BACKLIGHT"

I think the way forward is going to be to have the backlights disabled
by default at runtime and require enabling through a framebuffer module
parameter. The should be enabled by default in the PMAC_BACKLIGHT case.
Anyone needing it can then pass the appropriate parameter. Does that
sound like the best solution?

Cheers,

Richard

