Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbXEJOAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbXEJOAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761159AbXEJN4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:56:40 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55418 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760372AbXEJN4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:56:22 -0400
Message-Id: <20070510135645.698308626@de.ibm.com>
References: <20070510135152.178104939@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 15:52:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/15] Kconfig: common config options for s390.
Content-Disposition: inline; filename=103-kconfig-option-s390.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Disable some configuration options in the common Kconfig files that
are of no interest to a s390 machine. Enable hangcheck timer.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/char/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: quilt-2.6/drivers/char/Kconfig
===================================================================
--- quilt-2.6.orig/drivers/char/Kconfig
+++ quilt-2.6/drivers/char/Kconfig
@@ -6,6 +6,7 @@ menu "Character devices"
 
 config VT
 	bool "Virtual terminal" if EMBEDDED
+	depends on !S390
 	select INPUT
 	default y if !VIOCONS
 	---help---
@@ -766,7 +767,7 @@ config NVRAM
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && (!SPARC || PCI) && !FRV && !ARM && !SUPERH
+	depends on !PPC && !PARISC && !IA64 && !M68K && (!SPARC || PCI) && !FRV && !ARM && !SUPERH && !S390
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -814,7 +815,7 @@ config SGI_IP27_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV && !S390
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -1045,7 +1046,7 @@ config HPET_MMAP
 
 config HANGCHECK_TIMER
 	tristate "Hangcheck timer"
-	depends on X86 || IA64 || PPC64
+	depends on X86 || IA64 || PPC64 || S390
 	help
 	  The hangcheck-timer module detects when the system has gone
 	  out to lunch past a certain margin.  It can reboot the system

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

