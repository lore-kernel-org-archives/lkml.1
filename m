Return-Path: <linux-kernel-owner+w=401wt.eu-S1423590AbXEDBlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423590AbXEDBlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 21:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423581AbXEDBlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 21:41:00 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:34044 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423557AbXEDBk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 21:40:59 -0400
Date: Thu, 3 May 2007 18:40:58 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Roman Zippel <zippel@linux-m68k.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <Pine.LNX.4.64.0705040212080.1479@scrub.home>
Message-ID: <Pine.LNX.4.58.0705031826360.32689@shell2.speakeasy.net>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost>
 <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost>
 <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
 <20070503204942.GB18539@uranus.ravnborg.org> <Pine.LNX.4.64.0705040212080.1479@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Roman Zippel wrote:
> I don't quite understand. With the menuconfig changes more menu entries
> should  appear on the left side, so I don't understand why you have to
> "drill down" to reach it.
> The rule for menu to appear on the left side is relatively simple - all
> its parents must be of menu type as well. So if a menuconfig is on the
> right side it must have a normal config entry as parent.

I think that's it.  The media tree was done with options to select the core
system module, then a menuconfig that depended on that which the drivers
were under.

> > > menuconfig XXXX
> > > if XXXX
> > > [....all the other options....]
> > > endif
> > >
> > > Into this:
> > >
> > > menuconfig XXXX
> > > [....all the other options....]
> > > endmenu
> > >
> > > The reason is that a frontend would easily be able to understand the coupling
> > > between the "menuconfig XXXX" and the "if XXXX".  It will make it easier for
> > > the frontend to see that all the options are inside and controlled by the
> > > enclosing menuconfig.
>
> If the frontend wants to change the behaviour of a menuconfig, it can
> already do that, so this doesn't require a syntax change.

How about these examples:

menuconfig FOO
if FOO
config A
	depends on FOO
endif
config B
if FOO
config C
	depends on FOO
endif

Or this:
menu FOO
menuconfig BAR
config A
menuconfig BAZ
config B
endmenu

How does it show the first one, keeping the config entries in the correct
order and put them into the menu at the same time?

And which of what should the second be show?

foo
\-bar
  \-baz

or

foo
|-bar
\-baz

There is no question with menus, as the menu tree is clearly lexically
defined by the matching menu / endmenu pairs.  But menuconfig doesn't work
that way, and it seems like it would make more sense if it did.
