Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbYBPTGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbYBPTGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYBPTGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:06:11 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57911 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYBPTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:06:10 -0500
Date: Sat, 16 Feb 2008 14:05:49 -0500
Message-Id: <200802161905.m1GJ5njk028098@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -mmotm] one more reject fix in arch/x86/Kconfig
Cc: linux-kernel@vger.kernel.org
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using mmotm-2008-02-15-11-03, I get

$ make ARCH=i386
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
arch/x86/Kconfig:24: unknown option "HEAD"
arch/x86/Kconfig:30: unknown option "FETCH_HEAD"
make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by `include/config/kernel.release'.  Stop.

The following small patch fixes it for me, but may not be the right fix (I
chose to resolve the conflict by including both parts).

Cheers,
Erez.


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6d6150b..dd4d64d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,13 +21,9 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-<<<<<<< HEAD:arch/x86/Kconfig
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
-
-=======
 	select HAVE_FTRACE
->>>>>>> FETCH_HEAD:arch/x86/Kconfig
 
 config GENERIC_LOCKBREAK
 	def_bool n
