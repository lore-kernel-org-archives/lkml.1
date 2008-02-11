Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYBKN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYBKN0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYBKN0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:26:12 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58708 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYBKN0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:26:11 -0500
Date: Mon, 11 Feb 2008 14:26:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc1 ,  syntax error near unexpected token `;'
Message-ID: <20080211132603.GA20959@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <Pine.LNX.4.64.0802101645230.4708@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802101645230.4708@filesrv1.baby-dragons.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 04:47:43PM -0900, Mr. James W. Laferriere wrote:
> 	Hello All ,  grabbed using git just moments ago .
> 
> make V=1 KBUILD_VERBOSE=1 INSTALL_PATH=/boot clean all install 
> modules_install
> 
> ...snip...
> make -f scripts/Makefile.clean obj=sound/usb/usx2y
> make -f scripts/Makefile.clean obj=usr
>   rm -rf .tmp_versions
>   rm -f arch/x86/boot/fdimage arch/x86/boot/image.iso 
>   arch/x86/boot/mtools.conf vmlinux System.map .tmp_kallsyms* .tmp_version 
> .tmp_vmlinux* .tmp_System.map
> rm -f include/config/kernel.release
> echo 2.6.25-rc1 > include/config/kernel.release
> set -e; ; mkdir -p include/linux/;      (echo \#define LINUX_VERSION_CODE 
> 132633; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + 
> (c))';) < /usr/src/linux-2.6.25-rc1-git/Makefile > 
> include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s 
> include/linux/version.h include/linux/version.h.tmp; then rm -f 
> include/linux/version.h.tmp; else ; mv -f include/linux/version.h.tmp 
> include/linux/version.h; fi
> /bin/sh: -c: line 0: syntax error near unexpected token `;'
> /bin/sh: -c: line 0: `set -e; ; mkdir -p include/linux/;        (echo 
> \#define LINUX_VERSION_CODE 132633; echo '#define KERNEL_VERSION(a,b,c) 
> (((a) << 16) + ((b) << 8) + (c))';) < 
> /usr/src/linux-2.6.25-rc1-git/Makefile > include/linux/version.h.tmp; if [ 
> -r include/linux/version.h ] && cmp -s include/linux/version.h 
> include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else ; 
> mv -f include/linux/version.h.tmp include/linux/version.h; fi'
> make: *** [include/linux/version.h] Error 2

Please use following fix.

	Sam

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index da3559e..d64e6ba 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -39,10 +39,13 @@ escsq = $(subst $(squote),'\$(squote)',$1)
 # - If they are equal no change, and no timestamp update
 # - stdin is piped in from the first prerequisite ($<) so one has
 #   to specify a valid file as first prerequisite (often the kbuild file)
+       chk_filechk = :
  quiet_chk_filechk = echo '  CHK     $@'
 silent_chk_filechk = :
+       upd_filechk = :
  quiet_upd_filechk = echo '  UPD     $@'
 silent_upd_filechk = :
+
 define filechk
 	$(Q)set -e;				\
 	$($(quiet)chk_filechk);			\
