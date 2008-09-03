Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYICUUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYICUUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYICUUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:20:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:36325 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYICUUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=dv62tf2iOB3kogCtHFalzprpVRB+1gQ/aTTEieUogOrHco7wmvaw4daKyT8tPqgFnG
         uyZgsGxD3nJOM6MNSCT/5HhQH6+uzFxR7q9K5hAGBMBsI4yWt/6DwGcQPYXBzuaOph78
         Cd2Mtq4Q7/8918WNt5/v7LVahoc61ygNBIs4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] ncurses based config
Date: Wed, 3 Sep 2008 22:18:20 +0200
User-Agent: KMail/1.9.9
Cc: Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Nir Tzachar <nir@tzachar.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> <200809032138.14651.bzolnier@gmail.com> <Pine.LNX.4.64.0809031259110.20541@shark.he.net>
In-Reply-To: <Pine.LNX.4.64.0809031259110.20541@shark.he.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809032218.20298.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008, Randy.Dunlap wrote:
> On Wed, 3 Sep 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> > 
> > Hi,
> > 
> > On Wednesday 03 September 2008, Nir Tzachar wrote:
> > > This patch was inspired by the kernel projects page, where an ncurses
> > > replacement for menuconfig was mentioned (by Sam Ravnborg).
> > > 
> > > Building on menuconfig, this patch implements a more modern look interface using
> > > ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
> > > does not depend on lxdialog, which is currently distributed with the kernel.
> > > 
> > > The only change outside of nconf.c is due to a name clash: both ncurses and
> > > lkc.h define a fucntion named menu_init(). I changed the internal version's
> > > name. 
> > > 
> > > Please consider the patch for merging. Comments are appreciated.
> > 
> > Could you please tell what kernel version is it against?
> 
> It applies cleanly to 2.6.27-rc5-git4 FWIW.
> 
> > I'm getting the following error on make nconfig (and also on make menuconfig
> > which works fine without this patch) with the current Linus' tree:
> > 
> >   HOSTCC  scripts/kconfig/conf.o
> >   HOSTCC  scripts/kconfig/kxgettext.o
> >   HOSTCC  scripts/kconfig/nconf.o
> >   HOSTCC  scripts/kconfig/zconf.tab.o
> > scripts/kconfig/zconf.tab.c: In function ÿÿconf_parseÿÿ:
> > scripts/kconfig/zconf.tab.c:2258: warning: implicit declaration of function ÿÿmenu_initÿÿ
> >   HOSTLD  scripts/kconfig/nconf
> > scripts/kconfig/nconf arch/x86/Kconfig
> > make[1]: *** [nconfig] Segmentation fault
> > make: *** [nconfig] Error 2
> 
> Need to change all /menu_init/ in zconf.tab.c* to /_menu_init/.

Thanks, this fixed it.

> Need to strip trailing whitespace on new source code lines.
> 
> I'm seeing cyan (?) foreground on black background.  Is that the colors
> that were planned?
> 
> Instructions are dark blue on black -- cannot read them.

Yeah.  Additionally the main window for selecting options
is limited to ~40 characters x 5 lines.  Is this intended?

Also it seems that hotkeys are not highlighted/working... :(

Thanks,
Bart
