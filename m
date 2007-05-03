Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXECMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXECMh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXECMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:37:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44885 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbXECMhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:37:23 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
	DVB
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>
	 <1178129426.29579.17.camel@localhost>
	 <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
	 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=utf-8
Date: Thu, 03 May 2007 09:37:00 -0300
Message-Id: <1178195820.12651.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qui, 2007-05-03 às 08:56 +0200, Jan Engelhardt escreveu:
> On May 2 2007 14:38, Trent Piepho wrote:
> >On Wed, 2 May 2007, Mauro Carvalho Chehab wrote:
> >> Em Seg, 2007-04-30 às 14:30 +0200, Jan Engelhardt escreveu:
> >> > Change Kconfig objects from "menu, config" into "menuconfig" so
> >> > that the user can disable the whole feature without having to
> >> > enter the menu first.
> >> >
> >> > Also remove one indirection (CONFIG_DVB) that does not seem to
> >> > be really used inside the kernel.
> >>
> >> Hmm.. in fact, it becames harder to unselect DVB, at least on my tests.
> >> The patch bellow solved the issue. It also allows keeping core DVB,
> >> disabling the adapters menu.
> >>
> >> If nobody is against, I intend to apply both Jan and the patch bellow on
> >> my tree by tomorrow.
> >
> >The v4l-dvb build system doesn't support menuconfig yet.
> >I'm pretty sure stuff like:
> >if VIDEO_CAPTURE_DRIVERS
> >will not work correctly either.
> 
> Have you actually tried running `make menuconfig` ['menuconfig' works
> -- unfortunate misnaming between menuconfig and menuconfig though],
> and looked at Documentation/kbuild/ [explains if..endif]?
> menuconfig-if-...-endif is also used in other Kconfig files, and I
> did not have problems building a kernel out of it.

Trent is mentioning an out-of-tree building system to allow easier
testing of V4L/DVB patches by end users and developers and during driver
development time. The building system allows faster
compilation/linkedition during driver development, by allowing you to
use:
	make menuconfig/qconfig/xconfig

inside the tree, unselecting the drivers that you're not working.

This way, our building system allows testing Kconfig menus, and properly
process Kconfig items for building drivers. 

The point rised by Trent is that, currently, this is not prepared to
handle the "menuconfig" and "if/endif" tags.

However, the v4l-dvb building system shouldn't stop improvements at the
kernel building system. So, if there are any limits there, the proper
solution is to fix the issues, instead of avoiding patches that could
break it.

> Jan
-- 
Cheers,
Mauro

