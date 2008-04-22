Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbYDVRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbYDVRz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYDVRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:55:10 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:60247 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546AbYDVRzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:55:09 -0400
Message-ID: <480E2666.9080609@aknet.ru>
Date: Tue, 22 Apr 2008 21:54:46 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp causes driver conflict)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5hwsmrcvow.wl%tiwai@suse.de>	<480CD281.6050902@aknet.ru> <s5hd4oib3qt.wl%tiwai@suse.de>
In-Reply-To: <s5hd4oib3qt.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------030104060101010102030606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030104060101010102030606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Takashi Iwai wrote:
> Err, no, this wasn't merged to sound git tree because apparently the
> patch is to 2.6.22 and you didn't resubmit it...
That's simply because the old one
applies fine. :)

> No, I gave no ACK yet.
OK, sorry.

> I'd rather add a new line with a single "depends on SND_PCSP=n".
> You see a clear difference in the art of dependencies, one for
> architectures and one for driver-specific.
Done.

---
- Update CREDITS with the pc-speaker
driver authors.
- Prevent pcspkr from being built together
with snd-pcsp.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------030104060101010102030606
Content-Type: text/x-patch;
 name="pcsp-kernel-2.6.25-01.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="pcsp-kernel-2.6.25-01.diff"

diff -ur linux-2.6.25/CREDITS linux-2.6.25-pcsp-kern/CREDITS
--- linux-2.6.25/CREDITS	2008-02-16 22:37:23.000000000 +0300
+++ linux-2.6.25-pcsp-kern/CREDITS	2008-04-22 21:45:23.000000000 +0400
@@ -403,6 +403,8 @@
 N: Erik Inge Bolsø
 E: knan@mo.himolde.no
 D: Misc kernel hacks
+D: Updated PC speaker driver for 2.3
+S: Norway
 
 N: Andreas E. Bombe
 E: andreas.bombe@munich.netsurf.de
@@ -3116,6 +3118,12 @@
 S: Sunnyvale, California 94088-4132
 S: USA
 
+N: Stas Sergeev
+E: stsp@users.sourceforge.net
+D: PCM PC-Speaker driver
+D: misc fixes
+S: Russia
+
 N: Simon Shapiro
 E: shimon@i-Connect.Net
 W: http://www.-i-Connect.Net/~shimon
diff -ur linux-2.6.25/drivers/input/misc/Kconfig linux-2.6.25-pcsp-kern/drivers/input/misc/Kconfig
--- linux-2.6.25/drivers/input/misc/Kconfig	2008-04-22 20:50:41.000000000 +0400
+++ linux-2.6.25-pcsp-kern/drivers/input/misc/Kconfig	2008-04-22 21:45:23.000000000 +0400
@@ -15,6 +15,7 @@
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on SND_PCSP=n
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
 	  bells and whistles.

--------------030104060101010102030606--
