Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbYDNT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbYDNT5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYDNT4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:56:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55838 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280AbYDNT4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:56:41 -0400
Date: Mon, 14 Apr 2008 22:55:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net, p_gortmaker@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] xtensa: don't offer CONFIG_GEN_RTC
Message-ID: <20080414195534.GD26885@cs181133002.pp.htv.fi>
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
8efde38c14112370e1a2cdbe64a99c0c50f18f4f diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 5dc5794..da98c9a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -776,7 +776,7 @@ config SGI_IP27_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !XTENSA
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you

