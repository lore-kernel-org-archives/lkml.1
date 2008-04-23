Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbYDWJzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbYDWJzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYDWJve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:34 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59410 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbYDWJvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:33 -0400
Date: Wed, 23 Apr 2008 12:50:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net, p_gortmaker@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] xtensa: don't offer CONFIG_GEN_RTC
Message-ID: <20080423095053.GT28933@cs181133002.pp.htv.fi>
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

This patch has been sent on:
- 14 Apr 2008

8efde38c14112370e1a2cdbe64a99c0c50f18f4f diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 5dc5794..da98c9a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -776,7 +776,7 @@ config SGI_IP27_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !XTENSA
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you



