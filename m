Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbYEXUhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbYEXUhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759289AbYEXUhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:37:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55263 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbYEXUhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:37:09 -0400
Date: Sat, 24 May 2008 22:37:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: use defconfig as last resort
Message-ID: <20080524203748.GA2343@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <alpine.LFD.1.10.0805241320200.3081@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805241320200.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: use defconfig as last resort

When using "make oldconfig" with no .config
present try the list from init/Kconfig DEFCONFIG_LIST
before resorting to use one of the defconfigs.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

I had the patch in my local tree but never got it posted.
And then I forgot.

I plan to redo this stuff soonish so we have a more
clean and predictive approach.
But the KCONFIG_ stuff was just more fun ;^)

	Sam

 arch/x86/Kconfig |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe361ae..393a169 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,18 +26,6 @@ config X86
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
-config DEFCONFIG_LIST
-	string
-	depends on X86_32
-	option defconfig_list
-	default "arch/x86/configs/i386_defconfig"
-
-config DEFCONFIG_LIST
-	string
-	depends on X86_64
-	option defconfig_list
-	default "arch/x86/configs/x86_64_defconfig"
-
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -205,6 +193,18 @@ config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
 
+config DEFCONFIG_LIST
+	string
+	depends on X86_32
+	option defconfig_list
+	default "arch/x86/configs/i386_defconfig"
+
+config DEFCONFIG_LIST
+	string
+	depends on X86_64
+	option defconfig_list
+	default "arch/x86/configs/x86_64_defconfig"
+
 menu "Processor type and features"
 
 source "kernel/time/Kconfig"
-- 
1.5.4.1.143.ge7e51

