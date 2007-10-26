Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbXJZRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbXJZRcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXJZRcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:32:01 -0400
Received: from main.gmane.org ([80.91.229.2]:40601 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbXJZRcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:32:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Check handling of kernel build output directory
Date: Fri, 26 Oct 2007 19:31:38 +0200
Message-ID: <fft89p$rko$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c6db3.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Two ways are mentioned in the Makefile for the Linux kernel 2.6.31.1 to specify output
diretories. The description of the environment variable "KBUILD_OUTPUT" is missing from
the file "README".

I am trying to generate all executable files for the current stable kernel release on my
openSUSE 10.3 system.

Sonne:/usr/src/linux # make mrproper
Sonne:/usr/src/linux # cp -p /boot/config-2.6.23.1-0-adjusted .config
[reactivate backup copy]

Sonne:/usr/src/linux # export KBUILD_OUTPUT=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted
Sonne:/usr/src/linux # make silentoldconfig
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
scripts/kconfig/conf -s arch/x86_64/Kconfig
***
*** You have not yet configured your kernel!
*** (missing kernel .config file)
***
*** Please run some configurator (e.g. "make oldconfig" or
*** "make menuconfig" or "make xconfig").
***
make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2
make: *** [silentoldconfig] Error 2

Another try:
Sonne:/usr/src/linux # make oldconfig
[...]
#
# configuration written to .config
#
Sonne:/usr/src/linux # date && echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make -j4
&& echo YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && make -j4 modules_install install &&
echo ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ && date
Fri Oct 26 18:38:18 CEST 2007
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
make: INTERNAL: Exiting with 5 jobserver tokens available; should be 4!

Does this error message correspond to the open issue that was described in the bug report
"make randomly fails with interrupted system call on slower filesystems with parallel builds"?
http://savannah.gnu.org/bugs/?14853

When this happens, there is always one more token available than I've specified by the
parameter "-j". If I ommit it, I get the following result.

Sonne:/usr/src/linux # date && echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make &&
echo YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && make modules_install install && echo
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ && date
Fri Oct 26 19:17:18 CEST 2007
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  Using /usr/src/linux-2.6.23.1 as source for kernel
  /usr/src/linux-2.6.23.1 is not clean, please run 'make mrproper'
  in the '/usr/src/linux-2.6.23.1' directory.
make[1]: *** [prepare3] Error 1
make: *** [_all] Error 2

The option to build into a specific output diretory is unusable on my system so far. Would
you like to share any ideas to resolve this unpleasant situation?

Regards,
Markus

