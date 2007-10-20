Return-Path: <linux-kernel-owner+w=401wt.eu-S1765502AbXJTS2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765502AbXJTS2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbXJTS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:28:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39809 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXJTS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:28:36 -0400
Date: Sat, 20 Oct 2007 20:30:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, zippel@linux-m68k.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] xconfig: set title bar
Message-ID: <20071020183009.GB8334@uranus.ravnborg.org>
References: <20071019145528.1cdeb007.randy.dunlap@oracle.com> <20071020171403.GD6855@uranus.ravnborg.org> <20071020111847.a5cfb02c.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020111847.a5cfb02c.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 11:18:47AM -0700, Randy Dunlap wrote:
> On Sat, 20 Oct 2007 19:14:03 +0200 Sam Ravnborg wrote:
> 
> > I found this one to work:
> > +       setCaption("hello my little world");
> 
> Thanks, your search expressions were better than mine.
> 
> > We should show the prompt associated with mainmenu here.
> 
> You want all 3 of them converted to
> 	symbol_value(mainmenu) + $KERNELVERSION

Well - if mainmenu should serve any purpose then yes.


> ?
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Put kernel version info on title bar in xconfig (qconf) instead of
> defaulting to "qconf".
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  scripts/kconfig/qconf.cc |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- linux-2.6.23-git13.orig/scripts/kconfig/qconf.cc
> +++ linux-2.6.23-git13/scripts/kconfig/qconf.cc
> @@ -1274,8 +1274,12 @@ ConfigMainWindow::ConfigMainWindow(void)
>  	QMenuBar* menu;
>  	bool ok;
>  	int x, y, width, height;
> +	char title[256];
>  
>  	QWidget *d = configApp->desktop();
> +	sprintf(title, _("Linux Kernel v%s Configuration"),

I made this look like this:
> +	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration"),

because we may append to the KERNELVERSION using EXTRAVERSION and people could go insane.

	Sam
