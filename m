Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbYD2Krv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbYD2Krv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYD2Krn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:47:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56589 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbYD2Krm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:47:42 -0400
Date: Tue, 29 Apr 2008 12:48:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org
Subject: [PATCH] x86: use defconfigs from x86/configs/*
Message-ID: <20080429104815.GA16753@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake <dsd@gentoo.org> reported:

In 2.6.23, if you unpacked a kernel source tarball and then
ran "make menuconfig" you'd be presented with this message:
    # using defaults found in arch/i386/defconfig

and the default options would be set.

The same thing in 2.6.24 does not give you any "using defaults" message, and
the default config options within menuconfig are rather blank (e.g. no PCI
support). You can work around this by explicitly running "make defconfig"
before menuconfig, but it would be nice to have the behaviour the way it was
for 2.6.23 (and the way it still is for other archs).


Fixed by adding a x86 specific defconfig list to Kconfig.

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=10470
Tested-by: dsd@gentoo.org
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a12dbb2..91df357 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,18 @@ config X86
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
+config DEFCONFIG_LIST
+        string
+	depends on X86_32
+        option defconfig_list
+        default "arch/x86/configs/i386_defconfig"
+
+config DEFCONFIG_LIST
+        string
+	depends on X86_64
+        option defconfig_list
+        default "arch/x86/configs/x86_64_defconfig"
+
 
 config GENERIC_LOCKBREAK
 	def_bool n

