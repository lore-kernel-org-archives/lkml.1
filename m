Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbYDNOSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbYDNOSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbYDNORq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:17:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33460 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760667AbYDNORp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:17:45 -0400
Date: Mon, 14 Apr 2008 17:16:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com, p_gortmaker@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: don't offer CONFIG_RTC
Message-ID: <20080414141640.GB6695@cs181133002.pp.htv.fi>
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

---
42380180f5f69102dfdffd4472ac2ca370d3a3d7 diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 47c6be8..79c6fd1 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -706,7 +706,7 @@ config NVRAM
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !AVR32
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you

