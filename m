Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbXJZSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbXJZSkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759224AbXJZSks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:40:48 -0400
Received: from main.gmane.org ([80.91.229.2]:48492 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919AbXJZSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:40:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Fri, 26 Oct 2007 20:40:22 +0200
Message-ID: <fftcal$dim$1@ger.gmane.org>
References: <fft89p$rko$1@ger.gmane.org> <19f34abd0710261036m65fd0d3bjace68c860a29023b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c6db3.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <19f34abd0710261036m65fd0d3bjace68c860a29023b@mail.gmail.com>
Cc: linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Aren't you supposed to use O= as described by "make help"?

I expect that both ways should work. I find it easier to use the environment variable
"KBUILD_OUTPUT" because the command line parameter does not need to be repeated on each
make invocation.

Anyway - How do you think about my following test result?

Sonne:/usr/src/linux # MY_OUTDIR=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted && rm -rf
$MY_OUTDIR/*
Sonne:/usr/src/linux # unset KBUILD_OUTPUT && make mrproper
  CLEAN   .config
Sonne:/usr/src/linux # cp -p /boot/config-2.6.23.1-0-adjusted .config
Sonne:/usr/src/linux # make O=$MY_OUTDIR oldconfig && date && echo
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make -j3 O=$MY_OUTDIR && echo
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && make -j3 O=$MY_OUTDIR modules_install install
&& echo ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ && date
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -o arch/x86_64/Kconfig
*
* Linux Kernel Configuration
*
[...]
#
# configuration written to .config
#
Fri Oct 26 20:30:39 CEST 2007
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
scripts/kconfig/conf -s arch/x86_64/Kconfig
  GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86_64
  Using /usr/src/linux-2.6.23.1 as source for kernel
  /usr/src/linux-2.6.23.1 is not clean, please run 'make mrproper'
  in the '/usr/src/linux-2.6.23.1' directory.
make[1]: *** [prepare3] Error 1
make: *** [_all] Error 2
make: INTERNAL: Exiting with 4 jobserver tokens available; should be 3!

How does any internal status information get inconsistent here?

Regards,
Markus

