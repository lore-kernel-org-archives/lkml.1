Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbXECUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbXECUsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXECUsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:48:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43421 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbXECUsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:48:52 -0400
Date: Thu, 3 May 2007 22:49:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trent Piepho <xyzzy@speakeasy.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II - DVB
Message-ID: <20070503204942.GB18539@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost> <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net> <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost> <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr> <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please include Roman Zippel when you propose kconfig changes.

	Sam
> 
> Jan, have you looked at the effect these changes have when using xconfig, and
> not just menuconfig?
> 
> While your changes make menuconfig better, they have nearly opposite effect on
> xconfig.
> 
> xconfig has the menu tree display in the left panel, where one can see the
> overall layout of the menu tree and jump directly to any menu (even one
> multiple levels deep).  All the menuconfigs that used to be menus don't show
> up here anymore.
> 
> To turn a menuconfig off, you must go to the top level menu containing the
> menuconfig you want (and you must know which one that is!).  Then you have to
> drill down through each menu level one by one, by finding that menu in the top
> panel (which also has all the config options listed) and clicking on it to get
> to the next one.  When you get to the menuconfig you want, you must enter it
> and then you finally get the box to turn that menuconfig off.
> 
> It looks like your changes are going in, so I suppose the solution is to
> improve the way xconfig handles "menuconfig".
> 
> I wonder, would it be possible to change the kconfig language so that:
> menuconfig XXXX
> 	boolean "name of menu"
> 
> Did the same thing as:
> config XXXX
> 	boolean "name of menu"
> menu "name of menu"
> 	depends on XXXX
> 
> This way you could change this:
> 
> menuconfig XXXX
> if XXXX
> [....all the other options....]
> endif
> 
> Into this:
> 
> menuconfig XXXX
> [....all the other options....]
> endmenu
> 
> The reason is that a frontend would easily be able to understand the coupling
> between the "menuconfig XXXX" and the "if XXXX".  It will make it easier for
> the frontend to see that all the options are inside and controlled by the
> enclosing menuconfig.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
