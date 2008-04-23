Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYDWJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYDWJzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbYDWJva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:30 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46051 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbYDWJv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:29 -0400
Date: Wed, 23 Apr 2008 12:50:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org, Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: [2.6 patch] xtensa: don't offer CONFIG_RTC
Message-ID: <20080423095050.GS28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC [M]  drivers/char/rtc.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/rtc.c:70:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mc146818rtc.h:16:59: error: asm/mc146818rtc.h: No such file or directory
...
make[3]: *** [drivers/char/rtc.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Paul Gortmaker <p_gortmaker@yahoo.com>

---

This patch has been sent on:
- 14 Apr 2008

58a9730328adf21f2b76b8ab3a586da2d7e8bcfa diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index a87b89d..5dc5794 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -706,7 +706,7 @@ config NVRAM
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !AVR32
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !AVR32 && !XTENSA
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you

