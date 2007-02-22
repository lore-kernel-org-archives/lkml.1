Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXBVPSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXBVPSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXBVPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:18:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48730 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXBVPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:18:34 -0500
Date: Thu, 22 Feb 2007 15:18:25 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Yaroslav Halchenko <lists@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
In-Reply-To: <1172137565.5837.24.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702221502190.29542@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com> 
 <20070219000412.acad13de.akpm@linux-foundation.org> 
 <1171876788.6046.3.camel@localhost.localdomain>  <20070221055648.GM25659@washoe.onerussian.com>
  <1172104471.5790.57.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0702220054460.17121@pentafluge.infradead.org>
 <1172137565.5837.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >    Ug. Previously it did the selecting for you. If you selected 
> > backlight support the fbdev backlight would just come to life. This caused 
> > problems for the case of having ACPI backlight and a fbdev driver with 
> > backlight support. Two drivers controling the same hardware is not the
> > greatest idea. I made it so that people explictly had to pick the backlight
> > with a fbdev device. The other reason for this change was not every 
> > one is using a LCD display. I have a system at home that uses a CRT. 
> >    Plus their is the case of "standard" PC graphics cards being used 
> > in embedded devices. In this case even tho the graphics card has backlight 
> > support the external lcd/backlight is routed through gpio independent of 
> > the embedded graphics card. In such case we don't want to enable the
> > backlight for the graphics card but enable it.
> >     In a nut shell the solution is select the backlight support for your
> > fbdev driver if you need it.
> 
> This is ugly for distribution maintainers as pick the wrong Kconfig
> options and your device breaks. You need a different build depending on
> the hardware you have. 

Distros would have to enable "standard" backlights to maximize their 
target machines. In other words they will aim for backlights from the ACPI layer 
for x86_64/ia32 machine and pmac_backlights for select ppc machines.
Specially since most default kernels on distros use only vgacon for intel 
type machines.

> I understand some people need to be able to turn these things on but it
> sounds like the majority of users don't need it and it will break things
> for them. The config option sounds tempting to them though...
> 
> In case anyone else is wondering, the commit in question is
> http://git.o-hand.com/?p=linux-rpurdie-backlight;a=commitdiff;h=e0e34ef7f02915cfe50e501e9f32c24217177a96
> and previously, all the appropriate entries had "depends PMAC_BACKLIGHT"
> 
> I think the way forward is going to be to have the backlights disabled
> by default at runtime and require enabling through a framebuffer module
> parameter. The should be enabled by default in the PMAC_BACKLIGHT case.
> Anyone needing it can then pass the appropriate parameter. Does that
> sound like the best solution?

That is the correct solution. Basically people that select PMAC_BACKLIGHT
expect there driver to automatically to work. Basically they want 
PMAC_BACKLIGHT to work as a generic selectfor there card. I will work up a 
patch.

