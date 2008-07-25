Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYGYXig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYGYXig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYGYXi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:38:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44055 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbYGYXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:38:28 -0400
Date: Sat, 26 Jul 2008 02:38:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>, sameo@openedhand.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] MFD_TC6393XB is ARM-only
Message-ID: <20080725233800.GD9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile error on other architectures:

<--  snip  -->

...
  CC      drivers/mfd/tc6393xb.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c: In function ‘tc6393xb_attach_irq’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c:324: error: implicit declaration of function ‘set_irq_flags’
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c:324: error: ‘IRQF_VALID’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c:324: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c:324: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c:324: error: ‘IRQF_PROBE’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mfd/tc6393xb.c:327: error: ‘IRQT_FALLING’ undeclared (first use in this function)
make[3]: *** [drivers/mfd/tc6393xb.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
7ca0351d28039eab954d273dd600499e8122dcce 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1f57a99..883e7ea 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -52,7 +52,7 @@ config HTC_PASIC3
 
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
-	depends on GPIOLIB
+	depends on GPIOLIB && ARM
 	select MFD_CORE
 	help
 	  Support for Toshiba Mobile IO Controller TC6393XB

