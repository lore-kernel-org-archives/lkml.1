Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYEDEW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYEDEW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 00:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYEDEWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 00:22:48 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:53084 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbYEDEWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 00:22:47 -0400
Message-ID: <481D3A08.2040500@aknet.ru>
Date: Sun, 04 May 2008 08:22:32 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch][resend] pcspkr: fix dependancies
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------090305030108000300000500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090305030108000300000500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thomas Gleixner wrote:
> The input changes need to go via Dimitry, the x86 part can go in the
> same commit.
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
Dmitry, would you mind applying this one?
If not, then I see no way to get either
fix applied...

---
fix pcspkr dependancies: make the pcspkr platform
drivers to depend on a platform device, and
not the other way around.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
CC: Vojtech Pavlik <vojtech@suse.cz>
CC: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Takashi Iwai <tiwai@suse.de>


--------------090305030108000300000500
Content-Type: text/x-patch;
 name="pcsp_dep2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_dep2.diff"

--- a/init/Kconfig	2008-04-26 13:40:20.000000000 +0400
+++ b/init/Kconfig	2008-04-26 18:20:40.000000000 +0400
@@ -624,6 +624,14 @@
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
@@ -83,7 +83,7 @@
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
-ifdef CONFIG_INPUT_PCSPKR
+ifdef CONFIG_PCSPKR_PLATFORM
 obj-y				+= pcspeaker.o
 endif
 
--- a/drivers/input/misc/Kconfig	2008-04-22 20:50:41.000000000 +0400
+++ b/drivers/input/misc/Kconfig	2008-04-26 18:23:32.000000000 +0400
@@ -14,7 +14,7 @@
 
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
-	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on PCSPKR_PLATFORM
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
 	  bells and whistles.


--------------090305030108000300000500--
