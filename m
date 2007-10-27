Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXJ0FIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXJ0FIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXJ0FIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:08:12 -0400
Received: from main.gmane.org ([80.91.229.2]:51359 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbXJ0FIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:08:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Sat, 27 Oct 2007 07:07:55 +0200
Message-ID: <ffuh39$d7b$1@ger.gmane.org>
References: <fft89p$rko$1@ger.gmane.org> <20071026190500.GA23480@uranus.ravnborg.org> <ffteuq$n3b$1@ger.gmane.org> <20071026194727.GA23871@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c7005.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <20071026194727.GA23871@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You did it in your output directory I assume.

No.


> kbuild complains that the source directory is not clean - which
> is what you need to clean up.

I am looking for the real reasons for the occuring error messages. Let us look at another
test example ...

Sonne:~ # ls -ld /usr/src/linux
lrwxrwxrwx 1 root root 23 Oct 13 10:11 /usr/src/linux -> /usr/src/linux-2.6.23.1
Sonne:~ # cd /usr/src/linux-2.6.23.1
Sonne:/usr/src/linux-2.6.23.1 # unset KBUILD_OUTPUT && make mrproper && cp -p
/boot/config-2.6.23.1-0-adjusted .config && export
KBUILD_OUTPUT=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted && rm -rf $KBUILD_OUTPUT/*
  CLEAN   .config
Sonne:/usr/src/linux-2.6.23.1 # make oldconfig && date && echo
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make -j2 && echo
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && make -j2 modules_install install && echo
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ && date
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
*
* General setup
*
[...]
#
# configuration written to .config
#
Sat Oct 27 06:43:24 CEST 2007
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
make: INTERNAL: Exiting with 3 jobserver tokens available; should be 2!


Which files are not clean in my situation after the command "make mrproper" was executed
at the beginning?

Which results do you or other software developers get by such test runs on kernel releases
since "2.6.22.9-0.4-default" like it is published by SUSE now?
( I can build the current Linux kernel into my source directory successfully.)

Regards,
Markus

