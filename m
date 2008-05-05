Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYEEFDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYEEFDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYEEFCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:02:52 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:51498 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbYEEFCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:02:51 -0400
Message-ID: <481E94EE.5080308@aknet.ru>
Date: Mon, 05 May 2008 09:02:38 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch][resend2] pcspkr: fix dependancies
References: <481D3A08.2040500@aknet.ru> <20080505035733.GA11584@anvil.corenet.prv> <481E8C64.7090507@aknet.ru> <20080505043554.GC11584@anvil.corenet.prv>
In-Reply-To: <20080505043554.GC11584@anvil.corenet.prv>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------020707090504020102000906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020707090504020102000906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Dmitry Torokhov wrote:
> Why don't we ask Takashi to apply it in one step? You can add my
> 	Acked-by: Dmitry Torokhov <dtor@mail.ru>
OK, lets do. :)
Takashi, could you please apply?

---
fix pcspkr dependancies: make the pcspkr platform
drivers to depend on a platform device, and
not the other way around.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
CC: Vojtech Pavlik <vojtech@suse.cz>
CC: Michael Opdenacker <michael-lists@free-electrons.com>

--------------020707090504020102000906
Content-Type: text/x-patch;
 name="pcsp_dep.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_dep.diff"

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
 
--- a/sound/drivers/Kconfig	2008-04-26 13:40:21.000000000 +0400
+++ b/sound/drivers/Kconfig	2008-04-26 18:24:59.000000000 +0400
@@ -5,8 +5,8 @@
 
 
 config SND_PCSP
-	tristate "Internal PC speaker support"
-	depends on X86_PC && HIGH_RES_TIMERS
+	tristate "PC-Speaker support"
+	depends on PCSPKR_PLATFORM && X86_PC && HIGH_RES_TIMERS
 	help
 	  If you don't have a sound card in your computer, you can include a
 	  driver for the PC speaker which allows it to act like a primitive
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

--------------020707090504020102000906--
