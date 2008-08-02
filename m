Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYHBX6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYHBX6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYHBX6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:58:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36684 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYHBX6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:58:30 -0400
Date: Sat, 2 Aug 2008 19:58:18 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Kconfig no longer outputs a .config with freshly updated
 defconfigs
Message-ID: <20080802195818.7f72583f@zod.rchland.ibm.com>
In-Reply-To: <20080802192646.GR19682@cs181140183.pp.htv.fi>
References: <1217693013.2328.22.camel@localhost.localdomain>
	<20080802192646.GR19682@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008 22:26:47 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Sat, Aug 02, 2008 at 12:03:33PM -0400, Josh Boyer wrote:
> > I was going through the somewhat tedious task of updating the 4xx
> > defconfigs today, and I noticed some odd behavior from Kconfig.
> > Basically, I would do:
> > 
> > 	make ppc44x_defconfig
> > 	make oldconfig
> > 	<build>
> > 	cp .config arch/powerpc/configs/ppc44x_defconfig
> > 	make distclean
> > 
> > I did this for a number of configs.  Then I went back and tried to build
> > ppc44x_defconfig again and I got this result:
> > 
> > [jwboyer@localhost linux-2.6]$ make ppc44x_defconfig
> >   HOSTCC  scripts/basic/fixdep
> >   HOSTCC  scripts/basic/docproc
> >   HOSTCC  scripts/kconfig/conf.o
> >   HOSTCC  scripts/kconfig/kxgettext.o
> >   SHIPPED scripts/kconfig/zconf.tab.c
> >   SHIPPED scripts/kconfig/lex.zconf.c
> >   SHIPPED scripts/kconfig/zconf.hash.c
> >   HOSTCC  scripts/kconfig/zconf.tab.o
> > scripts/kconfig/lex.zconf.c:1628: warning: ‘input’ defined but not used
> >   HOSTLD  scripts/kconfig/conf
> > [jwboyer@localhost linux-2.6]$ make oldconfig
> > scripts/kconfig/conf -o arch/powerpc/Kconfig
> > #
> > # using defaults found in /boot/config-2.6.25.13-104.fc9.ppc64
> > #
> > 
> > There was no .config file present after the initial 'make
> > ppc44x_defconfig', so it defaulted to using something in /boot.  I'm a
> > bit baffled here, but that seems to be common to any newly updated
> > defconfig I've done.
> > 
> > Was there a change to Kconfig recently that won't copy the defconfig
> > file to .config if there are no symbol changes or something like that?
> 
> Thanks for your bug report, this should have worked.
> 
> @Sam:
> I've bisected this and it is caused by
> commit f443d2eccf077afd8a839cc7ed66cc4d520c5f05
> (kconfig: speed up all*config + randconfig).

Thanks Adrian.  I had intended to bisect it this evening, but you beat
me to the punch.

josh
