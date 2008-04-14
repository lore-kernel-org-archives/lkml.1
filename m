Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbYDNOSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYDNOSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760357AbYDNORu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:17:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41748 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760379AbYDNORs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:17:48 -0400
Date: Mon, 14 Apr 2008 17:16:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com, p_gortmaker@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: don't offer CONFIG_GEN_RTC
Message-ID: <20080414141644.GC6695@cs181133002.pp.htv.fi>
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
  CC [M]  drivers/char/genrtc.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/genrtc.c:58:21: error: asm/rtc.h: No such file or directory
...
make[3]: *** [drivers/char/genrtc.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a2136f51db673446bfcc0ebc1b92e62d8ddb3f57 diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 79c6fd1..a87b89d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -776,7 +776,7 @@ config SGI_IP27_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
