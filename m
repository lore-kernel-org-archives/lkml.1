Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbYCaSme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbYCaSme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYCaSmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:42:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38036 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973AbYCaSmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:42:22 -0400
Date: Mon, 31 Mar 2008 20:42:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Hellermann <stefan@the2masters.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make O=dir fails with current git
Message-ID: <20080331184247.GC4833@uranus.ravnborg.org>
References: <47EE8829.10409@the2masters.de> <20080331180022.GA4833@uranus.ravnborg.org> <47F12CE9.1090202@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F12CE9.1090202@the2masters.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 08:26:49PM +0200, Stefan Hellermann wrote:
> Sam Ravnborg schrieb:
> > On Sat, Mar 29, 2008 at 07:19:21PM +0100, Stefan Hellermann wrote:
> >> Hi,
> >>
> >> I'm using "make O=machinename" for building different kernels from one tree. About 15 days
> >> ago it was okay, with current git it fails:
> >> $ make O=client1
> >> scripts/kconfig/conf -s arch/x86/Kconfig
> >>   Using /srv/devel/kernel as source for kernel
> >>   /srv/devel/kernel is not clean, please run 'make mrproper'
> >>   in the '/srv/devel/kernel' directory.
> >> make[1]: *** [prepare3] Error 1
> >> make: *** [sub-make] Error 2
> >>
> >> running "make mrproper" (without O=dir) doesn't help.
> >> I've not changed anything, I only made a "git-pull".
> >> Now I'm at home, tried "mkdir test; make O=test defconfig all" with current git-head, it
> >> doesn't work too.
> > 
> > I tried to reproduce this here without luck.
> > The tests performed by kbuild to dertermine if the
> > source directory is clean are very basic.
> > If the file .config exist or the directory
> > include/config exists then the source tree is considered clean.
> > Otherwise you get the above message.
> 
> Hi, damn, it's that easy!
> It was the .config file, I added (as root) a symlink to dir/.config to let some other
> application check if some Kernel-options are set, then the permissions of this symlink
> prevented make mrproper from removing it.
> 
> For what purpose is this check?
The O= build will use the wrong files if the source tree is not clean.
There are several special cases which goes wrong under the wrong circumstances
and therefore this consistency check.

> I can't point the other application to kerneldir/dir
> because it also greps in kerneldir/Makefile for the kernel-version.
They could use:
make kernelversion

and this could be used in the output directory too.

	Sam
