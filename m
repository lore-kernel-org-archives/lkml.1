Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbXJTSKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbXJTSKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXJTSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:10:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38550 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbXJTSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:10:28 -0400
Date: Sat, 20 Oct 2007 20:12:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, zippel@linux-m68k.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] xconfig: set title bar
Message-ID: <20071020181202.GA8334@uranus.ravnborg.org>
References: <20071019145528.1cdeb007.randy.dunlap@oracle.com> <20071020171403.GD6855@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020171403.GD6855@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 07:14:03PM +0200, Sam Ravnborg wrote:
> On Fri, Oct 19, 2007 at 02:55:28PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > menuconfig and gconfig already place a title (or caption) on the top
> > bar of their window (or whatever that is properly called).  However,
> > qconf (xconfig) just says "qconf".  I tried to find a Qt API to set
> > the title but did not find one, so set the program title (caption)
> > by using the "-title <caption>" command line option instead.
> 
> I found this one to work:
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index e4eeb59..4905cd1 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -1277,6 +1277,7 @@ ConfigMainWindow::ConfigMainWindow(void)
>  
>         QWidget *d = configApp->desktop();
>  
> +       setCaption("hello my little world");
>         width = configSettings->readNumEntry("/window width", d->width() - 64);
>         height = configSettings->readNumEntry("/window height", d->height() - 64);
>         resize(width, height);
> 
> We should show the prompt associated with mainmenu here.

After a closer looks it revealed that kconfig does not even save
the mainmenu prompt?!??!
See following snippet from zconf.y:

stmt_list:
	  /* empty */
	| stmt_list common_stmt
	| stmt_list choice_stmt
	| stmt_list menu_stmt
	| stmt_list T_MAINMENU prompt nl

So it seems no frontend displays the mainmenu prompt.

	Sam
