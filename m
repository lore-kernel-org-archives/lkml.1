Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbXHQRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbXHQRP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXHQRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:15:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:65374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbXHQRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:15:19 -0400
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>
In-Reply-To: <200708170955.06388.david-b@pacbell.net>
References: <200708170823.15894.david-b@pacbell.net>
	 <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
	 <3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
	 <200708170955.06388.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 19:18:46 +0200
Message-Id: <1187371126.4253.10.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19QmtWvM6ltfZXiNAzow0hYoDOHJz8/RTEgz8f
 pfdBRoNEV+43lLjKyvGP0BbGJhK3KnsjpKsngMqPXHGinhQIgT
 aEDhEIsv8P3sGm7kHuw9TnP2bbkDClj
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 09:55 -0700, David Brownell wrote:
> On Friday 17 August 2007, Kay Sievers wrote:
> > Again,
> 
> "Again"?

We exchanges several mails a few weeks ago after the Debian bug caused
by a modprobe loop. 

> > the only sane solution is to provide MODALIAS="platform:<name>" 
> > from the platform bus, and adding the aliases to drivers who support
> > autoloading. Modalias strings are not free-text strings, they are
> > required to be prefixed by the subsystem.
> 
> If so, then whoever tried to change the usage of module aliases
> in that way goofed in several ways.  First, by not changing all
> the in-kernel uses.  Second, by not changing all the out-of-tree
> uses in various distros, toolchains, etc.  Third, by not even
> documenting that change...

Yes, please fix the misuse of MODALIAS.

> Module aliases have been around since very early versions of
> stuff like "modprobe" ... without that new rule.  Aliases have
> always been 	

The environment key MODALIAS= and the sysfs file 'modalias" are part of
the driver core, and have a well defined meaning. And it's a much
younger construct, and _not_ free-text.

> > I still fail to see why platform must be different from everything
> > else in the kernel.
> 
> It isn't.  See above.

Sure, it is. Please prefix it with "platform:".

> > Please change that stuff, and the bugs which we 
> > are fighting magically go away, because module-init-tools alias
> > resolving works like it does for every other subsystem in the kernel.
> 
> Those bugs would be ... what?  "We" haven't observed anything
> attributable to this usage, which has been common for years now.

Loops of modprobe by modules requesting itself, you worked around that
in the recent kernel, but that broke other setups. And module-init-tools
"blacklist" does not work, because platform uses no alias, but a plain
driver name. That should be fixed, please, please, please...

Every distro has problems with platform, and believe me, I as the udev
maintainer, get all the questions and the trouble. Some blacklist the
whole platform event, some only a few devices. All just because platform
thinks it must not follow the rules everybody else plays. Please,
please, please do what everybody else is doing with the driver core.

Thanks again,
Kay

