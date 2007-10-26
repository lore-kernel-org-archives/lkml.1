Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXJZTDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXJZTDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXJZTD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:03:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46760 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXJZTD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:03:26 -0400
Date: Fri, 26 Oct 2007 21:05:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Check handling of kernel build output directory
Message-ID: <20071026190500.GA23480@uranus.ravnborg.org>
References: <fft89p$rko$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fft89p$rko$1@ger.gmane.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus.

> Two ways are mentioned in the Makefile for the Linux kernel 2.6.31.1 to specify output
> diretories. The description of the environment variable "KBUILD_OUTPUT" is missing from
> the file "README".

It is on purpose left out - README contains only the most typical stuff.
And no-one has written a "everything you possible want to know about building the kernel"
text yet for some reason :-(

> 
> I am trying to generate all executable files for the current stable kernel release on my
> openSUSE 10.3 system.
> 
> Sonne:/usr/src/linux # make mrproper
> Sonne:/usr/src/linux # cp -p /boot/config-2.6.23.1-0-adjusted .config
> [reactivate backup copy]
> 
> Sonne:/usr/src/linux # export KBUILD_OUTPUT=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted
> Sonne:/usr/src/linux # make silentoldconfig
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>   GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTCC  scripts/kconfig/kxgettext.o
>   SHIPPED scripts/kconfig/zconf.tab.c
>   SHIPPED scripts/kconfig/lex.zconf.c
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -s arch/x86_64/Kconfig
> ***
> *** You have not yet configured your kernel!
> *** (missing kernel .config file)
> ***
> *** Please run some configurator (e.g. "make oldconfig" or
> *** "make menuconfig" or "make xconfig").
> ***
> make[2]: *** [silentoldconfig] Error 1
> make[1]: *** [silentoldconfig] Error 2
> make: *** [silentoldconfig] Error 2
> 
So here you do not have a .config file in the directory: /usr/src/obj/linux/2.6.23.1/x86_64/adjusted
So you are told to create one using some of the available methods.


> Another try:
> Sonne:/usr/src/linux # make oldconfig
> [...]
> #
> # configuration written to .config
> #
> Sonne:/usr/src/linux # date && echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make -j4
> && echo YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && make -j4 modules_install install &&
> echo ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ && date
> Fri Oct 26 18:38:18 CEST 2007
> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
>   GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
> scripts/kconfig/conf -s arch/x86_64/Kconfig
>   GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86_64
>   Using /usr/src/linux-2.6.23.1 as source for kernel
>   /usr/src/linux-2.6.23.1 is not clean, please run 'make mrproper'
>   in the '/usr/src/linux-2.6.23.1' directory.
> make[1]: *** [prepare3] Error 1
> make: *** [_all] Error 2

Here kbuild tells you that "/usr/src/linux-2.6.23.1 is not clean".
This is another way to tell you that the kernel source you are using contains
files that will cause your build to fail later on.
The suggested way to fix it is to run "make mrproper" but in your case you
would then delete all the output files of your vendor supplied kernel.
What you should do in your case is to:
1) Take a full copy of the kernel tree
2) run "make mrproper" in the tree
3) Copy over your adjusted .config
4) make

Then a few minutes later you have a kernel and maybe a few modules.
To install them either use sudo or do so as root:
sudo make modules_install
sudo make install

> make: INTERNAL: Exiting with 5 jobserver tokens available; should be 4!
> Does this error message correspond to the open issue that was described in the bug report
> "make randomly fails with interrupted system call on slower filesystems with parallel builds"?
> http://savannah.gnu.org/bugs/?14853

This is something internal make stuff that is irrelevant in this case.

	Sam
