Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYCOS5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYCOS5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 14:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYCOS5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 14:57:35 -0400
Received: from mylar.outflux.net ([69.93.193.226]:34804 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYCOS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 14:57:35 -0400
X-Greylist: delayed 2448 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 14:57:35 EDT
Date: Sat, 15 Mar 2008 11:16:38 -0700
From: Bryce Harrington <bryce@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Message-ID: <20080315181638.GT12381@bryceharrington.org>
References: <47D828BB.2000702@gawab.com> <200803141029.38124.jbarnes@virtuousgeek.org> <47DB46F1.80106@gawab.com> <200803151035.23808.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803151035.23808.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-HELO: localhost
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 10:35:23AM -0700, Jesse Barnes wrote:
> [Adding Bryce to cc list, he may have a copy of intel_reg_dumper already built 
> for Ubuntu.  Bryce, please see below for a few more questions, thanks.]
> 
> On Friday, March 14, 2008 8:48 pm Justin Madru wrote:
> > Jesse Barnes wrote:
> > > It would be interesting if you could get register dumps at a couple of
> > > different points, using the intel_reg_dumper tool in
> > > git://git.freedesktop.org/git/xorg/driver/xf86-video-intel (in
> > > src/reg_dumper).
> >
> > I couldn't get it to compile. What am I suppose to do? I ran autogen.sh
> > in the top level dir and it gave the error message:
> >
> > ./configure: line 20486: syntax error near unexpected token `XINERMA,'
> > ./configure: line 20486: `XORG_DRIVER_CHECK_EXT(XINERMA, xineramaproto)'
> 
> This usually means you don't have the xorg autoconf macros installed.  Your 
> distro probably has some sort of xserver-devel package that may include it.

The following command will pull in all the dependencies you need for
building -intel:

 sudo apt-get build-dep xserver-xorg-video-intel
 
> > Then I also tried to run make and make -f Makefile.in (in the reg_dumper
> > dir and top level dir), and it said:
> >
> > Makefile.in:15 *** missing separator. Stop.
> >
> > That part of Makefile.in contains:
> > @SET_MAKE@
> > VPATH = @srcdir@
> >
> > What am I doing wrong? You'll have to forgive me, I'm not that
> > experienced with the cmd line and compiling - I'm trying though.
> 
> No problem, building X still isn't quite as easy as it should be, but it's 
> only slightly more complicated than the typical './configure;make;make 
> install' due to the dependencies between packages.  You can check out the X 
> wiki (wiki.x.org), there are some hints on building things there.
> 
> > > You'll probably have to modify your boot scripts though.
> > > It would be good to get them:
> > >   - at startup time before the splash screen
> > >   - sometime while the splash screen is running
> > >   - after X starts and you see the blank screen
>
> > How exactly would I do that? I would think I could just add command at
> > the end of 3 files in /etc/init.d. Would that work? It should run my
> > command when it starts that script and gets to the end. Or do boot
> > scripts exit in the middle of the script, which would prevent my command
> > from running?
> 
> Hm, I haven't looked at the Ubuntu scripts before.  I know they're using 
> upstart, but if they haven't divered too much from the old style init, you 
> may be able to modify rc.sysinit to get the boot time register dump.
> 
> For the splash screen dump, you'd just have to add the intel_reg_dumper 
> command to one of the other init scripts that runs while the splash screen is 
> up (maybe the HAL daemon script or something).
> 
> Once your screen is blank, it's probably easiest to ssh into your machine and 
> capture the dump that way.
> 
> Hope that helps, maybe Bryce can give you some more hints on Ubuntu specifics.

If you're having troubles while the splash screen is displayed, you may
want to look at / fiddle with the settings in /etc/gdm/gdm.conf.

Also have a look in /etc/gdm/, where the Init, PreSession, and
PostSession scripts are located.  Those are additional places where
scripts can be tied in during this early startup phase.  (I don't know
if that would actually be of use here though.)

Bryce
