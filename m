Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYEPRst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYEPRst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYEPRsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:48:41 -0400
Received: from mail.aknet.ru ([78.158.192.26]:64651 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYEPRsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:48:40 -0400
Message-ID: <482DC8EC.3070401@aknet.ru>
Date: Fri, 16 May 2008 21:48:28 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] snd-pcsp: adjust help texts to frighten users
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <482C71B3.8090200@aknet.ru> <20080515182643.GL18825@mit.edu>
In-Reply-To: <20080515182643.GL18825@mit.edu>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------050002040404030202040006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050002040404030202040006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Takashi, could you please apply the
attached patch?

It makes the snd-pcsp help text to
alert the user about the possible
problems.

--------------050002040404030202040006
Content-Type: text/x-patch;
 name="pcsp_wr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_wr.diff"

# HG changeset patch
# User Stas Sergeev <stsp@users.sourceforge.net>
# Date 1210878004 -14400
# Node ID 26bbbefc222c5a7fffc15c34422ff0408a4d6dc3
# Parent  903c7be2316a6b892c8c20a0a8a6e21cd9a9ee8c
snd-pcsp: adjust help texts to frighten users.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

diff -r 903c7be2316a -r 26bbbefc222c Kconfig
--- a/Kconfig	Thu May 08 21:20:04 2008 +0400
+++ b/Kconfig	Thu May 15 23:00:04 2008 +0400
@@ -27,11 +27,6 @@ config SOUND
 	  after the PnP configuration is finished.  To do this, choose M here
 	  and read <file:Documentation/sound/oss/README.modules>; the module
 	  will be called soundcore.
-
-	  I'm told that even without a sound card, you can make your computer
-	  say more than an occasional beep, by programming the PC speaker.
-	  Kernel patches and supporting utilities to do that are in the pcsp
-	  package, available at <ftp://ftp.infradead.org/pub/pcsp/>.
 
 source "sound/oss/dmasound/Kconfig"
 
diff -r 903c7be2316a -r 26bbbefc222c drivers/Kconfig
--- a/drivers/Kconfig	Thu May 08 21:20:04 2008 +0400
+++ b/drivers/Kconfig	Thu May 15 23:00:04 2008 +0400
@@ -5,7 +5,7 @@ menu "Generic devices"
 
 
 config SND_PCSP
-	tristate "PC-Speaker support"
+	tristate "PC-Speaker support (READ HELP!)"
 	depends on X86_PC && HIGH_RES_TIMERS
 	depends on SND
 	select SND_PCM
@@ -17,11 +17,21 @@ config SND_PCSP
 
 	  You can compile this as a module which will be called snd-pcsp.
 
+	  WARNING: if you already have a soundcard, enabling this
+	  driver may lead to a problem. Namely, it may get loaded
+	  before the other sound driver of yours, making the
+	  pc-speaker a default sound device. Which is likely not
+	  what you want. To make this driver play nicely with other
+	  sound driver, you can add this into your /etc/modprobe.conf:
+	  options snd-pcsp index=2
+
 	  You don't need this driver if you only want your pc-speaker to beep.
 	  You don't need this driver if you have a tablet piezo beeper
 	  in your PC instead of the real speaker.
 
-	  It should not hurt to say Y or M here in all other cases.
+	  Say N if you have a sound card.
+	  Say M if you don't.
+	  Say Y only if you really know what you do.
 
 config SND_PCSP_INPUT
 	def_bool y


--------------050002040404030202040006--
