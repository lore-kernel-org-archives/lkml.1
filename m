Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXBLVmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXBLVmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030189AbXBLVmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:42:47 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41323 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030185AbXBLVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:42:46 -0500
X-Originating-Ip: 74.109.98.130
Date: Mon, 12 Feb 2007 16:41:05 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] Standardize on "depends on" in Kconfig files.
Message-ID: <Pine.LNX.4.64.0702121635001.29808@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Standardize on "depends on" in Kconfig files, and drop support for
the alternative forms of "depends" or "requires".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  there was a consensus to standardize exclusively on the qualifier
"depends on" in Kconfig files, and i've had a patch in the system for
quite some time to take care of the three remaining files.  but not
only are those files still using the old form of "depends", now
there's another file that's *added* a few more instances.  grrrr.

  what about just dropping support in the kbuild structure?  *that*
would make sure things got cleaned up in a hurry.  this isn't perl --
it's not necessarily good that there's more than one way to do it.


 arch/arm/Kconfig         |    2 +-
 arch/arm/mm/Kconfig      |    2 +-
 arch/v850/Kconfig        |    2 +-
 sound/soc/codecs/Kconfig |    8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5c79519..77d062e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -405,7 +405,7 @@ source arch/arm/mm/Kconfig

 config IWMMXT
 	bool "Enable iWMMXt support"
-	depends CPU_XSCALE || CPU_XSC3
+	depends on CPU_XSCALE || CPU_XSC3
 	default y if PXA27x
 	help
 	  Enable support for iWMMXt context switching at run time if
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index aade2f7..3c2f979 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -525,7 +525,7 @@ config CPU_BIG_ENDIAN
 	  of your chipset/board/processor.

 config CPU_HIGH_VECTOR
-	depends !MMU && CPU_CP15 && !CPU_ARM740T
+	depends on !MMU && CPU_CP15 && !CPU_ARM740T
 	bool "Select the High exception vector"
 	default n
 	help
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index dbfab8f..50ccc7f 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -217,7 +217,7 @@ menu "Processor type and features"
    # Some platforms pre-zero memory, in which case the kernel doesn't need to
    config ZERO_BSS
    	  bool
-	  depends !V850E2_SIM85E2C
+	  depends on !V850E2_SIM85E2C
 	  default y

    # The crappy-ass zone allocator requires that the start of allocatable
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 78ac268..ec2a278 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1,15 +1,15 @@
 config SND_SOC_AC97_CODEC
 	tristate
-	depends SND_SOC
+	depends on SND_SOC

 config SND_SOC_WM8731
 	tristate
-	depends SND_SOC
+	depends on SND_SOC

 config SND_SOC_WM8750
 	tristate
-	depends SND_SOC
+	depends on SND_SOC

 config SND_SOC_WM9712
 	tristate
-	depends SND_SOC
+	depends on SND_SOC

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
