Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbYHESwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbYHESwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYHESwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:52:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51746 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYHESwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:52:06 -0400
Date: Tue, 5 Aug 2008 14:50:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] SOUND: Remove references to dead sound/oss vars
 AEDSP16_{MSS,SBPRO}.
Message-ID: <alpine.LFD.1.10.0808051444580.15734@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the Kconfig definitions of unused variables AEDSP16_MSS and
AEDSP16_SBPRO since they're:

1) unused, and
2) referenced incorrectly anyway.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  while the sound/oss/Kconfig file defines the variables as
AEDSP16_MSS and AEDSP16_SBPRO, they're (apparently) referenced thusly
in aedsp16.c:

#if defined(CONFIG_SOUND_AEDSP16_SBPRO) && defined(CONFIG_SOUND_AEDSP16_MSS)
#error You have to enable only one of the MSS and SBPRO emulations.
#endif

in other words, not even spelled correctly.  so either something
should be fixed or something should be removed.  i'm going with
removal.


 sound/oss/Kconfig   |   28 ----------------------------
 sound/oss/aedsp16.c |    8 --------
 2 files changed, 36 deletions(-)

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index d4fafb6..906714a 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -546,34 +546,6 @@ config SC6600_CDROMBASE
 	  Base I/O port address for the CD-ROM interface of the Audio Excel
 	  DSP 16 card.

-choice
-	prompt "Audio Excel DSP 16"
-	optional
-	depends on SOUND_AEDSP16
-
-config AEDSP16_MSS
-	bool "MSS emulation"
-	depends on SOUND_MSS
-	help
-	  Answer Y if you want your audio card to emulate Microsoft Sound
-	  System. You should then say Y to "Microsoft Sound System support"
-	  and say N to "Audio Excel DSP 16 (SBPro emulation)".
-
-config AEDSP16_SBPRO
-	bool "SBPro emulation"
-	depends on SOUND_SB
-	help
-	  Answer Y if you want your audio card to emulate Sound Blaster Pro.
-	  You should then say Y to "100% Sound Blaster compatibles
-	  (SB16/32/64, ESS, Jazz16) support" and N to "Audio Excel DSP 16 (MSS
-	  emulation)".
-
-	  If you compile the driver into the kernel, you have to add
-	  "aedsp16=<io>,<irq>,<dma>,<mssio>,<mpuio>,<mouirq>" to the kernel
-	  command line.
-
-endchoice
-
 config SOUND_VIDC
 	tristate "VIDC 16-bit sound"
 	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500)
diff --git a/sound/oss/aedsp16.c b/sound/oss/aedsp16.c
index 51e1fde..a0274f3 100644
--- a/sound/oss/aedsp16.c
+++ b/sound/oss/aedsp16.c
@@ -29,14 +29,6 @@
 #include "sound_config.h"

 /*
- * Sanity checks
- */
-
-#if defined(CONFIG_SOUND_AEDSP16_SBPRO) && defined(CONFIG_SOUND_AEDSP16_MSS)
-#error You have to enable only one of the MSS and SBPRO emulations.
-#endif
-
-/*

    READ THIS

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
