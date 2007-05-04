Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXEDHu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXEDHu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXEDHu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:50:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59958 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965698AbXEDHuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:50:25 -0400
Date: Fri, 4 May 2007 09:46:22 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <Pine.LNX.4.58.0705031826360.32689@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.61.0705040944550.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost>
 <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost>
 <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
 <20070503204942.GB18539@uranus.ravnborg.org> <Pine.LNX.4.64.0705040212080.1479@scrub.home>
 <Pine.LNX.4.58.0705031826360.32689@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 18:40, Trent Piepho wrote:
>
>How about these examples:
>
>menuconfig FOO
>if FOO
>config A
>	depends on FOO
>endif
>config B
>if FOO
>config C
>	depends on FOO
>endif

This does not work as expected in ncurses-menuconfig either.
It does not even need a "menuconfig" object for that, something
as simple as

config A
config B
config C
  depends on A

prints it

A
B
C

rather than

A
\_ C
B

which is why some of my menuconfig patches _move_ C to not come after B.

>How does it show the first one, keeping the config entries in the correct
>order and put them into the menu at the same time?
>
>And which of what should the second be show?
>
>foo
>\-bar
>  \-baz
>
>or
>
>foo
>|-bar
>\-baz
>
>There is no question with menus, as the menu tree is clearly lexically
>defined by the matching menu / endmenu pairs.  But menuconfig doesn't work
>that way, and it seems like it would make more sense if it did.
>

Jan
-- 
