Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbYEHOIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbYEHOIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYEHOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:08:34 -0400
Received: from mail.aknet.ru ([78.158.192.26]:50404 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYEHOIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:08:32 -0400
X-Greylist: delayed 1086 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 10:08:32 EDT
Message-ID: <48233D4B.9080505@aknet.ru>
Date: Thu, 08 May 2008 21:50:03 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] pcspkr: fix dependancies
References: <481D3A08.2040500@aknet.ru>	<20080505035733.GA11584@anvil.corenet.prv>	<481E8C64.7090507@aknet.ru>	<20080505043554.GC11584@anvil.corenet.prv>	<481E94EE.5080308@aknet.ru> <s5hy76pc8u1.wl%tiwai@suse.de>
In-Reply-To: <s5hy76pc8u1.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------000607090301070502070206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000607090301070502070206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Takashi Iwai wrote:
> This could be replaced now better with
>   obj-$(CONFIG_PCSPKR_PLATFORM) += pcspeaker.o
> These two chunks don't apply on 2.6.26-git tree.  Please recreate the
> patch.
Done.
Could you please apply?

---
fix pcspkr dependancies: make the pcspkr platform
drivers to depend on a platform device, and
not the other way around.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
CC: Vojtech Pavlik <vojtech@suse.cz>
CC: Michael Opdenacker <michael-lists@free-electrons.com>

--------------000607090301070502070206
Content-Type: text/x-patch;
 name="pcsp_dep3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_dep3.diff"

--- a/init/Kconfig	2008-04-26 13:40:20.000000000 +0400
+++ b/init/Kconfig	2008-04-26 18:20:40.000000000 +0400
@@ -634,6 +634,14 @@
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
+config PCSPKR_PLATFORM
+	bool "Enable PC-Speaker support" if EMBEDDED
+	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	default y
+	help
+          This option allows to disable the internal PC-Speaker
+          support, saving some memory.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
--- a/arch/x86/kernel/Makefile	2008-04-26 13:40:06.000000000 +0400
+++ b/arch/x86/kernel/Makefile	2008-04-26 18:22:49.000000000 +0400
@@ -83,9 +83,7 @@
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
-ifdef CONFIG_INPUT_PCSPKR
-obj-y				+= pcspeaker.o
-endif
+obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
 obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
--- a/sound/drivers/Kconfig	2008-04-26 13:40:21.000000000 +0400
+++ b/sound/drivers/Kconfig	2008-04-26 18:24:59.000000000 +0400
@@ -5,7 +5,8 @@
 
 
 config SND_PCSP
-	tristate "Internal PC speaker support"
+	tristate "PC-Speaker support"
+	depends on PCSPKR_PLATFORM
 	depends on X86_PC && HIGH_RES_TIMERS
 	depends on INPUT
 	depends on SND
--- a/drivers/input/misc/Kconfig	2008-04-22 20:50:41.000000000 +0400
+++ b/drivers/input/misc/Kconfig	2008-04-26 18:23:32.000000000 +0400
@@ -14,7 +14,7 @@
 
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
-	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on PCSPKR_PLATFORM
 	depends on SND_PCSP=n
 	help
 	  Say Y here if you want the standard PC Speaker to be used for

--------------000607090301070502070206--
