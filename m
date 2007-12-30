Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXL3Ulw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXL3Ulw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXL3Ulo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:41:44 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42918 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXL3Ulo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:41:44 -0500
Date: Sun, 30 Dec 2007 22:41:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: devzero@web.de, linux-kernel@vger.kernel.org
Subject: Re: allmodconfig:  udev won`t start due to CONFIG_UNIX=m
Message-ID: <20071230204134.GA17670@does.not.exist>
References: <77171111@web.de> <Pine.LNX.4.64.0712302112510.2093@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712302112510.2093@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 09:18:38PM +0100, Jan Engelhardt wrote:
> 
> On Dec 30 2007 21:11, devzero@web.de wrote:
> >
> >i build a kernel with allmodconfig and didn`t get my system to boot with that.
> >
> >after some investigation i found that it was due to udev:
> >
> >udevd[1226]: init_udev_socket: error getting socket: Address family not supported by protocol 
> >
> >this was missing support UNIX DOMAIN SOCKETS at boot time.
> >easy - so i added unix.ko to my initrd.
> >
> >but that didn`t make a difference. Still same error with udev.
> >
> >seems, there are others who stepped into this trap and someone telling, unix domain sockets cannot be modular
> >https://forums.gentoo.org/viewtopic-t-476363-highlight-.html
> >https://forums.gentoo.org/viewtopic-t-463793-highlight-.html
> >
> >
> >since we have 1206 options set to "Y" anyway, would it make sense to remove module support for Unix Domain Sockets ?
> >opensuse103:/home/kernel/linux-2.6.23 # cat .config.allmodconfig |grep "=y" |wc -l
> >1206
> >opensuse103:/home/kernel/linux-2.6.23 # cat .config.allmodconfig |grep "=m" |wc -l
> >2098
> >
> >i also came across this one:
> >
> >http://readlist.com/lists/vger.kernel.org/linux-kernel/41/205717.html
> >
> 
> I'd rather much do in the Kconfig:
> 
> config UNIX
> 	tristate "UNIX domain sockets" if I_KNOW_WHAT_I_AM_DOING # currently called CONFIG_EMBEDDED
> 	bool "UNIX domain sockets"

CONFIG_EMBEDDED is _not_ a generic "advanced user" option, it's only for 
options that allow additional space savings.

What you could actually do would be

config UNIX
	bool "Unix domain sockets" if EMBEDDED
	default y

since as the help text already says everything other than Y is expected 
to cause problems - and if people know they are in a space limited 
environment and really don't need it they'll still be able to disable it.

As a bonus, making it a bool would allow to make the kernel image 
slightly smaller for everyone.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

