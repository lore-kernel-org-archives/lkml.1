Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbXJ0Maz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbXJ0Maz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXJ0Mas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:30:48 -0400
Received: from main.gmane.org ([80.91.229.2]:57567 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbXJ0Mar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:30:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Sat, 27 Oct 2007 14:30:26 +0200
Message-ID: <47232F62.5030109@web.de>
References: <fft89p$rko$1@ger.gmane.org> <20071026190500.GA23480@uranus.ravnborg.org> <ffteuq$n3b$1@ger.gmane.org> <20071026194727.GA23871@uranus.ravnborg.org> <ffuh39$d7b$1@ger.gmane.org> <20071027072348.GA28566@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c7942.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <20071027072348.GA28566@uranus.ravnborg.org>
Cc: linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From the above we can see that two make's are running in parallel here
> where only one should run.

Is this a problem here? - I can omit the parameter "-j".


> I have seen this before but only in cases where you specified several targets
> on the make commandline - which you do not do in the make invocation.
> Just to check it you could do a:
> $(warning CMD=$(MAKECMDFLAGS)) around the place where SUBARCH is assigned in the
> top-level Makefile.

elfring@Sonne:~/Projekte/Linux/Kernel/2.6.23.1> unset KBUILD_OUTPUT && make mrproper && cp
-p /boot/config-2.6.23.1-0-adjusted .config && export
KBUILD_OUTPUT=~/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted && rm -rf $KBUILD_OUTPUT/*
Makefile:165: CMD=
  CLEAN   .config
elfring@Sonne:~/Projekte/Linux/Kernel/2.6.23.1> make oldconfig && date && echo
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make && echo
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && date
/home/elfring/Projekte/Linux/Kernel/2.6.23.1/Makefile:165: CMD=
  GEN     /home/elfring/Projekte/Linux/Kernel/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
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
Sa 27. Okt 14:23:51 CEST 2007
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
/home/elfring/Projekte/Linux/Kernel/2.6.23.1/Makefile:165: CMD=
/home/elfring/Projekte/Linux/Kernel/2.6.23.1/Makefile:165: CMD=
  GEN     /home/elfring/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted/Makefile
scripts/kconfig/conf -s arch/x86_64/Kconfig
/home/elfring/Projekte/Linux/Kernel/2.6.23.1/Makefile:165: CMD=
  Using /home/elfring/Projekte/Linux/Kernel/2.6.23.1 as source for kernel
  /home/elfring/Projekte/Linux/Kernel/2.6.23.1 is not clean, please run 'make mrproper'
  in the '/home/elfring/Projekte/Linux/Kernel/2.6.23.1' directory.
make[1]: *** [prepare3] Fehler 1
make: *** [_all] Fehler 2


Are any more steps needed to perform safe Makefile debugging now?
Is the specific number of (recursive) make calls interesting?


elfring@Sonne:~/Projekte/Linux/Kernel/2.6.23.1> unset KBUILD_OUTPUT && make mrproper && cp
-p /boot/config-2.6.23.1-0-adjusted .config && export
KBUILD_OUTPUT=~/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted && rm -rf $KBUILD_OUTPUT/*
Makefile:165: CMD=
  CLEAN   .config
elfring@Sonne:~/Projekte/Linux/Kernel/2.6.23.1> make silentoldconfig && date && echo
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make && echo
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && date
/home/elfring/Projekte/Linux/Kernel/2.6.23.1/Makefile:165: CMD=
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  GEN     /home/elfring/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86_64/Kconfig
Sa 27. Okt 14:26:53 CEST 2007
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
/home/elfring/Projekte/Linux/Kernel/2.6.23.1/Makefile:165: CMD=
  Using /home/elfring/Projekte/Linux/Kernel/2.6.23.1 as source for kernel
  /home/elfring/Projekte/Linux/Kernel/2.6.23.1 is not clean, please run 'make mrproper'
  in the '/home/elfring/Projekte/Linux/Kernel/2.6.23.1' directory.
make[1]: *** [prepare3] Fehler 1
make: *** [_all] Fehler 2


> Does the issue by any chance go away if you refrain from the
> command && command && command && command && command && command
> way of doing things?

I want to ensure that every command was successfully executed. The return values will be
ignored if the commands are concatenated by the metacharacter ";". I prefer to use "AND
lists" here.


> So you either a .config file or the config directory.

I would expect that both will be generated in my output directory by a command like "make
silentoldconfig". Why is the cleanliness check additionally performed on my source
directory? Should it really matter if I want to concentrate on "objtree"?


> If you now say this is a SUSE specific problem then I suggest asking SUSE for help.

I don't want to say that. I indicated a bit about my runtime environment. Is it more
likely that the Makefile will need an update?

Regards,
Markus

