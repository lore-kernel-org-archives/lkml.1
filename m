Return-Path: <linux-kernel-owner+w=401wt.eu-S1767523AbXEDA24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767523AbXEDA24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767524AbXEDA24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:28:56 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4733 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767523AbXEDA2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:28:54 -0400
Date: Fri, 4 May 2007 02:28:39 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <20070503204942.GB18539@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705040212080.1479@scrub.home>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost>
 <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost>
 <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
 <20070503204942.GB18539@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2007, Sam Ravnborg wrote:

> Please include Roman Zippel when you propose kconfig changes.

Thanks, the lkml volume lately forces me to skip a lot, so it's quite 
possible I miss something. :)

> > xconfig has the menu tree display in the left panel, where one can see the
> > overall layout of the menu tree and jump directly to any menu (even one
> > multiple levels deep).  All the menuconfigs that used to be menus don't show
> > up here anymore.
> > 
> > To turn a menuconfig off, you must go to the top level menu containing the
> > menuconfig you want (and you must know which one that is!).  Then you have to
> > drill down through each menu level one by one, by finding that menu in the top
> > panel (which also has all the config options listed) and clicking on it to get
> > to the next one.  When you get to the menuconfig you want, you must enter it
> > and then you finally get the box to turn that menuconfig off.
> > 
> > It looks like your changes are going in, so I suppose the solution is to
> > improve the way xconfig handles "menuconfig".

I don't quite understand. With the menuconfig changes more menu entries 
should  appear on the left side, so I don't understand why you have to 
"drill down" to reach it.
The rule for menu to appear on the left side is relatively simple - all 
its parents must be of menu type as well. So if a menuconfig is on the 
right side it must have a normal config entry as parent.

> > I wonder, would it be possible to change the kconfig language so that:
> > menuconfig XXXX
> > 	boolean "name of menu"
> > 
> > Did the same thing as:
> > config XXXX
> > 	boolean "name of menu"
> > menu "name of menu"
> > 	depends on XXXX
> > 
> > This way you could change this:
> > 
> > menuconfig XXXX
> > if XXXX
> > [....all the other options....]
> > endif
> > 
> > Into this:
> > 
> > menuconfig XXXX
> > [....all the other options....]
> > endmenu
> > 
> > The reason is that a frontend would easily be able to understand the coupling
> > between the "menuconfig XXXX" and the "if XXXX".  It will make it easier for
> > the frontend to see that all the options are inside and controlled by the
> > enclosing menuconfig.

If the frontend wants to change the behaviour of a menuconfig, it can 
already do that, so this doesn't require a syntax change.

bye, Roman
